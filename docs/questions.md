<p align="center">
  <img src="../Snowflake_Logo.svg" alt="Snowflake Logo" width="200">
</p>

# Zenith Insurance Intelligence Agent - Complex Test Questions

These 25 complex questions demonstrate the intelligence agent's ability to analyze Zenith's workers' compensation policies, claims, medical management, litigation, fraud detection, and return-to-work programs across multiple dimensions.

---

## Structured Data Analysis Questions (Semantic Views)

These questions test the agent's ability to query structured data via Cortex Analyst semantic views.

### 1. Policy Performance and Loss Ratio Analysis

**Question:** "Analyze policy performance by coverage type. Show total premium written, total claims incurred, and loss ratio percentage for each coverage type. Which coverage types are most profitable?"

**Why Complex:**
- Multi-table joins (POLICIES_WRITTEN, CLAIMS, POLICY_PRODUCTS)
- Loss ratio calculation (claims cost / premium)
- Profitability analysis
- Aggregation by coverage type

**Data Sources:** POLICIES_WRITTEN, CLAIMS, POLICY_PRODUCTS

---

### 2. Competitive Win Rate Analysis

**Question:** "What is our competitive win rate against major carriers? Show total competitive wins by previous carrier (Travelers, Hartford, Liberty Mutual, Zurich, AIG, CNA), premium captured from each, and which industries we're winning in."

**Why Complex:**
- Competitive intelligence filtering
- Multi-dimensional segmentation (carrier, industry)
- Premium impact calculation
- Win rate analysis

**Data Sources:** POLICIES_WRITTEN, EMPLOYERS

---

### 3. Agent Performance and Retention

**Question:** "Analyze agent performance. Show total premium written, renewal rate, average commission earned, and number of new employers by agent. Which agents have the best retention rates?"

**Why Complex:**
- Agent productivity metrics
- Renewal rate calculation
- Commission calculations
- Performance benchmarking

**Data Sources:** INSURANCE_AGENTS, POLICIES_WRITTEN, POLICY_RENEWALS

---

### 4. Employer Risk Segmentation

**Question:** "Identify high-risk employers requiring intervention. Show employers with mod rating >1.2, claim frequency >industry average, and poor safety ratings. Calculate potential premium impact of risk reduction."

**Why Complex:**
- Risk factor aggregation
- Industry benchmarking
- Multi-criteria filtering
- Premium impact estimation

**Data Sources:** EMPLOYERS, CLAIMS, POLICIES_WRITTEN

---

### 5. Claim Cost Analysis by Injury Type

**Question:** "Analyze claim costs by injury type and body part. Show average medical paid, average indemnity paid, average days lost, and return-to-work rate for each combination."

**Why Complex:**
- Multi-dimensional analysis (injury type x body part)
- Multiple cost metrics
- Return-to-work rate calculation
- Severity indicators

**Data Sources:** CLAIMS, INJURED_WORKERS

---

### 6. Return to Work Effectiveness

**Question:** "Which employers have the most effective return-to-work programs? Show average days to return to work, percentage of claims with zero lost time, and total indemnity savings by employer."

**Why Complex:**
- Return-to-work metrics calculation
- Time-to-return analysis
- Cost savings quantification
- Employer best practices identification

**Data Sources:** CLAIMS, EMPLOYERS

---

### 7. Litigation Rate and Legal Cost Analysis

**Question:** "Analyze litigation trends. Show dispute rate by industry vertical, average legal costs, average settlement amounts, and resolution times. Which industries have highest litigation exposure?"

**Why Complex:**
- Litigation frequency by industry
- Multiple cost metrics
- Time-to-resolution analysis
- Industry exposure ranking

**Data Sources:** CLAIM_DISPUTES, EMPLOYERS, CLAIMS

---

### 8. Premium Trend Analysis

**Question:** "Analyze premium trends over past 12 months. Show month-over-month premium growth, renewal rate trends, competitive win trends, and premium by state program."

**Why Complex:**
- Time-series analysis (12 months)
- Growth rate calculations
- Multi-dimensional trending
- Geographic segmentation

**Data Sources:** POLICIES_WRITTEN, POLICY_RENEWALS, PREMIUM_PAYMENTS

---

### 9. Claims Frequency by Industry and Class Code

**Question:** "Which industry class codes have highest claim frequency? Show claims per $100K payroll, average claim cost, and loss ratio by NCCI class code."

**Why Complex:**
- Frequency calculation normalized by payroll
- Class code analysis
- Loss ratio by classification
- Risk assessment by occupation

**Data Sources:** CLAIMS, EMPLOYERS, POLICY_PRODUCTS

---

### 10. Adjuster Performance Metrics

**Question:** "Analyze claims adjuster performance. Show average claim cost, closure rate, days to close, and claimant satisfaction scores by adjuster type (field, desk, nurse case manager)."

**Why Complex:**
- Multiple performance dimensions
- Efficiency metrics
- Quality indicators
- Adjuster type comparison

**Data Sources:** CLAIMS_ADJUSTERS, CLAIMS

---

### 11. Permanent Disability Analysis

**Question:** "Analyze permanent disability claims. Show average settlement amounts, time from injury to settlement, attorney involvement rate, and employer impact by industry."

**Why Complex:**
- Claim outcome analysis
- Timeline tracking
- Attorney involvement correlation
- Industry-specific impacts

**Data Sources:** CLAIMS, CLAIM_DISPUTES, EMPLOYERS

---

### 12. Medical Cost Drivers

**Question:** "Identify medical cost outliers. Show claims with medical costs exceeding $50K, injury types, treatment duration, and whether treatment followed guidelines."

**Why Complex:**
- Cost outlier identification
- Treatment pattern analysis
- Guideline compliance assessment
- Cost containment opportunities

**Data Sources:** CLAIMS, MEDICAL_TREATMENT_GUIDELINES

---

### 13. Agent Program ROI Analysis

**Question:** "Analyze agent program effectiveness. Show program participation rates, premium generated from participants vs non-participants, and ROI by program type."

**Why Complex:**
- Program participation tracking
- Incremental premium attribution
- ROI calculation
- Program effectiveness ranking

**Data Sources:** AGENT_PROGRAMS, AGENT_PROGRAM_PARTICIPATION, POLICIES_WRITTEN

---

### 14. Mod Rating Impact on Renewal

**Question:** "How does experience mod rating affect renewal rates? Show renewal rate by mod rating bucket (<0.9, 0.9-1.1, 1.1-1.3, >1.3), premium change at renewal, and employer retention."

**Why Complex:**
- Mod rating segmentation
- Renewal correlation analysis
- Premium change patterns
- Retention analysis

**Data Sources:** EMPLOYERS, POLICY_RENEWALS

---

### 15. Geographic Performance Analysis

**Question:** "Analyze performance by state. Show total premium, claim frequency, loss ratio, and competitive win rate by state. Identify expansion opportunities."

**Why Complex:**
- Geographic segmentation
- Multiple performance metrics by state
- Opportunity identification
- Market penetration analysis

**Data Sources:** EMPLOYERS, POLICIES_WRITTEN, CLAIMS

---

## Unstructured Data Search Questions (Cortex Search)

These questions test the agent's ability to search and retrieve insights from unstructured data using Cortex Search services.

### 16. Successful Return to Work Strategies

**Question:** "Search claim notes for successful return-to-work strategies for back injuries in construction. What modified duty accommodations and timelines were most effective?"

**Why Complex:**
- Semantic search over claim notes
- Best practice extraction
- Industry and injury-specific filtering
- Timeline identification

**Data Source:** CLAIM_NOTES_SEARCH

---

### 17. Medical Treatment Guidelines - Low Back

**Question:** "What do our treatment guidelines say about appropriate treatment timelines for low back strain? What treatments should be avoided?"

**Why Complex:**
- Evidence-based protocol retrieval
- Treatment timeline extraction
- Contraindicated treatment identification
- ODG compliance

**Data Source:** MEDICAL_TREATMENT_GUIDELINES_SEARCH

---

### 18. Fraud Investigation Patterns

**Question:** "Search SIU investigation reports for surveillance findings showing activity inconsistencies. What were the common fraud indicators and outcomes?"

**Why Complex:**
- Fraud pattern recognition
- Surveillance evidence synthesis
- Indicator extraction
- Outcome analysis

**Data Source:** SIU_INVESTIGATION_REPORTS_SEARCH

---

### 19. Settlement Negotiation Strategies

**Question:** "Search claim notes for successful mediation and settlement approaches in permanent disability claims. What strategies led to favorable outcomes?"

**Why Complex:**
- Settlement strategy extraction
- Outcome correlation
- Best practice identification
- Negotiation technique analysis

**Data Source:** CLAIM_NOTES_SEARCH

---

### 20. Opioid Management Guidelines

**Question:** "What guidance do our treatment guidelines provide about opioid prescribing and tapering protocols? What are the red flags for opioid dependence?"

**Why Complex:**
- Medication management protocol retrieval
- Risk indicator identification
- Tapering procedure extraction
- Clinical guidance synthesis

**Data Source:** MEDICAL_TREATMENT_GUIDELINES_SEARCH

---

### 21. Medical Provider Fraud Patterns

**Question:** "Search SIU reports for medical provider fraud schemes. What billing patterns, upcoding, and services-not-rendered indicators were identified?"

**Why Complex:**
- Provider fraud pattern recognition
- Billing anomaly identification
- Multi-case pattern analysis
- Investigation technique extraction

**Data Source:** SIU_INVESTIGATION_REPORTS_SEARCH

---

### 22. Shoulder Injury Return to Work

**Question:** "What do treatment guidelines recommend for shoulder injury return-to-work restrictions and timelines? What are the phases of recovery?"

**Why Complex:**
- Injury-specific protocol retrieval
- Restriction timeline extraction
- Recovery phase documentation
- RTW progression guidance

**Data Source:** MEDICAL_TREATMENT_GUIDELINES_SEARCH

---

### 23. Causation Dispute Strategies

**Question:** "Search claim notes for causation disputes and IME findings. What medical evidence and strategies were used successfully?"

**Why Complex:**
- Legal strategy extraction
- Medical evidence synthesis
- Defense approach identification
- Successful outcome patterns

**Data Source:** CLAIM_NOTES_SEARCH

---

### 24. Social Media Investigation Findings

**Question:** "Search SIU reports for social media investigation results. What activity inconsistencies were documented and how were they used?"

**Why Complex:**
- Social media evidence extraction
- Inconsistency documentation
- Evidentiary use analysis
- Investigation technique synthesis

**Data Source:** SIU_INVESTIGATION_REPORTS_SEARCH

---

### 25. Carpal Tunnel Treatment Protocols

**Question:** "What do treatment guidelines say about conservative care vs surgical intervention for carpal tunnel syndrome? What are the success rates and timelines?"

**Why Complex:**
- Treatment pathway comparison
- Outcome metric extraction
- Timeline documentation
- Evidence-based decision criteria

**Data Source:** MEDICAL_TREATMENT_GUIDELINES_SEARCH

---

## Combined Questions (Structured + Unstructured)

These questions require the agent to combine insights from both structured data (Cortex Analyst) and unstructured content (Cortex Search).

### 26. High-Cost Claims + Treatment Analysis

**Question:** "Which injury types have the highest average costs? Search treatment guidelines for appropriate care protocols and identify potential cost savings opportunities."

**Why Complex:**
- Structured cost analysis
- Unstructured guideline retrieval
- Cost-benefit comparison
- Savings opportunity identification

**Tools Used:** SV_CLAIMS_MEDICAL_INTELLIGENCE + MEDICAL_TREATMENT_GUIDELINES_SEARCH

---

### 27. Litigation Trends + Defense Strategies

**Question:** "Show dispute rates and legal costs by dispute type. Search claim notes for successful defense strategies in each dispute category."

**Why Complex:**
- Structured litigation metrics
- Unstructured strategy extraction
- Category-specific best practices
- Cost-effectiveness analysis

**Tools Used:** SV_LITIGATION_DISPUTE_INTELLIGENCE + CLAIM_NOTES_SEARCH

---

### 28. Employer Performance + Return to Work Programs

**Question:** "Which employers have best return-to-work rates? Search claim notes for their specific accommodation strategies and modified duty programs."

**Why Complex:**
- Structured performance ranking
- Unstructured program documentation
- Best practice extraction
- Correlation analysis

**Tools Used:** SV_CLAIMS_MEDICAL_INTELLIGENCE + CLAIM_NOTES_SEARCH

---

### 29. Fraud Detection + Investigation Techniques

**Question:** "Show claim dispute rates by employer. Search SIU reports for fraud indicators and investigation methods used in disputed claims."

**Why Complex:**
- Structured dispute frequency
- Unstructured investigation technique extraction
- Fraud indicator correlation
- Method effectiveness analysis

**Tools Used:** SV_LITIGATION_DISPUTE_INTELLIGENCE + SIU_INVESTIGATION_REPORTS_SEARCH

---

### 30. Medical Costs + Guideline Compliance

**Question:** "Identify claims with excessive medical costs. Search treatment guidelines to determine if treatment exceeded evidence-based protocols."

**Why Complex:**
- Structured cost outlier identification
- Unstructured guideline comparison
- Compliance gap analysis
- Cost containment opportunities

**Tools Used:** SV_CLAIMS_MEDICAL_INTELLIGENCE + MEDICAL_TREATMENT_GUIDELINES_SEARCH

---

## Question Complexity Summary

These questions test the agent's ability to:

1. **Multi-table joins** - connecting employers, policies, claims, disputes across entities
2. **Temporal analysis** - premium trends, claim duration, time-to-settlement
3. **Segmentation & classification** - industry verticals, coverage types, injury types
4. **Derived metrics** - loss ratios, win rates, return-to-work rates, growth calculations
5. **Competitive intelligence** - win rate by competitor, market share analysis
6. **Performance benchmarking** - agent productivity, adjuster efficiency, employer programs
7. **Correlation analysis** - mod ratings vs renewals, safety ratings vs claim frequency
8. **Risk assessment** - employer health scoring, litigation exposure, fraud indicators
9. **Outcome measurement** - settlement success, return-to-work rates, resolution times
10. **Cost analysis** - medical vs indemnity costs, legal cost trends, premium adequacy
11. **Semantic search** - treatment protocols, fraud patterns, settlement strategies
12. **Best practice extraction** - return-to-work programs, investigation techniques
13. **Evidence synthesis** - medical guidelines, defense strategies, fraud indicators
14. **Guideline compliance** - treatment appropriateness, cost containment

These questions reflect realistic business intelligence needs for Zenith's workers' compensation insurance operations including underwriting, claims, medical management, litigation, fraud detection, and return-to-work program optimization.

---

## ML Prediction Questions (Optional - If ML Models Added)

These questions require the optional ML procedures (PREDICT_CLAIM_COST, DETECT_FRAUD_RISK, PREDICT_RTW_TIMELINE).

### 31. Claim Cost Forecasting

**Question:** "Predict costs for open back injury claims in construction using the claim cost predictor model"

**Why Complex:**
- Calls ML model from Model Registry
- Regression prediction with multiple features
- Returns cost forecasts

**Tool Used:** PREDICT_CLAIM_COST procedure

---

### 32. Fraud Risk Detection

**Question:** "Which open claims have high fraud risk according to the fraud detector model?"

**Why Complex:**
- ML classification model
- Multi-factor fraud analysis
- Risk scoring and prioritization

**Tool Used:** DETECT_FRAUD_RISK procedure

---

### 33. Return-to-Work Timeline Prediction

**Question:** "Use the RTW predictor to estimate return-to-work timelines for shoulder injuries in healthcare"

**Why Complex:**
- ML regression prediction
- Injury and industry-specific filtering
- Timeline forecasting

**Tool Used:** PREDICT_RTW_TIMELINE procedure

---

### 34. Combined ML and Analytics

**Question:** "Predict costs for open claims, then identify which ones have high fraud risk and analyze if there's correlation with injury type"

**Why Complex:**
- Multiple ML model calls
- Correlation analysis
- Cross-functional insights

**Tools Used:** PREDICT_CLAIM_COST + DETECT_FRAUD_RISK + SV_CLAIMS_MEDICAL_INTELLIGENCE

---

### 35. ML Prediction with Visualization

**Question:** "Predict return-to-work timeline for all open claims and show distribution of predicted timelines"

**Why Complex:**
- ML forecasting
- Data visualization request
- Distribution analysis

**Tools Used:** PREDICT_RTW_TIMELINE + agent's built-in data_to_chart

---

**Version:** 1.0  
**Created:** October 2025  
**Updated:** Added ML prediction questions (optional)  
**Target Use Case:** Zenith Insurance workers' compensation intelligence

