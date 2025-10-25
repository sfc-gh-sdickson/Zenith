<p align="center">
  <img src="./Snowflake_Logo.svg" alt="Snowflake Logo" width="200">
</p>

# Zenith Insurance Intelligence Agent Solution

## About Zenith Insurance

Zenith Insurance Company is a leading specialist in workers' compensation insurance, operating across 45 states and the District of Columbia. Founded in 1977, Zenith has built a reputation for providing superior service and expertise in the workers' compensation sector.

### Key Service Areas

- **Workers' Compensation Insurance**: Specialized coverage for workplace injuries
- **Claims Management**: Efficient processing and resolution of injury claims  
- **Medical Case Management**: Coordinating quality medical care and return-to-work programs
- **Loss Control & Safety**: Proactive workplace safety programs
- **Fraud Investigation**: Special Investigation Unit (SIU) for fraud detection
- **Litigation Management**: Expert handling of disputed claims

### Market Position

- Exclusive focus on workers' compensation insurance
- 45 states + DC coverage
- In-house medical, legal, and claims specialists
- 29% better loss ratio than industry average over past decade
- Focus on return-to-work outcomes and fraud prevention

## Project Overview

This Snowflake Intelligence solution demonstrates how Zenith can leverage AI agents to analyze:

- **Policy & Underwriting Intelligence**: New business, renewals, agent performance, competitive wins
- **Claims & Medical Intelligence**: Claim costs, return-to-work rates, medical management, adjuster performance
- **Litigation & Dispute Intelligence**: Disputed claims, legal costs, settlement outcomes, litigation trends
- **Employer Health**: Loss ratios, mod rating trends, retention risk, claim frequency
- **Fraud Detection**: SIU investigations, suspicious claim patterns, overbilling analysis
- **Medical Management**: Treatment guideline compliance, cost control, outcome optimization
- **Agent Performance**: Premium production, retention rates, program participation
- **Unstructured Data Search**: Semantic search over claim notes, medical guidelines, and SIU reports using Cortex Search

## Database Schema

The solution includes:

### 1. RAW Schema: Core Business Tables

**Policy & Underwriting:**
- EMPLOYERS: Companies purchasing workers' comp insurance
- INSURANCE_AGENTS: Agents and brokers selling policies
- POLICY_PRODUCTS: Coverage products and state programs
- POLICIES_WRITTEN: New policies issued to employers
- POLICY_RENEWALS: Policy renewals and endorsements
- PREMIUM_PAYMENTS: Premium payments and transactions

**Claims & Medical:**
- INJURED_WORKERS: Employees filing workers' comp claims
- CLAIMS: Workers' compensation injury claims
- CLAIMS_ADJUSTERS: Claims adjusters and case managers
- CLAIM_DISPUTES: Disputed claims and litigation cases

**Supporting Tables:**
- SERVICE_CONTRACTS: Premium service agreements
- PROFESSIONAL_CREDENTIALS: Adjuster licenses and certifications
- CREDENTIAL_VERIFICATIONS: License verification records
- AGENT_PROGRAMS: Agent marketing and training programs
- AGENT_PROGRAM_PARTICIPATION: Agent program engagement

**Unstructured Data:**
- CLAIM_NOTES: 25,000 adjuster notes and medical records (unstructured text)
- MEDICAL_TREATMENT_GUIDELINES: 3 comprehensive evidence-based treatment protocols
- SIU_INVESTIGATION_REPORTS: 15,000 fraud investigation reports (unstructured text)

### 2. ANALYTICS Schema: Curated Views and Semantic Models

**Analytical Views:**
- V_EMPLOYER_360: Complete employer profile with claims and policies
- V_INJURED_WORKER_ANALYTICS: Worker injury history and outcomes
- V_POLICY_ANALYTICS: Policy performance and loss ratios
- V_PRODUCT_PERFORMANCE: Policy product metrics
- V_AGENT_PERFORMANCE: Agent production and retention
- V_CLAIMS_ANALYTICS: Detailed claim metrics and outcomes
- V_CLAIM_DISPUTE_ANALYTICS: Litigation and dispute tracking
- V_PREMIUM_PAYMENT_ANALYTICS: Premium payment patterns
- V_ADJUSTER_PERFORMANCE: Adjuster efficiency metrics
- V_CREDENTIAL_ANALYTICS: License and certification tracking

**Semantic Views for AI Agents:**
- SV_POLICY_UNDERWRITING_INTELLIGENCE: Policy, agent, employer, and renewal data
- SV_CLAIMS_MEDICAL_INTELLIGENCE: Claims, medical costs, and return-to-work metrics
- SV_LITIGATION_DISPUTE_INTELLIGENCE: Disputes, litigation, settlements, and legal costs

### 3. Cortex Search Services: Semantic Search Over Unstructured Data

- **CLAIM_NOTES_SEARCH**: Search 25,000 claim adjuster notes and medical records
- **MEDICAL_TREATMENT_GUIDELINES_SEARCH**: Search evidence-based treatment protocols
- **SIU_INVESTIGATION_REPORTS_SEARCH**: Search 15,000 fraud investigation reports

## Files

### Core Files
- `README.md`: This comprehensive solution documentation
- `MAPPING_DOCUMENT.md`: Business entity mapping from Microchip template
- `docs/AGENT_SETUP.md`: Complete agent configuration instructions
- `docs/questions.md`: 20+ complex test questions

### SQL Files
- `sql/setup/01_database_and_schema.sql`: Database and schema creation
- `sql/setup/02_create_tables.sql`: Table definitions with proper constraints
- `sql/data/03_generate_synthetic_data.sql`: Realistic insurance sample data
- `sql/views/04_create_views.sql`: Analytical views
- `sql/views/05_create_semantic_views.sql`: Semantic views for AI agents (verified syntax)
- `sql/search/06_create_cortex_search.sql`: Unstructured data tables and Cortex Search services
- `sql/ml/07_create_model_wrapper_functions.sql`: ML model wrapper procedures (optional)

### ML Models (Optional)
- `notebooks/zenith_ml_models.ipynb`: Snowflake Notebook for training ML models

## Setup Instructions

1. Execute SQL files in order (01 through 06)
   - 01: Database and schema setup
   - 02: Create tables
   - 03: Generate synthetic data (10-20 min)
   - 04: Create analytical views
   - 05: Create semantic views
   - 06: Create Cortex Search services (5-10 min)
2. Follow AGENT_SETUP.md for agent configuration
3. Test with questions from questions.md

## Data Model Highlights

### Structured Data
- Realistic workers' compensation insurance scenarios
- 25K employers across SMALL_BUSINESS, MIDMARKET, LARGE_ACCOUNT segments
- 250K injured workers with injury history
- 30 policy products across state programs and coverage types
- 500K policies written with competitive win tracking
- 300K policy renewals with premium change analysis
- 1M premium payment transactions
- 75K workers' compensation claims
- 25K claim disputes and litigation cases
- 40K professional credentials (adjuster licenses, certifications)
- 10 major insurance agents/brokers

### Unstructured Data
- 25,000 claim notes with realistic adjuster narratives and medical reviews
- 3 comprehensive medical treatment guidelines (low back, carpal tunnel, shoulder)
- 15,000 SIU investigation reports with fraud detection findings
- Semantic search powered by Snowflake Cortex Search
- RAG (Retrieval Augmented Generation) ready for AI agents

## Key Features

✅ **Hybrid Data Architecture**: Combines structured tables with unstructured claim notes and medical content  
✅ **Semantic Search**: Find similar claims and fraud patterns by meaning, not keywords  
✅ **RAG-Ready**: Agent can retrieve context from claim notes and treatment guidelines  
✅ **Production-Ready Syntax**: All SQL verified against Snowflake documentation  
✅ **Comprehensive Demo**: 1M+ premium payments, 75K claims, 25K claim notes  
✅ **Verified Syntax**: CREATE SEMANTIC VIEW and CREATE CORTEX SEARCH SERVICE syntax verified against official Snowflake documentation  
✅ **No Duplicate Synonyms**: All semantic view synonyms globally unique across all three views  
✅ **ML-Powered** (Optional): 3 ML models for claim cost prediction, fraud detection, and return-to-work forecasting

## Complex Questions Examples

The agent can answer sophisticated questions like:

### Structured Data Analysis (Semantic Views)
1. **Policy Performance**: Loss ratios by industry vertical and coverage type
2. **Competitive Intelligence**: Win rate vs. competitors (Travelers, Hartford, Liberty Mutual)
3. **Agent Performance**: Premium production by region, retention rates, program participation
4. **Claims Cost Analysis**: Medical vs. indemnity costs by injury type and body part
5. **Return to Work**: Average days to return by industry and injury severity
6. **Litigation Trends**: Dispute rates, legal costs, settlement outcomes by dispute type
7. **Premium Trends**: Month-over-month growth, renewal rates, mod rating impact
8. **Loss Control**: Correlation between safety rating and claim frequency
9. **Adjuster Efficiency**: Case closure rates, average claim costs, satisfaction scores
10. **Employer Health**: Retention risk scoring based on loss ratios and claim trends

### Unstructured Data Search (Cortex Search)
11. **Back Injuries**: Treatment protocols, return-to-work strategies, successful outcomes
12. **Fraud Patterns**: Surveillance findings, staged accidents, provider fraud schemes
13. **Medical Mgmt**: Treatment guideline compliance, utilization review procedures
14. **Settlement Strategies**: Negotiation approaches, mediation outcomes in claim notes
15. **Return to Work**: Modified duty programs, accommodation strategies from adjuster notes
16. **Medical Providers**: Provider billing patterns, treatment effectiveness from notes
17. **Injury Prevention**: Root cause analysis, safety recommendations from claims
18. **Legal Strategies**: Defense approaches, attorney involvement patterns
19. **Chronic Pain Management**: Opioid management, alternative therapies from guidelines
20. **IME Findings**: Independent medical exam results, causation opinions from notes

## Semantic Views

The solution includes three verified semantic views:

1. **SV_POLICY_UNDERWRITING_INTELLIGENCE**: Comprehensive view of employers, agents, policy products, policies written, renewals, and professional credentials
2. **SV_CLAIMS_MEDICAL_INTELLIGENCE**: Claims, injured workers, adjusters, medical costs, and return-to-work outcomes
3. **SV_LITIGATION_DISPUTE_INTELLIGENCE**: Claim disputes, litigation, legal costs, settlements, and dispute outcomes

All semantic views follow the verified syntax structure:
- TABLES clause with PRIMARY KEY definitions
- RELATIONSHIPS clause defining foreign keys
- DIMENSIONS clause with synonyms and comments
- METRICS clause with aggregations and calculations
- Proper clause ordering (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT)
- **NO DUPLICATE SYNONYMS** - All synonyms globally unique

## Cortex Search Services

Three Cortex Search services enable semantic search over unstructured data:

1. **CLAIM_NOTES_SEARCH**: Search 25,000 adjuster notes and medical reviews
   - Find similar injury patterns and treatment approaches
   - Retrieve successful return-to-work strategies
   - Analyze settlement negotiation outcomes
   - Searchable attributes: employer_id, adjuster_id, injury_type, body_part, note_type

2. **MEDICAL_TREATMENT_GUIDELINES_SEARCH**: Search evidence-based treatment protocols
   - Retrieve appropriate treatment timelines for injuries
   - Find return-to-work procedures and restrictions
   - Access best practices for medical management
   - Searchable attributes: injury_type, body_part, treatment_category, title

3. **SIU_INVESTIGATION_REPORTS_SEARCH**: Search 15,000 fraud investigation reports
   - Find similar fraud patterns and indicators
   - Identify effective investigation techniques
   - Retrieve surveillance findings and outcomes
   - Searchable attributes: investigation_type, investigation_status, employer_id, claim_id

All Cortex Search services use verified syntax:
- ON clause specifying search column
- ATTRIBUTES clause for filterable columns
- WAREHOUSE assignment
- TARGET_LAG for refresh frequency
- AS clause with source query

## Syntax Verification

All SQL syntax has been verified against official Snowflake documentation:

- **CREATE SEMANTIC VIEW**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **CREATE CORTEX SEARCH SERVICE**: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
- **Cortex Search Overview**: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview

Key verification points:
- ✅ Clause order is mandatory (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS)
- ✅ PRIMARY KEY columns verified to exist in source tables
- ✅ No self-referencing or cyclic relationships
- ✅ Semantic expression format: `name AS expression`
- ✅ Change tracking enabled for Cortex Search tables
- ✅ Correct ATTRIBUTES syntax for filterable columns
- ✅ All column references verified against table definitions
- ✅ No duplicate synonyms across all three semantic views

## Getting Started

### Prerequisites
- Snowflake account with Cortex Intelligence enabled
- ACCOUNTADMIN or equivalent privileges
- X-SMALL or larger warehouse

### Quick Start
```sql
-- 1. Create database and schemas
@sql/setup/01_database_and_schema.sql

-- 2. Create tables
@sql/setup/02_create_tables.sql

-- 3. Generate sample data (10-20 minutes)
@sql/data/03_generate_synthetic_data.sql

-- 4. Create analytical views
@sql/views/04_create_views.sql

-- 5. Create semantic views
@sql/views/05_create_semantic_views.sql

-- 6. Create Cortex Search services (5-10 minutes)
@sql/search/06_create_cortex_search.sql
```

### Configure Agent
Follow the detailed instructions in `docs/AGENT_SETUP.md` to:
1. Create the Snowflake Intelligence Agent
2. Add semantic views as data sources (Cortex Analyst)
3. Configure Cortex Search services
4. Set up system prompts and instructions
5. Test with sample questions

## Testing

### Verify Installation
```sql
-- Check semantic views
SHOW SEMANTIC VIEWS IN SCHEMA ZENITH_INSURANCE_INTELLIGENCE.ANALYTICS;

-- Check Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA ZENITH_INSURANCE_INTELLIGENCE.RAW;

-- Test Cortex Search
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'ZENITH_INSURANCE_INTELLIGENCE.RAW.CLAIM_NOTES_SEARCH',
      '{"query": "back injury return to work", "limit":5}'
  )
)['results'] as results;
```

### Sample Test Questions
1. "Which employers have the highest claim frequency in construction?"
2. "What is our competitive win rate against Travelers and Hartford?"
3. "Search claim notes for successful return-to-work strategies for back injuries"
4. "Find fraud investigation reports about surveillance evidence"

## Data Volumes

- **Employers**: 25,000
- **Injured Workers**: 250,000
- **Policy Products**: 30 coverage types and state programs
- **Insurance Agents**: 10 major agencies
- **Policies Written**: 500,000
- **Policy Renewals**: 300,000
- **Premium Payments**: 1,000,000
- **Service Contracts**: 15,000
- **Professional Credentials**: 40,000
- **Claims**: 75,000
- **Claim Disputes**: 25,000
- **Agent Programs**: 100
- **Claim Notes**: 25,000 (unstructured)
- **Medical Treatment Guidelines**: 3 comprehensive protocols
- **SIU Investigation Reports**: 15,000 (unstructured)

## Architecture

The Zenith Insurance Intelligence Agent follows a three-layer architecture:

**Layer 1: Snowflake Intelligence Agent (Orchestration)**
- Routes requests to appropriate services
- Combines structured and unstructured insights
- Provides conversational interface

**Layer 2A: Cortex Analyst (Structured Data)**
- Analyzes structured data via semantic views
- 3 semantic views covering policy, claims, and litigation
- Provides metrics, aggregations, and trend analysis

**Layer 2B: Cortex Search (Unstructured Data)**
- Searches unstructured documents semantically
- 3 search services: Claim notes, treatment guidelines, SIU reports
- Enables RAG (Retrieval Augmented Generation)

**Layer 3: RAW Schema (Source Data)**
- 15 structured tables with 2.5M records
- 40K+ unstructured documents
- All relationships defined with foreign keys

## Support

For questions or issues:
- Review `docs/AGENT_SETUP.md` for detailed setup instructions
- Check `docs/questions.md` for example questions
- Consult `MAPPING_DOCUMENT.md` for entity mapping details
- Refer to Snowflake documentation for syntax verification
- Contact your Snowflake account team for assistance

## Version History

- **v1.0** (October 2025): Initial release
  - Verified semantic view syntax
  - Verified Cortex Search syntax
  - 25K employers, 250K injured workers, 500K policies, 1M premium payments
  - 75K claims with detailed analytics
  - 25K claim notes with semantic search
  - 3 medical treatment guidelines
  - 15K SIU investigation reports
  - 20+ complex test questions
  - Comprehensive documentation

## License

This solution is provided as a template for building Snowflake Intelligence agents for workers' compensation insurance. Adapt as needed for your specific use case.

---

**Created**: October 2025  
**Template Based On**: Microchip Intelligence Agent  
**Snowflake Documentation**: Syntax verified against official documentation  
**Target Use Case**: Zenith Insurance workers' compensation intelligence

**NO GUESSING - ALL SYNTAX VERIFIED** ✅  
**NO DUPLICATE SYNONYMS - ALL GLOBALLY UNIQUE** ✅

