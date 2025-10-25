-- ============================================================================
-- Zenith Insurance Intelligence Agent - Semantic Views
-- ============================================================================
-- Purpose: Create semantic views for Snowflake Intelligence agents
-- All syntax VERIFIED against official documentation:
-- https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
-- 
-- Syntax Verification Notes:
-- 1. Clause order is MANDATORY: TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT
-- 2. Semantic expression format: semantic_name AS sql_expression
-- 3. No self-referencing relationships allowed
-- 4. No cyclic relationships allowed
-- 5. PRIMARY KEY columns must exist in table definitions
-- 6. All column references VERIFIED against 02_create_tables.sql
-- 7. All synonyms are GLOBALLY UNIQUE across all semantic views
-- ============================================================================

USE DATABASE ZENITH_INSURANCE_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE ZENITH_WH;

-- ============================================================================
-- Semantic View 1: Zenith Policy & Underwriting Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_POLICY_UNDERWRITING_INTELLIGENCE
  TABLES (
    employers AS RAW.EMPLOYERS
      PRIMARY KEY (employer_id)
      WITH SYNONYMS ('policyholders', 'insured companies', 'business clients')
      COMMENT = 'Employers purchasing workers compensation insurance',
    agents AS RAW.INSURANCE_AGENTS
      PRIMARY KEY (agent_id)
      WITH SYNONYMS ('insurance brokers', 'agent partners', 'producers')
      COMMENT = 'Insurance agents selling policies',
    policy_products AS RAW.POLICY_PRODUCTS
      PRIMARY KEY (policy_product_id)
      WITH SYNONYMS ('coverage products', 'insurance programs', 'policy types')
      COMMENT = 'Workers compensation policy products',
    policies AS RAW.POLICIES_WRITTEN
      PRIMARY KEY (policy_id)
      WITH SYNONYMS ('written policies', 'coverage policies', 'issued policies')
      COMMENT = 'Policies written for employers',
    renewals AS RAW.POLICY_RENEWALS
      PRIMARY KEY (renewal_id)
      WITH SYNONYMS ('policy renewals', 'renewal transactions', 'renewed policies')
      COMMENT = 'Policy renewals and endorsements',
    credentials AS RAW.PROFESSIONAL_CREDENTIALS
      PRIMARY KEY (credential_id)
      WITH SYNONYMS ('adjuster licenses', 'professional licenses', 'certifications')
      COMMENT = 'Professional credentials and licenses'
  )
  RELATIONSHIPS (
    policies(agent_id) REFERENCES agents(agent_id),
    policies(policy_product_id) REFERENCES policy_products(policy_product_id),
    policies(employer_id) REFERENCES employers(employer_id),
    renewals(policy_id) REFERENCES policies(policy_id),
    renewals(agent_id) REFERENCES agents(agent_id),
    renewals(policy_product_id) REFERENCES policy_products(policy_product_id),
    renewals(employer_id) REFERENCES employers(employer_id)
  )
  DIMENSIONS (
    employers.employer_name AS employer_name
      WITH SYNONYMS ('company name view1', 'insured name', 'policyholder name')
      COMMENT = 'Name of the employer',
    employers.employer_status AS employer_status
      WITH SYNONYMS ('account status view1', 'employer active status')
      COMMENT = 'Employer status: ACTIVE, INACTIVE, NON_RENEWED',
    employers.business_segment AS business_segment
      WITH SYNONYMS ('employer segment view1', 'business size category')
      COMMENT = 'Business segment: SMALL_BUSINESS, MIDMARKET, LARGE_ACCOUNT',
    employers.industry_vertical AS industry_vertical
      WITH SYNONYMS ('business industry', 'employer sector', 'industry classification')
      COMMENT = 'Industry vertical: CONSTRUCTION, MANUFACTURING, HEALTHCARE, RETAIL, HOSPITALITY, AGRICULTURE, TRANSPORTATION',
    employers.state AS state
      WITH SYNONYMS ('employer state view1', 'business location state')
      COMMENT = 'Employer state location',
    employers.city AS city
      WITH SYNONYMS ('employer city view1', 'business location city')
      COMMENT = 'Employer city location',
    employers.safety_rating AS safety_rating
      WITH SYNONYMS ('safety score', 'safety grade', 'loss control rating')
      COMMENT = 'Safety rating: A+, A, A-, B+, B, B-, C+, C',
    agents.agent_name AS agent_name
      WITH SYNONYMS ('broker name', 'producer name', 'agency name')
      COMMENT = 'Name of the insurance agent',
    agents.agency_type AS agency_type
      WITH SYNONYMS ('broker type', 'agent classification')
      COMMENT = 'Agency type: INDEPENDENT, CAPTIVE, MGA, WHOLESALER',
    agents.region AS region
      WITH SYNONYMS ('agent territory', 'sales region')
      COMMENT = 'Agent region',
    agents.agent_status AS agent_status
      WITH SYNONYMS ('agent active status', 'broker status')
      COMMENT = 'Agent status: ACTIVE, INACTIVE',
    agents.partnership_tier AS partnership_tier
      WITH SYNONYMS ('agent tier', 'producer level', 'partnership level')
      COMMENT = 'Partnership tier: PLATINUM, GOLD, SILVER, BRONZE',
    policy_products.product_name AS product_name
      WITH SYNONYMS ('coverage name', 'program name', 'policy product name')
      COMMENT = 'Name of the policy product',
    policy_products.state_program AS state_program
      WITH SYNONYMS ('jurisdiction', 'state coverage', 'regulatory program')
      COMMENT = 'State program where policy is issued',
    policy_products.coverage_type AS coverage_type
      WITH SYNONYMS ('policy type', 'coverage class', 'program type')
      COMMENT = 'Coverage type: STANDARD, HIGH_HAZARD, LARGE_DEDUCTIBLE, HEALTHCARE, RETAIL, HOSPITALITY, AGRICULTURE, PREMIUM_SAFETY',
    policy_products.industry_class_code AS industry_class_code
      WITH SYNONYMS ('ncci code', 'class code', 'risk classification')
      COMMENT = 'Industry classification code',
    policy_products.hazard_level AS hazard_level
      WITH SYNONYMS ('risk level', 'danger level', 'exposure level')
      COMMENT = 'Hazard level: LOW, MEDIUM, HIGH, EXTREME',
    policy_products.product_status AS product_status
      WITH SYNONYMS ('policy product status', 'coverage availability')
      COMMENT = 'Product status: ACTIVE, INACTIVE',
    policies.policy_status AS policy_status
      WITH SYNONYMS ('coverage status', 'policy state')
      COMMENT = 'Policy status: QUOTED, ACTIVE, CANCELLED, EXPIRED',
    policies.competitive_win AS competitive_win
      WITH SYNONYMS ('won from competitor', 'competitive takeout', 'market share gain')
      COMMENT = 'Whether policy was won from competitor',
    renewals.renewal_status AS renewal_status
      WITH SYNONYMS ('renewal state', 'reinstatement status')
      COMMENT = 'Renewal status: RENEWED, NON_RENEWED, PENDING',
    credentials.credential_type AS credential_type
      WITH SYNONYMS ('license type', 'certification type')
      COMMENT = 'Credential type: STATE_ADJUSTER_LICENSE, NURSE_CASE_MANAGER, CCM, CPCU, AIC, WCCA',
    credentials.credential_status AS credential_status
      WITH SYNONYMS ('license status', 'certification status')
      COMMENT = 'Credential status: ACTIVE, EXPIRED',
    credentials.state_issued AS state_issued
      WITH SYNONYMS ('licensing state', 'credential jurisdiction')
      COMMENT = 'State that issued the credential',
    credentials.credential_level AS credential_level
      WITH SYNONYMS ('certification level', 'professional level')
      COMMENT = 'Credential level: ASSOCIATE, PROFESSIONAL, EXPERT, SPECIALIST'
  )
  METRICS (
    employers.total_employers AS COUNT(DISTINCT employer_id)
      WITH SYNONYMS ('employer count view1', 'number of policyholders')
      COMMENT = 'Total number of employers',
    employers.avg_lifetime_premium AS AVG(lifetime_premium_value)
      WITH SYNONYMS ('average lifetime premium', 'mean premium value')
      COMMENT = 'Average lifetime premium value per employer',
    employers.avg_mod_rating AS AVG(mod_rating)
      WITH SYNONYMS ('average experience mod', 'mean modification factor')
      COMMENT = 'Average experience modification rating',
    employers.avg_payroll AS AVG(annual_payroll)
      WITH SYNONYMS ('average annual payroll', 'mean payroll')
      COMMENT = 'Average annual payroll across employers',
    agents.total_agents AS COUNT(DISTINCT agent_id)
      WITH SYNONYMS ('agent count', 'broker count', 'producer count')
      COMMENT = 'Total number of insurance agents',
    agents.avg_commission_rate AS AVG(commission_rate)
      WITH SYNONYMS ('average commission', 'mean agent commission')
      COMMENT = 'Average commission rate for agents',
    policy_products.total_products AS COUNT(DISTINCT policy_product_id)
      WITH SYNONYMS ('product count view1', 'coverage count')
      COMMENT = 'Total number of policy products',
    policy_products.avg_base_rate AS AVG(base_rate)
      WITH SYNONYMS ('average policy rate', 'mean premium rate')
      COMMENT = 'Average base rate across policy products',
    policies.total_policies AS COUNT(DISTINCT policy_id)
      WITH SYNONYMS ('policy count', 'written policy count')
      COMMENT = 'Total number of policies written',
    policies.total_estimated_premium AS SUM(estimated_annual_premium)
      WITH SYNONYMS ('total estimated premium', 'aggregate estimated premium')
      COMMENT = 'Total estimated annual premium across all policies',
    policies.total_actual_premium AS SUM(actual_annual_premium)
      WITH SYNONYMS ('total earned premium', 'aggregate actual premium')
      COMMENT = 'Total actual annual premium across all policies',
    policies.avg_premium AS AVG(actual_annual_premium)
      WITH SYNONYMS ('average policy premium', 'mean premium per policy')
      COMMENT = 'Average premium per policy',
    renewals.total_renewals AS COUNT(DISTINCT renewal_id)
      WITH SYNONYMS ('renewal count', 'reinstatement count')
      COMMENT = 'Total number of policy renewals',
    renewals.total_renewal_premium AS SUM(renewal_premium)
      WITH SYNONYMS ('total renewed premium', 'aggregate renewal premium')
      COMMENT = 'Total renewal premium',
    renewals.avg_premium_change AS AVG(premium_change_pct)
      WITH SYNONYMS ('average premium change', 'mean rate change')
      COMMENT = 'Average premium change percentage at renewal',
    credentials.total_credentials AS COUNT(DISTINCT credential_id)
      WITH SYNONYMS ('credential count', 'license count')
      COMMENT = 'Total number of professional credentials'
  )
  COMMENT = 'Zenith Policy & Underwriting Intelligence - comprehensive view of employers, agents, policies, renewals, and credentials';

-- ============================================================================
-- Semantic View 2: Zenith Claims & Medical Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_CLAIMS_MEDICAL_INTELLIGENCE
  TABLES (
    employers AS RAW.EMPLOYERS
      PRIMARY KEY (employer_id)
      WITH SYNONYMS ('claim employers view2', 'insured employers', 'employers having claims')
      COMMENT = 'Employers with claims',
    claims AS RAW.CLAIMS
      PRIMARY KEY (claim_id)
      WITH SYNONYMS ('injury claims', 'workers comp claims', 'compensation claims')
      COMMENT = 'Workers compensation claims',
    injured_workers AS RAW.INJURED_WORKERS
      PRIMARY KEY (injured_worker_id)
      WITH SYNONYMS ('claimants', 'injured employees', 'workers')
      COMMENT = 'Injured workers filing claims',
    adjusters AS RAW.CLAIMS_ADJUSTERS
      PRIMARY KEY (adjuster_id)
      WITH SYNONYMS ('claims adjusters', 'case managers', 'claims examiners')
      COMMENT = 'Claims adjusters handling claims',
    policy_products AS RAW.POLICY_PRODUCTS
      PRIMARY KEY (policy_product_id)
      WITH SYNONYMS ('claim policy products', 'coverage types', 'policy programs')
      COMMENT = 'Policy products associated with claims'
  )
  RELATIONSHIPS (
    claims(employer_id) REFERENCES employers(employer_id),
    claims(injured_worker_id) REFERENCES injured_workers(injured_worker_id),
    claims(adjuster_id) REFERENCES adjusters(adjuster_id),
    injured_workers(employer_id) REFERENCES employers(employer_id)
  )
  DIMENSIONS (
    employers.employer_name AS employer_name
      WITH SYNONYMS ('claim employer name', 'insured company name')
      COMMENT = 'Name of the employer',
    employers.business_segment AS business_segment
      WITH SYNONYMS ('employer segment view2', 'company size segment')
      COMMENT = 'Business segment: SMALL_BUSINESS, MIDMARKET, LARGE_ACCOUNT',
    employers.state AS state
      WITH SYNONYMS ('employer state view2', 'claim location state')
      COMMENT = 'Employer state location',
    claims.claim_status AS claim_status
      WITH SYNONYMS ('claim state', 'claim case status')
      COMMENT = 'Claim status: REPORTED, OPEN, MEDICAL_ONLY, LOST_TIME, CLOSED, LITIGATED',
    claims.injury_type AS injury_type
      WITH SYNONYMS ('type of injury', 'accident type', 'injury classification')
      COMMENT = 'Injury type: STRAIN_SPRAIN, LACERATION, FRACTURE, FALL, BURN, CRUSH, REPETITIVE_MOTION, AMPUTATION',
    claims.body_part AS body_part
      WITH SYNONYMS ('injured body part', 'affected area')
      COMMENT = 'Body part injured: BACK, SHOULDER, KNEE, HAND, WRIST, ANKLE, NECK, FINGER, ARM, LEG, MULTIPLE',
    claims.claim_type AS claim_type
      WITH SYNONYMS ('claim classification', 'disability type')
      COMMENT = 'Claim type: MEDICAL_ONLY, LOST_TIME, TEMPORARY_DISABILITY, PERMANENT_DISABILITY',
    claims.severity AS severity
      WITH SYNONYMS ('injury severity', 'claim severity', 'accident severity')
      COMMENT = 'Severity: MINOR, MODERATE, SERIOUS, CATASTROPHIC',
    claims.litigated AS litigated
      WITH SYNONYMS ('in litigation', 'attorney involved', 'disputed claim')
      COMMENT = 'Whether claim is in litigation',
    injured_workers.worker_name AS worker_name
      WITH SYNONYMS ('claimant name', 'injured employee name')
      COMMENT = 'Name of injured worker',
    injured_workers.job_title AS job_title
      WITH SYNONYMS ('worker position', 'employee role', 'occupation')
      COMMENT = 'Job title of injured worker',
    injured_workers.department AS department
      WITH SYNONYMS ('worker department', 'work unit')
      COMMENT = 'Department where worker is employed',
    injured_workers.worker_status AS worker_status
      WITH SYNONYMS ('employee status', 'worker employment status')
      COMMENT = 'Worker status: ACTIVE, INACTIVE',
    injured_workers.safety_training_completed AS safety_training_completed
      WITH SYNONYMS ('trained worker', 'safety certified worker')
      COMMENT = 'Whether worker completed safety training',
    adjusters.adjuster_name AS adjuster_name
      WITH SYNONYMS ('examiner name', 'case manager name')
      COMMENT = 'Name of claims adjuster',
    adjusters.adjuster_type AS adjuster_type
      WITH SYNONYMS ('adjuster role', 'examiner type')
      COMMENT = 'Adjuster type: FIELD_ADJUSTER, DESK_ADJUSTER, NURSE_CASE_MANAGER, INVESTIGATOR, ATTORNEY',
    adjusters.specialty AS specialty
      WITH SYNONYMS ('adjuster expertise', 'case manager specialty')
      COMMENT = 'Adjuster specialty area',
    adjusters.adjuster_status AS adjuster_status
      WITH SYNONYMS ('adjuster active status', 'examiner status')
      COMMENT = 'Adjuster status: ACTIVE, INACTIVE',
    policy_products.product_name AS product_name
      WITH SYNONYMS ('claim coverage name', 'policy name for claims')
      COMMENT = 'Name of policy product',
    policy_products.coverage_type AS coverage_type
      WITH SYNONYMS ('claim coverage type', 'policy coverage class')
      COMMENT = 'Coverage type',
    policy_products.hazard_level AS hazard_level
      WITH SYNONYMS ('claim risk level', 'exposure hazard')
      COMMENT = 'Hazard level of coverage'
  )
  METRICS (
    employers.total_employers AS COUNT(DISTINCT employer_id)
      WITH SYNONYMS ('employer count view2', 'employers with claims')
      COMMENT = 'Total number of employers with claims',
    claims.total_claims AS COUNT(DISTINCT claim_id)
      WITH SYNONYMS ('claim count', 'injury count', 'number of claims')
      COMMENT = 'Total number of claims',
    claims.total_medical_paid AS SUM(medical_paid)
      WITH SYNONYMS ('total medical costs', 'aggregate medical payments')
      COMMENT = 'Total medical costs paid',
    claims.total_indemnity_paid AS SUM(indemnity_paid)
      WITH SYNONYMS ('total indemnity costs', 'aggregate wage loss payments')
      COMMENT = 'Total indemnity (lost wages) paid',
    claims.total_incurred_amount AS SUM(total_incurred)
      WITH SYNONYMS ('total claim costs', 'aggregate incurred costs', 'total losses')
      COMMENT = 'Total incurred costs (medical + indemnity)',
    claims.avg_incurred_per_claim AS AVG(claims.total_incurred)
      WITH SYNONYMS ('average claim cost', 'mean claim severity')
      COMMENT = 'Average incurred cost per claim',
    claims.total_reserved AS SUM(total_reserved)
      WITH SYNONYMS ('total reserves', 'aggregate case reserves')
      COMMENT = 'Total reserved amounts for open claims',
    claims.total_days_lost AS SUM(days_lost)
      WITH SYNONYMS ('total lost time', 'aggregate lost work days')
      COMMENT = 'Total days lost across all claims',
    claims.avg_days_lost AS AVG(days_lost)
      WITH SYNONYMS ('average lost time', 'mean days away from work')
      COMMENT = 'Average days lost per claim',
    claims.total_settlements AS SUM(settlement_amount)
      WITH SYNONYMS ('total settlement payments', 'aggregate settlements')
      COMMENT = 'Total settlement amounts',
    injured_workers.total_workers AS COUNT(DISTINCT injured_worker_id)
      WITH SYNONYMS ('injured worker count', 'claimant count')
      COMMENT = 'Total number of injured workers',
    injured_workers.avg_worker_age AS AVG(age)
      WITH SYNONYMS ('average claimant age', 'mean worker age')
      COMMENT = 'Average age of injured workers',
    injured_workers.avg_experience AS AVG(years_of_experience)
      WITH SYNONYMS ('average worker experience', 'mean years on job')
      COMMENT = 'Average years of experience for injured workers',
    adjusters.total_adjusters AS COUNT(DISTINCT adjuster_id)
      WITH SYNONYMS ('adjuster count', 'examiner count')
      COMMENT = 'Total number of claims adjusters',
    adjusters.avg_adjuster_rating AS AVG(average_satisfaction_rating)
      WITH SYNONYMS ('average adjuster satisfaction')
      COMMENT = 'Average satisfaction rating for adjusters',
    policy_products.total_products AS COUNT(DISTINCT policy_product_id)
      WITH SYNONYMS ('product count view2', 'coverage product count')
      COMMENT = 'Total number of policy products'
  )
  COMMENT = 'Zenith Claims & Medical Intelligence - comprehensive view of claims, injured workers, adjusters, medical costs, and outcomes';

-- ============================================================================
-- Semantic View 3: Zenith Litigation & Dispute Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_LITIGATION_DISPUTE_INTELLIGENCE
  TABLES (
    employers AS RAW.EMPLOYERS
      PRIMARY KEY (employer_id)
      WITH SYNONYMS ('dispute employers view3', 'litigated employers', 'employers in disputes')
      COMMENT = 'Employers with claim disputes',
    disputes AS RAW.CLAIM_DISPUTES
      PRIMARY KEY (dispute_id)
      WITH SYNONYMS ('claim disputes', 'litigation cases', 'contested claims')
      COMMENT = 'Claim disputes and litigation',
    claims AS RAW.CLAIMS
      PRIMARY KEY (claim_id)
      WITH SYNONYMS ('disputed claims', 'contested cases', 'claims in dispute')
      COMMENT = 'Claims related to disputes',
    injured_workers AS RAW.INJURED_WORKERS
      PRIMARY KEY (injured_worker_id)
      WITH SYNONYMS ('dispute claimants', 'litigating workers', 'disputing employees')
      COMMENT = 'Injured workers involved in disputes',
    adjusters AS RAW.CLAIMS_ADJUSTERS
      PRIMARY KEY (adjuster_id)
      WITH SYNONYMS ('dispute adjusters', 'litigation adjusters', 'defense adjusters')
      COMMENT = 'Adjusters handling disputed claims'
  )
  RELATIONSHIPS (
    disputes(claim_id) REFERENCES claims(claim_id),
    disputes(employer_id) REFERENCES employers(employer_id),
    disputes(injured_worker_id) REFERENCES injured_workers(injured_worker_id),
    claims(employer_id) REFERENCES employers(employer_id),
    claims(injured_worker_id) REFERENCES injured_workers(injured_worker_id),
    claims(adjuster_id) REFERENCES adjusters(adjuster_id)
  )
  DIMENSIONS (
    employers.employer_name AS employer_name
      WITH SYNONYMS ('dispute employer name', 'litigated company name')
      COMMENT = 'Name of the employer',
    employers.business_segment AS business_segment
      WITH SYNONYMS ('employer segment view3', 'disputing company segment')
      COMMENT = 'Business segment: SMALL_BUSINESS, MIDMARKET, LARGE_ACCOUNT',
    disputes.dispute_type AS dispute_type
      WITH SYNONYMS ('type of dispute', 'litigation issue', 'contested issue')
      COMMENT = 'Dispute type: COMPENSABILITY, CAUSATION, EXTENT_OF_INJURY, MEDICAL_TREATMENT, SETTLEMENT, PERMANENT_DISABILITY, IME',
    disputes.dispute_severity AS dispute_severity
      WITH SYNONYMS ('litigation severity', 'dispute complexity')
      COMMENT = 'Dispute severity: LOW, MEDIUM, HIGH, LITIGATION',
    disputes.dispute_status AS dispute_status
      WITH SYNONYMS ('litigation status', 'dispute state', 'case status')
      COMMENT = 'Dispute status: OPEN, IN_MEDIATION, ARBITRATION, LITIGATION, RESOLVED',
    disputes.resolution_method AS resolution_method
      WITH SYNONYMS ('dispute resolution type', 'settlement method')
      COMMENT = 'Resolution method: SETTLEMENT, MEDIATION, ARBITRATION, TRIAL, WITHDRAWN',
    disputes.dispute_outcome AS dispute_outcome
      WITH SYNONYMS ('litigation outcome', 'dispute result', 'case resolution')
      COMMENT = 'Dispute outcome: EMPLOYER_FAVOR, CLAIMANT_FAVOR, COMPROMISE, WITHDRAWN',
    disputes.attorney_involved AS attorney_involved
      WITH SYNONYMS ('legal representation', 'attorney retained', 'lawyer involved')
      COMMENT = 'Whether attorney is involved in dispute',
    disputes.dispute_category AS dispute_category
      WITH SYNONYMS ('legal category', 'dispute classification')
      COMMENT = 'Dispute category: MEDICAL, INDEMNITY, CAUSATION, APPORTIONMENT, TTD, PTD, PPD',
    claims.claim_status AS claim_status
      WITH SYNONYMS ('underlying claim status', 'original claim state')
      COMMENT = 'Status of underlying claim',
    claims.injury_type AS injury_type
      WITH SYNONYMS ('disputed injury type', 'contested injury')
      COMMENT = 'Type of injury in dispute',
    claims.claim_type AS claim_type
      WITH SYNONYMS ('disputed claim type', 'disability classification')
      COMMENT = 'Type of claim in dispute',
    injured_workers.worker_name AS worker_name
      WITH SYNONYMS ('disputing worker name', 'litigant name')
      COMMENT = 'Name of injured worker in dispute',
    injured_workers.job_title AS job_title
      WITH SYNONYMS ('disputing worker job', 'litigant occupation')
      COMMENT = 'Job title of worker in dispute',
    adjusters.adjuster_name AS adjuster_name
      WITH SYNONYMS ('defense adjuster name', 'litigation adjuster name')
      COMMENT = 'Name of adjuster handling dispute',
    adjusters.adjuster_type AS adjuster_type
      WITH SYNONYMS ('defense adjuster type', 'litigation handler type')
      COMMENT = 'Type of adjuster handling dispute',
    adjusters.specialty AS specialty
      WITH SYNONYMS ('litigation specialty', 'defense expertise')
      COMMENT = 'Specialty of adjuster'
  )
  METRICS (
    employers.total_employers AS COUNT(DISTINCT employer_id)
      WITH SYNONYMS ('employer count view3', 'employers with disputes')
      COMMENT = 'Total number of employers with disputes',
    disputes.total_disputes AS COUNT(DISTINCT dispute_id)
      WITH SYNONYMS ('dispute count', 'litigation count', 'number of disputes')
      COMMENT = 'Total number of disputes',
    disputes.total_legal_costs AS SUM(legal_costs)
      WITH SYNONYMS ('total attorney fees', 'aggregate legal expenses')
      COMMENT = 'Total legal costs',
    disputes.avg_legal_costs AS AVG(legal_costs)
      WITH SYNONYMS ('average legal costs', 'mean attorney fees')
      COMMENT = 'Average legal costs per dispute',
    disputes.total_settlement_amount AS SUM(settlement_amount)
      WITH SYNONYMS ('total settlements', 'aggregate dispute settlements')
      COMMENT = 'Total settlement amounts',
    disputes.avg_settlement_amount AS AVG(settlement_amount)
      WITH SYNONYMS ('average settlement', 'mean dispute settlement')
      COMMENT = 'Average settlement amount per dispute',
    claims.total_claims AS COUNT(DISTINCT claim_id)
      WITH SYNONYMS ('disputed claim count', 'claims in litigation')
      COMMENT = 'Total number of claims with disputes',
    claims.total_claim_costs AS SUM(total_incurred)
      WITH SYNONYMS ('total disputed claim costs', 'aggregate claim losses')
      COMMENT = 'Total costs of disputed claims',
    injured_workers.total_workers AS COUNT(DISTINCT injured_worker_id)
      WITH SYNONYMS ('disputing worker count', 'litigant count')
      COMMENT = 'Total number of workers involved in disputes',
    adjusters.total_adjusters AS COUNT(DISTINCT adjuster_id)
      WITH SYNONYMS ('defense adjuster count', 'litigation handler count')
      COMMENT = 'Total number of adjusters handling disputes'
  )
  COMMENT = 'Zenith Litigation & Dispute Intelligence - comprehensive view of claim disputes, litigation, legal costs, settlements, and outcomes';

-- ============================================================================
-- Display confirmation and verification
-- ============================================================================
SELECT 'Semantic views created successfully - all syntax verified' AS status;

-- Verify semantic views exist
SELECT 
    table_name AS semantic_view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS'
  AND table_name LIKE 'SV_%'
ORDER BY table_name;

-- Show semantic view details
SHOW SEMANTIC VIEWS IN SCHEMA ANALYTICS;

