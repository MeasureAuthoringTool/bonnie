// This fixture was created by taking the JS file for measure 0022,
// defining the global fixture variables (if necessary), and changing
// the last line of each measure section (two places, since this
// measure has two distinct populations/subids) place the measure into
// the fixtures instead of the bonnie router

window.Fixtures || (window.Fixtures = {});
window.Fixtures.Measures || (window.Fixtures.Measures = new Thorax.Collections.Measures());

  (function() {
    var measure = new Thorax.Models.Measure({"_id":"40280381-3D61-56A7-013E-65C9C3043E54","category":"Core","cms_id":"CMS156v2","continuous_variable":false,"created_at":null,"custom_functions":null,"data_criteria":{"PatientCharacteristicSexOncAdministrativeSex":{"title":"ONC Administrative Sex","description":"Patient Characteristic Sex: ONC Administrative Sex","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113762.1.4.1","property":"gender","type":"characteristic","definition":"patient_characteristic_gender","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicSexOncAdministrativeSex","value":{"type":"CD","system":"Administrative Sex","code":"F"}},"PatientCharacteristicRaceRace":{"title":"Race","description":"Patient Characteristic Race: Race","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.836","property":"race","type":"characteristic","definition":"patient_characteristic_race","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicRaceRace","inline_code_list":{"CDC Race":["1002-5","2028-9","2054-5","2076-8","2106-3","2131-1"]}},"PatientCharacteristicEthnicityEthnicity":{"title":"Ethnicity","description":"Patient Characteristic Ethnicity: Ethnicity","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.837","property":"ethnicity","type":"characteristic","definition":"patient_characteristic_ethnicity","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicEthnicityEthnicity","inline_code_list":{"CDC Race":["2135-2","2186-5"]}},"PatientCharacteristicPayerPayer":{"title":"Payer","description":"Patient Characteristic Payer: Payer","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.3591","property":"payer","type":"characteristic","definition":"patient_characteristic_payer","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicPayerPayer","inline_code_list":{"SOP":["1","11","111","112","113","119","12","121","122","123","129","19","2","21","211","212","213","219","22","23","24","25","29","3","31","311","3111","3112","3113","3114","3115","3116","3119","312","3121","3122","3123","313","32","321","3211","3212","32121","32122","32123","32124","32125","32126","322","3221","3222","3223","3229","33","331","332","333","334","34","341","342","343","349","35","36","361","362","369","37","371","3711","3712","3713","372","379","38","381","3811","3812","3813","3819","382","389","39","4","41","42","43","44","5","51","511","512","513","514","515","519","52","521","522","523","529","53","54","55","59","6","61","611","612","613","619","62","63","64","69","7","71","72","73","79","8","81","82","821","822","823","83","84","85","89","9","91","92","93","94","95","951","953","954","959","96","98","99","9999"]}},"MedicationOrderHighRiskMedicationsForTheElderly_precondition_1":{"title":"High Risk Medications for the Elderly","description":"Medication, Order: High Risk Medications for the Elderly","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1253","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsForTheElderly","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_3":{"title":"High-Risk Medications With Days Supply Criteria","description":"Medication, Order: High-Risk Medications With Days Supply Criteria","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1254","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria","field_values":{"CUMULATIVE_MEDICATION_DURATION":{"type":"IVL_PQ","low":{"type":"PQ","unit":"d","value":"90","inclusive?":false,"derived?":false}}},"temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"MedicationOrderHighRiskMedicationsForTheElderly_precondition_8":{"title":"High Risk Medications for the Elderly","description":"Medication, Order: High Risk Medications for the Elderly","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1253","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsForTheElderly","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10":{"title":"High-Risk Medications With Days Supply Criteria","description":"Medication, Order: High-Risk Medications With Days Supply Criteria","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1254","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria","field_values":{"CUMULATIVE_MEDICATION_DURATION":{"type":"IVL_PQ","low":{"type":"PQ","unit":"d","value":"90","inclusive?":false,"derived?":false}}},"temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"GROUP_COUNT_34":{"title":"GROUP_COUNT_34","description":"","standard_category":"","qds_data_type":"","children_criteria":["MedicationOrderHighRiskMedicationsForTheElderly_precondition_8","MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10"],"derivation_operator":"UNION","type":"derived","definition":"derived","hard_status":false,"negation":false,"source_data_criteria":"GROUP_COUNT_34","subset_operators":[{"type":"COUNT","value":{"type":"IVL_PQ","low":{"type":"PQ","value":"2","inclusive?":true,"derived?":false}}}]},"PatientCharacteristicBirthdateBirthDate_precondition_16":{"title":"birth date","description":"Patient Characteristic Birthdate: birth date","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113883.3.560.100.4","property":"birthtime","type":"characteristic","definition":"patient_characteristic_birthdate","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicBirthdateBirthDate","inline_code_list":{"LOINC":["21112-8"]},"temporal_references":[{"type":"SBS","reference":"MeasurePeriod","range":{"type":"IVL_PQ","low":{"type":"PQ","unit":"a","value":"66","inclusive?":true,"derived?":false}}}]},"EncounterPerformedOfficeVisit_precondition_18":{"title":"Office Visit","description":"Encounter, Performed: Office Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1001","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedOfficeVisit","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedFaceToFaceInteraction_precondition_20":{"title":"Face-to-Face Interaction","description":"Encounter, Performed: Face-to-Face Interaction","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1048","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedFaceToFaceInteraction","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22":{"title":"Preventive Care Services - Established Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services - Established Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1025","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24":{"title":"Preventive Care Services-Initial Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services-Initial Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1023","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedAnnualWellnessVisit_precondition_26":{"title":"Annual Wellness Visit","description":"Encounter, Performed: Annual Wellness Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.526.3.1240","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedAnnualWellnessVisit","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedHomeHealthcareServices_precondition_28":{"title":"Home Healthcare Services","description":"Encounter, Performed: Home Healthcare Services","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1016","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedHomeHealthcareServices","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]}},"description":"Percentage of patients 66 years of age and older who were ordered high-risk medications. Two rates are reported.\na. Percentage of patients who were ordered at least one high-risk medication. \nb. Percentage of patients who were ordered at least two different high-risk medications.","endorser":null,"episode_ids":null,"episode_of_care":false,"force_sources":null,"hqmf_id":"40280381-3D61-56A7-013E-65C9C3043E54","hqmf_set_id":"A3837FF8-1ABC-4BA9-800E-FD4E7953ADBD","hqmf_version_number":2,"id":"0022a","measure_attributes":[{"id":"COPYRIGHT","code":"COPY","value":"Physician Performance Measure (Measures) and related data specifications were developed by the National Committee for Quality Assurance (NCQA). \n\nThe Measures are copyrighted but can be reproduced and distributed, without modification, for noncommercial purposes (e.g., use by healthcare providers in connection with their practices). Commercial use is defined as the sale, licensing, or distribution of the Measures for commercial gain, or incorporation of the Measures into a product or service that is sold, licensed or distributed for commercial gain. Commercial use of the Measures requires a license agreement between the user and NCQA. NCQA is not responsible for any use of the Measures. \n\n(c) 2008-2013 National Committee for Quality Assurance. All Rights Reserved. \n\nLimited proprietary coding is contained in the Measure specifications for user convenience. Users of proprietary code sets should obtain all necessary licenses from the owners of the code sets.  NCQA disclaims all liability for use or accuracy of any CPT or other codes contained in the specifications.\n\nCPT(R) contained in the Measure specifications is copyright 2004-2012 American Medical Association. LOINC(R) copyright 2004-2012 Regenstrief Institute, Inc. This material contains SNOMED Clinical Terms(R) (SNOMED CT[R]) copyright 2004-2012 International Health Terminology Standards Development Organisation. ICD-10 copyright 2012 World Health Organization. All Rights Reserved.","name":"Copyright"},{"id":"MEASURE_SCORING","code":"MSRSCORE","name":"Measure Scoring"},{"id":"MEASURE_TYPE","code":"MSRTYPE","name":"Measure Type"},{"id":"STRATIFICATION","code":"STRAT","value":"None","name":"Stratification"},{"id":"RISK_ADJUSTMENT","code":"MSRADJ","value":"None","name":"Risk Adjustment"},{"id":"RATE_AGGREGATION","code":"MSRAGG","value":"None","name":"Rate Aggregation"},{"id":"RATIONALE","code":"RAT","value":"Seniors receiving inappropriate medications are more likely to report poorer health status at follow-up, compared to seniors who receive appropriate medications (Fu, Liu, and Christensen 2004). In 2005, rates of potentially inappropriate medication use in the elderly were as large or larger than in a 1996 national sample, highlighting the need for progress in this area (Simon et al. 2005). While some adverse drug events are not preventable, studies estimate that between 30 and 80 percent of adverse drug events in the elderly are preventable (MacKinnon and Hepler 2003).\n\nReducing the number of inappropriate prescriptions can lead to improved patient safety and significant cost savings.  Conservative estimates of extra costs due to potentially inappropriate medications in the elderly average $7.2 billion a year (Fu, Liu, and Christensen 2004). Medication use by older adults will likely increase further as the U.S. population ages, new drugs are developed, and new therapeutic and preventive uses for medications are discovered (Rothberg et al. 2008). By the year 2030, nearly one in five U.S. residents is expected to be aged 65 years or older; this age group is projected to more than double in number from 38.7 million in 2008 to more than 88.5 million in 2050.  Likewise, the population aged 85 years or older is expected to increase almost four-fold, from 5.4 million to 19 million between 2008 and 2050.  As the elderly population continues to grow, the number of older adults who present with multiple medical conditions for which several medications are prescribed continues to increase, resulting in polypharmacy (Gray and Gardner 2009).","name":"Rationale"},{"id":"CLINICAL_RECOMMENDATION_STATEMENT","code":"CRS","value":"The measure is based on the literature and key clinical expert consensus processes by Beers in 1997, Zahn in 2001 and an updated process by Fick in 2003, which identified drugs of concern in the elderly based on various high-risk criteria. NCQA's Medication Management expert panel selected a subset of drugs that should be used with caution in the elderly for inclusion in the proposed measure based upon these two lists.  NCQA analyzed the prevalence of drugs prescribed according to the Beers and Zhan classifications and determined that drugs identified by Zhan that are classified as never or rarely appropriate would form the basis for the list (Fick 2003).\n\n\nCertain medications (MacKinnon 2003) are associated with increased risk of harms from drug side-effects and drug toxicity and pose a concern for patient safety. There is clinical consensus that these drugs pose increased risks in the elderly (Kaufman 2005). Studies link prescription drug use by the elderly with adverse drug events that contribute to hospitalization, increased length of hospital stay, increased duration of illness, nursing home placement and falls and fractures that are further associated with physical, functional and social decline in the elderly (AHRQ 2009).","name":"Clinical Recommendation Statement"},{"id":"IMPROVEMENT_NOTATION","code":"IDUR","value":"Lower score indicates better quality","name":"Improvement Notation"},{"id":"NQF_ID_NUMBER","code":"OTH","value":"0022","name":"NQF ID Number"},{"id":"DISCLAIMER","code":"DISC","value":"These performance Measures are not clinical guidelines and do not establish a standard of medical care, and have not been tested for all potential applications.\n\nTHE MEASURES AND SPECIFICATIONS ARE PROVIDED \u201cAS IS\u201d WITHOUT WARRANTY OF ANY KIND.\n\nDue to technical limitations, registered trademarks are indicated by (R) or [R] and unregistered trademarks are indicated by (TM) or [TM].","name":"Disclaimer"},{"id":"EMEASURE_IDENTIFIER","code":"OTH","value":"156","name":"eMeasure Identifier"},{"id":"REFERENCE","code":"REF","value":"Rothberg, M.B., P.S. Perkow, F. Liu, B. Korc-Grodzicki, M.J. Brennan, S. Bellantonio, M. Heelon, P.K. Lindenauer. 2008. \u201cPotentially Inappropriate Medication Use in Hospitalized Elders.\u201d J Hosp Med 3:91-102.","name":"Reference"},{"id":"DEFINITION","code":"DEF","value":"A high-risk medication is identified by either of the following:\n     a.\t A prescription for medications classified as high risk at any dose and for any duration\n     b. Prescriptions for medications classified as high risk at any dose with greater than a 90 day supply","name":"Definition"},{"id":"GUIDANCE","code":"GUIDE","value":"The intent of Numerator 1 of the measure is to assess if the patient has been prescribed one high-risk medication.  The intent of Numerator 2 of the measure is to assess if the patient has been prescribed at least two different high-risk medications.\n\nCUMULATIVE MEDICATION DURATION is an individual\u2019s total number of medication days over a specific period; the period counts multiple prescriptions with gaps in between, but does not count the gaps during which a medication was not dispensed.\n \nTo determine the cumulative medication duration, determine first the number of the Medication Days for each prescription in the period: the number of doses divided by the dose frequency per day. Then add the Medication Days for each prescription without counting any days between the prescriptions.\n\nFor example, there is an original prescription for 30 days with 2 refills for thirty days each. After a gap of 3 months, the medication was prescribed again for 60 days with 1 refill for 60 days. The cumulative medication duration is (30 x 3) + (60 x 2) = 210 days over the 10 month period.","name":"Guidance"},{"id":"TRANSMISSION_FORMAT","code":"OTH","value":"TBD","name":"Transmission Format"},{"id":"INITIAL_PATIENT_POPULATION","code":"IPP","value":"Patients 66 years and older who had a visit during the measurement period","name":"Initial Patient Population"},{"id":"DENOMINATOR","code":"DENOM","value":"Equals initial patient population","name":"Denominator"},{"id":"DENOMINATOR_EXCLUSIONS","code":"OTH","value":"None","name":"Denominator Exclusions"},{"id":"NUMERATOR","code":"NUMER","value":"Numerator 1: Patients with an order for at least one high-risk medication during the measurement period. \nNumerator 2: Patients with an order for at least two different high-risk medications during the measurement period.","name":"Numerator"},{"id":"NUMERATOR_EXCLUSIONS","code":"OTH","value":"Not applicable","name":"Numerator Exclusions"},{"id":"DENOMINATOR_EXCEPTIONS","code":"DENEXCEP","value":"None","name":"Denominator Exceptions"},{"id":"MEASURE_POPULATION","code":"MSRPOPL","value":"Not applicable","name":"Measure Population"},{"id":"MEASURE_OBSERVATIONS","code":"OTH","value":"Not applicable","name":"Measure Observations"},{"id":"SUPPLEMENTAL_DATA_ELEMENTS","code":"OTH","value":"For every patient evaluated by this measure also identify payer, race, ethnicity and sex.","name":"Supplemental Data Elements"}],"measure_id":"0022","measure_period":{"type":"IVL_TS","low":{"type":"TS","value":"201201010000","inclusive?":true,"derived?":false},"high":{"type":"TS","value":"201212312359","inclusive?":true,"derived?":false},"width":{"type":"PQ","unit":"a","value":"1","inclusive?":true,"derived?":false}},"population_criteria":{"NUMER":{"conjunction?":true,"type":"NUMER","title":"Numerator","hqmf_id":"4C09A356-D793-487E-BD27-1031D9BF35B7","preconditions":[{"id":7,"preconditions":[{"id":5,"preconditions":[{"id":1,"reference":"MedicationOrderHighRiskMedicationsForTheElderly_precondition_1"},{"id":3,"reference":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_3"}],"conjunction_code":"atLeastOneTrue"}],"conjunction_code":"allTrue"}]},"NUMER_1":{"conjunction?":true,"type":"NUMER","title":"Numerator","hqmf_id":"F9870989-EC28-4523-934A-544F19C34ED1","preconditions":[{"id":15,"preconditions":[{"id":13,"reference":"GROUP_COUNT_34","conjunction_code":"allTrue"}],"conjunction_code":"allTrue"}]},"DENOM":{"conjunction?":true,"type":"DENOM","title":"Denominator","hqmf_id":"30B2C98C-09C0-425E-94B0-98A224D8958D"},"IPP":{"conjunction?":true,"type":"IPP","title":"Initial Patient Population","hqmf_id":"EE59C907-09FA-47C7-94CF-BB03E2F18667","preconditions":[{"id":32,"preconditions":[{"id":16,"reference":"PatientCharacteristicBirthdateBirthDate_precondition_16"},{"id":30,"preconditions":[{"id":18,"reference":"EncounterPerformedOfficeVisit_precondition_18"},{"id":20,"reference":"EncounterPerformedFaceToFaceInteraction_precondition_20"},{"id":22,"reference":"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22"},{"id":24,"reference":"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24"},{"id":26,"reference":"EncounterPerformedAnnualWellnessVisit_precondition_26"},{"id":28,"reference":"EncounterPerformedHomeHealthcareServices_precondition_28"}],"conjunction_code":"atLeastOneTrue"}],"conjunction_code":"allTrue"}]}},"populations":[{"NUMER":"NUMER","DENOM":"DENOM","IPP":"IPP","title":"1+ High-Risk Medications","id":"Population1"},{"NUMER":"NUMER_1","DENOM":"DENOM","IPP":"IPP","title":"2+ High-Risk Medications","id":"Population2"}],"preconditions":null,"publish_date":null,"published":null,"source_data_criteria":{"PatientCharacteristicBirthdateBirthDate":{"title":"birth date","description":"Patient Characteristic Birthdate: birth date","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113883.3.560.100.4","property":"birthtime","type":"characteristic","definition":"patient_characteristic_birthdate","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicBirthdateBirthDate","inline_code_list":{"LOINC":["21112-8"]}},"EncounterPerformedOfficeVisit":{"title":"Office Visit","description":"Encounter, Performed: Office Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1001","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedOfficeVisit"},"EncounterPerformedFaceToFaceInteraction":{"title":"Face-to-Face Interaction","description":"Encounter, Performed: Face-to-Face Interaction","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1048","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedFaceToFaceInteraction"},"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp":{"title":"Preventive Care Services - Established Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services - Established Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1025","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp"},"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp":{"title":"Preventive Care Services-Initial Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services-Initial Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1023","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp"},"EncounterPerformedAnnualWellnessVisit":{"title":"Annual Wellness Visit","description":"Encounter, Performed: Annual Wellness Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.526.3.1240","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedAnnualWellnessVisit"},"EncounterPerformedHomeHealthcareServices":{"title":"Home Healthcare Services","description":"Encounter, Performed: Home Healthcare Services","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1016","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedHomeHealthcareServices"},"MedicationOrderHighRiskMedicationsForTheElderly":{"title":"High Risk Medications for the Elderly","description":"Medication, Order: High Risk Medications for the Elderly","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1253","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsForTheElderly"},"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria":{"title":"High-Risk Medications With Days Supply Criteria","description":"Medication, Order: High-Risk Medications With Days Supply Criteria","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1254","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria"},"PatientCharacteristicSexOncAdministrativeSex":{"title":"ONC Administrative Sex","description":"Patient Characteristic Sex: ONC Administrative Sex","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113762.1.4.1","property":"gender","type":"characteristic","definition":"patient_characteristic_gender","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicSexOncAdministrativeSex","value":{"type":"CD","system":"Administrative Sex","code":"F"}},"PatientCharacteristicRaceRace":{"title":"Race","description":"Patient Characteristic Race: Race","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.836","property":"race","type":"characteristic","definition":"patient_characteristic_race","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicRaceRace","inline_code_list":{"CDC Race":["1002-5","2028-9","2054-5","2076-8","2106-3","2131-1"]}},"PatientCharacteristicEthnicityEthnicity":{"title":"Ethnicity","description":"Patient Characteristic Ethnicity: Ethnicity","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.837","property":"ethnicity","type":"characteristic","definition":"patient_characteristic_ethnicity","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicEthnicityEthnicity","inline_code_list":{"CDC Race":["2135-2","2186-5"]}},"PatientCharacteristicPayerPayer":{"title":"Payer","description":"Patient Characteristic Payer: Payer","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.3591","property":"payer","type":"characteristic","definition":"patient_characteristic_payer","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicPayerPayer","inline_code_list":{"SOP":["1","11","111","112","113","119","12","121","122","123","129","19","2","21","211","212","213","219","22","23","24","25","29","3","31","311","3111","3112","3113","3114","3115","3116","3119","312","3121","3122","3123","313","32","321","3211","3212","32121","32122","32123","32124","32125","32126","322","3221","3222","3223","3229","33","331","332","333","334","34","341","342","343","349","35","36","361","362","369","37","371","3711","3712","3713","372","379","38","381","3811","3812","3813","3819","382","389","39","4","41","42","43","44","5","51","511","512","513","514","515","519","52","521","522","523","529","53","54","55","59","6","61","611","612","613","619","62","63","64","69","7","71","72","73","79","8","81","82","821","822","823","83","84","85","89","9","91","92","93","94","95","951","953","954","959","96","98","99","9999"]}}},"steward":null,"title":"Use of High-Risk Medications in the Elderly","type":"ep","updated_at":"2013-10-03T19:22:28Z","user_id":"501fdba3044a111b98000001","value_set_oids":["2.16.840.1.113762.1.4.1","2.16.840.1.114222.4.11.836","2.16.840.1.114222.4.11.837","2.16.840.1.114222.4.11.3591","2.16.840.1.113883.3.464.1003.196.12.1253","2.16.840.1.113883.3.464.1003.196.12.1254","2.16.840.1.113883.3.560.100.4","2.16.840.1.113883.3.464.1003.101.12.1001","2.16.840.1.113883.3.464.1003.101.12.1048","2.16.840.1.113883.3.464.1003.101.12.1025","2.16.840.1.113883.3.464.1003.101.12.1023","2.16.840.1.113883.3.526.3.1240","2.16.840.1.113883.3.464.1003.101.12.1016"],"version":null})
    measure.calculate = function(patient) {

      if (patient.toJSON != null) {
        patient = patient.toJSON();
      }

      var enable_logging = false;
      var enable_rationale = false;
      ObjectId = function() { return 1; };
      var result = null; // Calls to emit() set this local variable
      emit = function(id, value) { result = value; };
      var print = function(output) { console.log(output); };

      
        var patient_api = new hQuery.Patient(patient);

        
        // #########################
        // ##### DATA ELEMENTS #####
        // #########################

        hqmfjs.nqf_id = '0022';
        hqmfjs.hqmf_id = '40280381-3D61-56A7-013E-65C9C3043E54';
        hqmfjs.sub_id = 'a';
        if (typeof(test_id) == 'undefined') hqmfjs.test_id = null;

        OidDictionary = {'2.16.840.1.114222.4.11.837':{'CDC Race':['2135-2','2186-5']},'2.16.840.1.114222.4.11.836':{'CDC Race':['1002-5','2028-9','2054-5','2076-8','2106-3','2131-1']},'2.16.840.1.114222.4.11.3591':{'SOP':['1','11','111','112','113','119','12','121','122','123','129','19','2','21','211','212','213','219','22','23','24','25','29','3','31','311','3111','3112','3113','3114','3115','3116','3119','312','3121','3122','3123','313','32','321','3211','3212','32121','32122','32123','32124','32125','32126','322','3221','3222','3223','3229','33','331','332','333','334','34','341','342','343','349','35','36','361','362','369','37','371','3711','3712','3713','372','379','38','381','3811','3812','3813','3819','382','389','39','4','41','42','43','44','5','51','511','512','513','514','515','519','52','521','522','523','529','53','54','55','59','6','61','611','612','613','619','62','63','64','69','7','71','72','73','79','8','81','82','821','822','823','83','84','85','89','9','91','92','93','94','95','951','953','954','959','96','98','99','9999']},'2.16.840.1.113883.3.560.100.4':{'LOINC':['21112-8']},'2.16.840.1.113883.3.526.3.1240':{'HCPCS':['G0438','G0439']},'2.16.840.1.113883.3.464.1003.196.12.1254':{'RxNorm':['1232194','1232202','311988','311989','311992','311994','311995','313761','313762','485440','485442','485465','828692','836641','836647','854873','854876','854880','854894','891888']},'2.16.840.1.113883.3.464.1003.196.12.1253':{'RxNorm':['1000351','1000352','1000355','1000356','1000486','1000490','1000496','1010696','1010807','1010946','1010980','1012650','1012690','1012757','1012764','1012904','1012940','1012950','1012956','1012963','1012972','1012974','1012980','1012982','1012995','1020477','1037364','1037379','1041814','1042684','1043400','1046751','1047494','1049091','1049289','1049630','1049633','1049723','1049880','1049898','1049900','1049904','1049906','1049909','1049918','1050077','1050080','1052462','1052647','1052928','1053138','1053618','1053629','1085945','1086463','1086475','1086720','1087026','1087459','1087607','1088936','1089822','1090532','1092189','1092373','1092398','1092411','1092566','1092570','1093075','1093083','1093098','1094131','1094330','1094350','1094355','1094406','1094434','1094473','1094501','1094549','1098443','1098881','1098906','1099308','1099446','1099644','1099653','1099654','1099659','1099668','1099677','1099684','1099694','1099711','1099779','1099788','1099872','1099948','1100501','1101427','1101439','1101446','1101457','1101855','1101858','1112489','1112779','1113380','1113998','1115329','1117245','1119420','1145951','1147619','1148155','1149632','1189337','1190448','1232642','1233546','1234386','1236048','1236387','1236395','1236403','1236420','1236428','1236455','1236459','1237035','1237103','1237110','1237118','1242072','1242502','1242515','1242522','1242582','1242618','1242622','1244523','1244714','1244743','1244747','1244918','1245284','1248057','1248354','1249617','1250949','1251493','1251499','1251614','1251621','1251625','1251756','1251762','1251770','1251771','1251787','1251791','1251792','1251794','1251836','1251838','1291711','1291718','1291854','1291867','1291868','1292097','1292098','1292313','1292314','1292321','1292322','1292324','1293036','1293040','1293706','1293710','1294306','1294313','1294322','1294338','1294348','1294366','1294367','1294368','1294370','1294371','1294372','1294380','1294382','1294383','1294557','1294564','1294567','1294572','1294589','1294602','1294607','1297410','1297514','1297517','1297947','1297950','1297967','1297974','1298267','1298287','1298288','1298295','1298348','1298442','1298446','1298799','1298834','1300081','1300084','1300164','1304533','1305588','1305775','1307225','1308438','1356800','1356807','1356833','1356841','1356848','1356859','1356866','1357013','1357389','1359123','1359124','1359126','1359127','1362789','1363011','1363504','1363648','1363651','1366953','153444','197426','197427','197428','197429','197446','197447','197458','197459','197460','197461','197495','197496','197501','197502','197622','197647','197657','197658','197659','197660','197661','197662','197663','197666','197667','197668','197669','197670','197737','197743','197744','197745','197746','197817','197818','197819','197923','197924','197925','197928','197929','197930','197935','197943','197944','197945','197956','197957','197958','197960','197963','198032','198033','198034','198035','198036','198083','198084','198085','198086','198089','198270','198274','198275','198276','198277','198278','198280','198368','199164','199167','199168','199208','199314','199329','199340','199341','199543','199549','199607','199782','199820','200330','200331','200332','200335','204434','204452','205254','205333','208545','235760','238003','238004','238006','238090','238133','238134','238135','238153','238154','238175','240093','240826','241527','241946','242333','242891','242892','243025','243220','243628','245373','248139','248478','282462','282463','283463','284437','284438','308162','308163','308164','308165','308169','308170','308172','308322','309232','309239','309243','309244','309249','309709','309952','309953','309955','309958','309960','310143','310169','310197','310203','310204','310205','310206','310212','310213','310215','310534','310536','310537','310539','310661','310991','310992','311534','311536','311538','311551','311552','311553','311554','311555','312288','312289','312357','312362','312370','312914','312915','313352','313354','313357','313385','313386','313387','313389','313391','313393','313396','313406','313492','313496','313497','313498','313499','314000','314132','314267','315144','315201','315234','315235','318179','346508','346713','346714','346966','347151','348906','349199','349281','349533','349563','351130','351192','351228','351254','351262','351263','359278','359280','359281','359375','359376','359431','359923','360042','391980','402242','402250','403849','403922','403923','403956','406590','410205','422098','425319','435430','435436','435462','435463','435470','435475','435517','476152','476540','476545','477221','477245','477587','483169','485607','487079','540358','542947','544218','546174','577027','577029','577154','584640','597658','597675','602598','618368','618370','618376','618378','628823','631644','636382','636793','636794','644096','644097','647171','647172','668535','672838','686523','688240','688507','692766','695963','700669','700850','700851','700860','701393','702220','702519','707680','728118','728581','730794','730878','731007','731032','748594','748802','749850','754744','755584','755618','755621','756245','756251','756342','758147','759687','762986','828299','828320','828348','828353','828358','834022','835564','835568','835572','835577','835582','835589','835591','835593','848331','856706','856720','856762','856773','856783','856797','856825','856834','856840','856845','856853','857291','857296','857297','857301','857305','857315','857416','857430','857461','858364','858923','859003','859250','860092','860096','860103','860107','860113','860114','860115','860215','860221','860225','860231','860749','860767','860771','860792','861447','861455','861459','861463','861467','861470','861473','861476','861479','861482','861493','861494','861509','861573','861578','861743','861748','861753','861846','862006','862013','862019','862025','863669','866021','866144','881320','882504','884707','885209','885213','885219','889520','895664','901814','905269','905273','905283','905295','991486','991528','992432','992438','992441','992447','992454','992460','992475','992478','992858','992900','993943','994012','994226','994237','994521','994528','994535','994541','994824','995062','995082','995123','995128','995211','995214','995218','995232','995235','995241','995253','995258','995270','995274','995278','995281','995285','995428','995591','995592','996640','996757','997008','997272','998254','999434','999731']},'2.16.840.1.113883.3.464.1003.101.12.1048':{'SNOMED-CT':['12843005','18170008','185349003','185463005','185465003','19681004','207195004','270427003','270430005','308335008','390906007','406547006','439708006','4525004','87790002','90526000']},'2.16.840.1.113883.3.464.1003.101.12.1025':{'CPT':['99395','99396','99397']},'2.16.840.1.113883.3.464.1003.101.12.1023':{'CPT':['99385','99386','99387']},'2.16.840.1.113883.3.464.1003.101.12.1016':{'CPT':['99341','99342','99343','99344','99345','99347','99348','99349','99350']},'2.16.840.1.113883.3.464.1003.101.12.1001':{'CPT':['99201','99202','99203','99204','99205','99212','99213','99214','99215']},'2.16.840.1.113762.1.4.1':{'AdministrativeSex':['F','M','U']}};
        
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

hqmfjs.MedicationOrderHighRiskMedicationsForTheElderly_precondition_1 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1253"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_3 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1254"};
  var events = patient.getEvents(eventCriteria);
  events = filterEventsByField(events, "cumulativeMedicationDuration", new IVL_PQ(new PQ(90, "d", false), null));
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.MedicationOrderHighRiskMedicationsForTheElderly_precondition_8 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1253"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1254"};
  var events = patient.getEvents(eventCriteria);
  events = filterEventsByField(events, "cumulativeMedicationDuration", new IVL_PQ(new PQ(90, "d", false), null));
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.GROUP_COUNT_34 = function(patient, initialSpecificContext) {
  var events = UNION(
    hqmfjs.MedicationOrderHighRiskMedicationsForTheElderly_precondition_8(patient, initialSpecificContext),
    hqmfjs.MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10(patient, initialSpecificContext)
  );

  hqmf.SpecificsManager.setIfNull(events);
  events = COUNT(events, new IVL_PQ(new PQ(2, null, true), null), initialSpecificContext);
  return events;
}

hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_16 = function(patient, initialSpecificContext) {
  var value = patient.birthtime() || null;
  var events = [value];
  events = SBS(events, hqmfjs.MeasurePeriod(patient), new IVL_PQ(new PQ(66, "a", true), null));
  events.specificContext=hqmf.SpecificsManager.identity();
  return events;
}

hqmfjs.EncounterPerformedOfficeVisit_precondition_18 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1001"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedFaceToFaceInteraction_precondition_20 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1048"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1025"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1023"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedAnnualWellnessVisit_precondition_26 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.526.3.1240"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedHomeHealthcareServices_precondition_28 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1016"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}



        // #########################
        // ##### MEASURE LOGIC #####
        // #########################
        
        hqmfjs.initializeSpecifics = function(patient_api, hqmfjs) { hqmf.SpecificsManager.initialize(patient_api,hqmfjs) }

        // INITIAL PATIENT POPULATION
        hqmfjs.IPP = function(patient, initialSpecificContext) {
  return allTrue('IPP', patient, initialSpecificContext,
    allTrue('32', patient, initialSpecificContext, hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_16,
      atLeastOneTrue('30', patient, initialSpecificContext, hqmfjs.EncounterPerformedOfficeVisit_precondition_18, hqmfjs.EncounterPerformedFaceToFaceInteraction_precondition_20, hqmfjs.EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22, hqmfjs.EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24, hqmfjs.EncounterPerformedAnnualWellnessVisit_precondition_26, hqmfjs.EncounterPerformedHomeHealthcareServices_precondition_28
      )
    )
  )();
};


        // DENOMINATOR
        hqmfjs.DENOM = function(patient) { return new Boolean(true); }
        // NUMERATOR
        hqmfjs.NUMER = function(patient, initialSpecificContext) {
  return allTrue('NUMER', patient, initialSpecificContext,
    allTrue('7', patient, initialSpecificContext,
      atLeastOneTrue('5', patient, initialSpecificContext, hqmfjs.MedicationOrderHighRiskMedicationsForTheElderly_precondition_1, hqmfjs.MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_3
      )
    )
  )();
};


        hqmfjs.DENEX = function(patient) { return new Boolean(false); }
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

      this.set('result', result);
      return result;
    };
    window.Fixtures.Measures.add(measure);
  })();
  (function() {
    var measure = new Thorax.Models.Measure({"_id":"40280381-3D61-56A7-013E-65C9C3043E54","category":"Core","cms_id":"CMS156v2","continuous_variable":false,"created_at":null,"custom_functions":null,"data_criteria":{"PatientCharacteristicSexOncAdministrativeSex":{"title":"ONC Administrative Sex","description":"Patient Characteristic Sex: ONC Administrative Sex","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113762.1.4.1","property":"gender","type":"characteristic","definition":"patient_characteristic_gender","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicSexOncAdministrativeSex","value":{"type":"CD","system":"Administrative Sex","code":"F"}},"PatientCharacteristicRaceRace":{"title":"Race","description":"Patient Characteristic Race: Race","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.836","property":"race","type":"characteristic","definition":"patient_characteristic_race","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicRaceRace","inline_code_list":{"CDC Race":["1002-5","2028-9","2054-5","2076-8","2106-3","2131-1"]}},"PatientCharacteristicEthnicityEthnicity":{"title":"Ethnicity","description":"Patient Characteristic Ethnicity: Ethnicity","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.837","property":"ethnicity","type":"characteristic","definition":"patient_characteristic_ethnicity","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicEthnicityEthnicity","inline_code_list":{"CDC Race":["2135-2","2186-5"]}},"PatientCharacteristicPayerPayer":{"title":"Payer","description":"Patient Characteristic Payer: Payer","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.3591","property":"payer","type":"characteristic","definition":"patient_characteristic_payer","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicPayerPayer","inline_code_list":{"SOP":["1","11","111","112","113","119","12","121","122","123","129","19","2","21","211","212","213","219","22","23","24","25","29","3","31","311","3111","3112","3113","3114","3115","3116","3119","312","3121","3122","3123","313","32","321","3211","3212","32121","32122","32123","32124","32125","32126","322","3221","3222","3223","3229","33","331","332","333","334","34","341","342","343","349","35","36","361","362","369","37","371","3711","3712","3713","372","379","38","381","3811","3812","3813","3819","382","389","39","4","41","42","43","44","5","51","511","512","513","514","515","519","52","521","522","523","529","53","54","55","59","6","61","611","612","613","619","62","63","64","69","7","71","72","73","79","8","81","82","821","822","823","83","84","85","89","9","91","92","93","94","95","951","953","954","959","96","98","99","9999"]}},"MedicationOrderHighRiskMedicationsForTheElderly_precondition_1":{"title":"High Risk Medications for the Elderly","description":"Medication, Order: High Risk Medications for the Elderly","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1253","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsForTheElderly","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_3":{"title":"High-Risk Medications With Days Supply Criteria","description":"Medication, Order: High-Risk Medications With Days Supply Criteria","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1254","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria","field_values":{"CUMULATIVE_MEDICATION_DURATION":{"type":"IVL_PQ","low":{"type":"PQ","unit":"d","value":"90","inclusive?":false,"derived?":false}}},"temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"MedicationOrderHighRiskMedicationsForTheElderly_precondition_8":{"title":"High Risk Medications for the Elderly","description":"Medication, Order: High Risk Medications for the Elderly","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1253","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsForTheElderly","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10":{"title":"High-Risk Medications With Days Supply Criteria","description":"Medication, Order: High-Risk Medications With Days Supply Criteria","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1254","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria","field_values":{"CUMULATIVE_MEDICATION_DURATION":{"type":"IVL_PQ","low":{"type":"PQ","unit":"d","value":"90","inclusive?":false,"derived?":false}}},"temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"GROUP_COUNT_34":{"title":"GROUP_COUNT_34","description":"","standard_category":"","qds_data_type":"","children_criteria":["MedicationOrderHighRiskMedicationsForTheElderly_precondition_8","MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10"],"derivation_operator":"UNION","type":"derived","definition":"derived","hard_status":false,"negation":false,"source_data_criteria":"GROUP_COUNT_34","subset_operators":[{"type":"COUNT","value":{"type":"IVL_PQ","low":{"type":"PQ","value":"2","inclusive?":true,"derived?":false}}}]},"PatientCharacteristicBirthdateBirthDate_precondition_16":{"title":"birth date","description":"Patient Characteristic Birthdate: birth date","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113883.3.560.100.4","property":"birthtime","type":"characteristic","definition":"patient_characteristic_birthdate","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicBirthdateBirthDate","inline_code_list":{"LOINC":["21112-8"]},"temporal_references":[{"type":"SBS","reference":"MeasurePeriod","range":{"type":"IVL_PQ","low":{"type":"PQ","unit":"a","value":"66","inclusive?":true,"derived?":false}}}]},"EncounterPerformedOfficeVisit_precondition_18":{"title":"Office Visit","description":"Encounter, Performed: Office Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1001","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedOfficeVisit","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedFaceToFaceInteraction_precondition_20":{"title":"Face-to-Face Interaction","description":"Encounter, Performed: Face-to-Face Interaction","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1048","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedFaceToFaceInteraction","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22":{"title":"Preventive Care Services - Established Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services - Established Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1025","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24":{"title":"Preventive Care Services-Initial Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services-Initial Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1023","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedAnnualWellnessVisit_precondition_26":{"title":"Annual Wellness Visit","description":"Encounter, Performed: Annual Wellness Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.526.3.1240","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedAnnualWellnessVisit","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]},"EncounterPerformedHomeHealthcareServices_precondition_28":{"title":"Home Healthcare Services","description":"Encounter, Performed: Home Healthcare Services","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1016","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedHomeHealthcareServices","temporal_references":[{"type":"DURING","reference":"MeasurePeriod"}]}},"description":"Percentage of patients 66 years of age and older who were ordered high-risk medications. Two rates are reported.\na. Percentage of patients who were ordered at least one high-risk medication. \nb. Percentage of patients who were ordered at least two different high-risk medications.","endorser":null,"episode_ids":null,"episode_of_care":false,"force_sources":null,"hqmf_id":"40280381-3D61-56A7-013E-65C9C3043E54","hqmf_set_id":"A3837FF8-1ABC-4BA9-800E-FD4E7953ADBD","hqmf_version_number":2,"id":"0022b","measure_attributes":[{"id":"COPYRIGHT","code":"COPY","value":"Physician Performance Measure (Measures) and related data specifications were developed by the National Committee for Quality Assurance (NCQA). \n\nThe Measures are copyrighted but can be reproduced and distributed, without modification, for noncommercial purposes (e.g., use by healthcare providers in connection with their practices). Commercial use is defined as the sale, licensing, or distribution of the Measures for commercial gain, or incorporation of the Measures into a product or service that is sold, licensed or distributed for commercial gain. Commercial use of the Measures requires a license agreement between the user and NCQA. NCQA is not responsible for any use of the Measures. \n\n(c) 2008-2013 National Committee for Quality Assurance. All Rights Reserved. \n\nLimited proprietary coding is contained in the Measure specifications for user convenience. Users of proprietary code sets should obtain all necessary licenses from the owners of the code sets.  NCQA disclaims all liability for use or accuracy of any CPT or other codes contained in the specifications.\n\nCPT(R) contained in the Measure specifications is copyright 2004-2012 American Medical Association. LOINC(R) copyright 2004-2012 Regenstrief Institute, Inc. This material contains SNOMED Clinical Terms(R) (SNOMED CT[R]) copyright 2004-2012 International Health Terminology Standards Development Organisation. ICD-10 copyright 2012 World Health Organization. All Rights Reserved.","name":"Copyright"},{"id":"MEASURE_SCORING","code":"MSRSCORE","name":"Measure Scoring"},{"id":"MEASURE_TYPE","code":"MSRTYPE","name":"Measure Type"},{"id":"STRATIFICATION","code":"STRAT","value":"None","name":"Stratification"},{"id":"RISK_ADJUSTMENT","code":"MSRADJ","value":"None","name":"Risk Adjustment"},{"id":"RATE_AGGREGATION","code":"MSRAGG","value":"None","name":"Rate Aggregation"},{"id":"RATIONALE","code":"RAT","value":"Seniors receiving inappropriate medications are more likely to report poorer health status at follow-up, compared to seniors who receive appropriate medications (Fu, Liu, and Christensen 2004). In 2005, rates of potentially inappropriate medication use in the elderly were as large or larger than in a 1996 national sample, highlighting the need for progress in this area (Simon et al. 2005). While some adverse drug events are not preventable, studies estimate that between 30 and 80 percent of adverse drug events in the elderly are preventable (MacKinnon and Hepler 2003).\n\nReducing the number of inappropriate prescriptions can lead to improved patient safety and significant cost savings.  Conservative estimates of extra costs due to potentially inappropriate medications in the elderly average $7.2 billion a year (Fu, Liu, and Christensen 2004). Medication use by older adults will likely increase further as the U.S. population ages, new drugs are developed, and new therapeutic and preventive uses for medications are discovered (Rothberg et al. 2008). By the year 2030, nearly one in five U.S. residents is expected to be aged 65 years or older; this age group is projected to more than double in number from 38.7 million in 2008 to more than 88.5 million in 2050.  Likewise, the population aged 85 years or older is expected to increase almost four-fold, from 5.4 million to 19 million between 2008 and 2050.  As the elderly population continues to grow, the number of older adults who present with multiple medical conditions for which several medications are prescribed continues to increase, resulting in polypharmacy (Gray and Gardner 2009).","name":"Rationale"},{"id":"CLINICAL_RECOMMENDATION_STATEMENT","code":"CRS","value":"The measure is based on the literature and key clinical expert consensus processes by Beers in 1997, Zahn in 2001 and an updated process by Fick in 2003, which identified drugs of concern in the elderly based on various high-risk criteria. NCQA's Medication Management expert panel selected a subset of drugs that should be used with caution in the elderly for inclusion in the proposed measure based upon these two lists.  NCQA analyzed the prevalence of drugs prescribed according to the Beers and Zhan classifications and determined that drugs identified by Zhan that are classified as never or rarely appropriate would form the basis for the list (Fick 2003).\n\n\nCertain medications (MacKinnon 2003) are associated with increased risk of harms from drug side-effects and drug toxicity and pose a concern for patient safety. There is clinical consensus that these drugs pose increased risks in the elderly (Kaufman 2005). Studies link prescription drug use by the elderly with adverse drug events that contribute to hospitalization, increased length of hospital stay, increased duration of illness, nursing home placement and falls and fractures that are further associated with physical, functional and social decline in the elderly (AHRQ 2009).","name":"Clinical Recommendation Statement"},{"id":"IMPROVEMENT_NOTATION","code":"IDUR","value":"Lower score indicates better quality","name":"Improvement Notation"},{"id":"NQF_ID_NUMBER","code":"OTH","value":"0022","name":"NQF ID Number"},{"id":"DISCLAIMER","code":"DISC","value":"These performance Measures are not clinical guidelines and do not establish a standard of medical care, and have not been tested for all potential applications.\n\nTHE MEASURES AND SPECIFICATIONS ARE PROVIDED \u201cAS IS\u201d WITHOUT WARRANTY OF ANY KIND.\n\nDue to technical limitations, registered trademarks are indicated by (R) or [R] and unregistered trademarks are indicated by (TM) or [TM].","name":"Disclaimer"},{"id":"EMEASURE_IDENTIFIER","code":"OTH","value":"156","name":"eMeasure Identifier"},{"id":"REFERENCE","code":"REF","value":"Rothberg, M.B., P.S. Perkow, F. Liu, B. Korc-Grodzicki, M.J. Brennan, S. Bellantonio, M. Heelon, P.K. Lindenauer. 2008. \u201cPotentially Inappropriate Medication Use in Hospitalized Elders.\u201d J Hosp Med 3:91-102.","name":"Reference"},{"id":"DEFINITION","code":"DEF","value":"A high-risk medication is identified by either of the following:\n     a.\t A prescription for medications classified as high risk at any dose and for any duration\n     b. Prescriptions for medications classified as high risk at any dose with greater than a 90 day supply","name":"Definition"},{"id":"GUIDANCE","code":"GUIDE","value":"The intent of Numerator 1 of the measure is to assess if the patient has been prescribed one high-risk medication.  The intent of Numerator 2 of the measure is to assess if the patient has been prescribed at least two different high-risk medications.\n\nCUMULATIVE MEDICATION DURATION is an individual\u2019s total number of medication days over a specific period; the period counts multiple prescriptions with gaps in between, but does not count the gaps during which a medication was not dispensed.\n \nTo determine the cumulative medication duration, determine first the number of the Medication Days for each prescription in the period: the number of doses divided by the dose frequency per day. Then add the Medication Days for each prescription without counting any days between the prescriptions.\n\nFor example, there is an original prescription for 30 days with 2 refills for thirty days each. After a gap of 3 months, the medication was prescribed again for 60 days with 1 refill for 60 days. The cumulative medication duration is (30 x 3) + (60 x 2) = 210 days over the 10 month period.","name":"Guidance"},{"id":"TRANSMISSION_FORMAT","code":"OTH","value":"TBD","name":"Transmission Format"},{"id":"INITIAL_PATIENT_POPULATION","code":"IPP","value":"Patients 66 years and older who had a visit during the measurement period","name":"Initial Patient Population"},{"id":"DENOMINATOR","code":"DENOM","value":"Equals initial patient population","name":"Denominator"},{"id":"DENOMINATOR_EXCLUSIONS","code":"OTH","value":"None","name":"Denominator Exclusions"},{"id":"NUMERATOR","code":"NUMER","value":"Numerator 1: Patients with an order for at least one high-risk medication during the measurement period. \nNumerator 2: Patients with an order for at least two different high-risk medications during the measurement period.","name":"Numerator"},{"id":"NUMERATOR_EXCLUSIONS","code":"OTH","value":"Not applicable","name":"Numerator Exclusions"},{"id":"DENOMINATOR_EXCEPTIONS","code":"DENEXCEP","value":"None","name":"Denominator Exceptions"},{"id":"MEASURE_POPULATION","code":"MSRPOPL","value":"Not applicable","name":"Measure Population"},{"id":"MEASURE_OBSERVATIONS","code":"OTH","value":"Not applicable","name":"Measure Observations"},{"id":"SUPPLEMENTAL_DATA_ELEMENTS","code":"OTH","value":"For every patient evaluated by this measure also identify payer, race, ethnicity and sex.","name":"Supplemental Data Elements"}],"measure_id":"0022","measure_period":{"type":"IVL_TS","low":{"type":"TS","value":"201201010000","inclusive?":true,"derived?":false},"high":{"type":"TS","value":"201212312359","inclusive?":true,"derived?":false},"width":{"type":"PQ","unit":"a","value":"1","inclusive?":true,"derived?":false}},"population_criteria":{"NUMER":{"conjunction?":true,"type":"NUMER","title":"Numerator","hqmf_id":"4C09A356-D793-487E-BD27-1031D9BF35B7","preconditions":[{"id":7,"preconditions":[{"id":5,"preconditions":[{"id":1,"reference":"MedicationOrderHighRiskMedicationsForTheElderly_precondition_1"},{"id":3,"reference":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_3"}],"conjunction_code":"atLeastOneTrue"}],"conjunction_code":"allTrue"}]},"NUMER_1":{"conjunction?":true,"type":"NUMER","title":"Numerator","hqmf_id":"F9870989-EC28-4523-934A-544F19C34ED1","preconditions":[{"id":15,"preconditions":[{"id":13,"reference":"GROUP_COUNT_34","conjunction_code":"allTrue"}],"conjunction_code":"allTrue"}]},"DENOM":{"conjunction?":true,"type":"DENOM","title":"Denominator","hqmf_id":"30B2C98C-09C0-425E-94B0-98A224D8958D"},"IPP":{"conjunction?":true,"type":"IPP","title":"Initial Patient Population","hqmf_id":"EE59C907-09FA-47C7-94CF-BB03E2F18667","preconditions":[{"id":32,"preconditions":[{"id":16,"reference":"PatientCharacteristicBirthdateBirthDate_precondition_16"},{"id":30,"preconditions":[{"id":18,"reference":"EncounterPerformedOfficeVisit_precondition_18"},{"id":20,"reference":"EncounterPerformedFaceToFaceInteraction_precondition_20"},{"id":22,"reference":"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22"},{"id":24,"reference":"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24"},{"id":26,"reference":"EncounterPerformedAnnualWellnessVisit_precondition_26"},{"id":28,"reference":"EncounterPerformedHomeHealthcareServices_precondition_28"}],"conjunction_code":"atLeastOneTrue"}],"conjunction_code":"allTrue"}]}},"populations":[{"NUMER":"NUMER","DENOM":"DENOM","IPP":"IPP","title":"1+ High-Risk Medications","id":"Population1"},{"NUMER":"NUMER_1","DENOM":"DENOM","IPP":"IPP","title":"2+ High-Risk Medications","id":"Population2"}],"preconditions":null,"publish_date":null,"published":null,"source_data_criteria":{"PatientCharacteristicBirthdateBirthDate":{"title":"birth date","description":"Patient Characteristic Birthdate: birth date","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113883.3.560.100.4","property":"birthtime","type":"characteristic","definition":"patient_characteristic_birthdate","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicBirthdateBirthDate","inline_code_list":{"LOINC":["21112-8"]}},"EncounterPerformedOfficeVisit":{"title":"Office Visit","description":"Encounter, Performed: Office Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1001","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedOfficeVisit"},"EncounterPerformedFaceToFaceInteraction":{"title":"Face-to-Face Interaction","description":"Encounter, Performed: Face-to-Face Interaction","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1048","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedFaceToFaceInteraction"},"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp":{"title":"Preventive Care Services - Established Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services - Established Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1025","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp"},"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp":{"title":"Preventive Care Services-Initial Office Visit, 18 and Up","description":"Encounter, Performed: Preventive Care Services-Initial Office Visit, 18 and Up","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1023","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp"},"EncounterPerformedAnnualWellnessVisit":{"title":"Annual Wellness Visit","description":"Encounter, Performed: Annual Wellness Visit","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.526.3.1240","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedAnnualWellnessVisit"},"EncounterPerformedHomeHealthcareServices":{"title":"Home Healthcare Services","description":"Encounter, Performed: Home Healthcare Services","standard_category":"encounter","qds_data_type":"encounter","code_list_id":"2.16.840.1.113883.3.464.1003.101.12.1016","type":"encounters","definition":"encounter","status":"performed","hard_status":false,"negation":false,"source_data_criteria":"EncounterPerformedHomeHealthcareServices"},"MedicationOrderHighRiskMedicationsForTheElderly":{"title":"High Risk Medications for the Elderly","description":"Medication, Order: High Risk Medications for the Elderly","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1253","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsForTheElderly"},"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria":{"title":"High-Risk Medications With Days Supply Criteria","description":"Medication, Order: High-Risk Medications With Days Supply Criteria","standard_category":"medication","qds_data_type":"medication_order","code_list_id":"2.16.840.1.113883.3.464.1003.196.12.1254","type":"medications","definition":"medication","status":"ordered","hard_status":true,"negation":false,"source_data_criteria":"MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria"},"PatientCharacteristicSexOncAdministrativeSex":{"title":"ONC Administrative Sex","description":"Patient Characteristic Sex: ONC Administrative Sex","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.113762.1.4.1","property":"gender","type":"characteristic","definition":"patient_characteristic_gender","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicSexOncAdministrativeSex","value":{"type":"CD","system":"Administrative Sex","code":"F"}},"PatientCharacteristicRaceRace":{"title":"Race","description":"Patient Characteristic Race: Race","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.836","property":"race","type":"characteristic","definition":"patient_characteristic_race","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicRaceRace","inline_code_list":{"CDC Race":["1002-5","2028-9","2054-5","2076-8","2106-3","2131-1"]}},"PatientCharacteristicEthnicityEthnicity":{"title":"Ethnicity","description":"Patient Characteristic Ethnicity: Ethnicity","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.837","property":"ethnicity","type":"characteristic","definition":"patient_characteristic_ethnicity","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicEthnicityEthnicity","inline_code_list":{"CDC Race":["2135-2","2186-5"]}},"PatientCharacteristicPayerPayer":{"title":"Payer","description":"Patient Characteristic Payer: Payer","standard_category":"individual_characteristic","qds_data_type":"individual_characteristic","code_list_id":"2.16.840.1.114222.4.11.3591","property":"payer","type":"characteristic","definition":"patient_characteristic_payer","hard_status":false,"negation":false,"source_data_criteria":"PatientCharacteristicPayerPayer","inline_code_list":{"SOP":["1","11","111","112","113","119","12","121","122","123","129","19","2","21","211","212","213","219","22","23","24","25","29","3","31","311","3111","3112","3113","3114","3115","3116","3119","312","3121","3122","3123","313","32","321","3211","3212","32121","32122","32123","32124","32125","32126","322","3221","3222","3223","3229","33","331","332","333","334","34","341","342","343","349","35","36","361","362","369","37","371","3711","3712","3713","372","379","38","381","3811","3812","3813","3819","382","389","39","4","41","42","43","44","5","51","511","512","513","514","515","519","52","521","522","523","529","53","54","55","59","6","61","611","612","613","619","62","63","64","69","7","71","72","73","79","8","81","82","821","822","823","83","84","85","89","9","91","92","93","94","95","951","953","954","959","96","98","99","9999"]}}},"steward":null,"title":"Use of High-Risk Medications in the Elderly","type":"ep","updated_at":"2013-10-03T19:22:28Z","user_id":"501fdba3044a111b98000001","value_set_oids":["2.16.840.1.113762.1.4.1","2.16.840.1.114222.4.11.836","2.16.840.1.114222.4.11.837","2.16.840.1.114222.4.11.3591","2.16.840.1.113883.3.464.1003.196.12.1253","2.16.840.1.113883.3.464.1003.196.12.1254","2.16.840.1.113883.3.560.100.4","2.16.840.1.113883.3.464.1003.101.12.1001","2.16.840.1.113883.3.464.1003.101.12.1048","2.16.840.1.113883.3.464.1003.101.12.1025","2.16.840.1.113883.3.464.1003.101.12.1023","2.16.840.1.113883.3.526.3.1240","2.16.840.1.113883.3.464.1003.101.12.1016"],"version":null})
    measure.calculate = function(patient) {

      if (patient.toJSON != null) {
        patient = patient.toJSON();
      }

      var enable_logging = false;
      var enable_rationale = false;
      ObjectId = function() { return 1; };
      var result = null; // Calls to emit() set this local variable
      emit = function(id, value) { result = value; };
      var print = function(output) { console.log(output); };

      
        var patient_api = new hQuery.Patient(patient);

        
        // #########################
        // ##### DATA ELEMENTS #####
        // #########################

        hqmfjs.nqf_id = '0022';
        hqmfjs.hqmf_id = '40280381-3D61-56A7-013E-65C9C3043E54';
        hqmfjs.sub_id = 'b';
        if (typeof(test_id) == 'undefined') hqmfjs.test_id = null;

        OidDictionary = {'2.16.840.1.114222.4.11.837':{'CDC Race':['2135-2','2186-5']},'2.16.840.1.114222.4.11.836':{'CDC Race':['1002-5','2028-9','2054-5','2076-8','2106-3','2131-1']},'2.16.840.1.114222.4.11.3591':{'SOP':['1','11','111','112','113','119','12','121','122','123','129','19','2','21','211','212','213','219','22','23','24','25','29','3','31','311','3111','3112','3113','3114','3115','3116','3119','312','3121','3122','3123','313','32','321','3211','3212','32121','32122','32123','32124','32125','32126','322','3221','3222','3223','3229','33','331','332','333','334','34','341','342','343','349','35','36','361','362','369','37','371','3711','3712','3713','372','379','38','381','3811','3812','3813','3819','382','389','39','4','41','42','43','44','5','51','511','512','513','514','515','519','52','521','522','523','529','53','54','55','59','6','61','611','612','613','619','62','63','64','69','7','71','72','73','79','8','81','82','821','822','823','83','84','85','89','9','91','92','93','94','95','951','953','954','959','96','98','99','9999']},'2.16.840.1.113883.3.560.100.4':{'LOINC':['21112-8']},'2.16.840.1.113883.3.526.3.1240':{'HCPCS':['G0438','G0439']},'2.16.840.1.113883.3.464.1003.196.12.1254':{'RxNorm':['1232194','1232202','311988','311989','311992','311994','311995','313761','313762','485440','485442','485465','828692','836641','836647','854873','854876','854880','854894','891888']},'2.16.840.1.113883.3.464.1003.196.12.1253':{'RxNorm':['1000351','1000352','1000355','1000356','1000486','1000490','1000496','1010696','1010807','1010946','1010980','1012650','1012690','1012757','1012764','1012904','1012940','1012950','1012956','1012963','1012972','1012974','1012980','1012982','1012995','1020477','1037364','1037379','1041814','1042684','1043400','1046751','1047494','1049091','1049289','1049630','1049633','1049723','1049880','1049898','1049900','1049904','1049906','1049909','1049918','1050077','1050080','1052462','1052647','1052928','1053138','1053618','1053629','1085945','1086463','1086475','1086720','1087026','1087459','1087607','1088936','1089822','1090532','1092189','1092373','1092398','1092411','1092566','1092570','1093075','1093083','1093098','1094131','1094330','1094350','1094355','1094406','1094434','1094473','1094501','1094549','1098443','1098881','1098906','1099308','1099446','1099644','1099653','1099654','1099659','1099668','1099677','1099684','1099694','1099711','1099779','1099788','1099872','1099948','1100501','1101427','1101439','1101446','1101457','1101855','1101858','1112489','1112779','1113380','1113998','1115329','1117245','1119420','1145951','1147619','1148155','1149632','1189337','1190448','1232642','1233546','1234386','1236048','1236387','1236395','1236403','1236420','1236428','1236455','1236459','1237035','1237103','1237110','1237118','1242072','1242502','1242515','1242522','1242582','1242618','1242622','1244523','1244714','1244743','1244747','1244918','1245284','1248057','1248354','1249617','1250949','1251493','1251499','1251614','1251621','1251625','1251756','1251762','1251770','1251771','1251787','1251791','1251792','1251794','1251836','1251838','1291711','1291718','1291854','1291867','1291868','1292097','1292098','1292313','1292314','1292321','1292322','1292324','1293036','1293040','1293706','1293710','1294306','1294313','1294322','1294338','1294348','1294366','1294367','1294368','1294370','1294371','1294372','1294380','1294382','1294383','1294557','1294564','1294567','1294572','1294589','1294602','1294607','1297410','1297514','1297517','1297947','1297950','1297967','1297974','1298267','1298287','1298288','1298295','1298348','1298442','1298446','1298799','1298834','1300081','1300084','1300164','1304533','1305588','1305775','1307225','1308438','1356800','1356807','1356833','1356841','1356848','1356859','1356866','1357013','1357389','1359123','1359124','1359126','1359127','1362789','1363011','1363504','1363648','1363651','1366953','153444','197426','197427','197428','197429','197446','197447','197458','197459','197460','197461','197495','197496','197501','197502','197622','197647','197657','197658','197659','197660','197661','197662','197663','197666','197667','197668','197669','197670','197737','197743','197744','197745','197746','197817','197818','197819','197923','197924','197925','197928','197929','197930','197935','197943','197944','197945','197956','197957','197958','197960','197963','198032','198033','198034','198035','198036','198083','198084','198085','198086','198089','198270','198274','198275','198276','198277','198278','198280','198368','199164','199167','199168','199208','199314','199329','199340','199341','199543','199549','199607','199782','199820','200330','200331','200332','200335','204434','204452','205254','205333','208545','235760','238003','238004','238006','238090','238133','238134','238135','238153','238154','238175','240093','240826','241527','241946','242333','242891','242892','243025','243220','243628','245373','248139','248478','282462','282463','283463','284437','284438','308162','308163','308164','308165','308169','308170','308172','308322','309232','309239','309243','309244','309249','309709','309952','309953','309955','309958','309960','310143','310169','310197','310203','310204','310205','310206','310212','310213','310215','310534','310536','310537','310539','310661','310991','310992','311534','311536','311538','311551','311552','311553','311554','311555','312288','312289','312357','312362','312370','312914','312915','313352','313354','313357','313385','313386','313387','313389','313391','313393','313396','313406','313492','313496','313497','313498','313499','314000','314132','314267','315144','315201','315234','315235','318179','346508','346713','346714','346966','347151','348906','349199','349281','349533','349563','351130','351192','351228','351254','351262','351263','359278','359280','359281','359375','359376','359431','359923','360042','391980','402242','402250','403849','403922','403923','403956','406590','410205','422098','425319','435430','435436','435462','435463','435470','435475','435517','476152','476540','476545','477221','477245','477587','483169','485607','487079','540358','542947','544218','546174','577027','577029','577154','584640','597658','597675','602598','618368','618370','618376','618378','628823','631644','636382','636793','636794','644096','644097','647171','647172','668535','672838','686523','688240','688507','692766','695963','700669','700850','700851','700860','701393','702220','702519','707680','728118','728581','730794','730878','731007','731032','748594','748802','749850','754744','755584','755618','755621','756245','756251','756342','758147','759687','762986','828299','828320','828348','828353','828358','834022','835564','835568','835572','835577','835582','835589','835591','835593','848331','856706','856720','856762','856773','856783','856797','856825','856834','856840','856845','856853','857291','857296','857297','857301','857305','857315','857416','857430','857461','858364','858923','859003','859250','860092','860096','860103','860107','860113','860114','860115','860215','860221','860225','860231','860749','860767','860771','860792','861447','861455','861459','861463','861467','861470','861473','861476','861479','861482','861493','861494','861509','861573','861578','861743','861748','861753','861846','862006','862013','862019','862025','863669','866021','866144','881320','882504','884707','885209','885213','885219','889520','895664','901814','905269','905273','905283','905295','991486','991528','992432','992438','992441','992447','992454','992460','992475','992478','992858','992900','993943','994012','994226','994237','994521','994528','994535','994541','994824','995062','995082','995123','995128','995211','995214','995218','995232','995235','995241','995253','995258','995270','995274','995278','995281','995285','995428','995591','995592','996640','996757','997008','997272','998254','999434','999731']},'2.16.840.1.113883.3.464.1003.101.12.1048':{'SNOMED-CT':['12843005','18170008','185349003','185463005','185465003','19681004','207195004','270427003','270430005','308335008','390906007','406547006','439708006','4525004','87790002','90526000']},'2.16.840.1.113883.3.464.1003.101.12.1025':{'CPT':['99395','99396','99397']},'2.16.840.1.113883.3.464.1003.101.12.1023':{'CPT':['99385','99386','99387']},'2.16.840.1.113883.3.464.1003.101.12.1016':{'CPT':['99341','99342','99343','99344','99345','99347','99348','99349','99350']},'2.16.840.1.113883.3.464.1003.101.12.1001':{'CPT':['99201','99202','99203','99204','99205','99212','99213','99214','99215']},'2.16.840.1.113762.1.4.1':{'AdministrativeSex':['F','M','U']}};
        
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

hqmfjs.MedicationOrderHighRiskMedicationsForTheElderly_precondition_1 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1253"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_3 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1254"};
  var events = patient.getEvents(eventCriteria);
  events = filterEventsByField(events, "cumulativeMedicationDuration", new IVL_PQ(new PQ(90, "d", false), null));
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.MedicationOrderHighRiskMedicationsForTheElderly_precondition_8 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1253"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "allMedications", "statuses": ["ordered"], "valueSetId": "2.16.840.1.113883.3.464.1003.196.12.1254"};
  var events = patient.getEvents(eventCriteria);
  events = filterEventsByField(events, "cumulativeMedicationDuration", new IVL_PQ(new PQ(90, "d", false), null));
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.GROUP_COUNT_34 = function(patient, initialSpecificContext) {
  var events = UNION(
    hqmfjs.MedicationOrderHighRiskMedicationsForTheElderly_precondition_8(patient, initialSpecificContext),
    hqmfjs.MedicationOrderHighRiskMedicationsWithDaysSupplyCriteria_precondition_10(patient, initialSpecificContext)
  );

  hqmf.SpecificsManager.setIfNull(events);
  events = COUNT(events, new IVL_PQ(new PQ(2, null, true), null), initialSpecificContext);
  return events;
}

hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_16 = function(patient, initialSpecificContext) {
  var value = patient.birthtime() || null;
  var events = [value];
  events = SBS(events, hqmfjs.MeasurePeriod(patient), new IVL_PQ(new PQ(66, "a", true), null));
  events.specificContext=hqmf.SpecificsManager.identity();
  return events;
}

hqmfjs.EncounterPerformedOfficeVisit_precondition_18 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1001"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedFaceToFaceInteraction_precondition_20 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1048"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1025"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1023"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedAnnualWellnessVisit_precondition_26 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.526.3.1240"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}

hqmfjs.EncounterPerformedHomeHealthcareServices_precondition_28 = function(patient, initialSpecificContext) {
  var eventCriteria = {"type": "encounters", "statuses": ["performed"], "includeEventsWithoutStatus": true, "valueSetId": "2.16.840.1.113883.3.464.1003.101.12.1016"};
  var events = patient.getEvents(eventCriteria);
  if (events.length > 0) events = DURING(events, hqmfjs.MeasurePeriod(patient));
  if (events.length == 0) events.specificContext=hqmf.SpecificsManager.empty();
  return events;
}



        // #########################
        // ##### MEASURE LOGIC #####
        // #########################
        
        hqmfjs.initializeSpecifics = function(patient_api, hqmfjs) { hqmf.SpecificsManager.initialize(patient_api,hqmfjs) }

        // INITIAL PATIENT POPULATION
        hqmfjs.IPP = function(patient, initialSpecificContext) {
  return allTrue('IPP', patient, initialSpecificContext,
    allTrue('32', patient, initialSpecificContext, hqmfjs.PatientCharacteristicBirthdateBirthDate_precondition_16,
      atLeastOneTrue('30', patient, initialSpecificContext, hqmfjs.EncounterPerformedOfficeVisit_precondition_18, hqmfjs.EncounterPerformedFaceToFaceInteraction_precondition_20, hqmfjs.EncounterPerformedPreventiveCareServicesEstablishedOfficeVisit18AndUp_precondition_22, hqmfjs.EncounterPerformedPreventiveCareServicesInitialOfficeVisit18AndUp_precondition_24, hqmfjs.EncounterPerformedAnnualWellnessVisit_precondition_26, hqmfjs.EncounterPerformedHomeHealthcareServices_precondition_28
      )
    )
  )();
};


        // DENOMINATOR
        hqmfjs.DENOM = function(patient) { return new Boolean(true); }
        // NUMERATOR
        hqmfjs.NUMER = function(patient, initialSpecificContext) {
  return allTrue('NUMER_1', patient, initialSpecificContext,
    allTrue('15', patient, initialSpecificContext, hqmfjs.GROUP_COUNT_34
    )
  )();
};


        hqmfjs.DENEX = function(patient) { return new Boolean(false); }
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

      this.set('result', result);
      return result;
    };
    window.Fixtures.Measures.add(measure);
  })();
