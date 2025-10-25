<p align="center">
  <img src="../Snowflake_Logo.svg" alt="Snowflake Logo" width="200">
</p>

# Zenith Insurance Intelligence Agent - Setup Guide

This guide walks through configuring a Snowflake Intelligence agent for Zenith's workers' compensation insurance intelligence solution covering policies, claims, medical management, litigation, and fraud detection.

---

## Prerequisites

1. **Snowflake Account** with:
   - Snowflake Intelligence (Cortex) enabled
   - Appropriate warehouse size (recommended: X-SMALL or larger)
   - Permissions to create databases, schemas, tables, and semantic views

2. **Roles and Permissions**:
   - `ACCOUNTADMIN` role or equivalent for initial setup
   - `CREATE DATABASE` privilege
   - `CREATE SEMANTIC VIEW` privilege
   - `CREATE CORTEX SEARCH SERVICE` privilege
   - `USAGE` on warehouses

---

## Step 1: Execute SQL Scripts in Order

Execute the SQL files in the following sequence:

### 1.1 Database Setup
```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates database, schemas (RAW, ANALYTICS), and warehouse
-- Execution time: < 1 second
```

### 1.2 Create Tables
```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates all table structures with proper relationships
-- Tables: EMPLOYERS, INJURED_WORKERS, POLICY_PRODUCTS, INSURANCE_AGENTS,
--         POLICIES_WRITTEN, POLICY_RENEWALS, PREMIUM_PAYMENTS, SERVICE_CONTRACTS,
--         PROFESSIONAL_CREDENTIALS, CREDENTIAL_VERIFICATIONS, CLAIMS,
--         CLAIMS_ADJUSTERS, CLAIM_DISPUTES, AGENT_PROGRAMS, AGENT_PROGRAM_PARTICIPATION
-- Execution time: < 5 seconds
```

### 1.3 Generate Sample Data
```sql
-- Execute: sql/data/03_generate_synthetic_data.sql
-- Generates realistic sample data:
--   - 25,000 employers
--   - 250,000 injured workers
--   - 500,000 policies written
--   - 300,000 policy renewals
--   - 1,000,000 premium payments
--   - 40,000 professional credentials
--   - 75,000 claims
--   - 25,000 claim disputes
-- Execution time: 10-20 minutes (depending on warehouse size)
```

### 1.4 Create Analytical Views
```sql
-- Execute: sql/views/04_create_views.sql
-- Creates curated analytical views:
--   - V_EMPLOYER_360
--   - V_INJURED_WORKER_ANALYTICS
--   - V_POLICY_ANALYTICS
--   - V_PRODUCT_PERFORMANCE
--   - V_AGENT_PERFORMANCE
--   - V_CLAIMS_ANALYTICS
--   - V_CLAIM_DISPUTE_ANALYTICS
--   - V_PREMIUM_PAYMENT_ANALYTICS
--   - V_ADJUSTER_PERFORMANCE
--   - V_CREDENTIAL_ANALYTICS
-- Execution time: < 5 seconds
```

### 1.5 Create Semantic Views
```sql
-- Execute: sql/views/05_create_semantic_views.sql
-- Creates semantic views for AI agents (VERIFIED SYNTAX):
--   - SV_POLICY_UNDERWRITING_INTELLIGENCE
--   - SV_CLAIMS_MEDICAL_INTELLIGENCE
--   - SV_LITIGATION_DISPUTE_INTELLIGENCE
-- Execution time: < 5 seconds
```

### 1.6 Create Cortex Search Services
```sql
-- Execute: sql/search/06_create_cortex_search.sql
-- Creates tables for unstructured text data:
--   - CLAIM_NOTES (25,000 adjuster notes and medical reviews)
--   - MEDICAL_TREATMENT_GUIDELINES (3 evidence-based protocols)
--   - SIU_INVESTIGATION_REPORTS (15,000 fraud investigation reports)
-- Creates Cortex Search services for semantic search:
--   - CLAIM_NOTES_SEARCH
--   - MEDICAL_TREATMENT_GUIDELINES_SEARCH
--   - SIU_INVESTIGATION_REPORTS_SEARCH
-- Execution time: 5-10 minutes (data generation + index building)
```

---

## Step 2: Grant Cortex Analyst Permissions

Before creating the agent, ensure proper permissions are configured:

### 2.1 Grant Database Role for Cortex Analyst

```sql
USE ROLE ACCOUNTADMIN;

-- Grant Cortex Analyst user role
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE <your_role>;

-- Grant usage on database and schemas
GRANT USAGE ON DATABASE ZENITH_INSURANCE_INTELLIGENCE TO ROLE <your_role>;
GRANT USAGE ON SCHEMA ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS TO ROLE <your_role>;
GRANT USAGE ON SCHEMA ZENITH_INSURANCE_INTELLIGENCE.RAW TO ROLE <your_role>;

-- Grant privileges on semantic views
GRANT REFERENCES, SELECT ON SEMANTIC VIEW ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.SV_POLICY_UNDERWRITING_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.SV_CLAIMS_MEDICAL_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.SV_LITIGATION_DISPUTE_INTELLIGENCE TO ROLE <your_role>;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE ZENITH_WH TO ROLE <your_role>;

-- Grant usage on Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE ZENITH_INSURANCE_INTELLIGENCE.RAW.CLAIM_NOTES_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE ZENITH_INSURANCE_INTELLIGENCE.RAW.MEDICAL_TREATMENT_GUIDELINES_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE ZENITH_INSURANCE_INTELLIGENCE.RAW.SIU_INVESTIGATION_REPORTS_SEARCH TO ROLE <your_role>;
```

---

## Step 3: Create Snowflake Intelligence Agent

### Step 3.1: Create the Agent

1. In Snowsight, click on **AI & ML** > **Agents**
2. Click on **Create Agent**
3. Select **Create this agent for Snowflake Intelligence**
4. Configure:
   - **Agent Object Name**: `ZENITH_INSURANCE_INTELLIGENCE_AGENT`
   - **Display Name**: `Zenith Insurance Intelligence Agent`
5. Click **Create**

### Step 3.2: Add Description and Instructions

1. Click on **ZENITH_INSURANCE_INTELLIGENCE_AGENT** to open the agent
2. Click **Edit** on the top right corner
3. In the **Description** section, add:
   ```
   This agent orchestrates between Zenith Insurance workers' compensation data for analyzing 
   structured metrics using Cortex Analyst (semantic views) and unstructured claim notes, 
   medical guidelines, and fraud investigation reports using Cortex Search services.
   ```

### Step 3.3: Configure Response Instructions

1. Click on **Instructions** in the left pane
2. Enter the following **Response Instructions**:
   ```
   You are a specialized analytics assistant for Zenith Insurance, a leading workers' compensation 
   insurance provider. Your primary objectives are:

   For structured data queries (policies, claims, financial metrics, loss ratios):
   - Use the Cortex Analyst semantic views for policy underwriting, claims medical intelligence, 
     and litigation dispute analysis
   - Provide direct, numerical answers with minimal explanation
   - Format responses clearly with relevant units, percentages, and time periods
   - Only include essential context needed to understand the metric

   For unstructured content (claim notes, medical guidelines, fraud investigations):
   - Use Cortex Search services to find similar claims, treatment protocols, and investigation findings
   - Extract relevant adjuster notes, return-to-work strategies, and settlement approaches
   - Summarize fraud investigation findings and medical treatment recommendations
   - Maintain context from original claim notes and investigation reports

   Operating guidelines:
   - Always identify whether you're using Cortex Analyst or Cortex Search for each response
   - Keep responses under 3-4 sentences when possible for metrics
   - Present numerical data in structured format
   - Don't speculate beyond available data
   - Highlight loss ratios, claim frequency, return-to-work rates, and fraud indicators
   - For claim analysis, reference specific injury types, body parts, and industries
   - Include medical guideline references when discussing treatment appropriateness
   ```

3. **Add Sample Questions** (click "Add a question" for each):
   - "Which employers have the highest claim frequency in construction?"
   - "What is our competitive win rate against Travelers and Hartford?"
   - "Search claim notes for successful return-to-work strategies for back injuries"

---

## Step 3.4: Add Cortex Analyst Tools (Semantic Views)

1. Click on **Tools** in the left pane
2. Find **Cortex Analyst** and click **+ Add**

**Add Semantic View 1: Policy & Underwriting Intelligence**

1. **Select semantic view**: `ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.SV_POLICY_UNDERWRITING_INTELLIGENCE`
2. **Add a description**:
   ```
   This semantic view contains comprehensive data about employers, insurance agents, policy products, 
   policies written, renewals, and professional credentials. Use this for queries about:
   - New policy production and competitive wins
   - Policy renewal rates and premium changes
   - Agent performance and commission analysis
   - Employer risk profiles and mod ratings
   - Coverage types and state programs
   - Professional credentials and licensing
   ```
3. **Save**

**Add Semantic View 2: Claims & Medical Intelligence**

1. Click **+ Add** again for another Cortex Analyst tool
2. **Select semantic view**: `ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.SV_CLAIMS_MEDICAL_INTELLIGENCE`
3. **Add a description**:
   ```
   This semantic view contains claims data, injured workers, medical costs, adjusters, and outcomes. 
   Use this for queries about:
   - Claim costs (medical and indemnity paid)
   - Return-to-work rates and lost time days
   - Injury types and body part analysis
   - Adjuster performance and caseload
   - Claim severity and litigation rates
   - Industry-specific claim patterns
   ```
4. **Save**

**Add Semantic View 3: Litigation & Dispute Intelligence**

1. Click **+ Add** again for another Cortex Analyst tool
2. **Select semantic view**: `ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.SV_LITIGATION_DISPUTE_INTELLIGENCE`
3. **Add a description**:
   ```
   This semantic view contains claim disputes, litigation cases, legal costs, and settlement data. 
   Use this for queries about:
   - Dispute rates by type and severity
   - Legal costs and attorney involvement
   - Settlement amounts and outcomes
   - Resolution methods (mediation, arbitration, trial)
   - Employer-specific litigation patterns
   - Dispute resolution timeframes
   ```
4. **Save**

---

## Step 3.5: Add Cortex Search Tools (Unstructured Data)

1. While still in **Tools**, find **Cortex Search** and click **+ Add**

**Add Cortex Search 1: Claim Notes**

1. **Select Cortex Search Service**: `ZENITH_INSURANCE_INTELLIGENCE.RAW.CLAIM_NOTES_SEARCH`
2. **Add a description**:
   ```
   Search 25,000 claim adjuster notes and medical reviews for return-to-work strategies, 
   settlement approaches, and claim management best practices. Use for queries about:
   - Successful return-to-work programs and modified duty
   - Settlement negotiation strategies and outcomes
   - Medical management approaches for specific injuries
   - Adjuster handling of complex claims
   - Employer cooperation and accommodation
   - Claim resolution best practices
   ```
3. **Configure search settings**:
   - **ID Column**: `note_id`
   - **Title Column**: `claim_id`
   - **Max Results**: 10
4. **Save**

**Add Cortex Search 2: Medical Treatment Guidelines**

1. Click **+ Add** again for another Cortex Search
2. **Select Cortex Search Service**: `ZENITH_INSURANCE_INTELLIGENCE.RAW.MEDICAL_TREATMENT_GUIDELINES_SEARCH`
3. **Add a description**:
   ```
   Search evidence-based medical treatment guidelines and protocols for appropriate care pathways. 
   Use for queries about:
   - ODG-compliant treatment timelines for specific injuries
   - Return-to-work restrictions and functional capacity
   - Medication management and opioid guidelines
   - Physical therapy protocols and exercise programs
   - Red flags for serious pathology
   - Treatment that exceeds medical necessity
   ```
4. **Configure search settings**:
   - **ID Column**: `guideline_id`
   - **Title Column**: `title`
   - **Max Results**: 5
5. **Save**

**Add Cortex Search 3: SIU Investigation Reports**

1. Click **+ Add** again for another Cortex Search
2. **Select Cortex Search Service**: `ZENITH_INSURANCE_INTELLIGENCE.RAW.SIU_INVESTIGATION_REPORTS_SEARCH`
3. **Add a description**:
   ```
   Search Special Investigation Unit fraud investigation reports for fraud patterns, surveillance 
   findings, and investigation techniques. Use for queries about:
   - Surveillance evidence and activity inconsistencies
   - Medical provider fraud and overbilling patterns
   - Staged accidents and false injury claims
   - Social media investigation findings
   - Pre-existing condition investigations
   - Exaggeration of disability indicators
   ```
4. **Configure search settings**:
   - **ID Column**: `investigation_report_id`
   - **Title Column**: `claim_id`
   - **Max Results**: 10
5. **Save**

---

## Step 4: Test the Agent

### Step 4.1: Test Structured Data Queries (Cortex Analyst)

1. In the agent interface, click **Chat**
2. Try these test questions:

**Test 1: Policy Analysis**
```
Which coverage types have the best loss ratios? Show total premium and total claims cost.
```
Expected: Uses SV_POLICY_UNDERWRITING_INTELLIGENCE with claims data

**Test 2: Competitive Intelligence**
```
Show me our competitive win rate. Which competitors are we winning against most?
```
Expected: Uses SV_POLICY_UNDERWRITING_INTELLIGENCE, filters competitive_win = TRUE

**Test 3: Claims Cost Analysis**
```
What are the average medical and indemnity costs by injury type?
```
Expected: Uses SV_CLAIMS_MEDICAL_INTELLIGENCE, groups by injury_type

**Test 4: Return to Work Analysis**
```
Which employers have the best return-to-work rates? Show average days lost.
```
Expected: Uses SV_CLAIMS_MEDICAL_INTELLIGENCE, calculates days to return to work

**Test 5: Litigation Trends**
```
What is our dispute rate by employer industry? Show legal costs by industry vertical.
```
Expected: Uses SV_LITIGATION_DISPUTE_INTELLIGENCE, aggregates by industry

### Step 4.2: Test Unstructured Data Queries (Cortex Search)

**Test 6: Claim Notes Search**
```
Search claim notes for successful back injury return to work strategies
```
Expected: Uses CLAIM_NOTES_SEARCH, returns relevant adjuster notes

**Test 7: Medical Guidelines Search**
```
What do our treatment guidelines say about appropriate low back injury treatment timelines?
```
Expected: Uses MEDICAL_TREATMENT_GUIDELINES_SEARCH, retrieves ODG protocols

**Test 8: Fraud Investigation Search**
```
Find SIU reports about surveillance evidence showing activity inconsistencies
```
Expected: Uses SIU_INVESTIGATION_REPORTS_SEARCH, returns fraud investigation findings

**Test 9: Settlement Strategies**
```
Search claim notes for mediation settlement approaches in disputed claims
```
Expected: Uses CLAIM_NOTES_SEARCH, finds settlement discussions

**Test 10: Medical Management**
```
What guidance do treatment guidelines provide about opioid medication management?
```
Expected: Uses MEDICAL_TREATMENT_GUIDELINES_SEARCH, retrieves medication protocols

### Step 4.3: Test Combined Queries (Structured + Unstructured)

**Test 11: Claims + Treatment Analysis**
```
Which injury types have the highest costs? Search treatment guidelines for appropriate care.
```
Expected: Uses both SV_CLAIMS_MEDICAL_INTELLIGENCE and MEDICAL_TREATMENT_GUIDELINES_SEARCH

**Test 12: Litigation + Investigation**
```
Show dispute rates by employer. Search SIU reports for fraud patterns in disputed claims.
```
Expected: Uses SV_LITIGATION_DISPUTE_INTELLIGENCE and SIU_INVESTIGATION_REPORTS_SEARCH

---

## Verification Steps

### Verify Semantic Views
```sql
SHOW SEMANTIC VIEWS IN SCHEMA ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS;
-- Should show 3 semantic views
```

### Verify Cortex Search Services
```sql
SHOW CORTEX SEARCH SERVICES IN SCHEMA ZENITH_INSURANCE_INTELLIGENCE.RAW;
-- Should show 3 search services
```

### Test Cortex Search Directly
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'ZENITH_INSURANCE_INTELLIGENCE.RAW.CLAIM_NOTES_SEARCH',
      '{"query": "return to work modified duty", "limit":5}'
  )
)['results'] as results;
```

---

## Troubleshooting

### Agent Not Finding Data
1. Verify permissions on semantic views and search services
2. Check that warehouse is assigned and running
3. Ensure semantic views have data (check row counts)

### Cortex Search Not Working
1. Verify change tracking is enabled on tables
2. Check that search services are in READY state
3. Allow 5-10 minutes for initial indexing after creation

### Slow Response Times
1. Increase warehouse size for data generation
2. Verify Cortex Search indexes have built
3. Check query complexity in Cortex Analyst

---

## Next Steps

1. **Customize Questions**: Add insurance-specific questions to the agent
2. **Integrate with Applications**: Use agent via API for custom applications
3. **Monitor Usage**: Track which queries are most common
4. **Expand Data**: Add more employers, claims, or time periods
5. **Enhance Search**: Add more unstructured content (emails, medical records, etc.)

---

---

## OPTIONAL: Add ML Models (Claim Cost, Fraud Detection, RTW Prediction)

This section is optional but adds powerful ML prediction capabilities to your agent.

### Prerequisites for ML Models

- Core setup (Steps 1-3) completed
- Files 01-06 executed successfully
- Agent configured with semantic views and Cortex Search

### ML Setup Overview

1. Upload and run Snowflake Notebook to train models
2. Execute SQL wrapper procedures file
3. Add 3 ML procedures to agent as tools

**Time:** 20-30 minutes

---

### ML Step 1: Upload Notebook to Snowflake (5 min)

1. In Snowsight, click **Projects** → **Notebooks**
2. Click **+ Notebook** → **Import .ipynb file**
3. Upload: `notebooks/zenith_ml_models.ipynb`
4. Name it: `Zenith ML Models`
5. Configure:
   - **Database:** ZENITH_INSURANCE_INTELLIGENCE
   - **Schema:** ANALYTICS
   - **Warehouse:** ZENITH_WH
6. Click **Create**

### ML Step 2: Add Required Packages

1. In the notebook, click **Packages** dropdown (upper right)
2. Search and add each package:
   - `snowflake-ml-python`
   - `scikit-learn`
   - `xgboost`
   - `matplotlib`
3. Click **Start** to activate the notebook

### ML Step 3: Run Notebook to Train Models (10 min)

1. Click **Run All** (or run each cell sequentially)
2. Wait for training to complete (2-3 minutes per model)
3. Verify output shows:
   - "✅ Claim cost prediction model trained"
   - "✅ Fraud detection model trained"
   - "✅ Return-to-work timeline model trained"
   - "✅ Claim cost model registered to Model Registry as CLAIM_COST_PREDICTOR"
   - "✅ Fraud detection model registered to Model Registry as FRAUD_DETECTOR"
   - "✅ RTW timeline model registered to Model Registry as RTW_TIMELINE_PREDICTOR"

**Models created:**
- CLAIM_COST_PREDICTOR (Linear Regression for cost prediction)
- FRAUD_DETECTOR (Random Forest for fraud classification)
- RTW_TIMELINE_PREDICTOR (Linear Regression for return-to-work timeline)

### ML Step 4: Create Wrapper Procedures (2 min)

Execute the SQL wrapper procedures:

```sql
@sql/ml/07_create_model_wrapper_functions.sql
```

This creates 3 stored procedures that wrap the Model Registry models so the agent can call them.

**Procedures created:**
- PREDICT_CLAIM_COST(injury_type_filter, industry_filter)
- DETECT_FRAUD_RISK(claim_status_filter)
- PREDICT_RTW_TIMELINE(injury_type_filter, industry_filter)

### ML Step 5: Add ML Procedures to Agent (10 min)

#### Navigate to Agent Tools

1. In your agent editor (ZENITH_INSURANCE_INTELLIGENCE_AGENT)
2. Click **Tools** (left sidebar)

#### Add Procedure 1: PREDICT_CLAIM_COST

1. Click **+ Add** button (top right)
2. Click **Procedure** tile (NOT Function)
3. In dropdown, select: `ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.PREDICT_CLAIM_COST`
4. Paste in Description:
   ```
   Claim Cost Prediction Procedure
   
   Predicts total incurred costs for claims using the CLAIM_COST_PREDICTOR model from Model Registry.
   The model uses Linear Regression trained on closed claim patterns.
   
   Use when users ask to:
   - Predict claim costs
   - Forecast claim expenses
   - Estimate total incurred costs
   - Project medical and indemnity costs
   
   Parameters:
   - injury_type_filter: Filter by injury type (STRAIN_SPRAIN, FRACTURE, etc.) or empty for all
   - industry_filter: Filter by industry (CONSTRUCTION, HEALTHCARE, etc.) or empty for all
   
   Returns: JSON with average predicted cost, total predicted cost, min/max costs
   
   Example: "Predict costs for open back injuries in construction"
   ```
5. Click **Add**

#### Add Procedure 2: DETECT_FRAUD_RISK

1. Click **+ Add** → **Procedure**
2. Select: `ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.DETECT_FRAUD_RISK`
3. Description:
   ```
   Fraud Risk Detection Procedure
   
   Identifies claims with high fraud risk using the FRAUD_DETECTOR model from Model Registry.
   Uses Random Forest classifier trained on fraud indicators and patterns.
   
   Use when users ask to:
   - Identify fraud risk claims
   - Detect suspicious claims
   - Find claims needing SIU investigation
   - Screen for potential fraud
   
   Parameter:
   - claim_status_filter: Filter by status (OPEN, LITIGATED) or empty for both
   
   Returns: JSON with fraud risk count, fraud rate percentage, and SIU referral recommendation
   
   Example: "Which open claims have high fraud risk?"
   ```
4. Click **Add**

#### Add Procedure 3: PREDICT_RTW_TIMELINE

1. Click **+ Add** → **Procedure**
2. Select: `ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS.PREDICT_RTW_TIMELINE`
3. Description:
   ```
   Return-to-Work Timeline Prediction Procedure
   
   Predicts days until injured worker returns to work using the RTW_TIMELINE_PREDICTOR
   model from Model Registry. Uses Linear Regression.
   
   Use when users ask to:
   - Predict return-to-work timelines
   - Forecast recovery duration
   - Estimate days to RTW
   - Project disability duration
   
   Parameters:
   - injury_type_filter: Filter by injury (STRAIN_SPRAIN, FRACTURE, etc.) or empty for all
   - industry_filter: Filter by industry (CONSTRUCTION, HEALTHCARE, etc.) or empty for all
   
   Returns: JSON with average predicted RTW days, min/max, and counts by timeline buckets
   
   Example: "Predict RTW timeline for shoulder injuries in healthcare"
   ```
4. Click **Add**

#### Verify ML Procedures Added

Your agent's **Tools** section should now show:
- **Cortex Analyst (3):** Semantic views
- **Cortex Search (3):** Search services
- **Procedures (3):** ML prediction procedures

**Total: 9 tools**

### ML Step 6: Test ML Capabilities

Ask your agent:

```
"Predict costs for open back injury claims"
"Which claims have high fraud risk that should be investigated?"
"Predict return-to-work timeline for shoulder injuries in construction"
```

The agent will call the appropriate ML procedures and return predictions!

---

## Complete Setup Summary

### Core Setup (Required - 45 minutes):
1. Execute SQL files 01-06
2. Configure agent with semantic views and Cortex Search

### ML Setup (Optional - 30 minutes):
1. Upload and run ML notebook
2. Execute wrapper procedures SQL
3. Add 3 procedures to agent

**Total with ML: ~75 minutes**

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** Microchip Intelligence Agent Template  
**Verified:** All syntax verified against Snowflake documentation

**Setup Time Estimate**: 30-45 minutes core | +30 minutes ML (optional)

