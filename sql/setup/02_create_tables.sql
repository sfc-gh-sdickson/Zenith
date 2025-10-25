-- ============================================================================
-- Zenith Insurance Intelligence Agent - Table Definitions
-- ============================================================================
-- Purpose: Create all necessary tables for Zenith workers' compensation
--          insurance business model
-- Based on verified Microchip template structure
-- All columns verified against MAPPING_DOCUMENT.md
-- ============================================================================

USE DATABASE ZENITH_INSURANCE_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE ZENITH_WH;

-- ============================================================================
-- EMPLOYERS TABLE (from CUSTOMERS)
-- ============================================================================
CREATE OR REPLACE TABLE EMPLOYERS (
    employer_id VARCHAR(20) PRIMARY KEY,
    employer_name VARCHAR(200) NOT NULL,
    primary_contact_email VARCHAR(200) NOT NULL,
    primary_contact_phone VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    state VARCHAR(50),
    city VARCHAR(100),
    onboarding_date DATE NOT NULL,
    employer_status VARCHAR(20) DEFAULT 'ACTIVE',
    business_segment VARCHAR(30),
    lifetime_premium_value NUMBER(12,2) DEFAULT 0.00,
    credit_risk_score NUMBER(5,2),
    industry_vertical VARCHAR(50),
    annual_payroll NUMBER(15,2),
    employee_count NUMBER(10,0),
    safety_rating VARCHAR(10),
    mod_rating NUMBER(5,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- INJURED_WORKERS TABLE (from DESIGN_ENGINEERS)
-- ============================================================================
CREATE OR REPLACE TABLE INJURED_WORKERS (
    injured_worker_id VARCHAR(30) PRIMARY KEY,
    employer_id VARCHAR(20) NOT NULL,
    worker_name VARCHAR(200) NOT NULL,
    email VARCHAR(200),
    job_title VARCHAR(100),
    department VARCHAR(100),
    worker_status VARCHAR(20) DEFAULT 'ACTIVE',
    years_of_experience NUMBER(5,0),
    safety_training_completed BOOLEAN DEFAULT FALSE,
    injury_history_count NUMBER(5,0) DEFAULT 0,
    age NUMBER(3,0),
    hire_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id)
);

-- ============================================================================
-- SERVICE_CONTRACTS TABLE (from SUPPORT_CONTRACTS)
-- ============================================================================
CREATE OR REPLACE TABLE SERVICE_CONTRACTS (
    contract_id VARCHAR(30) PRIMARY KEY,
    employer_id VARCHAR(20) NOT NULL,
    contract_type VARCHAR(50) NOT NULL,
    service_tier VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    billing_cycle VARCHAR(20),
    monthly_fee NUMBER(10,2),
    dedicated_adjuster BOOLEAN DEFAULT FALSE,
    priority_service BOOLEAN DEFAULT FALSE,
    safety_program_included BOOLEAN DEFAULT FALSE,
    nurse_case_management BOOLEAN DEFAULT FALSE,
    contract_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id)
);

-- ============================================================================
-- POLICY_PRODUCTS TABLE (from PRODUCT_CATALOG)
-- ============================================================================
CREATE OR REPLACE TABLE POLICY_PRODUCTS (
    policy_product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    product_code VARCHAR(50) NOT NULL,
    state_program VARCHAR(50) NOT NULL,
    coverage_type VARCHAR(50),
    base_rate NUMBER(10,4),
    industry_class_code VARCHAR(10),
    hazard_level VARCHAR(20),
    product_description VARCHAR(1000),
    product_status VARCHAR(30) DEFAULT 'ACTIVE',
    is_active BOOLEAN DEFAULT TRUE,
    launch_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- INSURANCE_AGENTS TABLE (from DISTRIBUTORS)
-- ============================================================================
CREATE OR REPLACE TABLE INSURANCE_AGENTS (
    agent_id VARCHAR(20) PRIMARY KEY,
    agent_name VARCHAR(200) NOT NULL,
    agency_type VARCHAR(30),
    contact_email VARCHAR(200),
    contact_phone VARCHAR(20),
    country VARCHAR(50),
    region VARCHAR(50),
    agent_status VARCHAR(20) DEFAULT 'ACTIVE',
    partnership_tier VARCHAR(30),
    states_licensed VARCHAR(500),
    commission_rate NUMBER(5,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- POLICIES_WRITTEN TABLE (from DESIGN_WINS)
-- ============================================================================
CREATE OR REPLACE TABLE POLICIES_WRITTEN (
    policy_id VARCHAR(30) PRIMARY KEY,
    agent_id VARCHAR(20) NOT NULL,
    policy_product_id VARCHAR(30) NOT NULL,
    employer_id VARCHAR(20) NOT NULL,
    effective_date DATE NOT NULL,
    policy_status VARCHAR(30) DEFAULT 'QUOTED',
    expiration_date DATE,
    industry_class_code VARCHAR(10),
    estimated_annual_premium NUMBER(12,2),
    actual_annual_premium NUMBER(12,2),
    competitive_win BOOLEAN DEFAULT FALSE,
    previous_carrier VARCHAR(100),
    agent_commission_pct NUMBER(5,2),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agent_id) REFERENCES INSURANCE_AGENTS(agent_id),
    FOREIGN KEY (policy_product_id) REFERENCES POLICY_PRODUCTS(policy_product_id),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id)
);

-- ============================================================================
-- POLICY_RENEWALS TABLE (from PRODUCTION_ORDERS)
-- ============================================================================
CREATE OR REPLACE TABLE POLICY_RENEWALS (
    renewal_id VARCHAR(30) PRIMARY KEY,
    policy_id VARCHAR(30) NOT NULL,
    agent_id VARCHAR(20) NOT NULL,
    policy_product_id VARCHAR(30) NOT NULL,
    employer_id VARCHAR(20) NOT NULL,
    renewal_effective_date DATE NOT NULL,
    renewal_premium NUMBER(12,2),
    premium_change_pct NUMBER(8,2),
    mod_rating_at_renewal NUMBER(5,2),
    renewal_date DATE NOT NULL,
    renewal_status VARCHAR(30) DEFAULT 'RENEWED',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (policy_id) REFERENCES POLICIES_WRITTEN(policy_id),
    FOREIGN KEY (agent_id) REFERENCES INSURANCE_AGENTS(agent_id),
    FOREIGN KEY (policy_product_id) REFERENCES POLICY_PRODUCTS(policy_product_id),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id)
);

-- ============================================================================
-- PROFESSIONAL_CREDENTIALS TABLE (from CERTIFICATIONS)
-- ============================================================================
CREATE OR REPLACE TABLE PROFESSIONAL_CREDENTIALS (
    credential_id VARCHAR(30) PRIMARY KEY,
    adjuster_id VARCHAR(30) NOT NULL,
    employer_id VARCHAR(20),
    credential_type VARCHAR(50) NOT NULL,
    credential_name VARCHAR(200) NOT NULL,
    issuing_organization VARCHAR(200),
    credential_number VARCHAR(100),
    issue_date DATE NOT NULL,
    expiration_date DATE,
    verification_status VARCHAR(30) DEFAULT 'VERIFIED',
    credential_status VARCHAR(30) DEFAULT 'ACTIVE',
    primary_credential BOOLEAN DEFAULT FALSE,
    state_issued VARCHAR(50),
    credential_level VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- CREDENTIAL_VERIFICATIONS TABLE (from CERTIFICATION_VERIFICATIONS)
-- ============================================================================
CREATE OR REPLACE TABLE CREDENTIAL_VERIFICATIONS (
    verification_id VARCHAR(30) PRIMARY KEY,
    credential_id VARCHAR(30) NOT NULL,
    verification_date TIMESTAMP_NTZ NOT NULL,
    verification_method VARCHAR(50),
    verification_status VARCHAR(30) NOT NULL,
    verified_by VARCHAR(100),
    verification_source VARCHAR(200),
    notes VARCHAR(1000),
    next_verification_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (credential_id) REFERENCES PROFESSIONAL_CREDENTIALS(credential_id)
);

-- ============================================================================
-- PREMIUM_PAYMENTS TABLE (from ORDERS)
-- ============================================================================
CREATE OR REPLACE TABLE PREMIUM_PAYMENTS (
    payment_id VARCHAR(30) PRIMARY KEY,
    employer_id VARCHAR(20) NOT NULL,
    payment_date TIMESTAMP_NTZ NOT NULL,
    payment_type VARCHAR(50) NOT NULL,
    payment_amount NUMBER(12,2) NOT NULL,
    payment_terms VARCHAR(30),
    payment_status VARCHAR(30) DEFAULT 'COMPLETED',
    currency VARCHAR(10) DEFAULT 'USD',
    policy_id VARCHAR(30),
    agent_id VARCHAR(20),
    payment_method VARCHAR(30),
    discount_amount NUMBER(10,2) DEFAULT 0.00,
    late_fee_amount NUMBER(10,2) DEFAULT 0.00,
    payment_source VARCHAR(30),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id),
    FOREIGN KEY (policy_id) REFERENCES POLICIES_WRITTEN(policy_id),
    FOREIGN KEY (agent_id) REFERENCES INSURANCE_AGENTS(agent_id)
);

-- ============================================================================
-- CLAIMS TABLE (from SUPPORT_TICKETS)
-- ============================================================================
CREATE OR REPLACE TABLE CLAIMS (
    claim_id VARCHAR(30) PRIMARY KEY,
    employer_id VARCHAR(20) NOT NULL,
    injured_worker_id VARCHAR(30),
    policy_id VARCHAR(30),
    injury_date DATE NOT NULL,
    report_date TIMESTAMP_NTZ NOT NULL,
    claim_status VARCHAR(30) DEFAULT 'REPORTED',
    injury_type VARCHAR(50) NOT NULL,
    body_part VARCHAR(50),
    injury_description VARCHAR(5000),
    accident_description VARCHAR(5000),
    claim_type VARCHAR(30),
    severity VARCHAR(20) DEFAULT 'MEDIUM',
    adjuster_id VARCHAR(20),
    medical_paid NUMBER(12,2) DEFAULT 0.00,
    indemnity_paid NUMBER(12,2) DEFAULT 0.00,
    total_incurred NUMBER(12,2) DEFAULT 0.00,
    total_reserved NUMBER(12,2) DEFAULT 0.00,
    days_lost NUMBER(10,0) DEFAULT 0,
    return_to_work_date DATE,
    claim_closure_date TIMESTAMP_NTZ,
    settlement_amount NUMBER(12,2),
    litigated BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id),
    FOREIGN KEY (injured_worker_id) REFERENCES INJURED_WORKERS(injured_worker_id),
    FOREIGN KEY (policy_id) REFERENCES POLICIES_WRITTEN(policy_id)
);

-- ============================================================================
-- CLAIMS_ADJUSTERS TABLE (from SUPPORT_ENGINEERS)
-- ============================================================================
CREATE OR REPLACE TABLE CLAIMS_ADJUSTERS (
    adjuster_id VARCHAR(20) PRIMARY KEY,
    adjuster_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    adjuster_type VARCHAR(50),
    specialty VARCHAR(100),
    hire_date DATE,
    average_satisfaction_rating NUMBER(3,2),
    total_claims_closed NUMBER(10,0) DEFAULT 0,
    states_licensed VARCHAR(500),
    adjuster_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- CLAIM_DISPUTES TABLE (from QUALITY_ISSUES)
-- ============================================================================
CREATE OR REPLACE TABLE CLAIM_DISPUTES (
    dispute_id VARCHAR(30) PRIMARY KEY,
    claim_id VARCHAR(30) NOT NULL,
    employer_id VARCHAR(20) NOT NULL,
    injured_worker_id VARCHAR(30),
    dispute_filed_date TIMESTAMP_NTZ NOT NULL,
    dispute_type VARCHAR(50) NOT NULL,
    dispute_severity VARCHAR(20) DEFAULT 'MEDIUM',
    dispute_description VARCHAR(5000),
    dispute_status VARCHAR(30) DEFAULT 'OPEN',
    resolution_method VARCHAR(50),
    dispute_outcome VARCHAR(100),
    resolution_date TIMESTAMP_NTZ,
    legal_costs NUMBER(12,2) DEFAULT 0.00,
    settlement_amount NUMBER(12,2),
    attorney_involved BOOLEAN DEFAULT FALSE,
    dispute_category VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (claim_id) REFERENCES CLAIMS(claim_id),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id),
    FOREIGN KEY (injured_worker_id) REFERENCES INJURED_WORKERS(injured_worker_id)
);

-- ============================================================================
-- AGENT_PROGRAMS TABLE (from MARKETING_CAMPAIGNS)
-- ============================================================================
CREATE OR REPLACE TABLE AGENT_PROGRAMS (
    program_id VARCHAR(30) PRIMARY KEY,
    program_name VARCHAR(200) NOT NULL,
    program_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    target_agent_tier VARCHAR(100),
    budget NUMBER(12,2),
    program_channel VARCHAR(50),
    program_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- AGENT_PROGRAM_PARTICIPATION TABLE (from CUSTOMER_CAMPAIGN_INTERACTIONS)
-- ============================================================================
CREATE OR REPLACE TABLE AGENT_PROGRAM_PARTICIPATION (
    participation_id VARCHAR(30) PRIMARY KEY,
    agent_id VARCHAR(20) NOT NULL,
    program_id VARCHAR(30) NOT NULL,
    participation_date TIMESTAMP_NTZ NOT NULL,
    participation_type VARCHAR(50) NOT NULL,
    led_to_new_policy BOOLEAN DEFAULT FALSE,
    premium_generated NUMBER(12,2) DEFAULT 0.00,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (agent_id) REFERENCES INSURANCE_AGENTS(agent_id),
    FOREIGN KEY (program_id) REFERENCES AGENT_PROGRAMS(program_id)
);

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All tables created successfully' AS status;

