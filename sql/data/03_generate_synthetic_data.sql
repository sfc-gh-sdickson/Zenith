-- ============================================================================
-- Zenith Insurance Intelligence Agent - Synthetic Data Generation
-- ============================================================================
-- Purpose: Generate realistic sample data for Zenith workers' compensation
--          insurance operations
-- Volume: ~25K employers, 250K injured workers, 500K policies, 75K claims
-- ============================================================================

USE DATABASE ZENITH_INSURANCE_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE ZENITH_WH;

-- ============================================================================
-- Step 1: Generate Insurance Agents
-- ============================================================================
INSERT INTO INSURANCE_AGENTS VALUES
('AG001', 'Premier Insurance Group', 'INDEPENDENT', 'sales@premierinsurance.com', '+1-555-0101', 'USA', 'WEST', 'ACTIVE', 'PLATINUM', 'CA,OR,WA,NV,AZ', 8.5, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG002', 'National Workers Comp Partners', 'MGA', 'contact@nationalwcp.com', '+1-555-0102', 'USA', 'MIDWEST', 'ACTIVE', 'PLATINUM', 'IL,IN,OH,MI,WI', 9.0, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG003', 'Coastal Risk Solutions', 'INDEPENDENT', 'info@coastalrisk.com', '+1-555-0103', 'USA', 'EAST', 'ACTIVE', 'GOLD', 'NY,NJ,PA,MA,CT', 7.5, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG004', 'Southwest Insurance Brokers', 'WHOLESALER', 'sales@swbrokers.com', '+1-555-0104', 'USA', 'SOUTHWEST', 'ACTIVE', 'GOLD', 'TX,NM,OK,AR', 7.0, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG005', 'Atlantic Insurance Alliance', 'INDEPENDENT', 'contact@atlanticalliance.com', '+1-555-0105', 'USA', 'SOUTHEAST', 'ACTIVE', 'SILVER', 'FL,GA,SC,NC,VA', 6.5, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG006', 'Mountain States Risk Management', 'INDEPENDENT', 'info@mountainstates.com', '+1-555-0106', 'USA', 'MOUNTAIN', 'ACTIVE', 'SILVER', 'CO,UT,ID,WY,MT', 6.0, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG007', 'Great Lakes Insurance Partners', 'CAPTIVE', 'sales@greatlakes.com', '+1-555-0107', 'USA', 'GREAT_LAKES', 'ACTIVE', 'GOLD', 'MN,WI,MI,IL,IN,OH', 7.5, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG008', 'Pacific Northwest Insurance Group', 'INDEPENDENT', 'contact@pnwinsurance.com', '+1-555-0108', 'USA', 'NORTHWEST', 'ACTIVE', 'BRONZE', 'WA,OR,ID', 5.5, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG009', 'Tri-State Workers Comp', 'MGA', 'info@tristatewc.com', '+1-555-0109', 'USA', 'TRI_STATE', 'ACTIVE', 'SILVER', 'NY,NJ,CT', 6.5, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('AG010', 'Southern Insurance Network', 'INDEPENDENT', 'sales@southerninsnet.com', '+1-555-0110', 'USA', 'SOUTH', 'ACTIVE', 'BRONZE', 'AL,MS,LA,TN', 5.0, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 2: Generate Policy Products
-- ============================================================================
INSERT INTO POLICY_PRODUCTS VALUES
-- Standard Workers Comp Products
('PROD001', 'Standard Workers Compensation - CA', 'WC-STD-CA', 'CALIFORNIA', 'STANDARD', 2.45, '8810', 'LOW', 'Standard workers compensation coverage for California employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD002', 'Standard Workers Compensation - NY', 'WC-STD-NY', 'NEW_YORK', 'STANDARD', 2.85, '8810', 'LOW', 'Standard workers compensation coverage for New York employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD003', 'Standard Workers Compensation - TX', 'WC-STD-TX', 'TEXAS', 'STANDARD', 1.95, '8810', 'LOW', 'Standard workers compensation coverage for Texas employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD004', 'Standard Workers Compensation - FL', 'WC-STD-FL', 'FLORIDA', 'STANDARD', 2.25, '8810', 'LOW', 'Standard workers compensation coverage for Florida employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- High Hazard Products
('PROD010', 'High Hazard Construction - Multi-State', 'WC-HH-CONST', 'MULTI_STATE', 'HIGH_HAZARD', 12.50, '5403', 'EXTREME', 'Specialized coverage for high-risk construction operations', 'ACTIVE', TRUE, '2016-03-20', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD011', 'High Hazard Manufacturing - CA', 'WC-HH-MFG-CA', 'CALIFORNIA', 'HIGH_HAZARD', 8.75, '3632', 'HIGH', 'Coverage for manufacturing with heavy machinery', 'ACTIVE', TRUE, '2016-03-20', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD012', 'High Hazard Transportation - Multi-State', 'WC-HH-TRANS', 'MULTI_STATE', 'HIGH_HAZARD', 9.25, '7219', 'HIGH', 'Coverage for trucking and transportation companies', 'ACTIVE', TRUE, '2016-06-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Large Deductible Products
('PROD020', 'Large Deductible Program - $100K', 'WC-LD-100K', 'MULTI_STATE', 'LARGE_DEDUCTIBLE', 1.85, '8810', 'MEDIUM', 'Large employer program with $100,000 deductible', 'ACTIVE', TRUE, '2017-01-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD021', 'Large Deductible Program - $250K', 'WC-LD-250K', 'MULTI_STATE', 'LARGE_DEDUCTIBLE', 1.45, '8810', 'MEDIUM', 'Large employer program with $250,000 deductible', 'ACTIVE', TRUE, '2017-01-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD022', 'Large Deductible Program - $500K', 'WC-LD-500K', 'MULTI_STATE', 'LARGE_DEDUCTIBLE', 1.15, '8810', 'MEDIUM', 'Large employer program with $500,000 deductible', 'ACTIVE', TRUE, '2017-01-10', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Healthcare Products
('PROD030', 'Healthcare Workers Comp - Hospitals', 'WC-HC-HOSP', 'MULTI_STATE', 'HEALTHCARE', 4.25, '8833', 'MEDIUM', 'Specialized coverage for hospitals and medical centers', 'ACTIVE', TRUE, '2018-05-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD031', 'Healthcare Workers Comp - Nursing Homes', 'WC-HC-NH', 'MULTI_STATE', 'HEALTHCARE', 5.75, '8835', 'HIGH', 'Coverage for nursing homes and long-term care facilities', 'ACTIVE', TRUE, '2018-05-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Retail & Hospitality Products
('PROD040', 'Retail Workers Comp - Standard', 'WC-RET-STD', 'MULTI_STATE', 'RETAIL', 1.65, '8017', 'LOW', 'Coverage for retail stores and establishments', 'ACTIVE', TRUE, '2019-02-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD041', 'Hospitality Workers Comp - Restaurants', 'WC-HOSP-REST', 'MULTI_STATE', 'HOSPITALITY', 2.95, '9082', 'MEDIUM', 'Coverage for restaurants and food service', 'ACTIVE', TRUE, '2019-02-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD042', 'Hospitality Workers Comp - Hotels', 'WC-HOSP-HOTEL', 'MULTI_STATE', 'HOSPITALITY', 2.45, '9015', 'MEDIUM', 'Coverage for hotels and lodging establishments', 'ACTIVE', TRUE, '2019-02-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Small Business Products
('PROD050', 'Small Business Package - CA', 'WC-SB-CA', 'CALIFORNIA', 'SMALL_BUSINESS', 2.25, '8810', 'LOW', 'Affordable coverage for small California businesses', 'ACTIVE', TRUE, '2020-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD051', 'Small Business Package - Multi-State', 'WC-SB-MS', 'MULTI_STATE', 'SMALL_BUSINESS', 2.15, '8810', 'LOW', 'Multi-state coverage for growing small businesses', 'ACTIVE', TRUE, '2020-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Agriculture Products
('PROD060', 'Agricultural Workers Comp - CA', 'WC-AG-CA', 'CALIFORNIA', 'AGRICULTURE', 6.50, '0034', 'HIGH', 'Specialized coverage for California agricultural operations', 'ACTIVE', TRUE, '2020-09-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD061', 'Agricultural Workers Comp - Multi-State', 'WC-AG-MS', 'MULTI_STATE', 'AGRICULTURE', 5.75, '0034', 'HIGH', 'Coverage for agricultural operations across multiple states', 'ACTIVE', TRUE, '2020-09-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Premium Safety Programs
('PROD070', 'Premium Safety Plus - Manufacturing', 'WC-PSP-MFG', 'MULTI_STATE', 'PREMIUM_SAFETY', 2.95, '3632', 'MEDIUM', 'Enhanced safety program for manufacturing with dedicated loss control', 'ACTIVE', TRUE, '2021-03-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD071', 'Premium Safety Plus - Construction', 'WC-PSP-CONST', 'MULTI_STATE', 'PREMIUM_SAFETY', 8.25, '5403', 'HIGH', 'Enhanced safety program for construction with on-site consultants', 'ACTIVE', TRUE, '2021-03-01', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Additional State Programs
('PROD080', 'Standard Workers Compensation - IL', 'WC-STD-IL', 'ILLINOIS', 'STANDARD', 2.35, '8810', 'LOW', 'Standard workers compensation coverage for Illinois employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD081', 'Standard Workers Compensation - PA', 'WC-STD-PA', 'PENNSYLVANIA', 'STANDARD', 2.55, '8810', 'LOW', 'Standard workers compensation coverage for Pennsylvania employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD082', 'Standard Workers Compensation - OH', 'WC-STD-OH', 'OHIO', 'STANDARD', 2.15, '8810', 'LOW', 'Standard workers compensation coverage for Ohio employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD083', 'Standard Workers Compensation - GA', 'WC-STD-GA', 'GEORGIA', 'STANDARD', 2.05, '8810', 'LOW', 'Standard workers compensation coverage for Georgia employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD084', 'Standard Workers Compensation - NC', 'WC-STD-NC', 'NORTH_CAROLINA', 'STANDARD', 2.25, '8810', 'LOW', 'Standard workers compensation coverage for North Carolina employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD085', 'Standard Workers Compensation - MI', 'WC-STD-MI', 'MICHIGAN', 'STANDARD', 2.45, '8810', 'LOW', 'Standard workers compensation coverage for Michigan employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD086', 'Standard Workers Compensation - WA', 'WC-STD-WA', 'WASHINGTON', 'STANDARD', 2.65, '8810', 'LOW', 'Standard workers compensation coverage for Washington employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD087', 'Standard Workers Compensation - AZ', 'WC-STD-AZ', 'ARIZONA', 'STANDARD', 2.05, '8810', 'LOW', 'Standard workers compensation coverage for Arizona employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD088', 'Standard Workers Compensation - CO', 'WC-STD-CO', 'COLORADO', 'STANDARD', 2.35, '8810', 'LOW', 'Standard workers compensation coverage for Colorado employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD089', 'Standard Workers Compensation - OR', 'WC-STD-OR', 'OREGON', 'STANDARD', 2.55, '8810', 'LOW', 'Standard workers compensation coverage for Oregon employers', 'ACTIVE', TRUE, '2015-01-15', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 3: Generate Claims Adjusters
-- ============================================================================
INSERT INTO CLAIMS_ADJUSTERS
SELECT
    'ADJ' || LPAD(SEQ4(), 5, '0') AS adjuster_id,
    ARRAY_CONSTRUCT('John Smith', 'Sarah Chen', 'Michael Johnson', 'Emily Rodriguez', 'David Kim',
                    'Jessica Martinez', 'Robert Lee', 'Amanda Patel', 'Christopher Brown', 'Lisa Anderson')[UNIFORM(0, 9, RANDOM())] 
        || ' ' || ARRAY_CONSTRUCT('Jr.', 'Sr.', '', '', '')[UNIFORM(0, 4, RANDOM())] AS adjuster_name,
    'adjuster' || SEQ4() || '@zenith.com' AS email,
    ARRAY_CONSTRUCT('FIELD_ADJUSTER', 'DESK_ADJUSTER', 'NURSE_CASE_MANAGER', 'INVESTIGATOR', 'ATTORNEY')[UNIFORM(0, 4, RANDOM())] AS adjuster_type,
    ARRAY_CONSTRUCT('Medical Only', 'Lost Time', 'Catastrophic', 'Fraud Investigation', 'Litigation', 'Return to Work')[UNIFORM(0, 5, RANDOM())] AS specialty,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_DATE()) AS hire_date,
    (UNIFORM(38, 50, RANDOM()) / 10.0)::NUMBER(3,2) AS average_satisfaction_rating,
    UNIFORM(50, 1500, RANDOM()) AS total_claims_closed,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN ARRAY_CONSTRUCT('CA', 'CA,OR,WA', 'NY,NJ,CT', 'TX', 'FL', 'IL,IN,OH')[UNIFORM(0, 5, RANDOM())]
         ELSE ARRAY_CONSTRUCT('CA', 'NY', 'TX', 'FL', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI')[UNIFORM(0, 9, RANDOM())]
    END AS states_licensed,
    'ACTIVE' AS adjuster_status,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 200));

-- ============================================================================
-- Step 4: Generate Employers
-- ============================================================================
INSERT INTO EMPLOYERS
SELECT
    'EMP' || LPAD(SEQ4(), 10, '0') AS employer_id,
    CASE 
        WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 
            ARRAY_CONSTRUCT('ABC Construction', 'XYZ Manufacturing', 'Premier Healthcare', 'Superior Transport', 'Golden State Restaurants')[UNIFORM(0, 4, RANDOM())] || ' Inc.'
        WHEN UNIFORM(0, 100, RANDOM()) < 40 THEN
            ARRAY_CONSTRUCT('Advanced', 'Quality', 'Reliable', 'Professional', 'Best', 'Premier')[UNIFORM(0, 5, RANDOM())] || ' ' ||
            ARRAY_CONSTRUCT('Construction', 'Manufacturing', 'Services', 'Solutions', 'Logistics', 'Healthcare')[UNIFORM(0, 5, RANDOM())]
        ELSE
            ARRAY_CONSTRUCT('Alpha', 'Beta', 'Delta', 'Omega', 'Summit', 'Peak', 'Crown', 'Elite')[UNIFORM(0, 7, RANDOM())] || ' ' ||
            ARRAY_CONSTRUCT('Corp', 'LLC', 'Industries', 'Group', 'Enterprises', 'Services')[UNIFORM(0, 5, RANDOM())]
    END AS employer_name,
    'contact' || SEQ4() || '@' || ARRAY_CONSTRUCT('company', 'corp', 'business', 'enterprise', 'group')[UNIFORM(0, 4, RANDOM())] || '.com' AS primary_contact_email,
    CONCAT('+1-', UNIFORM(200, 999, RANDOM()), '-', UNIFORM(100, 999, RANDOM()), '-', UNIFORM(1000, 9999, RANDOM())) AS primary_contact_phone,
    'USA' AS country,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI', 'WA', 'AZ', 'CO', 'OR')[UNIFORM(0, 13, RANDOM())] AS state,
    ARRAY_CONSTRUCT('Los Angeles', 'San Diego', 'Houston', 'Dallas', 'Miami', 'Orlando', 'New York', 'Chicago', 'Philadelphia', 'Atlanta', 'Seattle', 'Phoenix', 'Denver', 'Portland')[UNIFORM(0, 13, RANDOM())] AS city,
    DATEADD('day', -1 * UNIFORM(30, 5475, RANDOM()), CURRENT_DATE()) AS onboarding_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 6 THEN 'INACTIVE'
         ELSE 'NON_RENEWED' END AS employer_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'SMALL_BUSINESS'
         WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN 'MIDMARKET'
         ELSE 'LARGE_ACCOUNT' END AS business_segment,
    (UNIFORM(10000, 500000, RANDOM()) / 1.0)::NUMBER(12,2) AS lifetime_premium_value,
    (UNIFORM(5, 45, RANDOM()) / 1.0)::NUMBER(5,2) AS credit_risk_score,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN 'CONSTRUCTION'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'MANUFACTURING'
         WHEN UNIFORM(0, 100, RANDOM()) < 18 THEN 'HEALTHCARE'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'RETAIL'
         WHEN UNIFORM(0, 100, RANDOM()) < 12 THEN 'HOSPITALITY'
         WHEN UNIFORM(0, 100, RANDOM()) < 5 THEN 'AGRICULTURE'
         ELSE 'TRANSPORTATION' END AS industry_vertical,
    (UNIFORM(500000, 50000000, RANDOM()) / 1.0)::NUMBER(15,2) AS annual_payroll,
    UNIFORM(10, 5000, RANDOM()) AS employee_count,
    ARRAY_CONSTRUCT('A+', 'A', 'A-', 'B+', 'B', 'B-', 'C+', 'C')[UNIFORM(0, 7, RANDOM())] AS safety_rating,
    (UNIFORM(65, 165, RANDOM()) / 100.0)::NUMBER(5,2) AS mod_rating,
    DATEADD('day', -1 * UNIFORM(30, 5475, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 25000));

-- ============================================================================
-- Step 5: Generate Injured Workers
-- ============================================================================
INSERT INTO INJURED_WORKERS
SELECT
    'IW' || LPAD(SEQ4(), 10, '0') AS injured_worker_id,
    e.employer_id,
    ARRAY_CONSTRUCT('James', 'Jennifer', 'Michael', 'Michelle', 'David', 'Diana', 'Robert', 'Rachel', 'William', 'Wendy',
                    'Richard', 'Rebecca', 'Daniel', 'Danielle', 'Thomas', 'Tiffany', 'Charles', 'Christine')[UNIFORM(0, 17, RANDOM())]
        || ' ' ||
    ARRAY_CONSTRUCT('Smith', 'Johnson', 'Lee', 'Chen', 'Kim', 'Patel', 'Garcia', 'Martinez', 'Anderson', 'Wilson',
                    'Taylor', 'Brown', 'Jones', 'Miller', 'Davis')[UNIFORM(0, 14, RANDOM())] AS worker_name,
    'worker' || SEQ4() || '@' || LOWER(REPLACE(REPLACE(e.employer_name, ' ', ''), '.', '')) || '.com' AS email,
    CASE WHEN e.industry_vertical = 'CONSTRUCTION' THEN ARRAY_CONSTRUCT('Carpenter', 'Electrician', 'Plumber', 'Laborer', 'Foreman', 'Heavy Equipment Operator')[UNIFORM(0, 5, RANDOM())]
         WHEN e.industry_vertical = 'MANUFACTURING' THEN ARRAY_CONSTRUCT('Machine Operator', 'Assembler', 'Welder', 'Maintenance Tech', 'Quality Inspector', 'Forklift Operator')[UNIFORM(0, 5, RANDOM())]
         WHEN e.industry_vertical = 'HEALTHCARE' THEN ARRAY_CONSTRUCT('Nurse', 'CNA', 'Physical Therapist', 'Medical Assistant', 'Orderly', 'Lab Technician')[UNIFORM(0, 5, RANDOM())]
         WHEN e.industry_vertical = 'RETAIL' THEN ARRAY_CONSTRUCT('Sales Associate', 'Cashier', 'Stock Clerk', 'Department Manager', 'Receiving Clerk')[UNIFORM(0, 4, RANDOM())]
         WHEN e.industry_vertical = 'HOSPITALITY' THEN ARRAY_CONSTRUCT('Server', 'Cook', 'Housekeeper', 'Front Desk', 'Bartender', 'Kitchen Manager')[UNIFORM(0, 5, RANDOM())]
         WHEN e.industry_vertical = 'TRANSPORTATION' THEN ARRAY_CONSTRUCT('Driver', 'Warehouse Worker', 'Dispatcher', 'Mechanic', 'Loader')[UNIFORM(0, 4, RANDOM())]
         ELSE ARRAY_CONSTRUCT('Worker', 'Technician', 'Operator', 'Specialist', 'Associate')[UNIFORM(0, 4, RANDOM())]
    END AS job_title,
    ARRAY_CONSTRUCT('Operations', 'Production', 'Maintenance', 'Administration', 'Sales', 'Customer Service')[UNIFORM(0, 5, RANDOM())] AS department,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'ACTIVE' ELSE 'INACTIVE' END AS worker_status,
    UNIFORM(1, 35, RANDOM()) AS years_of_experience,
    UNIFORM(0, 100, RANDOM()) < 70 AS safety_training_completed,
    UNIFORM(0, 3, RANDOM()) AS injury_history_count,
    UNIFORM(18, 68, RANDOM()) AS age,
    DATEADD('day', -1 * UNIFORM(30, 7300, RANDOM()), CURRENT_DATE()) AS hire_date,
    DATEADD('day', -1 * UNIFORM(30, 5475, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM EMPLOYERS e
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 10))
WHERE UNIFORM(0, 100, RANDOM()) < 100
LIMIT 250000;

-- ============================================================================
-- Step 6: Generate Agent Programs
-- ============================================================================
INSERT INTO AGENT_PROGRAMS
SELECT
    'PROG' || LPAD(SEQ4(), 5, '0') AS program_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 
        ARRAY_CONSTRUCT('Safety', 'Loss Control', 'Claims Management', 'Risk Assessment', 'Return to Work')[UNIFORM(0, 4, RANDOM())] || ' ' ||
        ARRAY_CONSTRUCT('Training', 'Webinar Series', 'Workshop', 'Certification')[UNIFORM(0, 3, RANDOM())]
    ELSE
        ARRAY_CONSTRUCT('Agent Conference', 'Producer Summit', 'Quarterly Business Review', 'New Product Launch', 'Agency Excellence Awards')[UNIFORM(0, 4, RANDOM())]
    END AS program_name,
    ARRAY_CONSTRUCT('TRAINING', 'CONFERENCE', 'WEBINAR', 'SAFETY_CAMPAIGN', 'AGENT_RECOGNITION')[UNIFORM(0, 4, RANDOM())] AS program_type,
    DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_DATE()) AS start_date,
    DATEADD('day', UNIFORM(1, 90, RANDOM()), DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_DATE())) AS end_date,
    ARRAY_CONSTRUCT('PLATINUM', 'GOLD', 'SILVER', 'ALL')[UNIFORM(0, 3, RANDOM())] AS target_agent_tier,
    (UNIFORM(5000, 150000, RANDOM()) / 1.0)::NUMBER(12,2) AS budget,
    ARRAY_CONSTRUCT('IN_PERSON', 'WEBINAR', 'EMAIL', 'WEBSITE', 'CONFERENCE')[UNIFORM(0, 4, RANDOM())] AS program_channel,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 55 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 'ACTIVE'
         ELSE 'PLANNED' END AS program_status,
    DATEADD('day', -1 * UNIFORM(1, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- ============================================================================
-- Step 7: Generate Service Contracts
-- ============================================================================
INSERT INTO SERVICE_CONTRACTS
SELECT
    'SVC' || LPAD(SEQ4(), 10, '0') AS contract_id,
    e.employer_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN 'BASIC_SERVICE'
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 'PREMIUM_SERVICE'
         ELSE 'ENTERPRISE_SERVICE' END AS contract_type,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN 'BASIC'
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 'PROFESSIONAL'
         ELSE 'ENTERPRISE' END AS service_tier,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS start_date,
    DATEADD('year', 1, DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE())) AS end_date,
    ARRAY_CONSTRUCT('MONTHLY', 'QUARTERLY', 'ANNUAL')[UNIFORM(0, 2, RANDOM())] AS billing_cycle,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 50 THEN (UNIFORM(200, 1000, RANDOM()) / 1.0)::NUMBER(10,2)
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN (UNIFORM(1000, 3000, RANDOM()) / 1.0)::NUMBER(10,2)
         ELSE (UNIFORM(3000, 10000, RANDOM()) / 1.0)::NUMBER(10,2) END AS monthly_fee,
    UNIFORM(0, 100, RANDOM()) < 25 AS dedicated_adjuster,
    UNIFORM(0, 100, RANDOM()) < 40 AS priority_service,
    UNIFORM(0, 100, RANDOM()) < 60 AS safety_program_included,
    UNIFORM(0, 100, RANDOM()) < 35 AS nurse_case_management,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 82 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 12 THEN 'EXPIRED'
         ELSE 'CANCELLED' END AS contract_status,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM EMPLOYERS e
WHERE UNIFORM(0, 100, RANDOM()) < 60;

-- ============================================================================
-- Step 8: Generate Professional Credentials
-- ============================================================================
INSERT INTO PROFESSIONAL_CREDENTIALS
SELECT
    'CRED' || LPAD(SEQ4(), 10, '0') AS credential_id,
    a.adjuster_id,
    NULL AS employer_id,
    ARRAY_CONSTRUCT('STATE_ADJUSTER_LICENSE', 'NURSE_CASE_MANAGER', 'CCM', 'CPCU', 'AIC', 'WCCA', 'ARM', 'CRM')[UNIFORM(0, 7, RANDOM())] AS credential_type,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN
        ARRAY_CONSTRUCT('CA', 'NY', 'TX', 'FL', 'IL')[UNIFORM(0, 4, RANDOM())] || ' Adjuster License'
    ELSE
        ARRAY_CONSTRUCT('Certified Case Manager', 'Workers Comp Certified', 'Claims Professional', 'Risk Management')[UNIFORM(0, 3, RANDOM())]
    END AS credential_name,
    ARRAY_CONSTRUCT('State Department of Insurance', 'CCMC', 'The Institutes', 'NCCI', 'RIMS')[UNIFORM(0, 4, RANDOM())] AS issuing_organization,
    'LIC-' || LPAD(UNIFORM(100000, 999999, RANDOM()), 6, '0') AS credential_number,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_DATE()) AS issue_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 80 THEN DATEADD('year', 2, DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_DATE()))
         ELSE NULL END AS expiration_date,
    'VERIFIED' AS verification_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'ACTIVE' ELSE 'EXPIRED' END AS credential_status,
    UNIFORM(0, 100, RANDOM()) < 40 AS primary_credential,
    ARRAY_CONSTRUCT('CA', 'NY', 'TX', 'FL', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI')[UNIFORM(0, 9, RANDOM())] AS state_issued,
    ARRAY_CONSTRUCT('ASSOCIATE', 'PROFESSIONAL', 'EXPERT', 'SPECIALIST')[UNIFORM(0, 3, RANDOM())] AS credential_level,
    DATEADD('day', -1 * UNIFORM(30, 2555, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CLAIMS_ADJUSTERS a
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 2))
WHERE UNIFORM(0, 100, RANDOM()) < 100
LIMIT 40000;

-- ============================================================================
-- Step 9: Generate Policies Written
-- ============================================================================
INSERT INTO POLICIES_WRITTEN
SELECT
    'POL' || LPAD(SEQ4(), 12, '0') AS policy_id,
    ag.agent_id,
    pp.policy_product_id,
    e.employer_id,
    DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_DATE()) AS effective_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 12 THEN 'CANCELLED'
         WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN 'EXPIRED'
         ELSE 'QUOTED' END AS policy_status,
    DATEADD('year', 1, DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_DATE())) AS expiration_date,
    pp.industry_class_code,
    (e.annual_payroll * pp.base_rate / 100.0)::NUMBER(12,2) AS estimated_annual_premium,
    (e.annual_payroll * pp.base_rate / 100.0 * (UNIFORM(85, 115, RANDOM()) / 100.0))::NUMBER(12,2) AS actual_annual_premium,
    UNIFORM(0, 100, RANDOM()) < 25 AS competitive_win,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 25 
         THEN ARRAY_CONSTRUCT('Travelers', 'Hartford', 'Liberty Mutual', 'Zurich', 'AIG', 'CNA')[UNIFORM(0, 5, RANDOM())]
         ELSE NULL END AS previous_carrier,
    ag.commission_rate,
    DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM EMPLOYERS e
CROSS JOIN POLICY_PRODUCTS pp
CROSS JOIN INSURANCE_AGENTS ag
WHERE e.employer_status = 'ACTIVE'
  AND pp.is_active = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 2
LIMIT 500000;

-- ============================================================================
-- Step 10: Generate Policy Renewals
-- ============================================================================
INSERT INTO POLICY_RENEWALS
SELECT
    'REN' || LPAD(SEQ4(), 12, '0') AS renewal_id,
    pw.policy_id,
    pw.agent_id,
    pw.policy_product_id,
    pw.employer_id,
    DATEADD('year', 1, pw.effective_date) AS renewal_effective_date,
    (pw.actual_annual_premium * (UNIFORM(90, 120, RANDOM()) / 100.0))::NUMBER(12,2) AS renewal_premium,
    (UNIFORM(-10, 20, RANDOM()) / 1.0)::NUMBER(8,2) AS premium_change_pct,
    (UNIFORM(75, 145, RANDOM()) / 100.0)::NUMBER(5,2) AS mod_rating_at_renewal,
    DATEADD('year', 1, pw.effective_date) AS renewal_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN 'RENEWED'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'NON_RENEWED'
         ELSE 'PENDING' END AS renewal_status,
    DATEADD('year', 1, pw.created_at) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM POLICIES_WRITTEN pw
WHERE pw.policy_status = 'ACTIVE'
  AND DATEDIFF('day', pw.effective_date, CURRENT_DATE()) > 365
  AND UNIFORM(0, 100, RANDOM()) < 60
LIMIT 300000;

-- ============================================================================
-- Step 11: Generate Premium Payments
-- ============================================================================
INSERT INTO PREMIUM_PAYMENTS
SELECT
    'PAY' || LPAD(SEQ4(), 12, '0') AS payment_id,
    e.employer_id,
    DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS payment_date,
    ARRAY_CONSTRUCT('PREMIUM_PAYMENT', 'AUDIT_ADJUSTMENT', 'ENDORSEMENT', 'CANCELLATION_RETURN')[UNIFORM(0, 3, RANDOM())] AS payment_type,
    (UNIFORM(500, 50000, RANDOM()) / 1.0)::NUMBER(12,2) AS payment_amount,
    ARRAY_CONSTRUCT('NET_30', 'NET_60', 'NET_90', 'IMMEDIATE', 'INSTALLMENT')[UNIFORM(0, 4, RANDOM())] AS payment_terms,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 94 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 4 THEN 'PENDING'
         ELSE 'LATE' END AS payment_status,
    'USD' AS currency,
    NULL AS policy_id,
    NULL AS agent_id,
    ARRAY_CONSTRUCT('DIRECT_BILL', 'AGENCY_BILL', 'PAYROLL_DEDUCT', 'EFT', 'CHECK')[UNIFORM(0, 4, RANDOM())] AS payment_method,
    (UNIFORM(0, 500, RANDOM()) / 1.0)::NUMBER(10,2) AS discount_amount,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN (UNIFORM(25, 500, RANDOM()) / 1.0)::NUMBER(10,2) ELSE 0.00 END AS late_fee_amount,
    ARRAY_CONSTRUCT('EMPLOYER_DIRECT', 'AGENT', 'ONLINE_PORTAL', 'BANK_DRAFT')[UNIFORM(0, 3, RANDOM())] AS payment_source,
    DATEADD('day', -1 * UNIFORM(0, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM EMPLOYERS e
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 40))
WHERE UNIFORM(0, 100, RANDOM()) < 100
LIMIT 1000000;

-- ============================================================================
-- Step 12: Generate Agent Program Participation
-- ============================================================================
INSERT INTO AGENT_PROGRAM_PARTICIPATION
SELECT
    'PART' || LPAD(SEQ4(), 10, '0') AS participation_id,
    ag.agent_id,
    ap.program_id,
    DATEADD('day', UNIFORM(0, 60, RANDOM()), ap.start_date) AS participation_date,
    ARRAY_CONSTRUCT('ATTENDED', 'REGISTERED', 'COMPLETED_TRAINING', 'EARNED_CERTIFICATION', 'WON_AWARD')[UNIFORM(0, 4, RANDOM())] AS participation_type,
    UNIFORM(0, 100, RANDOM()) < 20 AS led_to_new_policy,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN (UNIFORM(5000, 100000, RANDOM()) / 1.0)::NUMBER(12,2) ELSE 0.00 END AS premium_generated,
    DATEADD('day', UNIFORM(0, 60, RANDOM()), ap.start_date) AS created_at
FROM INSURANCE_AGENTS ag
CROSS JOIN AGENT_PROGRAMS ap
WHERE UNIFORM(0, 100, RANDOM()) < 15
LIMIT 3000;

-- ============================================================================
-- Step 13: Generate Claims
-- ============================================================================
INSERT INTO CLAIMS
SELECT
    'CLM' || LPAD(SEQ4(), 10, '0') AS claim_id,
    e.employer_id,
    iw.injured_worker_id,
    NULL AS policy_id,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_DATE()) AS injury_date,
    DATEADD('day', UNIFORM(0, 7, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_DATE())) AS report_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 68 THEN 'CLOSED'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'OPEN'
         WHEN UNIFORM(0, 100, RANDOM()) < 8 THEN 'LITIGATED'
         ELSE 'MEDICAL_ONLY' END AS claim_status,
    CASE WHEN e.industry_vertical = 'CONSTRUCTION' THEN ARRAY_CONSTRUCT('STRAIN_SPRAIN', 'LACERATION', 'FRACTURE', 'FALL', 'STRUCK_BY', 'CAUGHT_IN')[UNIFORM(0, 5, RANDOM())]
         WHEN e.industry_vertical = 'HEALTHCARE' THEN ARRAY_CONSTRUCT('STRAIN_SPRAIN', 'NEEDLE_STICK', 'PATIENT_HANDLING', 'SLIP_FALL', 'EXPOSURE')[UNIFORM(0, 4, RANDOM())]
         WHEN e.industry_vertical = 'MANUFACTURING' THEN ARRAY_CONSTRUCT('STRAIN_SPRAIN', 'LACERATION', 'BURN', 'CRUSH', 'REPETITIVE_MOTION', 'AMPUTATION')[UNIFORM(0, 5, RANDOM())]
         WHEN e.industry_vertical = 'TRANSPORTATION' THEN ARRAY_CONSTRUCT('STRAIN_SPRAIN', 'VEHICLE_ACCIDENT', 'SLIP_FALL', 'STRUCK_BY')[UNIFORM(0, 3, RANDOM())]
         ELSE ARRAY_CONSTRUCT('STRAIN_SPRAIN', 'SLIP_FALL', 'LACERATION', 'BURN', 'FRACTURE')[UNIFORM(0, 4, RANDOM())]
    END AS injury_type,
    ARRAY_CONSTRUCT('BACK', 'SHOULDER', 'KNEE', 'HAND', 'WRIST', 'ANKLE', 'NECK', 'FINGER', 'ARM', 'LEG', 'MULTIPLE')[UNIFORM(0, 10, RANDOM())] AS body_part,
    'Worker injured while performing job duties - detailed description of accident and injury' AS injury_description,
    'Accident occurred due to specific circumstances at workplace location' AS accident_description,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 45 THEN 'MEDICAL_ONLY'
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN 'LOST_TIME'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'TEMPORARY_DISABILITY'
         ELSE 'PERMANENT_DISABILITY' END AS claim_type,
    ARRAY_CONSTRUCT('MINOR', 'MODERATE', 'SERIOUS', 'CATASTROPHIC')[UNIFORM(0, 3, RANDOM())] AS severity,
    'ADJ' || LPAD(UNIFORM(1, 200, RANDOM()), 5, '0') AS adjuster_id,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 45 THEN (UNIFORM(500, 5000, RANDOM()) / 1.0)::NUMBER(12,2)
         WHEN UNIFORM(0, 100, RANDOM()) < 35 THEN (UNIFORM(5000, 25000, RANDOM()) / 1.0)::NUMBER(12,2)
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN (UNIFORM(25000, 100000, RANDOM()) / 1.0)::NUMBER(12,2)
         ELSE (UNIFORM(100000, 500000, RANDOM()) / 1.0)::NUMBER(12,2) END AS medical_paid,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 55 THEN 0.00
         WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN (UNIFORM(1000, 15000, RANDOM()) / 1.0)::NUMBER(12,2)
         WHEN UNIFORM(0, 100, RANDOM()) < 12 THEN (UNIFORM(15000, 75000, RANDOM()) / 1.0)::NUMBER(12,2)
         ELSE (UNIFORM(75000, 250000, RANDOM()) / 1.0)::NUMBER(12,2) END AS indemnity_paid,
    0.00 AS total_incurred,
    0.00 AS total_reserved,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 55 THEN 0
         ELSE UNIFORM(1, 180, RANDOM()) END AS days_lost,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 68 
         THEN DATEADD('day', UNIFORM(7, 180, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_DATE()))
         ELSE NULL END AS return_to_work_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 68 
         THEN DATEADD('day', UNIFORM(30, 365, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_DATE()))
         ELSE NULL END AS claim_closure_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 25 THEN (UNIFORM(5000, 150000, RANDOM()) / 1.0)::NUMBER(12,2) ELSE NULL END AS settlement_amount,
    UNIFORM(0, 100, RANDOM()) < 12 AS litigated,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM EMPLOYERS e
JOIN INJURED_WORKERS iw ON e.employer_id = iw.employer_id
WHERE UNIFORM(0, 100, RANDOM()) < 1
  AND iw.worker_status = 'ACTIVE'
LIMIT 75000;

-- Update total_incurred to be sum of medical and indemnity
UPDATE CLAIMS
SET total_incurred = medical_paid + indemnity_paid;

-- Update total_reserved (typically remaining estimated costs)
UPDATE CLAIMS
SET total_reserved = CASE 
    WHEN claim_status IN ('OPEN', 'LITIGATED') THEN total_incurred * (UNIFORM(20, 80, RANDOM()) / 100.0)
    ELSE 0.00
END;

-- ============================================================================
-- Step 14: Generate Claim Disputes
-- ============================================================================
INSERT INTO CLAIM_DISPUTES
SELECT
    'DISP' || LPAD(SEQ4(), 10, '0') AS dispute_id,
    c.claim_id,
    c.employer_id,
    c.injured_worker_id,
    DATEADD('day', UNIFORM(30, 180, RANDOM()), c.injury_date) AS dispute_filed_date,
    ARRAY_CONSTRUCT('COMPENSABILITY', 'CAUSATION', 'EXTENT_OF_INJURY', 'MEDICAL_TREATMENT', 'SETTLEMENT', 'PERMANENT_DISABILITY', 'IME')[UNIFORM(0, 6, RANDOM())] AS dispute_type,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'LITIGATION')[UNIFORM(0, 3, RANDOM())] AS dispute_severity,
    'Dispute regarding specific aspects of the workers compensation claim' AS dispute_description,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 65 THEN 'RESOLVED'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'IN_MEDIATION'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'ARBITRATION'
         ELSE 'LITIGATION' END AS dispute_status,
    ARRAY_CONSTRUCT('SETTLEMENT', 'MEDIATION', 'ARBITRATION', 'TRIAL', 'WITHDRAWN')[UNIFORM(0, 4, RANDOM())] AS resolution_method,
    ARRAY_CONSTRUCT('EMPLOYER_FAVOR', 'CLAIMANT_FAVOR', 'COMPROMISE', 'WITHDRAWN')[UNIFORM(0, 3, RANDOM())] AS dispute_outcome,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 65 
         THEN DATEADD('day', UNIFORM(60, 545, RANDOM()), DATEADD('day', UNIFORM(30, 180, RANDOM()), c.injury_date))
         ELSE NULL END AS resolution_date,
    (UNIFORM(2000, 75000, RANDOM()) / 1.0)::NUMBER(12,2) AS legal_costs,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN (UNIFORM(10000, 200000, RANDOM()) / 1.0)::NUMBER(12,2) ELSE NULL END AS settlement_amount,
    UNIFORM(0, 100, RANDOM()) < 55 AS attorney_involved,
    ARRAY_CONSTRUCT('MEDICAL', 'INDEMNITY', 'CAUSATION', 'APPORTIONMENT', 'TTD', 'PTD', 'PPD')[UNIFORM(0, 6, RANDOM())] AS dispute_category,
    DATEADD('day', UNIFORM(30, 180, RANDOM()), c.created_at) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM CLAIMS c
WHERE UNIFORM(0, 100, RANDOM()) < 33
LIMIT 25000;

-- ============================================================================
-- Step 15: Generate Credential Verifications
-- ============================================================================
INSERT INTO CREDENTIAL_VERIFICATIONS
SELECT
    'VER' || LPAD(SEQ4(), 10, '0') AS verification_id,
    cred.credential_id,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS verification_date,
    ARRAY_CONSTRUCT('ONLINE_VERIFICATION', 'DOCUMENT_REVIEW', 'THIRD_PARTY', 'STATE_REGISTRY')[UNIFORM(0, 3, RANDOM())] AS verification_method,
    'VERIFIED' AS verification_status,
    'Zenith Compliance Team' AS verified_by,
    ARRAY_CONSTRUCT('State DOI Database', 'Certification Body Portal', 'Third-Party Verification Service')[UNIFORM(0, 2, RANDOM())] AS verification_source,
    'License/credential verified and active' AS notes,
    DATEADD('year', 1, DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP())) AS next_verification_date,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM PROFESSIONAL_CREDENTIALS cred
WHERE UNIFORM(0, 100, RANDOM()) < 75
LIMIT 45000;

-- ============================================================================
-- Display completion
-- ============================================================================
SELECT 'All synthetic data generated successfully' AS status;

