# Zenith Insurance Intelligence Agent - Business Entity Mapping

**Template Source:** Microchip Technology Intelligence Agent  
**Target Business:** Zenith Insurance Company (Workers' Compensation Specialist)  
**Created:** October 24, 2025

---

## Business Overview

### Zenith Insurance Company
- **Industry:** Workers' Compensation Insurance
- **Geography:** 45 states + District of Columbia
- **Founded:** 1977
- **Specialization:** Exclusive focus on workers' compensation
- **Key Differentiators:** 
  - In-house specialists (medical, legal, claims)
  - 29% better loss ratio than industry average
  - Focus on return-to-work outcomes
  - Fraud detection and special investigations

### Core Business Operations
1. **Underwriting:** Writing policies for employers
2. **Claims Management:** Managing workplace injury claims
3. **Medical Case Management:** Coordinating medical care for injured workers
4. **Legal/Litigation:** Managing disputed claims and litigation
5. **Fraud Investigation:** Special Investigation Unit (SIU) operations
6. **Agent Distribution:** Working with insurance agents/brokers
7. **Return to Work:** Coordinating worker recovery and job placement

---

## Entity Mapping: Microchip → Zenith

### Core Business Tables

| Microchip Entity | Zenith Entity | Description |
|-----------------|---------------|-------------|
| **CUSTOMERS** | **EMPLOYERS** | Companies that purchase workers' comp policies |
| **DESIGN_ENGINEERS** | **INJURED_WORKERS** | Employees who file workers' compensation claims |
| **PRODUCT_CATALOG** | **POLICY_PRODUCTS** | Insurance policy types, coverage options, state programs |
| **DISTRIBUTORS** | **INSURANCE_AGENTS** | Independent agents and brokers selling Zenith policies |
| **DESIGN_WINS** | **POLICIES_WRITTEN** | New policies sold to employers |
| **PRODUCTION_ORDERS** | **POLICY_RENEWALS** | Policy renewals and endorsements |
| **ORDERS** | **PREMIUM_PAYMENTS** | Premium payments from employers |
| **SUPPORT_CONTRACTS** | **SERVICE_CONTRACTS** | Premium service agreements (dedicated adjusters, safety programs) |
| **CERTIFICATIONS** | **PROFESSIONAL_CREDENTIALS** | Adjuster licenses, nurse case manager certifications, medical provider credentials |
| **CERTIFICATION_VERIFICATIONS** | **CREDENTIAL_VERIFICATIONS** | License and credential verification records |
| **SUPPORT_TICKETS** | **CLAIMS** | Workers' compensation injury claims |
| **SUPPORT_ENGINEERS** | **CLAIMS_ADJUSTERS** | Claims adjusters, nurse case managers, investigators |
| **QUALITY_ISSUES** | **CLAIM_DISPUTES** | Disputed claims, litigation cases, appeals |
| **MARKETING_CAMPAIGNS** | **AGENT_PROGRAMS** | Agent marketing programs, safety campaigns, training events |
| **CUSTOMER_CAMPAIGN_INTERACTIONS** | **AGENT_PROGRAM_PARTICIPATION** | Agent participation in marketing and training programs |

### Unstructured Data Tables

| Microchip Entity | Zenith Entity | Description |
|-----------------|---------------|-------------|
| **SUPPORT_TRANSCRIPTS** | **CLAIM_NOTES** | Adjuster notes, medical records, investigation reports |
| **APPLICATION_NOTES** | **MEDICAL_TREATMENT_GUIDELINES** | Best practice treatment protocols, return-to-work procedures |
| **QUALITY_INVESTIGATION_REPORTS** | **SIU_INVESTIGATION_REPORTS** | Special Investigation Unit fraud investigation reports |

---

## Attribute Mapping Details

### EMPLOYERS (replaces CUSTOMERS)
- **employer_id** ← customer_id
- **employer_name** ← customer_name
- **industry_vertical** → CONSTRUCTION, MANUFACTURING, HEALTHCARE, RETAIL, HOSPITALITY, TRANSPORTATION, AGRICULTURE
- **business_segment** → SMALL_BUSINESS, MIDMARKET, LARGE_ACCOUNT
- **state** → Primary business location state
- **annual_payroll** ← annual_revenue
- **employee_count** ← employee_count
- **safety_rating** → A+, A, B+, B, C (based on OSHA records, claims history)
- **mod_rating** → Experience Modification Rating (insurance industry metric)

### INJURED_WORKERS (replaces DESIGN_ENGINEERS)
- **injured_worker_id** ← design_engineer_id
- **worker_name** ← engineer_name
- **employer_id** ← customer_id (foreign key)
- **job_title** → Warehouse Worker, Nurse, Construction Laborer, Driver, etc.
- **injury_date** ← hire_date (repurposed)
- **state** → State where injury occurred
- **age**, **years_experience**

### POLICY_PRODUCTS (replaces PRODUCT_CATALOG)
- **policy_product_id** ← product_id
- **product_name** → Workers' Comp Standard, Premium Safety Program, High Hazard Coverage
- **state_program** → CA, FL, TX, NY, etc. (state-specific programs)
- **coverage_type** → STANDARD, LARGE_DEDUCTIBLE, SELF_INSURED, MONOPOLISTIC_STATE
- **industry_class_code** → NCCI class codes (e.g., 5403 Carpentry, 8810 Clerical)
- **base_rate** ← unit_price
- **hazard_level** → LOW, MEDIUM, HIGH, EXTREME

### INSURANCE_AGENTS (replaces DISTRIBUTORS)
- **agent_id** ← distributor_id
- **agent_name** ← distributor_name
- **agency_type** → INDEPENDENT, CAPTIVE, MGA, WHOLESALER
- **states_licensed** ← regions_covered
- **partnership_tier** → PLATINUM, GOLD, SILVER, BRONZE (production volume tiers)
- **commission_rate** ← margin_percentage

### POLICIES_WRITTEN (replaces DESIGN_WINS)
- **policy_id** ← design_win_id
- **employer_id** ← customer_id
- **agent_id** ← design_engineer_id (who sold it)
- **policy_product_id** ← product_id
- **effective_date** ← design_win_date
- **policy_status** → QUOTED, BOUND, ACTIVE, CANCELLED, NON_RENEWED
- **estimated_annual_premium** ← estimated_production_volume
- **competitive_win** → TRUE if won from competitor
- **previous_carrier** ← displaced_competitor

### POLICY_RENEWALS (replaces PRODUCTION_ORDERS)
- **renewal_id** ← production_order_id
- **policy_id** ← design_win_id
- **renewal_effective_date** ← production_start_date
- **renewal_premium** ← order_value
- **premium_change_pct** → Percent change from prior term

### PREMIUM_PAYMENTS (replaces ORDERS)
- **payment_id** ← order_id
- **employer_id** ← customer_id
- **policy_id** ← product_id (repurposed)
- **agent_id** ← distributor_id
- **payment_date** ← order_date
- **payment_amount** ← order_value
- **payment_method** → DIRECT_BILL, AGENCY_BILL, PAYROLL_DEDUCT

### CLAIMS (replaces SUPPORT_TICKETS)
- **claim_id** ← ticket_id
- **injured_worker_id** ← customer_id (repurposed relationship)
- **employer_id** → Foreign key to EMPLOYERS
- **adjuster_id** ← support_engineer_id
- **injury_date** ← ticket_created_date
- **claim_status** → REPORTED, OPEN, MEDICAL_ONLY, LOST_TIME, CLOSED, LITIGATED
- **injury_type** → STRAIN_SPRAIN, LACERATION, FRACTURE, BURN, AMPUTATION, OCCUPATIONAL_DISEASE
- **body_part** → BACK, SHOULDER, KNEE, HAND, MULTIPLE
- **indemnity_paid** → Lost wage payments
- **medical_paid** → Medical treatment costs
- **total_incurred** → Total claim cost (paid + reserved)
- **days_lost** → Lost work days
- **return_to_work_date** ← ticket_resolved_date

### CLAIMS_ADJUSTERS (replaces SUPPORT_ENGINEERS)
- **adjuster_id** ← support_engineer_id
- **adjuster_name** ← engineer_name
- **adjuster_type** → FIELD_ADJUSTER, DESK_ADJUSTER, NURSE_CASE_MANAGER, INVESTIGATOR, ATTORNEY
- **states_licensed** → State adjuster licenses
- **specialty** → MEDICAL_ONLY, LOST_TIME, CATASTROPHIC, FRAUD, LITIGATION
- **years_experience** ← years_experience

### CLAIM_DISPUTES (replaces QUALITY_ISSUES)
- **dispute_id** ← quality_issue_id
- **claim_id** ← product_id (repurposed)
- **employer_id** ← customer_id
- **dispute_type** → COMPENSABILITY, CAUSATION, EXTENT_OF_INJURY, TREATMENT, SETTLEMENT, IME
- **dispute_severity** → LOW, MEDIUM, HIGH, LITIGATION
- **dispute_status** → OPEN, MEDIATION, ARBITRATION, LITIGATION, RESOLVED
- **legal_costs** → Attorney fees and litigation costs
- **resolution_date** ← resolution_date

### PROFESSIONAL_CREDENTIALS (replaces CERTIFICATIONS)
- **credential_id** ← certification_id
- **adjuster_id** ← engineer_id
- **credential_type** → STATE_ADJUSTER_LICENSE, NURSE_CASE_MANAGER, CCM, CPCU, AIC, WCCA
- **credential_level** → ASSOCIATE, PROFESSIONAL, EXPERT, SPECIALIST
- **state_issued** → State jurisdiction
- **issue_date**, **expiration_date**

### AGENT_PROGRAMS (replaces MARKETING_CAMPAIGNS)
- **program_id** ← campaign_id
- **program_name** → Safety Training Webinar, Agent Conference, New Product Launch
- **program_type** → TRAINING, CONFERENCE, WEBINAR, SAFETY_CAMPAIGN, PRODUCT_LAUNCH
- **target_agent_tier** → PLATINUM, GOLD, SILVER, ALL

---

## Unstructured Data Mapping

### CLAIM_NOTES (replaces SUPPORT_TRANSCRIPTS)
- **25,000 claim note documents** with adjuster narratives, medical records, investigation findings
- **Content includes:**
  - Initial injury reports
  - Medical provider notes
  - Adjuster investigation findings
  - Return-to-work coordination
  - Settlement negotiations
  - Red flags for fraud

### MEDICAL_TREATMENT_GUIDELINES (replaces APPLICATION_NOTES)
- **3 comprehensive treatment protocols**
  1. **Low Back Injury Treatment Guidelines** (ODG standards)
  2. **Carpal Tunnel Syndrome Management Protocol**
  3. **Shoulder Injury Return-to-Work Best Practices**
- **Content includes:**
  - Evidence-based treatment timelines
  - Appropriate medical procedures
  - Return-to-work milestones
  - Red flags for delayed recovery

### SIU_INVESTIGATION_REPORTS (replaces QUALITY_INVESTIGATION_REPORTS)
- **15,000 fraud investigation reports** from Special Investigation Unit
- **Content includes:**
  - Surveillance reports
  - Social media investigations
  - Medical provider fraud patterns
  - Claimant inconsistency findings
  - Prior injury history
  - Root cause analysis of fraud schemes

---

## Semantic View Mapping

### SV_POLICY_UNDERWRITING_INTELLIGENCE (replaces SV_DESIGN_ENGINEERING_INTELLIGENCE)
**Purpose:** Analyze employers, policies written, renewals, agents, and premium performance

**Tables:**
- EMPLOYERS (primary)
- INSURANCE_AGENTS
- POLICY_PRODUCTS
- POLICIES_WRITTEN
- POLICY_RENEWALS
- PROFESSIONAL_CREDENTIALS

**Key Metrics:**
- New policy count, renewal rate
- Premium volume by industry, state, agent
- Competitive win rate by previous carrier
- Loss ratio by employer segment
- Agent production by tier
- Credential impact on policy retention

### SV_CLAIMS_MEDICAL_INTELLIGENCE (replaces SV_SALES_REVENUE_INTELLIGENCE)
**Purpose:** Analyze claims, medical costs, adjuster performance, and return-to-work outcomes

**Tables:**
- CLAIMS (primary)
- INJURED_WORKERS
- EMPLOYERS
- CLAIMS_ADJUSTERS
- POLICY_PRODUCTS

**Key Metrics:**
- Total incurred costs (medical + indemnity)
- Claim frequency and severity
- Average days to return to work
- Medical-only vs. lost-time ratio
- Adjuster caseload and closure rates
- Claim costs by injury type, body part, industry

### SV_LITIGATION_DISPUTE_INTELLIGENCE (replaces SV_CUSTOMER_SUPPORT_INTELLIGENCE)
**Purpose:** Analyze claim disputes, litigation, legal costs, and resolution outcomes

**Tables:**
- CLAIM_DISPUTES (primary)
- CLAIMS
- EMPLOYERS
- CLAIMS_ADJUSTERS
- INJURED_WORKERS

**Key Metrics:**
- Dispute/litigation rate
- Legal cost trends
- Resolution time by dispute type
- Settlement amounts
- Attorney involvement impact
- Employer-specific litigation patterns

---

## Cortex Search Services Mapping

### CLAIM_NOTES_SEARCH (replaces SUPPORT_TRANSCRIPTS_SEARCH)
**Purpose:** Semantic search over 25,000 claim adjuster notes and medical records

**Use Cases:**
- Find similar injury patterns
- Identify fraud indicators
- Retrieve successful return-to-work strategies
- Search settlement negotiation outcomes

**Filterable Attributes:**
- employer_id
- adjuster_id
- injury_type
- claim_status
- body_part

### MEDICAL_TREATMENT_GUIDELINES_SEARCH (replaces APPLICATION_NOTES_SEARCH)
**Purpose:** Search treatment protocols and return-to-work best practices

**Use Cases:**
- Retrieve evidence-based treatment timelines
- Find return-to-work procedures for specific injuries
- Access medical management best practices
- Identify appropriate vs. excessive treatment

**Filterable Attributes:**
- injury_type
- body_part
- treatment_category
- guideline_title

### SIU_INVESTIGATION_REPORTS_SEARCH (replaces QUALITY_INVESTIGATION_REPORTS_SEARCH)
**Purpose:** Search 15,000 fraud investigation reports

**Use Cases:**
- Find similar fraud patterns
- Retrieve successful investigation techniques
- Identify medical provider fraud schemes
- Access surveillance best practices

**Filterable Attributes:**
- investigation_type
- investigation_status
- employer_id
- claim_id

---

## Complex Questions Examples (Zenith Version)

### Structured Data (Semantic Views)
1. Which employers have the highest claim frequency rates by industry vertical?
2. What is our competitive win rate against Travelers, Hartford, and Liberty Mutual?
3. Analyze claim costs by injury type - which injuries have longest time to return to work?
4. Show me policy retention rates by agent and identify underperforming agents
5. Which states have highest litigation rates and what is the cost impact?
6. Analyze the correlation between adjuster credentials and claim closure rates
7. Identify employers with declining mod ratings requiring safety intervention
8. Calculate loss ratios by policy product and state program
9. Show me premium trends by industry class code over past 12 months
10. Identify employers at risk of non-renewal based on claim patterns and premium erosion

### Unstructured Data (Cortex Search)
11. Search claim notes for back injury cases with successful return-to-work outcomes
12. Find fraud investigation reports about claimant surveillance and inconsistencies
13. What do medical treatment guidelines say about appropriate carpal tunnel treatment timelines?
14. Search for claim notes about shoulder injuries in construction industry
15. Find SIU reports about medical provider billing fraud patterns
16. What return-to-work strategies work best for manufacturing workers with knee injuries?
17. Search investigation reports for social media evidence used in fraud cases
18. Find claim notes about disputed causation and medical expert opinions
19. What guidance do treatment guidelines provide about opioid prescription management?
20. Search for settlement negotiation strategies in high-dollar catastrophic claims

---

## Data Volumes (Same Scale as Microchip)

- **Employers:** 25,000
- **Injured Workers:** 250,000
- **Policy Products:** 30 (various state programs and coverage types)
- **Insurance Agents:** 10 major agencies
- **Policies Written:** 500,000
- **Policy Renewals:** 300,000
- **Premium Payments:** 1,000,000
- **Service Contracts:** 15,000
- **Professional Credentials:** 40,000
- **Claims:** 75,000
- **Claim Disputes:** 25,000
- **Agent Programs:** 50
- **Claim Notes:** 25,000 (unstructured)
- **Medical Treatment Guidelines:** 3 comprehensive protocols
- **SIU Investigation Reports:** 15,000 (unstructured)

---

## Technical Verification Approach

Following PROJECT_LESSONS_LEARNED.md requirements:

1. ✅ **Create this mapping document FIRST** → Get user approval
2. ✅ **Read all Microchip template files** → Adapt systematically
3. ✅ **Verify column references** → Run automated verification
4. ✅ **Check for duplicate synonyms** → Ensure global uniqueness
5. ✅ **Follow verified syntax** → Use Microchip's working patterns
6. ✅ **Minimal documentation** → README, AGENT_SETUP, questions only
7. ✅ **No guessing** → All SQL verified against existing patterns

---

## Approval Request

**Does this mapping accurately reflect Zenith Insurance's workers' compensation business operations?**

Once approved, I will:
1. Create all 6 SQL files (01-06) with verified syntax
2. Create README.md with Zenith-specific overview
3. Create docs/AGENT_SETUP.md with configuration instructions
4. Create docs/questions.md with 20 complex test questions
5. Run automated verification to ensure 0 errors
6. Optionally create ML models for claim cost prediction, fraud detection, return-to-work forecasting

**Timeline:** 2-3 hours (based on Microchip experience)

**Quality Target:** ZERO syntax errors, ZERO column reference errors, ZERO duplicate synonyms

---

**Ready to proceed upon approval.**

