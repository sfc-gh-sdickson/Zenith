-- ============================================================================
-- Zenith Insurance Intelligence Agent - Analytical Views
-- ============================================================================
-- Purpose: Create curated analytical views for business intelligence
-- ============================================================================

USE DATABASE ZENITH_INSURANCE_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE ZENITH_WH;

-- ============================================================================
-- Employer 360 View
-- ============================================================================
CREATE OR REPLACE VIEW V_EMPLOYER_360 AS
SELECT
    e.employer_id,
    e.employer_name,
    e.primary_contact_email,
    e.primary_contact_phone,
    e.country,
    e.state,
    e.city,
    e.onboarding_date,
    e.employer_status,
    e.business_segment,
    e.industry_vertical,
    e.lifetime_premium_value,
    e.credit_risk_score,
    e.annual_payroll,
    e.employee_count,
    e.safety_rating,
    e.mod_rating,
    COUNT(DISTINCT iw.injured_worker_id) AS total_workers,
    COUNT(DISTINCT CASE WHEN iw.worker_status = 'ACTIVE' THEN iw.injured_worker_id END) AS active_workers,
    COUNT(DISTINCT sc.contract_id) AS total_service_contracts,
    COUNT(DISTINCT pw.policy_id) AS total_policies_written,
    COUNT(DISTINCT c.claim_id) AS total_claims,
    COUNT(DISTINCT CASE WHEN c.claim_status = 'OPEN' THEN c.claim_id END) AS open_claims,
    SUM(c.total_incurred) AS total_claims_incurred,
    SUM(c.medical_paid) AS total_medical_paid,
    SUM(c.indemnity_paid) AS total_indemnity_paid,
    COUNT(DISTINCT cd.dispute_id) AS total_disputes,
    COUNT(DISTINCT CASE WHEN cd.dispute_status IN ('IN_MEDIATION', 'ARBITRATION', 'LITIGATION') THEN cd.dispute_id END) AS active_disputes,
    e.created_at,
    e.updated_at
FROM RAW.EMPLOYERS e
LEFT JOIN RAW.INJURED_WORKERS iw ON e.employer_id = iw.employer_id
LEFT JOIN RAW.SERVICE_CONTRACTS sc ON e.employer_id = sc.employer_id
LEFT JOIN RAW.POLICIES_WRITTEN pw ON e.employer_id = pw.employer_id
LEFT JOIN RAW.CLAIMS c ON e.employer_id = c.employer_id
LEFT JOIN RAW.CLAIM_DISPUTES cd ON e.employer_id = cd.employer_id
GROUP BY
    e.employer_id, e.employer_name, e.primary_contact_email, e.primary_contact_phone,
    e.country, e.state, e.city, e.onboarding_date, e.employer_status,
    e.business_segment, e.industry_vertical, e.lifetime_premium_value, e.credit_risk_score,
    e.annual_payroll, e.employee_count, e.safety_rating, e.mod_rating,
    e.created_at, e.updated_at;

-- ============================================================================
-- Injured Worker Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_INJURED_WORKER_ANALYTICS AS
SELECT
    iw.injured_worker_id,
    iw.employer_id,
    e.employer_name,
    iw.worker_name,
    iw.email,
    iw.job_title,
    iw.department,
    iw.worker_status,
    iw.years_of_experience,
    iw.safety_training_completed,
    iw.injury_history_count,
    iw.age,
    iw.hire_date,
    COUNT(DISTINCT c.claim_id) AS total_claims_filed,
    COUNT(DISTINCT CASE WHEN c.claim_status = 'CLOSED' THEN c.claim_id END) AS closed_claims,
    SUM(c.total_incurred) AS total_claim_costs,
    SUM(c.days_lost) AS total_days_lost,
    COUNT(DISTINCT cd.dispute_id) AS total_disputes,
    iw.created_at,
    iw.updated_at
FROM RAW.INJURED_WORKERS iw
JOIN RAW.EMPLOYERS e ON iw.employer_id = e.employer_id
LEFT JOIN RAW.CLAIMS c ON iw.injured_worker_id = c.injured_worker_id
LEFT JOIN RAW.CLAIM_DISPUTES cd ON iw.injured_worker_id = cd.injured_worker_id
GROUP BY
    iw.injured_worker_id, iw.employer_id, e.employer_name, iw.worker_name,
    iw.email, iw.job_title, iw.department, iw.worker_status,
    iw.years_of_experience, iw.safety_training_completed, iw.injury_history_count,
    iw.age, iw.hire_date, iw.created_at, iw.updated_at;

-- ============================================================================
-- Policy Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_POLICY_ANALYTICS AS
SELECT
    pw.policy_id,
    pw.employer_id,
    e.employer_name,
    e.industry_vertical,
    e.business_segment,
    pw.agent_id,
    ag.agent_name,
    pw.policy_product_id,
    pp.product_name,
    pp.state_program,
    pp.coverage_type,
    pw.effective_date,
    pw.expiration_date,
    pw.policy_status,
    pw.industry_class_code,
    pw.estimated_annual_premium,
    pw.actual_annual_premium,
    pw.competitive_win,
    pw.previous_carrier,
    pw.agent_commission_pct,
    (pw.actual_annual_premium * pw.agent_commission_pct / 100.0)::NUMBER(12,2) AS agent_commission_amount,
    COUNT(DISTINCT pr.renewal_id) AS renewal_count,
    SUM(pr.renewal_premium) AS total_renewal_premium,
    COUNT(DISTINCT c.claim_id) AS total_claims,
    SUM(c.total_incurred) AS total_claims_cost,
    CASE 
        WHEN pw.actual_annual_premium > 0 THEN (SUM(c.total_incurred) / pw.actual_annual_premium * 100.0)::NUMBER(8,2)
        ELSE 0.00
    END AS loss_ratio_pct,
    pw.created_at,
    pw.updated_at
FROM RAW.POLICIES_WRITTEN pw
JOIN RAW.EMPLOYERS e ON pw.employer_id = e.employer_id
JOIN RAW.INSURANCE_AGENTS ag ON pw.agent_id = ag.agent_id
JOIN RAW.POLICY_PRODUCTS pp ON pw.policy_product_id = pp.policy_product_id
LEFT JOIN RAW.POLICY_RENEWALS pr ON pw.policy_id = pr.policy_id
LEFT JOIN RAW.CLAIMS c ON pw.employer_id = c.employer_id AND c.injury_date BETWEEN pw.effective_date AND pw.expiration_date
GROUP BY
    pw.policy_id, pw.employer_id, e.employer_name, e.industry_vertical,
    e.business_segment, pw.agent_id, ag.agent_name, pw.policy_product_id,
    pp.product_name, pp.state_program, pp.coverage_type,
    pw.effective_date, pw.expiration_date, pw.policy_status, pw.industry_class_code,
    pw.estimated_annual_premium, pw.actual_annual_premium, pw.competitive_win,
    pw.previous_carrier, pw.agent_commission_pct, pw.created_at, pw.updated_at;

-- ============================================================================
-- Product Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_PRODUCT_PERFORMANCE AS
SELECT
    pp.policy_product_id,
    pp.product_name,
    pp.product_code,
    pp.state_program,
    pp.coverage_type,
    pp.base_rate,
    pp.industry_class_code,
    pp.hazard_level,
    pp.product_status,
    pp.is_active,
    pp.launch_date,
    COUNT(DISTINCT pw.policy_id) AS total_policies_sold,
    COUNT(DISTINCT CASE WHEN pw.policy_status = 'ACTIVE' THEN pw.policy_id END) AS active_policies,
    COUNT(DISTINCT CASE WHEN pw.competitive_win = TRUE THEN pw.policy_id END) AS competitive_wins,
    SUM(pw.actual_annual_premium) AS total_premium_written,
    AVG(pw.actual_annual_premium) AS avg_premium_per_policy,
    COUNT(DISTINCT c.claim_id) AS total_claims,
    SUM(c.total_incurred) AS total_claims_cost,
    CASE 
        WHEN SUM(pw.actual_annual_premium) > 0 THEN (SUM(c.total_incurred) / SUM(pw.actual_annual_premium) * 100.0)::NUMBER(8,2)
        ELSE 0.00
    END AS loss_ratio_pct,
    AVG(DATEDIFF('day', pp.launch_date, CURRENT_DATE()))::NUMBER(10,0) AS days_in_market,
    pp.created_at,
    pp.updated_at
FROM RAW.POLICY_PRODUCTS pp
LEFT JOIN RAW.POLICIES_WRITTEN pw ON pp.policy_product_id = pw.policy_product_id
LEFT JOIN RAW.CLAIMS c ON pw.employer_id = c.employer_id AND c.injury_date BETWEEN pw.effective_date AND pw.expiration_date
GROUP BY
    pp.policy_product_id, pp.product_name, pp.product_code, pp.state_program,
    pp.coverage_type, pp.base_rate, pp.industry_class_code, pp.hazard_level,
    pp.product_status, pp.is_active, pp.launch_date, pp.created_at, pp.updated_at;

-- ============================================================================
-- Agent Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_AGENT_PERFORMANCE AS
SELECT
    ag.agent_id,
    ag.agent_name,
    ag.agency_type,
    ag.country,
    ag.region,
    ag.agent_status,
    ag.partnership_tier,
    ag.states_licensed,
    ag.commission_rate,
    COUNT(DISTINCT pw.policy_id) AS total_policies_sold,
    COUNT(DISTINCT CASE WHEN pw.policy_status = 'ACTIVE' THEN pw.policy_id END) AS active_policies,
    SUM(pw.actual_annual_premium) AS total_premium_written,
    SUM(pw.actual_annual_premium * ag.commission_rate / 100.0) AS total_commission_earned,
    COUNT(DISTINCT pr.renewal_id) AS total_renewals,
    SUM(pr.renewal_premium) AS total_renewal_premium,
    COUNT(DISTINCT pw.employer_id) AS unique_employers,
    COUNT(DISTINCT pp.participation_id) AS program_participations,
    SUM(pp.premium_generated) AS program_generated_premium,
    ag.created_at,
    ag.updated_at
FROM RAW.INSURANCE_AGENTS ag
LEFT JOIN RAW.POLICIES_WRITTEN pw ON ag.agent_id = pw.agent_id
LEFT JOIN RAW.POLICY_RENEWALS pr ON ag.agent_id = pr.agent_id
LEFT JOIN RAW.AGENT_PROGRAM_PARTICIPATION pp ON ag.agent_id = pp.agent_id
GROUP BY
    ag.agent_id, ag.agent_name, ag.agency_type, ag.country, ag.region,
    ag.agent_status, ag.partnership_tier, ag.states_licensed, ag.commission_rate,
    ag.created_at, ag.updated_at;

-- ============================================================================
-- Claims Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_CLAIMS_ANALYTICS AS
SELECT
    c.claim_id,
    c.employer_id,
    e.employer_name,
    e.industry_vertical,
    c.injured_worker_id,
    iw.worker_name,
    iw.job_title,
    c.policy_id,
    c.injury_date,
    c.report_date,
    c.claim_status,
    c.injury_type,
    c.body_part,
    c.claim_type,
    c.severity,
    c.adjuster_id,
    adj.adjuster_name,
    adj.adjuster_type,
    adj.specialty AS adjuster_specialty,
    c.medical_paid,
    c.indemnity_paid,
    c.total_incurred,
    c.total_reserved,
    c.days_lost,
    c.return_to_work_date,
    c.claim_closure_date,
    c.settlement_amount,
    c.litigated,
    DATEDIFF('day', c.injury_date, c.report_date) AS days_to_report,
    DATEDIFF('day', c.injury_date, c.return_to_work_date) AS days_to_return_to_work,
    DATEDIFF('day', c.injury_date, c.claim_closure_date) AS days_to_close,
    c.created_at,
    c.updated_at
FROM RAW.CLAIMS c
JOIN RAW.EMPLOYERS e ON c.employer_id = e.employer_id
LEFT JOIN RAW.INJURED_WORKERS iw ON c.injured_worker_id = iw.injured_worker_id
LEFT JOIN RAW.CLAIMS_ADJUSTERS adj ON c.adjuster_id = adj.adjuster_id;

-- ============================================================================
-- Claim Dispute Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_CLAIM_DISPUTE_ANALYTICS AS
SELECT
    cd.dispute_id,
    cd.claim_id,
    c.injury_date,
    c.claim_status,
    cd.employer_id,
    e.employer_name,
    e.industry_vertical,
    e.business_segment,
    cd.injured_worker_id,
    iw.worker_name,
    cd.dispute_filed_date,
    cd.dispute_type,
    cd.dispute_severity,
    cd.dispute_status,
    cd.resolution_method,
    cd.dispute_outcome,
    cd.resolution_date,
    cd.legal_costs,
    cd.settlement_amount,
    cd.attorney_involved,
    cd.dispute_category,
    DATEDIFF('day', cd.dispute_filed_date, cd.resolution_date) AS days_to_resolution,
    c.total_incurred AS claim_total_incurred,
    CASE 
        WHEN c.total_incurred > 0 THEN (cd.settlement_amount / c.total_incurred * 100.0)::NUMBER(8,2)
        ELSE 0.00
    END AS settlement_pct_of_claim,
    cd.created_at,
    cd.updated_at
FROM RAW.CLAIM_DISPUTES cd
JOIN RAW.EMPLOYERS e ON cd.employer_id = e.employer_id
LEFT JOIN RAW.CLAIMS c ON cd.claim_id = c.claim_id
LEFT JOIN RAW.INJURED_WORKERS iw ON cd.injured_worker_id = iw.injured_worker_id;

-- ============================================================================
-- Premium Payment Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_PREMIUM_PAYMENT_ANALYTICS AS
SELECT
    pp.payment_id,
    pp.employer_id,
    e.employer_name,
    e.industry_vertical,
    e.business_segment,
    pp.payment_date,
    DATE_TRUNC('month', pp.payment_date) AS payment_month,
    DATE_TRUNC('quarter', pp.payment_date) AS payment_quarter,
    DATE_TRUNC('year', pp.payment_date) AS payment_year,
    pp.payment_type,
    pp.payment_amount,
    pp.payment_terms,
    pp.payment_status,
    pp.policy_id,
    pp.agent_id,
    ag.agent_name,
    pp.payment_method,
    pp.discount_amount,
    pp.late_fee_amount,
    pp.payment_source,
    pp.created_at,
    pp.updated_at
FROM RAW.PREMIUM_PAYMENTS pp
JOIN RAW.EMPLOYERS e ON pp.employer_id = e.employer_id
LEFT JOIN RAW.INSURANCE_AGENTS ag ON pp.agent_id = ag.agent_id;

-- ============================================================================
-- Adjuster Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_ADJUSTER_PERFORMANCE AS
SELECT
    adj.adjuster_id,
    adj.adjuster_name,
    adj.email,
    adj.adjuster_type,
    adj.specialty,
    adj.hire_date,
    adj.average_satisfaction_rating,
    adj.total_claims_closed,
    adj.states_licensed,
    adj.adjuster_status,
    COUNT(DISTINCT c.claim_id) AS current_claims_assigned,
    COUNT(DISTINCT CASE WHEN c.claim_status = 'OPEN' THEN c.claim_id END) AS open_claims,
    COUNT(DISTINCT CASE WHEN c.claim_status = 'CLOSED' THEN c.claim_id END) AS closed_claims,
    AVG(c.total_incurred) AS avg_claim_cost,
    AVG(DATEDIFF('day', c.injury_date, c.claim_closure_date)) AS avg_days_to_close,
    SUM(c.total_incurred) AS total_claims_handled_cost,
    COUNT(DISTINCT cred.credential_id) AS total_credentials,
    COUNT(DISTINCT CASE WHEN cred.credential_status = 'ACTIVE' THEN cred.credential_id END) AS active_credentials,
    adj.created_at,
    adj.updated_at
FROM RAW.CLAIMS_ADJUSTERS adj
LEFT JOIN RAW.CLAIMS c ON adj.adjuster_id = c.adjuster_id
LEFT JOIN RAW.PROFESSIONAL_CREDENTIALS cred ON adj.adjuster_id = cred.adjuster_id
GROUP BY
    adj.adjuster_id, adj.adjuster_name, adj.email, adj.adjuster_type,
    adj.specialty, adj.hire_date, adj.average_satisfaction_rating,
    adj.total_claims_closed, adj.states_licensed, adj.adjuster_status,
    adj.created_at, adj.updated_at;

-- ============================================================================
-- Credential Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_CREDENTIAL_ANALYTICS AS
SELECT
    cred.credential_id,
    cred.adjuster_id,
    adj.adjuster_name,
    adj.adjuster_type,
    cred.employer_id,
    cred.credential_type,
    cred.credential_name,
    cred.issuing_organization,
    cred.credential_number,
    cred.issue_date,
    cred.expiration_date,
    cred.verification_status,
    cred.credential_status,
    cred.primary_credential,
    cred.state_issued,
    cred.credential_level,
    DATEDIFF('day', CURRENT_DATE(), cred.expiration_date) AS days_until_expiration,
    CASE 
        WHEN cred.expiration_date IS NULL THEN 'NO_EXPIRATION'
        WHEN cred.expiration_date < CURRENT_DATE() THEN 'EXPIRED'
        WHEN DATEDIFF('day', CURRENT_DATE(), cred.expiration_date) <= 90 THEN 'EXPIRING_SOON'
        ELSE 'VALID'
    END AS expiration_status,
    COUNT(DISTINCT v.verification_id) AS verification_count,
    MAX(v.verification_date) AS last_verification_date,
    cred.created_at,
    cred.updated_at
FROM RAW.PROFESSIONAL_CREDENTIALS cred
LEFT JOIN RAW.CLAIMS_ADJUSTERS adj ON cred.adjuster_id = adj.adjuster_id
LEFT JOIN RAW.CREDENTIAL_VERIFICATIONS v ON cred.credential_id = v.credential_id
GROUP BY
    cred.credential_id, cred.adjuster_id, adj.adjuster_name, adj.adjuster_type,
    cred.employer_id, cred.credential_type, cred.credential_name,
    cred.issuing_organization, cred.credential_number, cred.issue_date,
    cred.expiration_date, cred.verification_status, cred.credential_status,
    cred.primary_credential, cred.state_issued, cred.credential_level,
    cred.created_at, cred.updated_at;

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All analytical views created successfully' AS status;

