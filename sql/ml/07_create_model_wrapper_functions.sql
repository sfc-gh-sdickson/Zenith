-- ============================================================================
-- Zenith Insurance Intelligence Agent - Model Registry Wrapper Procedures
-- ============================================================================
-- Purpose: Create SQL procedures that wrap Model Registry models
--          so they can be added as tools to the Intelligence Agent
-- Based on: Model Registry integration pattern from Microchip template
-- ============================================================================

USE DATABASE ZENITH_INSURANCE_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE ZENITH_WH;

-- ============================================================================
-- Procedure 1: Claim Cost Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_CLAIM_COST(STRING, STRING);

CREATE OR REPLACE PROCEDURE PREDICT_CLAIM_COST(
    INJURY_TYPE_FILTER STRING,
    INDUSTRY_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_claim_cost'
COMMENT = 'Calls CLAIM_COST_PREDICTOR model from Model Registry to predict claim costs'
AS
$$
def predict_claim_cost(session, injury_type_filter, industry_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model from registry
    reg = Registry(session)
    model = reg.get_model("CLAIM_COST_PREDICTOR").default
    
    # Build query with optional filters
    injury_filter = f"AND c.injury_type = '{injury_type_filter}'" if injury_type_filter else ""
    industry = f"AND e.industry_vertical = '{industry_filter}'" if industry_filter else ""
    
    query = f"""
    SELECT
        c.injury_type,
        c.body_part,
        c.claim_type,
        c.severity,
        e.industry_vertical,
        e.business_segment,
        iw.age::FLOAT AS worker_age,
        iw.years_of_experience::FLOAT AS worker_experience,
        iw.safety_training_completed::BOOLEAN AS safety_trained,
        c.days_lost::FLOAT AS days_lost,
        0.0::FLOAT AS total_incurred
    FROM RAW.CLAIMS c
    JOIN RAW.EMPLOYERS e ON c.employer_id = e.employer_id
    LEFT JOIN RAW.INJURED_WORKERS iw ON c.injured_worker_id = iw.injured_worker_id
    WHERE c.claim_status = 'OPEN' {injury_filter} {industry}
    LIMIT 50
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Calculate statistics
    result = predictions.select("PREDICTED_COST").to_pandas()
    
    return json.dumps({
        "injury_type_filter": injury_type_filter or "ALL",
        "industry_filter": industry_filter or "ALL",
        "total_claims_analyzed": len(result),
        "avg_predicted_cost": round(float(result['PREDICTED_COST'].mean()), 2),
        "total_predicted_cost": round(float(result['PREDICTED_COST'].sum()), 2),
        "min_predicted_cost": round(float(result['PREDICTED_COST'].min()), 2),
        "max_predicted_cost": round(float(result['PREDICTED_COST'].max()), 2)
    })
$$;

-- ============================================================================
-- Procedure 2: Fraud Detection Wrapper
-- ============================================================================

-- Drop if exists
DROP FUNCTION IF EXISTS DETECT_FRAUD_RISK(STRING);

CREATE OR REPLACE PROCEDURE DETECT_FRAUD_RISK(
    CLAIM_STATUS_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'detect_fraud'
COMMENT = 'Calls FRAUD_DETECTOR model from Model Registry to identify high-risk fraud claims'
AS
$$
def detect_fraud(session, claim_status_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("FRAUD_DETECTOR").default
    
    # Build query
    status_filter = f"AND c.claim_status = '{claim_status_filter}'" if claim_status_filter else "AND c.claim_status IN ('OPEN', 'LITIGATED')"
    
    query = f"""
    SELECT
        c.injury_type,
        c.body_part,
        c.claim_type,
        c.severity,
        e.industry_vertical,
        DATEDIFF('day', c.injury_date, c.report_date)::FLOAT AS days_to_report,
        c.litigated::BOOLEAN AS has_litigation,
        COALESCE(iw.injury_history_count, 0)::FLOAT AS prior_injuries,
        CASE WHEN c.medical_paid > 0 
             THEN (c.indemnity_paid / NULLIF(c.medical_paid, 0))::FLOAT 
             ELSE 0.0 END AS indemnity_medical_ratio,
        FALSE::BOOLEAN AS is_fraud_risk
    FROM RAW.CLAIMS c
    JOIN RAW.EMPLOYERS e ON c.employer_id = e.employer_id
    LEFT JOIN RAW.INJURED_WORKERS iw ON c.injured_worker_id = iw.injured_worker_id
    WHERE 1=1 {status_filter}
    LIMIT 100
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Count high-risk claims
    result = predictions.select("FRAUD_PREDICTION").to_pandas()
    fraud_count = int(result['FRAUD_PREDICTION'].sum())
    total_count = len(result)
    
    return json.dumps({
        "claim_status_filter": claim_status_filter or "OPEN,LITIGATED",
        "total_claims_analyzed": total_count,
        "high_fraud_risk_count": fraud_count,
        "fraud_risk_rate_pct": round(fraud_count / total_count * 100, 2) if total_count > 0 else 0,
        "recommendation": f"Refer {fraud_count} claims to SIU for investigation" if fraud_count > 0 else "No high-risk claims identified"
    })
$$;

-- ============================================================================
-- Procedure 3: Return-to-Work Timeline Prediction Wrapper
-- ============================================================================

-- Drop if exists
DROP FUNCTION IF EXISTS PREDICT_RTW_TIMELINE(STRING, STRING);

CREATE OR REPLACE PROCEDURE PREDICT_RTW_TIMELINE(
    INJURY_TYPE_FILTER STRING,
    INDUSTRY_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_rtw'
COMMENT = 'Calls RTW_TIMELINE_PREDICTOR model to predict days to return to work'
AS
$$
def predict_rtw(session, injury_type_filter, industry_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("RTW_TIMELINE_PREDICTOR").default
    
    # Build query
    injury_filter = f"AND c.injury_type = '{injury_type_filter}'" if injury_type_filter else ""
    industry = f"AND e.industry_vertical = '{industry_filter}'" if industry_filter else ""
    
    query = f"""
    SELECT
        c.injury_type,
        c.body_part,
        c.claim_type,
        c.severity,
        e.industry_vertical,
        e.business_segment,
        e.safety_rating,
        COALESCE(iw.age, 40)::FLOAT AS worker_age,
        COALESCE(iw.years_of_experience, 5)::FLOAT AS worker_experience,
        COALESCE(iw.safety_training_completed, FALSE)::BOOLEAN AS safety_trained,
        COALESCE(adj.adjuster_type, 'DESK_ADJUSTER') AS adjuster_type,
        0.0::FLOAT AS days_to_rtw
    FROM RAW.CLAIMS c
    JOIN RAW.EMPLOYERS e ON c.employer_id = e.employer_id
    LEFT JOIN RAW.INJURED_WORKERS iw ON c.injured_worker_id = iw.injured_worker_id
    LEFT JOIN RAW.CLAIMS_ADJUSTERS adj ON c.adjuster_id = adj.adjuster_id
    WHERE c.claim_status = 'OPEN' 
      AND c.return_to_work_date IS NULL {injury_filter} {industry}
    LIMIT 50
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Calculate statistics
    result = predictions.select("PREDICTED_DAYS_TO_RTW").to_pandas()
    
    return json.dumps({
        "injury_type_filter": injury_type_filter or "ALL",
        "industry_filter": industry_filter or "ALL",
        "total_claims_analyzed": len(result),
        "avg_predicted_rtw_days": round(float(result['PREDICTED_DAYS_TO_RTW'].mean()), 1),
        "min_predicted_rtw_days": round(float(result['PREDICTED_DAYS_TO_RTW'].min()), 1),
        "max_predicted_rtw_days": round(float(result['PREDICTED_DAYS_TO_RTW'].max()), 1),
        "claims_rtw_under_30_days": int((result['PREDICTED_DAYS_TO_RTW'] < 30).sum()),
        "claims_rtw_over_90_days": int((result['PREDICTED_DAYS_TO_RTW'] > 90).sum())
    })
$$;

-- ============================================================================
-- Test the wrapper procedures
-- ============================================================================

SELECT 'ML model wrapper procedures created successfully' AS status;

-- Test each procedure (uncomment after models are registered via notebook)
/*
CALL PREDICT_CLAIM_COST('STRAIN_SPRAIN', 'CONSTRUCTION');
CALL DETECT_FRAUD_RISK('OPEN');
CALL PREDICT_RTW_TIMELINE('STRAIN_SPRAIN', 'HEALTHCARE');
*/

SELECT 'Execute notebook first to register models, then uncomment tests above' AS instruction;

