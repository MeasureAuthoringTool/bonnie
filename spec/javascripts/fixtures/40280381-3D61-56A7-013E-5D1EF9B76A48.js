// This fixture was created by taking the JS file for measure 0002,
// defining the global fixture variables (if necessary), and changing
// the last line to place the measure into the fixtures instead of the
// bonnie router

window.Fixtures || (window.Fixtures = {});
window.Fixtures.Measures || (window.Fixtures.Measures = new Thorax.Collections.Measures());

(function() {

  var measure = new Thorax.Models.Measure({"_id":"40280381-3D61-56A7-013E-5D1EF9B76A48","category":"Core","cms_id":"CMS146v2","continuous_variable":false,"created_at":null,"custom_functions":null,"data_criteria":{"DiagnosisActiveAcutePharyngitis":{"title":"Acute Pharyngitis","description":"Diagnosis, Active: Acute Pharyngitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1011","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"source_data_criteria":"DiagnosisActiveAcutePharyngitis"},"DiagnosisActiveAcuteTonsillitis":{"title":"Acute Tonsillitis","description":"Diagnosis, Active: Acute Tonsillitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1012","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"source_data_criteria":"DiagnosisActiveAcuteTonsillitis"},"EncounterPerformedAmbulatoryEdVisit":{"title":"Ambulatory/ED Visit","description":"Encounter, Performed: Ambulatory/ED Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1061","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedAmbulatoryEdVisit"},"OccurrenceAAmbulatoryEdVisit3":{"title":"Ambulatory/ED Visit","description":"Encounter, Performed: Ambulatory/ED Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1061","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"ENCOUNTER_PERFORMED_AMBULATORY_ED_VISIT","source_data_criteria":"OccurrenceAAmbulatoryEdVisit3"},"PatientCharacteristicSexOncAdministrativeSex":{"title":"ONC Administrative Sex","description":"Patient Characteristic Sex: ONC Administrative Sex","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113762.1.4.1","property":"gender","type":"characteristic","definition":"patient_characteristic_gender","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicSexOncAdministrativeSex","value":{"type":"CD","system":"Administrative Sex","code":"F"}},"PatientCharacteristicRaceRace":{"title":"Race","description":"Patient Characteristic Race: Race","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.836","property":"race","type":"characteristic","definition":"patient_characteristic_race","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicRaceRace","inline_code_list":{"CDC Race":["1002-5","2028-9","2054-5","2076-8","2106-3","2131-1"]}},"PatientCharacteristicEthnicityEthnicity":{"title":"Ethnicity","description":"Patient Characteristic Ethnicity: Ethnicity","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.837","property":"ethnicity","type":"characteristic","definition":"patient_characteristic_ethnicity","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicEthnicityEthnicity","inline_code_list":{"CDC Race":["2135-2","2186-5"]}},"PatientCharacteristicPayerPayer":{"title":"Payer","description":"Patient Characteristic Payer: Payer","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.3591","property":"payer","type":"characteristic","definition":"patient_characteristic_payer","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicPayerPayer","inline_code_list":{"SOP":["1","11","111","112","113","119","12","121","122","123","129","19","2","21","211","212","213","219","22","23","24","25","29","3","31","311","3111","3112","3113","3114","3115","3116","3119","312","3121","3122","3123","313","32","321","3211","3212","32121","32122","32123","32124","32125","32126","322","3221","3222","3223","3229","33","331","332","333","334","34","341","342","343","349","35","36","361","362","369","37","371","3711","3712","3713","372","379","38","381","3811","3812","3813","3819","382","389","39","4","41","42","43","44","5","51","511","512","513","514","515","519","52","521","522","523","529","53","54","55","59","6","61","611","612","613","619","62","63","64","69","7","71","72","73","79","8","81","82","821","822","823","83","84","85","89","9","91","92","93","94","95","951","953","954","959","96","98","99","9999"]}},"OccurrenceAAcutePharyngitis1_precondition_4":{"title":"Acute Pharyngitis","description":"Diagnosis, Active: Acute Pharyngitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1011","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_PHARYNGITIS","source_data_criteria":"OccurrenceAAcutePharyngitis1"},"OccurrenceAAcuteTonsillitis2_precondition_6":{"title":"Acute Tonsillitis","description":"Diagnosis, Active: Acute Tonsillitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1012","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_TONSILLITIS","source_data_criteria":"OccurrenceAAcuteTonsillitis2"},"MedicationActiveAntibioticMedications_precondition_9":{"title":"Antibiotic Medications","description":"Medication, Active: Antibiotic Medications","standard_category":"medication","qds_data_type":"medication_active","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1001","type":"medications","definition":"medication","status":"active","hard_status":false,"negation":false,"source_data_criteria":"MedicationActiveAntibioticMedications","temporal_references":[{"type":"SBS","reference":"GROUP_SBS_CHILDREN_47","range":{"type":"IVL_PQ","high":{"type":"PQ","unit":"d","value":"30","inclusive?":true,"derived?":false}}}]},"GROUP_SBS_CHILDREN_47":{"title":"GROUP_SBS_CHILDREN_47","description":"","standard_category":"","qds_data_type":"","children_criteria":["OccurrenceAAcutePharyngitis1_precondition_4","OccurrenceAAcuteTonsillitis2_precondition_6"],"derivation_operator":"UNION","type":"derived","definition":"derived","hard_status":false,"negation":false,"source_data_criteria":"GROUP_SBS_CHILDREN_47"},"LaboratoryTestResultGroupAStreptococcusTest_precondition_12":{"title":"Group A Streptococcus Test","description":"Laboratory Test, Result: Group A Streptococcus Test","standard_category":"laboratory_test","qds_data_type":"laboratory_test","code_list_id":"2.16.840.1.113883.3.464.1003.198.12.1012","type":"laboratory_tests","definition":"laboratory_test","hard_status":false,"negation":false,"source_data_criteria":"LaboratoryTestResultGroupAStreptococcusTest","value":{"type":"ANYNonNull"},"temporal_references":[{"type":"SBE","reference":"OccurrenceAAmbulatoryEdVisit3","range":{"type":"IVL_PQ","high":{"type":"PQ","unit":"d","value":"3","inclusive?":true,"derived?":false}}}]},"LaboratoryTestResultGroupAStreptococcusTest_precondition_14":{"title":"Group A Streptococcus Test","description":"Laboratory Test, Result: Group A Streptococcus Test","standard_category":"laboratory_test","qds_data_type":"laboratory_test","code_list_id":"2.16.840.1.113883.3.464.1003.198.12.1012","type":"laboratory_tests","definition":"laboratory_test","hard_status":false,"negation":false,"source_data_criteria":"LaboratoryTestResultGroupAStreptococcusTest","value":{"type":"ANYNonNull"},"temporal_references":[{"type":"SAE","reference":"OccurrenceAAmbulatoryEdVisit3","range":{"type":"IVL_PQ","high":{"type":"PQ","unit":"d","value":"3","inclusive?":true,"derived?":false}}}]},"PatientCharacteristicBirthdateBirthDate_precondition_19":{"title":"birth date","description":"Patient Characteristic Birthdate: birth date","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113883.3.560.100.4","property":"birthtime","type":"characteristic","definition":"patient_characteristic_birthdate","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicBirthdateBirthDate","inline_code_list":{"LOINC":["21112-8"]},"temporal_references":[{"type":"SBS","reference":"MeasurePeriod","range":{"type":"IVL_PQ","low":{"type":"PQ","unit":"a","value":"2","inclusive?":true,"derived?":false}}}]},"PatientCharacteristicBirthdateBirthDate_precondition_21":{"title":"birth date","description":"Patient Characteristic Birthdate: birth date","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113883.3.560.100.4","property":"birthtime","type":"characteristic","definition":"patient_characteristic_birthdate","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicBirthdateBirthDate","inline_code_list":{"LOINC":["21112-8"]},"temporal_references":[{"type":"SBS","reference":"MeasurePeriod","range":{"type":"IVL_PQ","high":{"type":"PQ","unit":"a","value":"18","inclusive?":false,"derived?":false}}}]},"OccurrenceAAmbulatoryEdVisit3_precondition_23":{"title":"Ambulatory/ED Visit","description":"Encounter, Performed: Ambulatory/ED Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1061","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"ENCOUNTER_PERFORMED_AMBULATORY_ED_VISIT","source_data_criteria":"OccurrenceAAmbulatoryEdVisit3","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"MedicationOrderAntibioticMedications_precondition_25":{"title":"Antibiotic Medications","description":"Medication, Order: Antibiotic Medications","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1001","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderAntibioticMedications","temporal_references":[{"type":"SAS","reference":"OccurrenceAAmbulatoryEdVisit3","range":{"type":"IVL_PQ","high":{"type":"PQ","unit":"d","value":"3","inclusive?":true,"derived?":false}}}]},"OccurrenceAAcutePharyngitis1_precondition_27":{"title":"Acute Pharyngitis","description":"Diagnosis, Active: Acute Pharyngitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1011","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_PHARYNGITIS","source_data_criteria":"OccurrenceAAcutePharyngitis1"},"OccurrenceAAcuteTonsillitis2_precondition_29":{"title":"Acute Tonsillitis","description":"Diagnosis, Active: Acute Tonsillitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1012","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_TONSILLITIS","source_data_criteria":"OccurrenceAAcuteTonsillitis2"},"OccurrenceAAmbulatoryEdVisit3_precondition_32":{"title":"Ambulatory/ED Visit","description":"Encounter, Performed: Ambulatory/ED Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1061","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"ENCOUNTER_PERFORMED_AMBULATORY_ED_VISIT","source_data_criteria":"OccurrenceAAmbulatoryEdVisit3","temporal_references":[{"type":"DURING","reference":"GROUP_DURING_CHILDREN_49"}]},"GROUP_DURING_CHILDREN_49":{"title":"GROUP_DURING_CHILDREN_49","description":"","standard_category":"","qds_data_type":"","children_criteria":["OccurrenceAAcutePharyngitis1_precondition_27","OccurrenceAAcuteTonsillitis2_precondition_29"],"derivation_operator":"UNION","type":"derived","definition":"derived","hard_status":false,"negation":false,"source_data_criteria":"GROUP_DURING_CHILDREN_49"},"OccurrenceAAmbulatoryEdVisit3_precondition_39":{"title":"Ambulatory/ED Visit","description":"Encounter, Performed: Ambulatory/ED Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1061","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"ENCOUNTER_PERFORMED_AMBULATORY_ED_VISIT","source_data_criteria":"OccurrenceAAmbulatoryEdVisit3"},"OccurrenceAAcutePharyngitis1_precondition_34":{"title":"Acute Pharyngitis","description":"Diagnosis, Active: Acute Pharyngitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1011","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_PHARYNGITIS","source_data_criteria":"OccurrenceAAcutePharyngitis1","temporal_references":[{"type":"SDU","reference":"OccurrenceAAmbulatoryEdVisit3_precondition_39"}]},"OccurrenceAAcuteTonsillitis2_precondition_36":{"title":"Acute Tonsillitis","description":"Diagnosis, Active: Acute Tonsillitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1012","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_TONSILLITIS","source_data_criteria":"OccurrenceAAcuteTonsillitis2","temporal_references":[{"type":"SDU","reference":"OccurrenceAAmbulatoryEdVisit3_precondition_39"}]}},"description":"Percentage of children 2-18 years of age who were diagnosed with pharyngitis, ordered an antibiotic and received a group A streptococcus (strep) test for the episode.","endorser":null,"episode_ids":null,"episode_of_care":false,"force_sources":null,"hqmf_id":"40280381-3D61-56A7-013E-5D1EF9B76A48","hqmf_set_id":"BEB1C33C-2549-4E7F-9567-05ED38448464","hqmf_version_number":2,"id":"40280381-3D61-56A7-013E-5D1EF9B76A48","measure_attributes":[{"id":"COPYRIGHT","code":"COPY","value":"Physician Performance Measure (Measures) and related data specifications were developed by the National Committee for Quality Assurance (NCQA). \n\nThe Measures are copyrighted but can be reproduced and distributed, without modification, for noncommercial purposes (e.g., use by healthcare providers in connection with their practices). Commercial use is defined as the sale, licensing, or distribution of the Measures for commercial gain, or incorporation of the Measures into a product or service that is sold, licensed or distributed for commercial gain. Commercial use of the Measures requires a license agreement between the user and NCQA. NCQA is not responsible for any use of the Measures. \n\n(c) 2008-2013 National Committee for Quality Assurance. All Rights Reserved. \n\nLimited proprietary coding is contained in the Measure specifications for user convenience. Users of proprietary code sets should obtain all necessary licenses from the owners of the code sets.  NCQA disclaims all liability for use or accuracy of any CPT or other codes contained in the specifications.\n\nCPT(R) contained in the Measure specifications is copyright 2004-2012 American Medical Association. LOINC(R) copyright 2004-2012 Regenstrief Institute, Inc. This material contains SNOMED Clinical Terms(R) (SNOMED CT[R]) copyright 2004-2012 International Health Terminology Standards Development Organisation. ICD-10 copyright 2012 World Health Organization. All Rights Reserved.","name":"Copyright"},{"id":"MEASURE_SCORING","code":"MSRSCORE","name":"Measure Scoring"},{"id":"MEASURE_TYPE","code":"MSRTYPE","name":"Measure Type"},{"id":"STRATIFICATION","code":"STRAT","value":"None","name":"Stratification"},{"id":"RISK_ADJUSTMENT","code":"MSRADJ","value":"None","name":"Risk Adjustment"},{"id":"RATE_AGGREGATION","code":"MSRAGG","value":"None","name":"Rate Aggregation"},{"id":"RATIONALE","code":"RAT","value":"Group A streptococcal bacterial infections and other infections that cause pharyngitis (which are most often viral) often produce the same signs and symptoms (IDSA 2002). The American Academy of Pediatrics, the Centers for Disease Control and Prevention, and the Infectious Diseases Society of America all recommend a diagnostic test for Strep A to improve diagnostic accuracy and avoid unnecessary antibiotic treatment (Linder et al. 2005).  A study on antibiotic treatment of children with sore throat found that although only 15 to 36 percent of children with sore throat have Strep A pharyngitis, physicians prescribed antibiotics to 53 percent of children with a chief complaint of sore throat between 1995 and 2003 (Linder et al. 2005).","name":"Rationale"},{"id":"CLINICAL_RECOMMENDATION_STATEMENT","code":"CRS","value":"Institute for Clinical Systems Improvement (ICSI) (2007) \n\nReduce unnecessary use of antibiotics. Antibiotic treatment should be reserved for a bacterial illness. Diagnosis of group A beta streptococcal Pharyngitis should be made by laboratory testing rather than clinically. \n\nInfectious Disease Society of America (Bisno et al. 2002) \n\nThe signs and symptoms of group A streptococcal and other (most frequently viral) pharyngitides overlap broadly. Therefore, unless the physician is able with confidence to exclude the diagnosis of streptococcal pharyngitis on epidemiological and clinical grounds alone, a laboratory test should be done to determine whether group A streptococci are present in the pharynx. \n\nWith the exception of very rare infections by certain other pharyngeal bacterial pathogens (e.g., Corynebacterium diphtheriae and Neisseria gonorrhoeae), antimicrobial therapy is of no proven benefit as treatment for acute pharyngitis due to bacteria other than group A streptococci. Therefore, it is extremely important that physicians exclude the diagnosis of group A streptococcal pharyngitis to prevent inappropriate administration of antimicrobials to large numbers of patients with pharyngitis. \n\nMichigan Quality Improvement Consortium (2007)\n\nProbability of group A beta hemolytic streptococci (GABHS): Low; Testing: None; Treatment: Symptomatic treatment only. Avoid antibiotics. Probability of GABHS: Intermediate or High; Testing: Throat Culture (TC) OR Rapid Screen; Treatment: If TC is positive, use antibiotics. If TC is negative, use symptomatic treatment only. Avoid antibiotics. If treatment is started and culture result is negative, stop antibiotics. If Rapid Screen is positive, use antibiotics. If Rapid Screen is negative, culture (Culture is optional for age 16 and over) and only use antibiotics if throat culture is positive. (Michigan, 2007)","name":"Clinical Recommendation Statement"},{"id":"IMPROVEMENT_NOTATION","code":"IDUR","value":"Higher score indicates better quality","name":"Improvement Notation"},{"id":"NQF_ID_NUMBER","code":"OTH","value":"0002","name":"NQF ID Number"},{"id":"DISCLAIMER","code":"DISC","value":"These performance Measures are not clinical guidelines and do not establish a standard of medical care, and have not been tested for all potential applications.\n\nTHE MEASURES AND SPECIFICATIONS ARE PROVIDED \u201cAS IS\u201d WITHOUT WARRANTY OF ANY KIND.\n\nDue to technical limitations, registered trademarks are indicated by (R) or [R] and unregistered trademarks are indicated by (TM) or [TM].","name":"Disclaimer"},{"id":"EMEASURE_IDENTIFIER","code":"OTH","value":"146","name":"eMeasure Identifier"},{"id":"REFERENCE","code":"REF","value":"Michigan Quality Improvement Consortium. 2007. Acute pharyngitis in children. Southfield: Michigan Quality Improvement Consortium.","name":"Reference"},{"id":"DEFINITION","code":"DEF","value":"None","name":"Definition"},{"id":"GUIDANCE","code":"GUIDE","value":"This is an episode of care measure that examines all eligible episodes for the patient during the measurement period. If the patient has more than one episode, include all episodes in the measure.","name":"Guidance"},{"id":"TRANSMISSION_FORMAT","code":"OTH","value":"TBD","name":"Transmission Format"},{"id":"INITIAL_PATIENT_POPULATION","code":"IPP","value":"Children 2-18 years of age who had an outpatient or emergency department (ED) visit with a diagnosis of pharyngitis during the measurement period and an antibiotic ordered on or three days after the visit","name":"Initial Patient Population"},{"id":"DENOMINATOR","code":"DENOM","value":"Equals Initial Patient Population","name":"Denominator"},{"id":"DENOMINATOR_EXCLUSIONS","code":"OTH","value":"Children who are taking antibiotics in the 30 days prior to the diagnosis of pharyngitis","name":"Denominator Exclusions"},{"id":"NUMERATOR","code":"NUMER","value":"Children with a group A streptococcus test in the 7-day period from 3 days prior through 3 days after the diagnosis of pharyngitis","name":"Numerator"},{"id":"NUMERATOR_EXCLUSIONS","code":"OTH","value":"Not Applicable","name":"Numerator Exclusions"},{"id":"DENOMINATOR_EXCEPTIONS","code":"DENEXCEP","value":"None","name":"Denominator Exceptions"},{"id":"MEASURE_POPULATION","code":"MSRPOPL","value":"Not Applicable","name":"Measure Population"},{"id":"MEASURE_OBSERVATIONS","code":"OTH","value":"Not Applicable","name":"Measure Observations"},{"id":"SUPPLEMENTAL_DATA_ELEMENTS","code":"OTH","value":"For every patient evaluated by this measure also identify payer, race, ethnicity and sex.","name":"Supplemental Data Elements"}],"measure_id":"0002","measure_period":{"type":"IVL_TS","low":{"type":"TS","value":"201201010000","inclusive?":true,"derived?":false},"high":{"type":"TS","value":"201212312359","inclusive?":true,"derived?":false},"width":{"type":"PQ","unit":"a","value":"1","inclusive?":true,"derived?":false}},"needs_finalize":false,"population_criteria":{"DENEX":{"conjunction?":true,"type":"DENEX","title":"Denominator","hqmf_id":"A91EC30F-85E5-4500-9813-055E732F5522","preconditions":[{"id":11,"preconditions":[{"id":9,"reference":"MedicationActiveAntibioticMedications_precondition_9"}],"conjunction_code":"allTrue"}]},"NUMER":{"conjunction?":true,"type":"NUMER","title":"Numerator","hqmf_id":"E872E719-77C6-4064-B1D1-D477125D341D","preconditions":[{"id":18,"preconditions":[{"id":16,"preconditions":[{"id":12,"reference":"LaboratoryTestResultGroupAStreptococcusTest_precondition_12"},{"id":14,"reference":"LaboratoryTestResultGroupAStreptococcusTest_precondition_14"}],"conjunction_code":"atLeastOneTrue"}],"conjunction_code":"allTrue"}]},"DENOM":{"conjunction?":true,"type":"DENOM","title":"Denominator","hqmf_id":"62326696-5654-455A-80A0-D080EEE5BE4C"},"IPP":{"conjunction?":true,"type":"IPP","title":"Initial Patient Population","hqmf_id":"28B96D52-338E-409E-8A92-C82E7769FE03","preconditions":[{"id":45,"preconditions":[{"id":19,"reference":"PatientCharacteristicBirthdateBirthDate_precondition_19"},{"id":21,"reference":"PatientCharacteristicBirthdateBirthDate_precondition_21"},{"id":43,"preconditions":[{"id":23,"reference":"OccurrenceAAmbulatoryEdVisit3_precondition_23"},{"id":25,"reference":"MedicationOrderAntibioticMedications_precondition_25"},{"id":41,"preconditions":[{"id":32,"reference":"OccurrenceAAmbulatoryEdVisit3_precondition_32"},{"id":38,"preconditions":[{"id":34,"reference":"OccurrenceAAcutePharyngitis1_precondition_34"},{"id":36,"reference":"OccurrenceAAcuteTonsillitis2_precondition_36"}],"conjunction_code":"atLeastOneTrue"}],"conjunction_code":"atLeastOneTrue"}],"conjunction_code":"allTrue"}],"conjunction_code":"allTrue"}]}},"populations":[{"IPP":"IPP","DENOM":"DENOM","NUMER":"NUMER","DENEX":"DENEX"}],"preconditions":null,"publish_date":null,"published":null,"source_data_criteria":{"PatientCharacteristicBirthdateBirthDate":{"title":"birth date","description":"Patient Characteristic Birthdate: birth date","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113883.3.560.100.4","property":"birthtime","type":"characteristic","definition":"patient_characteristic_birthdate","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicBirthdateBirthDate","inline_code_list":{"LOINC":["21112-8"]}},"DiagnosisActiveAcutePharyngitis":{"title":"Acute Pharyngitis","description":"Diagnosis, Active: Acute Pharyngitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1011","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"source_data_criteria":"DiagnosisActiveAcutePharyngitis"},"DiagnosisActiveAcuteTonsillitis":{"title":"Acute Tonsillitis","description":"Diagnosis, Active: Acute Tonsillitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1012","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"source_data_criteria":"DiagnosisActiveAcuteTonsillitis"},"MedicationOrderAntibioticMedications":{"title":"Antibiotic Medications","description":"Medication, Order: Antibiotic Medications","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1001","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderAntibioticMedications"},"MedicationActiveAntibioticMedications":{"title":"Antibiotic Medications","description":"Medication, Active: Antibiotic Medications","standard_category":"medication","qds_data_type":"medication_active","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1001","type":"medications","definition":"medication","status":"active","hard_status":false,"negation":false,"source_data_criteria":"MedicationActiveAntibioticMedications"},"LaboratoryTestResultGroupAStreptococcusTest":{"title":"Group A Streptococcus Test","description":"Laboratory Test, Result: Group A Streptococcus Test","standard_category":"laboratory_test","qds_data_type":"laboratory_test","code_list_id":"2.16.840.1.113883.3.464.1003.198.12.1012","type":"laboratory_tests","definition":"laboratory_test","hard_status":false,"negation":false,"source_data_criteria":"LaboratoryTestResultGroupAStreptococcusTest"},"EncounterPerformedAmbulatoryEdVisit":{"title":"Ambulatory/ED Visit","description":"Encounter, Performed: Ambulatory/ED Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1061","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedAmbulatoryEdVisit"},"OccurrenceAAcutePharyngitis1":{"title":"Acute Pharyngitis","description":"Diagnosis, Active: Acute Pharyngitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1011","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_PHARYNGITIS","source_data_criteria":"OccurrenceAAcutePharyngitis1"},"OccurrenceAAcuteTonsillitis2":{"title":"Acute Tonsillitis","description":"Diagnosis, Active: Acute Tonsillitis","standard_category":"diagnosis_condition_problem","qds_data_type":"diagnosis_active","code_list_id":"2.16.840.1.113883.3.464.1003.102.12.1012","type":"conditions","definition":"diagnosis","status":"active","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"DIAGNOSIS_ACTIVE_ACUTE_TONSILLITIS","source_data_criteria":"OccurrenceAAcuteTonsillitis2"},"OccurrenceAAmbulatoryEdVisit3":{"title":"Ambulatory/ED Visit","description":"Encounter, Performed: Ambulatory/ED Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1061","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"specific_occurrence":"A","specific_occurrence_const":"ENCOUNTER_PERFORMED_AMBULATORY_ED_VISIT","source_data_criteria":"OccurrenceAAmbulatoryEdVisit3"},"PatientCharacteristicSexOncAdministrativeSex":{"title":"ONC Administrative Sex","description":"Patient Characteristic Sex: ONC Administrative Sex","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113762.1.4.1","property":"gender","type":"characteristic","definition":"patient_characteristic_gender","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicSexOncAdministrativeSex","value":{"type":"CD","system":"Administrative Sex","code":"F"}},"PatientCharacteristicRaceRace":{"title":"Race","description":"Patient Characteristic Race: Race","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.836","property":"race","type":"characteristic","definition":"patient_characteristic_race","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicRaceRace","inline_code_list":{"CDC Race":["1002-5","2028-9","2054-5","2076-8","2106-3","2131-1"]}},"PatientCharacteristicEthnicityEthnicity":{"title":"Ethnicity","description":"Patient Characteristic Ethnicity: Ethnicity","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.837","property":"ethnicity","type":"characteristic","definition":"patient_characteristic_ethnicity","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicEthnicityEthnicity","inline_code_list":{"CDC Race":["2135-2","2186-5"]}},"PatientCharacteristicPayerPayer":{"title":"Payer","description":"Patient Characteristic Payer: Payer","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.3591","property":"payer","type":"characteristic","definition":"patient_characteristic_payer","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicPayerPayer","inline_code_list":{"SOP":["1","11","111","112","113","119","12","121","122","123","129","19","2","21","211","212","213","219","22","23","24","25","29","3","31","311","3111","3112","3113","3114","3115","3116","3119","312","3121","3122","3123","313","32","321","3211","3212","32121","32122","32123","32124","32125","32126","322","3221","3222","3223","3229","33","331","332","333","334","34","341","342","343","349","35","36","361","362","369","37","371","3711","3712","3713","372","379","38","381","3811","3812","3813","3819","382","389","39","4","41","42","43","44","5","51","511","512","513","514","515","519","52","521","522","523","529","53","54","55","59","6","61","611","612","613","619","62","63","64","69","7","71","72","73","79","8","81","82","821","822","823","83","84","85","89","9","91","92","93","94","95","951","953","954","959","96","98","99","9999"]}}},"steward":null,"title":"Appropriate Testing for Children with Pharyngitis","type":"ep","updated_at":"2013-10-28T16:14:52Z","user_id":"501fdba3044a111b98000001","value_set_oids":["2.16.840.1.113883.3.464.1003.102.12.1011","2.16.840.1.113883.3.464.1003.102.12.1012","2.16.840.1.113883.3.464.1003.101.12.1061","2.16.840.1.113762.1.4.1","2.16.840.1.114222.4.11.836","2.16.840.1.114222.4.11.837","2.16.840.1.114222.4.11.3591","2.16.840.1.113883.3.464.1003.196.12.1001","2.16.840.1.113883.3.464.1003.198.12.1012","2.16.840.1.113883.3.560.100.4"],"version":null}, {parse: true});


    (function() {

      var population = measure.get('populations').findWhere({ index: 0 });

      population.calculate = function(patient) {

        if (patient.toJSON != null) {
          patient = patient.toJSON();
        }

        var enable_logging = !!this.enable_logging;
        var enable_rationale = !!this.enable_rationale;
        ObjectId = function() { return 1; };
        var result = null; // Calls to emit() set this local variable
        emit = function(id, value) { result = value; };
        var print = function(output) { console.log(output); };

        
        var patient_api = new hQuery.Patient(patient);

        
        // #########################
        // ##### DATA ELEMENTS #####
        // #########################

        hqmfjs.nqf_id = '0002';
        hqmfjs.hqmf_id = '40280381-3D61-56A7-013E-5D1EF9B76A48';
        hqmfjs.sub_id = null;
        if (typeof(test_id) == 'undefined') hqmfjs.test_id = null;

        OidDictionary = {'2.16.840.1.114222.4.11.837':{'CDC Race':['2135-2','2186-5']},'2.16.840.1.114222.4.11.836':{'CDC Race':['1002-5','2028-9','2054-5','2076-8','2106-3','2131-1']},'2.16.840.1.114222.4.11.3591':{'SOP':['1','11','111','112','113','119','12','121','122','123','129','19','2','21','211','212','213','219','22','23','24','25','29','3','31','311','3111','3112','3113','3114','3115','3116','3119','312','3121','3122','3123','313','32','321','3211','3212','32121','32122','32123','32124','32125','32126','322','3221','3222','3223','3229','33','331','332','333','334','34','341','342','343','349','35','36','361','362','369','37','371','3711','3712','3713','372','379','38','381','3811','3812','3813','3819','382','389','39','4','41','42','43','44','5','51','511','512','513','514','515','519','52','521','522','523','529','53','54','55','59','6','61','611','612','613','619','62','63','64','69','7','71','72','73','79','8','81','82','821','822','823','83','84','85','89','9','91','92','93','94','95','951','953','954','959','96','98','99','9999']},'2.16.840.1.113883.3.560.100.4':{'LOINC':['21112-8']},'2.16.840.1.113883.3.464.1003.198.12.1012':{'LOINC':['11268-0','17656-0','18481-2','31971-5','49610-9','5036-9','60489-2','626-2','6556-5','6557-3','6558-1','6559-9','68954-7']},'2.16.840.1.113883.3.464.1003.196.12.1001':{'RxNorm':['1013659','1013662','1013665','1043022','1043027','1043030','1043464','105152','105170','105171','108449','1113012','1114491','1148107','1302650','1302664','1302674','141962','141963','142118','197449','197450','197451','197452','197453','197454','197511','197512','197516','197517','197518','197595','197596','197633','197650','197736','197898','197899','197984','197985','198044','198048','198049','198050','198201','198202','198228','198250','198252','198332','198334','198335','198395','198396','199026','199027','199055','199326','199327','199332','199370','199620','199802','199884','199885','199886','199997','200346','204466','204844','204871','204929','204931','205964','207362','207364','207390','207391','226633','239186','239189','239190','239191','239200','239204','239209','239210','239211','239212','240447','240637','240639','240741','240984','242800','242807','242816','242825','245242','246282','247673','248656','250347','250582','259290','259311','283535','284215','308177','308181','308182','308188','308189','308191','308192','308194','308207','308208','308210','308212','308459','308460','308461','308466','308467','308468','309040','309042','309043','309044','309045','309047','309048','309049','309051','309052','309053','309054','309055','309056','309057','309058','309065','309066','309067','309068','309069','309070','309071','309072','309074','309075','309076','309078','309079','309080','309081','309082','309083','309084','309085','309086','309087','309090','309091','309092','309093','309095','309096','309097','309098','309099','309100','309101','309110','309111','309112','309113','309114','309115','309175','309304','309308','309309','309310','309322','309329','309335','309336','309339','309860','310026','310027','310028','310029','310030','310151','310154','310155','310156','310157','310160','310163','310165','310472','310473','310474','310475','310476','310477','311214','311215','311296','311341','311342','311345','311346','311347','311364','311370','311371','311681','311683','311787','311895','311896','311897','311898','311899','311988','311989','311992','311994','311995','312127','312128','312130','312443','312444','312446','312447','312821','313115','313133','313134','313135','313137','313251','313252','313253','313254','313401','313402','313416','313570','313571','313572','313574','313797','313799','313800','313819','313850','313888','313890','313920','313922','313925','313926','313929','313996','314079','314106','314108','315090','315209','315219','317127','318218','342904','343049','348719','348869','348870','351121','351127','351156','351239','359383','359385','359465','388510','389025','403840','403920','403921','403945','406524','406696','413716','415059','415868','415869','419849','434018','476193','476299','476322','476325','476327','476576','476623','477391','486912','487129','562058','562251','562253','562266','562508','562707','577378','597194','597298','597455','597761','597808','597823','598006','598025','617296','617302','617304','617309','617316','617322','617423','617430','617993','617995','623677','623695','629695','629697','629699','636559','637173','637560','644541','645617','686354','686355','686383','686400','686405','686406','686418','686447','700408','728207','731538','731560','731564','731567','731570','731572','731575','745047','745053','745276','745278','745280','745282','745302','745303','745462','745519','745560','745561','745585','749780','749783','756189','756192','757460','757464','757466','761979','762666','762893','789980','796301','796484','796486','796488','796490','796492','799048','802550','808917','835341','835700','836306','847360','852868','858062','858372','860441','861416','863538','877486','895915','895924','901610','904288','905143','905148','993109','997632','997656','997665','997999','998004','998239','998241','998756']},'2.16.840.1.113883.3.464.1003.102.12.1012':{'SNOMED-CT':['17741008','195666007','195667003','195668008','195669000','195670004','195671000','195672007','195673002','195676005','195677001','302911003'],'ICD-9-CM':['463'],'ICD-10-CM':['J03.80','J03.81','J03.90','J03.91']},'2.16.840.1.113883.3.464.1003.102.12.1011':{'ICD-9-CM':['034.0','462'],'SNOMED-CT':['1532007','195655000','195656004','195657008','195658003','195659006','195660001','195662009','232399005','232400003','363746003','40766000','43878008','55355000','58031004'],'ICD-10-CM':['J02.8','J02.9']},'2.16.840.1.113883.3.464.1003.101.12.1061':{'SNOMED-CT':['12843005','18170008','185349003','185463005','185465003','19681004','207195004','270427003','270430005','308335008','390906007','406547006','439708006','4525004','87790002','90526000'],'CPT':['99201','99202','99203','99204','99205','99212','99213','99214','99215','99218','99219','99220','99281','99282','99283','99284','99285','99381','99382','99383','99384','99385','99386','99387','99391','99392','99393','99394','99395','99396','99397']},'2.16.840.1.113762.1.4.1':{'AdministrativeSex':['F','M','U']}};
        
        // Measure variables
var MeasurePeriod = {
  "low": new TS("201201010000", null, true),
  "high": new TS("201212312359", null, true)
}
hqmfjs.MeasurePeriod = function(patient) {
  return [new hQuery.CodedEntry(
    {
      "start_time": MeasurePeriod.low.asDate().getTime()/1000,
      "end_time": MeasurePeriod.high.asDate().getTime()/1000,
      "codes": {}
    }
  )];
}
if (typeof effective_date === 'number') {
  MeasurePeriod.high.date = new Date(1000*effective_date);
  // add one minute before pulling off the year.  This turns 12-31-2012 23:59 into 1-1-2013 00:00 => 1-1-2012 00:00
  MeasurePeriod.low.date = new Date(1000*(effective_date+60));
  MeasurePeriod.low.date.setFullYear(MeasurePeriod.low.date.getFullYear()-1);
}

// Data critera
hqmfjs.OccurrenceAAcutePharyngitis1 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1011", "specificOccurrence": "OccurrenceAAcutePharyngitis1"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.OccurrenceAAcuteTonsillitis2 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1012", "specificOccurrence": "OccurrenceAAcuteTonsillitis2"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.OccurrenceAAmbulatoryEdVisit3 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1061", "specificOccurrence": "OccurrenceAAmbulatoryEdVisit3"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.DiagnosisActiveAcutePharyngitis = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1011"};
  var events = patient.getEvents(eventCriteria);
  hqmf.SpecificsManager.setIfNull(events);
  return events;
}

hqmfjs.DiagnosisActiveAcuteTonsillitis = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1012"};
  var events = patient.getEvents(eventCriteria);
  hqmf.SpecificsManager.setIfNull(events);
  return events;
}

hqmfjs.EncounterPerformedAmbulatoryEdVisit = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1061"};
  var events = patient.getEvents(eventCriteria);
  hqmf.SpecificsManager.setIfNull(events);
  return events;
}

hqmfjs.OccurrenceAAmbulatoryEdVisit3 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1061", "specificOccurrence": "OccurrenceAAmbulatoryEdVisit3"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.PatientCharacteristicSexOncAdministrativeSex = function(patient, initialSpecificContext) {
  var value = patient.gender() || null;
  matching = matchingValue(value, new CD("F", "Administrative Sex"));
  matching.specificContext=hqmf.SpecificsManager.identity();
  return matching;
}

hqmfjs.PatientCharacteristicRaceRace = function(patient, initialSpecificContext) {
  var value = patient.race() || null;
  matching = matchingValue(value, null);
  matching.specificContext=hqmf.SpecificsManager.identity();
  return matching;
}

hqmfjs.PatientCharacteristicEthnicityEthnicity = function(patient, initialSpecificContext) {
  var value = patient.ethnicity() || null;
  matching = matchingValue(value, null);
  matching.specificContext=hqmf.SpecificsManager.identity();
  return matching;
}

hqmfjs.PatientCharacteristicPayerPayer = function(patient, initialSpecificContext) {
  var value = patient.payer() || null;
  matching = matchingValue(value, null);
  matching.specificContext=hqmf.SpecificsManager.identity();
  return matching;
}

hqmfjs.OccurrenceAAcutePharyngitis1_precondition_4 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1011", "specificOccurrence": "OccurrenceAAcutePharyngitis1"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.OccurrenceAAcuteTonsillitis2_precondition_6 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1012", "specificOccurrence": "OccurrenceAAcuteTonsillitis2"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.MedicationActiveAntibioticMedications_precondition_9 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1001"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = SBS(events, hqmfjs.GROUP_SBS_CHILDREN_47(patient), new IVL_PQ(null, new PQ(30, "d", true)));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.GROUP_SBS_CHILDREN_47 = function(patient, initialSpecificContext) {
  var events = UNION(
    hqmfjs.OccurrenceAAcutePharyngitis1_precondition_4(patient, initialSpecificContext),
    hqmfjs.OccurrenceAAcuteTonsillitis2_precondition_6(patient, initialSpecificContext)
  );

  hqmf.SpecificsManager.setIfNull(events);
  return events;
}

hqmfjs.LaboratoryTestResultGroupAStreptococcusTest_precondition_12 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "laboratoryTests", "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.198.12.1012"};
  var events = patient.getEvents(eventCriteria);
  events = filterEventsByValue(events, new ANYNonNull());
  if (events.length > 0) events = SBE(events, hqmfjs.OccurrenceAAmbulatoryEdVisit3(patient), new IVL_PQ(null, new PQ(3, "d", true)));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.LaboratoryTestResultGroupAStreptococcusTest_precondition_14 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "laboratoryTests", "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.198.12.1012"};
  var events = patient.getEvents(eventCriteria);
  events = filterEventsByValue(events, new ANYNonNull());
  if (events.length > 0) events = SAE(events, hqmfjs.OccurrenceAAmbulatoryEdVisit3(patient), new IVL_PQ(null, new PQ(3, "d", true)));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_19 = function(patient, initialSpecificContext) {
  var value = patient.birthtime() || null;
  var events = [value];
  events = SBS(events, hqmfjs.MeasurePeriod(patient), new IVL_PQ(new PQ(2, "a", true), null));
  events.specificContext=hqmf.SpecificsManager.identity();
  return events;
}

hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_21 = function(patient, initialSpecificContext) {
  var value = patient.birthtime() || null;
  var events = [value];
  events = SBS(events, hqmfjs.MeasurePeriod(patient), new IVL_PQ(null, new PQ(18, "a", false)));
  events.specificContext=hqmf.SpecificsManager.identity();
  return events;
}

hqmfjs.OccurrenceAAmbulatoryEdVisit3_precondition_23 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1061", "specificOccurrence": "OccurrenceAAmbulatoryEdVisit3"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.MedicationOrderAntibioticMedications_precondition_25 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1001"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = SAS(events, hqmfjs.OccurrenceAAmbulatoryEdVisit3(patient), new IVL_PQ(null, new PQ(3, "d", true)));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.OccurrenceAAcutePharyngitis1_precondition_27 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1011", "specificOccurrence": "OccurrenceAAcutePharyngitis1"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.OccurrenceAAcuteTonsillitis2_precondition_29 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1012", "specificOccurrence": "OccurrenceAAcuteTonsillitis2"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.OccurrenceAAmbulatoryEdVisit3_precondition_32 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1061", "specificOccurrence": "OccurrenceAAmbulatoryEdVisit3"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.GROUP_DURING_CHILDREN_49(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.GROUP_DURING_CHILDREN_49 = function(patient, initialSpecificContext) {
  var events = UNION(
    hqmfjs.OccurrenceAAcutePharyngitis1_precondition_27(patient, initialSpecificContext),
    hqmfjs.OccurrenceAAcuteTonsillitis2_precondition_29(patient, initialSpecificContext)
  );

  hqmf.SpecificsManager.setIfNull(events);
  return events;
}

hqmfjs.OccurrenceAAmbulatoryEdVisit3_precondition_39 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1061", "specificOccurrence": "OccurrenceAAmbulatoryEdVisit3"};
  var events = patient.getEvents(eventCriteria);
  events.specificContext=new hqmf.SpecificOccurrence(Row.buildForDataCriteria(events.specific_occurrence, events))
  return events;
}

hqmfjs.OccurrenceAAcutePharyngitis1_precondition_34 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1011", "specificOccurrence": "OccurrenceAAcutePharyngitis1"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = SDU(events, hqmfjs.OccurrenceAAmbulatoryEdVisit3_precondition_39(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.OccurrenceAAcuteTonsillitis2_precondition_36 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allProblems", "statuses": ["active"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.102.12.1012", "specificOccurrence": "OccurrenceAAcuteTonsillitis2"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = SDU(events, hqmfjs.OccurrenceAAmbulatoryEdVisit3_precondition_39(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}



        // #########################
        // ##### MEASURE LOGIC #####
        // #########################
        
        hqmfjs.initializeSpecifics = function(patient_api, hqmfjs) { hqmf.SpecificsManager.initialize(patient_api,hqmfjs,{"id":"OccurrenceAAcutePharyngitis1","type":"DIAGNOSIS_ACTIVE_ACUTE_PHARYNGITIS","function":"OccurrenceAAcutePharyngitis1"},{"id":"OccurrenceAAcuteTonsillitis2","type":"DIAGNOSIS_ACTIVE_ACUTE_TONSILLITIS","function":"OccurrenceAAcuteTonsillitis2"},{"id":"OccurrenceAAmbulatoryEdVisit3","type":"ENCOUNTER_PERFORMED_AMBULATORY_ED_VISIT","function":"OccurrenceAAmbulatoryEdVisit3"}) }

        // INITIAL PATIENT POPULATION
        hqmfjs.IPP = function(patient, initialSpecificContext) {
  return allTrue('IPP', patient, initialSpecificContext,
    allTrue('45', patient, initialSpecificContext, hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_19, hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_21,
      allTrue('43', patient, initialSpecificContext, hqmfjs.OccurrenceAAmbulatoryEdVisit3_precondition_23, hqmfjs.MedicationOrderAntibioticMedications_precondition_25,
        atLeastOneTrue('41', patient, initialSpecificContext, hqmfjs.OccurrenceAAmbulatoryEdVisit3_precondition_32,
          atLeastOneTrue('38', patient, initialSpecificContext, hqmfjs.OccurrenceAAcutePharyngitis1_precondition_34, hqmfjs.OccurrenceAAcuteTonsillitis2_precondition_36
          )
        )
      )
    )
  )();
};


        // DENOMINATOR
        hqmfjs.DENOM = function(patient) { return new Boolean(true); }
        // NUMERATOR
        hqmfjs.NUMER = function(patient, initialSpecificContext) {
  return allTrue('NUMER', patient, initialSpecificContext,
    allTrue('18', patient, initialSpecificContext,
      atLeastOneTrue('16', patient, initialSpecificContext, hqmfjs.LaboratoryTestResultGroupAStreptococcusTest_precondition_12, hqmfjs.LaboratoryTestResultGroupAStreptococcusTest_precondition_14
      )
    )
  )();
};


        hqmfjs.DENEX = function(patient, initialSpecificContext) {
  return atLeastOneTrue('DENEX', patient, initialSpecificContext,
    allTrue('11', patient, initialSpecificContext, hqmfjs.MedicationActiveAntibioticMedications_precondition_9
    )
  )();
};


        hqmfjs.DENEXCEP = function(patient) { return new Boolean(false); }
        // CV
        hqmfjs.MSRPOPL = function(patient) { return new Boolean(false); }
        hqmfjs.OBSERV = function(patient) { return new Boolean(false); }
        
        
        var occurrenceId = null;

        hqmfjs.initializeSpecifics(patient_api, hqmfjs)
        
        var population = function() {
          return executeIfAvailable(hqmfjs.IPP, patient_api);
        }
        var denominator = function() {
          return executeIfAvailable(hqmfjs.DENOM, patient_api);
        }
        var numerator = function() {
          return executeIfAvailable(hqmfjs.NUMER, patient_api);
        }
        var exclusion = function() {
          return executeIfAvailable(hqmfjs.DENEX, patient_api);
        }
        var denexcep = function() {
          return executeIfAvailable(hqmfjs.DENEXCEP, patient_api);
        }
        var msrpopl = function() {
          return executeIfAvailable(hqmfjs.MSRPOPL, patient_api);
        }
        var observ = function(specific_context) {
          
          var observFunc = hqmfjs.OBSERV
          if (typeof(observFunc)==='function')
            return observFunc(patient_api, specific_context);
          else
            return [];
        }
        
        var executeIfAvailable = function(optionalFunction, patient_api) {
          if (typeof(optionalFunction)==='function') {
            result = optionalFunction(patient_api);
            
            return result;
          } else {
            return false;
          }
        }

        
        if (typeof Logger != 'undefined') {
          // clear out logger
          Logger.logger = [];
          Logger.rationale={};
        
          // turn on logging if it is enabled
          if (enable_logging || enable_rationale) {
            injectLogger(hqmfjs, enable_logging, enable_rationale);
          }
        }

        try {
          map(patient, population, denominator, numerator, exclusion, denexcep, msrpopl, observ, occurrenceId,false);
        } catch(err) {
          print(err.stack);
          throw err;
        }

        

        delete ObjectId;
        delete emit;

        return result;
      };
    })();


  window.Fixtures.Measures.add(measure);

})();
