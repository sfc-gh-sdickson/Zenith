-- ============================================================================
-- Zenith Insurance Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          claim notes, medical treatment guidelines, and SIU investigation reports
-- Syntax verified against: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
-- ============================================================================

USE DATABASE ZENITH_INSURANCE_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE ZENITH_WH;

-- ============================================================================
-- Step 1: Create table for claim notes (unstructured text data)
-- ============================================================================
CREATE OR REPLACE TABLE CLAIM_NOTES (
    note_id VARCHAR(30) PRIMARY KEY,
    claim_id VARCHAR(30),
    employer_id VARCHAR(20),
    adjuster_id VARCHAR(20),
    note_text VARCHAR(16777216) NOT NULL,
    note_type VARCHAR(50),
    note_date TIMESTAMP_NTZ NOT NULL,
    injury_type VARCHAR(50),
    body_part VARCHAR(50),
    resolution_achieved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (claim_id) REFERENCES CLAIMS(claim_id),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id),
    FOREIGN KEY (adjuster_id) REFERENCES CLAIMS_ADJUSTERS(adjuster_id)
);

-- ============================================================================
-- Step 2: Create table for medical treatment guidelines
-- ============================================================================
CREATE OR REPLACE TABLE MEDICAL_TREATMENT_GUIDELINES (
    guideline_id VARCHAR(30) PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content VARCHAR(16777216) NOT NULL,
    injury_type VARCHAR(50),
    body_part VARCHAR(50),
    treatment_category VARCHAR(50),
    guideline_number VARCHAR(50),
    revision VARCHAR(20),
    tags VARCHAR(500),
    author VARCHAR(100),
    publish_date DATE,
    last_updated TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- Step 3: Create table for SIU investigation reports
-- ============================================================================
CREATE OR REPLACE TABLE SIU_INVESTIGATION_REPORTS (
    investigation_report_id VARCHAR(30) PRIMARY KEY,
    claim_id VARCHAR(30),
    employer_id VARCHAR(20),
    injured_worker_id VARCHAR(30),
    report_text VARCHAR(16777216) NOT NULL,
    investigation_type VARCHAR(50),
    investigation_status VARCHAR(30),
    fraud_indicators_summary VARCHAR(5000),
    investigation_outcome VARCHAR(5000),
    report_date TIMESTAMP_NTZ NOT NULL,
    investigated_by VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (claim_id) REFERENCES CLAIMS(claim_id),
    FOREIGN KEY (employer_id) REFERENCES EMPLOYERS(employer_id),
    FOREIGN KEY (injured_worker_id) REFERENCES INJURED_WORKERS(injured_worker_id)
);

-- ============================================================================
-- Step 4: Enable change tracking (required for Cortex Search)
-- ============================================================================
ALTER TABLE CLAIM_NOTES SET CHANGE_TRACKING = TRUE;
ALTER TABLE MEDICAL_TREATMENT_GUIDELINES SET CHANGE_TRACKING = TRUE;
ALTER TABLE SIU_INVESTIGATION_REPORTS SET CHANGE_TRACKING = TRUE;

-- ============================================================================
-- Step 5: Generate sample claim notes
-- ============================================================================
INSERT INTO CLAIM_NOTES
SELECT
    'NOTE' || LPAD(SEQ4(), 10, '0') AS note_id,
    c.claim_id,
    c.employer_id,
    c.adjuster_id,
    CASE (ABS(RANDOM()) % 20)
        WHEN 0 THEN 'Initial claim report received. Claimant alleges back strain while lifting heavy box at warehouse on 3/15/2024. Employer First Report of Injury indicates no witnesses. Claimant continued working until end of shift, reported injury next morning. Medical treatment sought at urgent care. Authorized treatment and assigned case to nurse case manager. Initial reserve set at $15,000. Will monitor medical only status.'
        WHEN 1 THEN 'Spoke with claimant regarding shoulder injury. States pain began gradually over 2 weeks performing repetitive overhead reaching in manufacturing role. No specific incident date. Employer disputes compensability, states this appears to be degenerative condition. Ordered IME with orthopedic specialist. Claimant has attorney representation. Medical treatment ongoing with physical therapy 3x per week. Current incurred: $8,500 medical. Litigation expected.'
        WHEN 2 THEN 'Field investigation completed at accident site. Claimant alleges slip and fall on wet floor in restaurant kitchen. Witness statements confirm floor was recently mopped, no wet floor signs posted. Photos taken of accident scene. Employer admits negligence in failure to post warning signage. Claimant suffered fractured wrist requiring surgery. Surgery authorized, return to work expected 8-10 weeks. Total incurred medical $45,000, indemnity $12,000. Claim accepted, reserves adequate.'
        WHEN 3 THEN 'Return to work discussion with employer. Claimant released to modified duty - no lifting over 20 lbs, no prolonged standing. Employer unable to accommodate restrictions at this time. Continuing temporary total disability benefits. Spoke with treating physician regarding permanent restrictions - physician states claimant should reach maximum medical improvement in 4-6 weeks. Will schedule settlement conference once MMI reached. Current exposure $67,000.'
        WHEN 4 THEN 'Nurse case manager report received. Claimant attended independent medical exam yesterday. IME physician agrees claimant has reached MMI with 15% whole person impairment to left leg. Recommends permanent partial disability rating. Claimant attorney requesting settlement discussion. Calculated PPD exposure at $42,000 based on state schedule. Employer willing to settle. Settlement authority requested. Recommend approval of $42,000 PPD settlement plus $3,500 attorney fees.'
        WHEN 5 THEN 'Red flags identified for potential fraud investigation. Claimant reported severe back injury preventing all activity, however surveillance shows claimant performing yard work, lifting heavy objects without apparent difficulty. Social media posts show claimant engaged in recreational activities inconsistent with reported restrictions. Referred to SIU for investigation. Medical treatment suspended pending investigation outcome. Attorney notified of denial of benefits based on fraud investigation.'
        WHEN 6 THEN 'Mediation held today. Claimant demanding $125,000 settlement for permanent total disability. Defense medical exam shows claimant capable of sedentary work. Employer has suitable position available. Claimant refused return to work offer. Mediator recommends settlement at $75,000. Carrier willing to offer $60,000. Claimant countered at $85,000. Mediation continued to next month. Litigation costs to date $18,500. Trial expected if settlement not reached.'
        WHEN 7 THEN 'Causation dispute ongoing. Claimant alleges carpal tunnel syndrome from keyboard work. Employer medical records show claimant previously treated for same condition 5 years ago at different employer. IME physician states current condition is natural progression of pre-existing degenerative arthritis, not work-related. Issued denial letter based on lack of causation. Claimant attorney filed appeal. Hearing scheduled in 45 days. Defense costs $8,200.'
        WHEN 8 THEN 'Catastrophic injury case. Claimant suffered multiple injuries in forklift accident including spinal cord injury resulting in paraplegia. Emergency surgery completed, claimant in rehabilitation facility. Life care plan being developed. Estimated lifetime medical exposure $2.8 million. Home modifications required, estimated $175,000. Claimant will require 24-hour attendant care. Structured settlement being negotiated. Current reserves set at $3.5 million. Subrogation investigation ongoing regarding equipment manufacturer.'
        WHEN 9 THEN 'Medical treatment guidelines exceeded. Claimant receiving opioid pain medication for 6+ months post-injury. ODG guidelines recommend discontinuation and alternative pain management. Peer review physician recommends opioid taper and cognitive behavioral therapy. Sent utilization review notice to treating physician. Physician disagrees with recommendations, states claimant requires continued medication. Second opinion requested. Current medication costs $850/month, trending unsustainable.'
        WHEN 10 THEN 'Return to work achieved! Claimant successfully returned to full duty after 12 weeks modified duty. Employer very cooperative throughout claim. Physical therapy completed, claimant reports no residual symptoms. Medical bills totaled $11,500. No indemnity paid as modified duty accommodated throughout. Claim closing as medical only. Employer satisfaction rating 5/5. No permanent impairment. Total incurred $11,500. Claim closing as success story.'
        WHEN 11 THEN 'Compensability accepted after investigation. Initial denial based on alleged horseplay, however witness statements confirm claimant was performing assigned duties when injured. Employer retracted horseplay allegation. Benefits reinstated retroactively. Claimant attorney demanding bad faith damages for claim delay. Evaluated bad faith exposure at $25,000. Recommend settlement of underlying claim plus bad faith penalty. Total exposure now $48,000 including penalties and attorney fees.'
        WHEN 12 THEN 'Suicide investigation completed. Claimant took own life 3 months after work injury. Psychological records show depression diagnosis following injury and inability to return to work. Widow filed claim for dependency benefits. State law requires proof that suicide was direct result of work injury. Retained psychiatrist expert who opines suicide was caused by work injury-related depression. Claim accepted. Death benefits $450,000 plus funeral expenses $12,000. Employer extremely upset, considering appeal.'
        WHEN 13 THEN 'Apportionment dispute. Claimant has 3 prior workers compensation claims for same body part (low back). Current claim also low back strain. Medical records show degenerative disc disease present before current injury. IME states 30% of current disability attributable to current work injury, 70% pre-existing. Claimant attorney arguing entire disability is work-related. Judge will decide apportionment. Settlement discussions at 50/50 apportionment. Awaiting trial decision.'
        WHEN 14 THEN 'Vocational rehabilitation initiated. Claimant unable to return to prior occupation as construction laborer due to permanent restrictions. Vocational counselor assessing transferable skills. Claimant has limited education, English as second language. Retraining options being explored. Estimated vocational rehab costs $15,000. May qualify for vocational rehabilitation benefits under state law. Employer supportive of retraining program.'
        WHEN 15 THEN 'Medical provider billing dispute. Provider billed $25,000 for surgery, fee schedule allows $12,000. Provider demanding payment in full, threatening lien. Reviewed medical bill review, fee schedule application correct. Sent explanation of benefits to provider. Provider appealing decision. Independent bill review confirms $12,000 is correct reimbursement. Will defend fee schedule application at hearing. Provider has history of overbilling.'
        WHEN 16 THEN 'Temporary total disability continuing. Claimant off work 6 months with complex regional pain syndrome following minor hand injury. Pain syndrome diagnosis controversial, difficult to verify objectively. Claimant seeing pain management specialist, multiple medications tried. Functional capacity exam shows claimant cannot perform any work. Psychiatric evaluation shows secondary depression. Continuing TTD benefits, current indemnity exposure $42,000. MMI timeline uncertain, condition may be permanent.'
        WHEN 17 THEN 'Second injury fund claim filed. Claimant has pre-existing amputation of left leg. Current work injury to right leg results in total disability. Employer seeking reimbursement from state second injury fund for pre-existing disability portion. Fund requires proof of prior permanent disability and that combined disabilities create greater impairment. Application submitted with supporting medical documentation. Fund decision expected in 90 days. Potential recovery $180,000.'
        WHEN 18 THEN 'Light duty program successful. Employer has robust modified duty program allowing injured workers to remain productive during recovery. Claimant worked modified duty 8 weeks while recovering from ankle sprain. No wage loss, no indemnity benefits paid. Medical costs $3,200 for treatment and PT. Employer receives premium discount for effective return to work program. Claim resolved quickly, claimant satisfied. Employer best practices case study.'
        WHEN 19 THEN 'Widow benefits claim. Worker killed in industrial accident. Widow and 3 minor children filing for death benefits. State law provides benefits until youngest child turns 18. Calculated benefit exposure $780,000 over 12 years. Funeral expenses $15,000. Wrongful death action filed against employer alleging gross negligence. Retained coverage counsel. Potential exposure millions in civil damages. Investigation shows equipment safety guard was removed. OSHA investigating. Serious employer liability exposure.'
    END AS note_text,
    ARRAY_CONSTRUCT('ADJUSTER_NOTE', 'FIELD_INVESTIGATION', 'MEDICAL_REVIEW', 'SETTLEMENT_DISCUSSION', 'SURVEILLANCE_REPORT')[UNIFORM(0, 4, RANDOM())] AS note_type,
    c.injury_date AS note_date,
    c.injury_type,
    c.body_part,
    c.claim_status = 'CLOSED' AS resolution_achieved,
    c.created_at AS created_at
FROM RAW.CLAIMS c
WHERE c.claim_id IS NOT NULL
LIMIT 25000;

-- ============================================================================
-- Step 6: Generate sample medical treatment guidelines
-- ============================================================================
INSERT INTO MEDICAL_TREATMENT_GUIDELINES VALUES
('MTG001', 'Low Back Injury Treatment Guidelines - Evidence Based Medicine',
$$LOW BACK INJURY TREATMENT GUIDELINES
Medical Treatment Guideline MTG-2024-001 Rev. D
Official Disability Guidelines (ODG) Compliant

INTRODUCTION
Low back injuries represent 25-30% of all workers compensation claims. These evidence-based guidelines provide appropriate treatment pathways to optimize outcomes while controlling costs.

INITIAL EVALUATION AND DIAGNOSIS
Within 24-72 hours of injury:
- Complete history and physical examination
- Pain assessment using validated scale (VAS 0-10)
- Neurological examination including straight leg raise
- Red flag screening for serious pathology
- Functional assessment and work restrictions

Imaging Guidelines:
- X-rays NOT recommended for uncomplicated strain/sprain within first 6 weeks
- MRI only if:
  * Neurological deficits present
  * Severe or progressive symptoms after 6 weeks conservative care
  * Red flags for serious pathology (tumor, infection, fracture)

CONSERVATIVE TREATMENT - FIRST 6 WEEKS
Phase 1 (Week 1-2): Acute Pain Management
- NSAIDs: Ibuprofen 600mg TID or Naproxen 500mg BID
- Avoid opioids if possible; if needed limit to 3-7 days
- Muscle relaxants for severe spasm: Cyclobenzaprine 10mg HS
- Ice application 15-20 minutes every 2-3 hours
- Stay active - complete bed rest NOT recommended
- Work restrictions: No lifting >10 lbs, frequent position changes

Phase 2 (Week 2-6): Active Recovery
- Physical therapy 2-3x weekly focusing on:
  * Core strengthening exercises
  * Flexibility and stretching
  * Posture education
  * Body mechanics training
- Gradual return to activity
- Modify work restrictions as tolerated
- Wean off medications as pain improves

TIMELINE EXPECTATIONS
- 50% of patients: Significant improvement within 2 weeks
- 80% of patients: Return to normal activity within 6 weeks
- 90% of patients: Complete recovery within 12 weeks
- 10% of patients: Chronic pain requiring ongoing management

RED FLAGS REQUIRING IMMEDIATE EVALUATION
- Cauda equina syndrome (bladder/bowel dysfunction)
- Progressive neurological deficits
- Severe night pain or fever (infection/tumor concerns)
- History of cancer
- Significant trauma or osteoporosis

TREATMENT NOT RECOMMENDED (LACK OF EVIDENCE)
- Prolonged bed rest (>2 days)
- Passive modalities only (ultrasound, TENS) without active therapy
- Traction
- Acupuncture as primary treatment (may be adjunct)
- Injections before 6 weeks conservative care

INTERVENTIONAL TREATMENT - AFTER 6 WEEKS IF CONSERVATIVE CARE FAILS
Epidural Steroid Injections:
- For radicular pain with nerve root compression
- Limit to 3 injections per year
- Must be performed under fluoroscopy
- Combined with active physical therapy
- Success rate: 50-60% for appropriately selected patients

Facet Joint Injections:
- For confirmed facet-mediated pain
- Diagnostic blocks before therapeutic intervention
- Limited evidence, consider only after all conservative care exhausted

SURGICAL INDICATIONS (RARE - <5% of cases)
Urgent Surgery Required:
- Cauda equina syndrome
- Progressive motor weakness

Elective Surgery Consideration (after 6-12 months failed conservative care):
- Herniated disc with persistent radiculopathy
- Spinal stenosis with neurogenic claudication
- Spondylolisthesis with neurological compromise

RETURN TO WORK GUIDELINES
Modified Duty:
- Begins as soon as medically appropriate
- Graduated return: 4 hours → 6 hours → 8 hours
- Lifting restrictions: Gradually increase from 10 lbs to full capacity
- Sitting/standing alternation recommended

Full Duty Release Criteria:
- Pain controlled with OTC medications or none
- Functional capacity evaluation shows ability to perform job demands
- Physician clearance based on objective functional improvement

PREVENTION OF CHRONICITY
High Risk Factors for Chronic Pain:
- History of previous back pain
- Poor job satisfaction
- Pending litigation
- Catastrophizing and fear-avoidance beliefs
- Depression or anxiety
- Opioid use beyond 6 weeks

Interventions to Prevent Chronicity:
- Early return to modified work
- Cognitive behavioral therapy for fear-avoidance
- Avoid unnecessary imaging that may lead to over-treatment
- Limit opioid exposure
- Address psychosocial factors early

MEDICATION MANAGEMENT
NSAIDs:
- First-line for pain management
- Monitor for GI side effects
- Limit duration in elderly or those with renal disease

Opioids:
- Use ONLY if severe pain and NSAIDs inadequate
- Limit to lowest dose for shortest duration
- Wean within 3-4 weeks
- Warning signs of opioid dependence:
  * Escalating doses
  * Early refill requests
  * Lost prescriptions
  * Resistant to weaning

Alternative Pain Management:
- Topical NSAIDs for localized pain
- Lidocaine patches
- Heat therapy after acute phase
- Mind-body techniques (meditation, relaxation)

PHYSICAL THERAPY PROTOCOLS
Active Exercise Focus:
- Core stabilization exercises (planks, bridges)
- McKenzie extension exercises for disc issues
- Williams flexion exercises for stenosis
- Aerobic conditioning (walking, swimming)
- Functional task training

Passive Modalities (Limited Use):
- Ice/heat for symptom relief only
- Should not be primary treatment
- Wean as patient progresses

Expected Progress:
- Week 1-2: Pain reduction, improved mobility
- Week 3-4: Functional gains, return to ADLs
- Week 5-6: Return to work activities
- Discharge criteria: Independent home exercise program

DOCUMENTATION REQUIREMENTS
Provider Must Document:
- Objective findings on exam
- Functional limitations specific to job
- Treatment plan with goals and timelines
- Progress toward recovery
- Barriers to recovery
- Return to work capacity

Warning Signs of Inappropriate Care:
- Treatment beyond 12 weeks without documented progress
- Passive care only (chiropractic adjustments without exercise)
- Repeated imaging without clinical indication
- Opioid prescriptions beyond 6 weeks without specialist consultation

OUTCOMES MEASUREMENT
Track These Metrics:
- Pain scores (VAS) - expect 50% reduction in 6 weeks
- Functional status (Oswestry Disability Index)
- Days to return to work
- Total treatment costs
- Patient satisfaction

QUALITY INDICATORS
Optimal Outcomes:
- 80% return to work within 12 weeks
- Average total medical costs <$8,000 for uncomplicated strain
- <5% progress to chronic pain
- <2% require surgery
- Patient satisfaction >90%

CONCLUSION
Following these evidence-based guidelines optimizes patient outcomes while controlling costs. Early intervention, active treatment, and focus on function result in best results.$$,
'STRAIN_SPRAIN', 'BACK', 'ORTHOPEDIC', 'MTG-2024-001', 'Rev. D', 'low back,lumbar strain,conservative care,return to work', 'Zenith Medical Director Staff', '2024-01-15', CURRENT_TIMESTAMP(), TRUE, CURRENT_TIMESTAMP()),

('MTG002', 'Carpal Tunnel Syndrome Management and Treatment Protocol',
$$CARPAL TUNNEL SYNDROME MANAGEMENT PROTOCOL  
Medical Treatment Guideline MTG-2024-002 Rev. B
Workers Compensation Best Practices

OVERVIEW
Carpal Tunnel Syndrome (CTS) is compression of the median nerve at the wrist. Represents 15-20% of upper extremity workers comp claims. Early appropriate treatment prevents progression to surgery.

DIAGNOSIS
Clinical Presentation:
- Numbness/tingling in thumb, index, middle fingers
- Night symptoms common
- Hand weakness, dropping objects
- Symptoms with repetitive hand use

Physical Examination:
- Tinel's sign at wrist (nerve percussion test)
- Phalen's maneuver (wrist flexion provocation)
- Thenar muscle atrophy (advanced cases)
- Two-point discrimination testing

Electrodiagnostic Testing:
- EMG/NCS confirms diagnosis
- Recommended before surgery
- Classifies severity: mild, moderate, severe
- Not required for initial conservative care

CONSERVATIVE TREATMENT (6-12 WEEKS)
First-Line Treatment:
- Wrist splint in neutral position
  * Wear at night initially
  * May wear during provocative activities
  * Custom vs. OTS splint both acceptable
- Activity modification at work
- Ergonomic assessment and workplace modifications
- NSAIDs for symptom relief

Physical/Occupational Therapy:
- Nerve gliding exercises
- Stretching exercises
- Strengthening of supporting muscles
- Workplace ergonomic training
- 6-8 sessions typically sufficient

Corticosteroid Injection:
- Consider if conservative care fails at 6 weeks
- Single injection: 10-40mg methylprednisolone
- Success rate 50-70% for mild-moderate CTS
- May provide 3-6 months relief
- Repeat injection only if good response to first

SURGICAL INDICATIONS
Surgery Recommended If:
- Failed 3 months conservative treatment
- Severe CTS on EMG/NCS
- Thenar atrophy present
- Progressive motor weakness

Carpal Tunnel Release:
- Open or endoscopic approach both acceptable
- Outpatient procedure
- Recovery 2-3 weeks for light duty
- Full recovery 6-8 weeks
- Success rate >90% for appropriately selected patients

POST-OPERATIVE CARE
Week 1-2:
- Hand elevation to reduce swelling
- Gentle finger ROM exercises
- Splint removal at 1 week typically
- Light activities of daily living

Week 2-6:
- Progressive strengthening
- Scar management
- Return to light duty work at 2 weeks
- Avoid heavy gripping until 6 weeks

Week 6-12:
- Return to full unrestricted work
- Continued strengthening
- Workplace ergonomic evaluation
- Monitor for symptom recurrence

RETURN TO WORK
Modified Duty Restrictions:
- Limit repetitive hand motions
- Avoid forceful gripping
- Frequent rest breaks
- Ergonomic tools (padded handles, wrist supports)

Return to Full Duty:
- Symptom-free or minimal symptoms
- Adequate grip strength
- Functional capacity evaluation if heavy work
- Typically 6-8 weeks post-surgery

PREVENTION OF RECURRENCE
Workplace Modifications:
- Adjust work station height and layout
- Use ergonomic keyboard and mouse
- Frequent position changes
- Job rotation if highly repetitive work

Worker Education:
- Proper hand positioning
- Regular stretching breaks
- Report early symptoms
- Use of neutral wrist postures

EXPECTED OUTCOMES
Conservative Care:
- 30-50% success avoiding surgery
- Best results in mild-moderate CTS
- Splinting most effective intervention

Surgical Care:
- 90-95% good/excellent results
- Symptom improvement within days
- Complete recovery 90% within 3 months
- Recurrence rate <5%

CAUSATION CONSIDERATIONS
Work-Related CTS Factors:
- Repetitive hand/wrist motions
- Forceful gripping
- Awkward wrist postures
- Vibration exposure
- Cold temperature work environment

Non-Work-Related Factors:
- Pregnancy
- Diabetes
- Thyroid disease  
- Rheumatoid arthritis
- Obesity
- Age >40

Apportionment:
- Many cases involve both occupational and non-occupational factors
- Consider prior symptoms and treatment
- Pre-existing conditions may aggravate work-related CTS$$,
'REPETITIVE_MOTION', 'HAND', 'OCCUPATIONAL_THERAPY', 'MTG-2024-002', 'Rev. B', 'carpal tunnel,cts,wrist pain,nerve compression', 'Zenith Medical Director Staff', '2024-01-15', CURRENT_TIMESTAMP(), TRUE, CURRENT_TIMESTAMP()),

('MTG003', 'Shoulder Injury Return to Work Best Practices',
$$SHOULDER INJURY RETURN TO WORK BEST PRACTICES
Medical Treatment Guideline MTG-2024-003 Rev. C  
Evidence-Based Rehabilitation Protocols

INTRODUCTION
Shoulder injuries account for 8-10% of workers compensation claims. Successful return to work requires coordinated medical treatment and workplace accommodation.

COMMON SHOULDER INJURIES IN WORKPLACE
Rotator Cuff Injuries:
- Tears (acute vs. chronic)
- Tendinitis/tendinopathy
- Impingement syndrome
- Most common in overhead workers

Other Shoulder Conditions:
- AC joint separation
- Labral tears
- Frozen shoulder (adhesive capsulitis)
- Biceps tendon pathology

TREATMENT PHASES
Phase 1: Pain Control and Protection (Week 1-2)
- Sling for comfort (not immobilization)
- Ice 15-20 minutes every 2-3 hours
- NSAIDs as needed
- Avoid painful activities
- Maintain elbow/wrist/hand motion
- Modified duty: No overhead work, no lifting

Phase 2: Restore Motion (Week 2-6)
- Physical therapy 2-3x weekly
- Passive and active-assisted range of motion
- Pendulum exercises
- Pulley exercises
- Gradual weaning from sling
- Modified duty: Lifting up to 10 lbs below shoulder level

Phase 3: Strengthening (Week 6-12)
- Rotator cuff strengthening
- Scapular stabilization exercises
- Progressive resistance training
- Sport/work-specific exercises
- Modified duty: Gradual increase to 25 lbs

Phase 4: Return to Full Function (Week 12+)
- Advanced strengthening
- Plyometric exercises if needed
- Job simulation activities
- Full duty release when appropriate

SURGICAL CONSIDERATIONS
Non-Surgical Candidates:
- Partial thickness rotator cuff tears
- Tendinitis/impingement
- Older patients with chronic tears, low demand

Surgical Indications:
- Full thickness tears in active workers
- Failed 3-6 months conservative care
- Acute traumatic tears
- Young patients with high physical demands

Post-Surgical Timeline:
- Sling 4-6 weeks
- Passive motion 0-6 weeks
- Active motion 6-12 weeks
- Strengthening 12-16 weeks
- Return to work 4-6 months typical

RETURN TO WORK STRATEGIES
Early Modified Duty (Week 1-2):
- Sedentary tasks with affected arm in sling
- One-handed computer work
- Phone tasks
- Administrative duties
- NO: Lifting, reaching, overhead work

Progressive Modified Duty (Week 3-12):
- Light bilateral activities
- Lifting 5-10 lbs waist level
- Limited reaching to shoulder level
- Duration: 4-6 hours initially, progress to 8
- Frequent breaks and position changes

Transitional Duty (Week 12-16):
- Lifting up to 25 lbs
- Occasional overhead reaching
- Most work tasks with restrictions
- Evaluate for full duty release

WORKPLACE ACCOMMODATIONS
Physical Modifications:
- Lower work surface height
- Provide mechanical assists for lifting
- Reduce overhead storage requirements
- Ergonomic tool selection (lighter weight)

Administrative Modifications:
- Job rotation to limit repetitive overhead work
- Scheduled rest breaks
- Cross-training to other positions
- Temporary reassignment if needed

FUNCTIONAL CAPACITY EVALUATION
Timing:
- Before return to heavy duty work
- When permanent restrictions considered
- To determine work capacity objectively

Components:
- Strength testing (lifting, pushing, pulling)
- Range of motion assessment
- Endurance testing
- Job-specific task simulation
- Valid effort determination

PREVENTION OF RE-INJURY
Worker Training:
- Proper lifting techniques
- Use of step stools for overhead access
- Report symptoms early
- Stretching program

Workplace Modifications:
- Minimize overhead work requirements
- Provide lifting assists
- Allow position variation
- Adequate staffing for two-person lifts

EXPECTED OUTCOMES
Non-Surgical Treatment:
- 70-80% successful return to work
- 3-6 months average duration
- Best results in impingement, tendinitis

Surgical Treatment:
- 85-90% successful return to work
- 6-9 months average duration
- Age and tear size affect outcomes
- Smokers have higher failure rates

MAXIMUM MEDICAL IMPROVEMENT
Criteria for MMI:
- Plateau in objective improvements
- Completed prescribed treatment
- Functional status stable
- Typically 6-12 months from injury

Permanent Restrictions Common:
- No lifting >50 lbs above shoulder
- Limit repetitive overhead work
- Use of mechanical assists for heavy loads
- Many workers can return to full duty with accommodations$$,
'STRAIN_SPRAIN', 'SHOULDER', 'PHYSICAL_THERAPY', 'MTG-2024-003', 'Rev. C', 'shoulder injury,rotator cuff,return to work,modified duty', 'Zenith Medical Director Staff', '2024-01-15', CURRENT_TIMESTAMP(), TRUE, CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 7: Generate sample SIU investigation reports
-- ============================================================================
INSERT INTO SIU_INVESTIGATION_REPORTS
SELECT
    'SIU' || LPAD(SEQ4(), 10, '0') AS investigation_report_id,
    c.claim_id,
    c.employer_id,
    c.injured_worker_id,
    CASE (ABS(RANDOM()) % 15)
        WHEN 0 THEN 'SPECIAL INVESTIGATION UNIT REPORT - Case #SIU-2024-' || LPAD(SEQ4(), 6, '0') || '. FRAUD INDICATORS IDENTIFIED. Claimant reported total disability from back injury, unable to perform any work. Surveillance conducted over 3 days. Day 1: Claimant observed leaving residence at 7:15 AM, drove to Home Depot, purchased lumber and tools. Day 2: Claimant observed performing construction work at residential property, carrying heavy materials, climbing ladder, using power tools for extended periods. Day 3: Claimant observed moving furniture, lifting and carrying without apparent difficulty. Activities clearly inconsistent with reported restrictions. Social media review shows claimant advertising handyman services on Facebook Marketplace. RECOMMENDATION: Benefits denial based on material misrepresentation. Criminal fraud referral to District Attorney. Estimated savings: $85,000 in future benefits.'
        WHEN 1 THEN 'INVESTIGATION REPORT - MEDICAL PROVIDER FRAUD. Pattern identified with Dr. Smith Pain Clinic. Review of 47 claims shows: 1) All patients receive same treatment regardless of diagnosis, 2) Excessive billing for procedures not medically necessary, 3) Upcoding of services, 4) Billing for services not rendered. Example: Patient #1 billed for epidural injection, medical records show only office visit performed. Peer review confirms pattern across multiple insurers. Total overbilling estimated $340,000 across all cases. RECOMMENDATION: Cease all authorizations to provider, demand refund of overpayments, referral to state medical board, criminal investigation referral. Provider has history of prior discipline.'
        WHEN 2 THEN 'CLAIMANT STATEMENT ANALYSIS - INCONSISTENCIES IDENTIFIED. Initial claim: States injured lifting 50-lb box alone, no witnesses, immediate severe pain requiring ambulance transport. Follow-up interview: Changed story to co-worker helping lift, box weight was 30 lbs, drove self to urgent care 2 hours later. Medical records: Urgent care states patient walked in without assistance, vitals normal, declined pain medication. Employer investigation: No record of incident, claimant did not report to supervisor as required. Surveillance: Claimant working second job as delivery driver, lifting and carrying packages. CONCLUSION: Claim appears fabricated. Recommend denial based on lack of credible evidence of work-related injury.'
        WHEN 3 THEN 'RETURN TO WORK FRAUD INVESTIGATION. Employer reports claimant working at competitor while collecting temporary total disability benefits. Investigation confirms claimant employed full-time at competing business under different name (using maiden name). Pay stubs obtained showing 40 hours/week employment during entire disability period. Claimant collected $18,500 in TTD benefits while employed. Surveillance confirms daily attendance at competitor location. RECOMMENDATION: Immediate cessation of benefits, demand full reimbursement of $18,500, criminal fraud prosecution. This is willful fraud with clear intent to defraud.'
        WHEN 4 THEN 'PRE-EXISTING CONDITION INVESTIGATION. Claimant alleges work-related shoulder injury, demands surgery. Medical records subpoena reveals extensive prior treatment same shoulder: 1) Emergency room visit 2 years prior for shoulder pain, 2) Orthopedic evaluation recommended surgery, 3) MRI shows chronic rotator cuff tear, 4) Patient declined surgery due to no insurance. Current claim filed immediately after obtaining workers comp coverage. Claimant failed to disclose prior injury on employment application. IME physician states current condition pre-existed employment. CONCLUSION: Pre-existing condition, not work-related. Claim appropriately denied. Employer considering termination for falsified employment application.'
        WHEN 5 THEN 'SURVEILLANCE INVESTIGATION - EXAGGERATION OF INJURY. Claimant reports inability to walk more than 50 feet, requires wheelchair, severe chronic pain. Three-day surveillance shows: Day 1 - Claimant walked through shopping mall for 2 hours without assistance or apparent discomfort. Day 2 - Claimant played 18 holes of golf, walked entire course carrying golf bag. Day 3 - Claimant worked in garden for 3 hours, bending, kneeling, lifting. Medical exam shows inconsistent effort on testing, Waddell signs positive suggesting non-organic pain. CONCLUSION: Significant exaggeration of disability. Benefits do not appear warranted. Recommend termination of benefits and settlement demand reduction.'
        WHEN 6 THEN 'SOCIAL MEDIA INVESTIGATION. Review of claimant social media profiles reveals activities inconsistent with claimed disability. Facebook posts during disability period show: 1) Photos of claimant skiing in Colorado, 2) Posts about training for marathon, 3) Multiple gym check-ins, 4) Posts advertising personal training services. Instagram shows claimant performing heavy weightlifting, CrossFit activities. Claimant simultaneously receiving benefits for total disability from back injury. Screenshots preserved as evidence. RECOMMENDATION: Confrontation interview with claimant, likely benefits suspension pending explanation. Estimated fraudulent benefits paid: $32,000.'
        WHEN 7 THEN 'EMPLOYER FRAUD INVESTIGATION - PREMIUM FRAUD DETECTED. Employer reported payroll of $250,000, actual payroll $1.2 million based on tax records obtained. Employer misclassified workers as independent contractors to avoid workers comp coverage. Payroll audit reveals $950,000 underreported payroll over 3 years. Additional premium owed: $47,500 plus penalties. Multiple injured workers not covered by policy. One serious injury resulted in uninsured worker suing employer. RECOMMENDATION: Demand immediate payment of back premium, report to state fraud bureau, consider policy cancellation.'
        WHEN 8 THEN 'STAGED ACCIDENT INVESTIGATION. Claimant alleges slip and fall on stairs at workplace. Investigation reveals: 1) No incident report filed day of alleged accident, 2) Claimant reported injury 3 days later after consulting attorney, 3) Witness statements conflict with claimant story, 4) Security camera footage does not show any fall on claimed date/time, 5) Claimant has history of 4 prior slip and fall claims at other employers. Attorney involved immediately before claim filed. CONCLUSION: Staged accident for financial gain. Recommend complete claim denial, SIU referral to law enforcement, notification to insurance fraud bureau.'
        WHEN 9 THEN 'MEDICAL NECESSITY REVIEW - EXCESSIVE TREATMENT. Claimant receiving chiropractic treatment 3x weekly for 18 months with no objective improvement. Peer review shows treatment beyond medical necessity by 12+ months. Chiropractor financially motivated, billing $450 per visit. Total excessive charges $75,000. Claimant admits treatment not helping but chiropractor says must continue. No objective findings support continued care. RECOMMENDATION: Immediate cessation of chiropractic authorization, demand from provider to justify excessive treatment, file complaint with state board. Chiropractic records show treatment plan never modified despite lack of progress.'
        WHEN 10 THEN 'ATTORNEY FRAUD INVESTIGATION. Claimant attorney submitted fraudulent medical bills to inflate settlement value. Investigation reveals: 1) Bills for services never rendered, 2) Bills from providers claimant never saw, 3) Altered medical records to show more serious injury, 4) False physician signatures on reports. Handwriting analysis confirms attorney staff forged provider signatures. Provider confirms never treated claimant. RECOMMENDATION: Immediate report to state bar association, criminal fraud referral, denial of all suspect bills. This is attorney-led fraud scheme affecting multiple claims. Full investigation of attorney other cases recommended.'
        WHEN 11 THEN 'CONCURRENT EMPLOYMENT FRAUD. Claimant working two jobs, injured at Job A, continued working full duty at Job B while collecting disability from Job A. Employer B confirms claimant working 40 hours per week without restrictions during entire TTD period. Claimant collected $22,500 in benefits while fully employed elsewhere. When confronted, claimant stated thought it was okay to work different job. Attorney involved claims claimant misunderstood. RECOMMENDATION: Overpayment demand for $22,500, potential fraud charges depending on claimant credibility in interview. May be mistake vs. intentional fraud.'
        WHEN 12 THEN 'ORGANIZED FRAUD RING INVESTIGATION. Multiple suspicious claims identified from same employer location. Pattern: 1) All claims filed by Russian-speaking workers within 3 month period, 2) All represented by same attorney, 3) All treated by same medical provider clinic, 4) All claim similar injuries with vague onset, 5) All seeking maximum benefits. Interpreter used in all cases is attorney employee. Investigation reveals: Medical provider paying kickbacks to attorney for referrals. Employer unaware of organized scheme. Estimated fraudulent claims: 12 cases totaling $385,000. RECOMMENDATION: Multi-agency investigation with insurance fraud bureau, state medical board, FBI. All claims suspended pending investigation. Provider credentials under review.'
        WHEN 13 THEN 'PERMANENT DISABILITY FRAUD. Claimant claims permanent total disability, unable to work any job. Vocational evaluation shows multiple jobs claimant could perform. Surveillance shows claimant operating landscaping business under spouse name. Business grossing $85,000/year. Claimant working 50+ hours per week. Disability benefits paid for 2 years totaling $124,000. Claimant owns commercial equipment, employs workers, manages all operations. RECOMMENDATION: Immediate termination of benefits, demand reimbursement of all benefits paid during business operation, criminal prosecution for fraud. This represents intentional, ongoing fraud.'
        WHEN 14 THEN 'IME SHOPPING INVESTIGATION. Claimant attorney has referred claimant to 4 different physicians seeking favorable opinion. First 3 IMEs all agreed claimant able to work with restrictions. Fourth physician (known plaintiff-friendly doctor) found claimant permanent total disability. Investigation of physician reveals: License discipline history, multiple Board complaints, financial relationship with referring attorneys. Physician opines permanent disability in 90% of IMEs performed. Physician charges 3x normal fee. RECOMMENDATION: Disregard biased IME, rely on first three independent evaluations, report physician to medical board for unethical practice.'
    END AS report_text,
    ARRAY_CONSTRUCT('SURVEILLANCE', 'MEDICAL_PROVIDER_FRAUD', 'CLAIMANT_FRAUD', 'EXAGGERATION', 'STAGED_ACCIDENT', 'PRIOR_INJURY')[UNIFORM(0, 5, RANDOM())] AS investigation_type,
    ARRAY_CONSTRUCT('CONFIRMED_FRAUD', 'SUSPICIOUS', 'UNFOUNDED', 'INVESTIGATION_ONGOING')[UNIFORM(0, 3, RANDOM())] AS investigation_status,
    'Multiple fraud indicators identified including surveillance evidence and inconsistent statements' AS fraud_indicators_summary,
    'Recommended benefits denial and referral for criminal prosecution based on material misrepresentation' AS investigation_outcome,
    c.injury_date AS report_date,
    ARRAY_CONSTRUCT('SIU Investigator Johnson', 'SIU Investigator Smith', 'SIU Investigator Martinez', 'SIU Investigator Chen')[UNIFORM(0, 3, RANDOM())] AS investigated_by,
    c.created_at AS created_at
FROM RAW.CLAIMS c
WHERE UNIFORM(0, 100, RANDOM()) < 60
LIMIT 15000;

-- ============================================================================
-- Step 8: Create Cortex Search Service for Claim Notes
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE CLAIM_NOTES_SEARCH
  ON note_text
  ATTRIBUTES employer_id, adjuster_id, injury_type, body_part, note_type
  WAREHOUSE = ZENITH_WH
  TARGET_LAG = '1 hour'
  AS (
    SELECT 
      note_text,
      employer_id,
      adjuster_id,
      injury_type,
      body_part,
      note_type,
      note_id,
      claim_id
    FROM CLAIM_NOTES
  );

-- ============================================================================
-- Step 9: Create Cortex Search Service for Medical Treatment Guidelines
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE MEDICAL_TREATMENT_GUIDELINES_SEARCH
  ON content
  ATTRIBUTES injury_type, body_part, treatment_category, title
  WAREHOUSE = ZENITH_WH
  TARGET_LAG = '1 day'
  AS (
    SELECT 
      content,
      injury_type,
      body_part,
      treatment_category,
      title,
      guideline_id,
      guideline_number
    FROM MEDICAL_TREATMENT_GUIDELINES
  );

-- ============================================================================
-- Step 10: Create Cortex Search Service for SIU Investigation Reports
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE SIU_INVESTIGATION_REPORTS_SEARCH
  ON report_text
  ATTRIBUTES employer_id, claim_id, investigation_type, investigation_status
  WAREHOUSE = ZENITH_WH
  TARGET_LAG = '1 hour'
  AS (
    SELECT 
      report_text,
      employer_id,
      claim_id,
      investigation_type,
      investigation_status,
      investigation_report_id,
      injured_worker_id
    FROM SIU_INVESTIGATION_REPORTS
  );

-- ============================================================================
-- Display completion and verification
-- ============================================================================
SELECT 'Cortex Search services created successfully' AS status;

-- Show Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- Test Cortex Search service
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'ZENITH_INSURANCE_INTELLIGENCE.RAW.CLAIM_NOTES_SEARCH',
      '{"query": "back injury return to work", "limit":5}'
  )
)['results'] as results;

