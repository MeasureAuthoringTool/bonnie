// This fixture was created by taking the patients JS generated as
// part of app/views/layouts/application.html.erb, copying it into
// this file, and tweaking the code to place the patients in the
// fixture instead of the bonnie router

window.Fixtures || (window.Fixtures = {});
window.Fixtures.Patients = new Thorax.Collections.Patients([{
  "_id": "5203afe2f7305cbf316eb5a7",
  "birthdate": 48600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521765cc0017f76983000003",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["305.00"],
      "SNOMED-CT": ["7200002"],
      "ICD-10-CM": ["F10"]
    },
    "description": "Diagnosis, Active: Alcohol and Drug Dependence (Code List: 2.16.840.1.113883.3.464.1003.106.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1349093100,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521765cc0017f76983000004",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.21"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Major Depression (Code List: 2.16.840.1.113883.3.464.1003.105.12.1007)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1349093100,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521765cc0017f76983000001",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1349096400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1349092800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521765cc0017f76983000005",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["90791"]
    },
    "description": "Encounter, Performed: Psych Visit (Code List: 2.16.840.113883.3.67.1.101.3.2445)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1351774800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1351771200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5a7",
  "insurance_providers": [{
    "_id": "520d3caa044a11a515000001",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "520d3caa044a11a515000002",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-7BC533A071D3",
  "measure_ids": ["0710", "0105", "0108", "0036", "0712", "0004", "0104", "0002", "0110", "0419", "0031", "0384", "0024", "0028"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "bc8f60f4cbde3d6c28974971b6880792",
  "medications": [{
    "_id": "521765cc0017f76983000002",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1000048"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: BH Antidepressant medication (Code List: 2.16.840.1.113883.3.1257.1.972)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1349092800,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1349092800,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [{
    "title": "Race",
    "description": "Patient Characteristic Race: Race",
    "standard_category": "individual_characteristic",
    "qds_data_type": "individual_characteristic",
    "code_list_id": "2.16.840.1.114222.4.11.836",
    "property": "race",
    "type": "characteristic",
    "definition": "patient_characteristic_race",
    "hard_status": false,
    "negation": false,
    "source_data_criteria": "PatientCharacteristicRaceRace",
    "inline_code_list": {
      "CDC Race": ["1002-5", "2028-9", "2054-5", "2076-8", "2106-3", "2131-1"]
    }
  }],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5a9",
  "birthdate": 1320156000,
  "clinicalTrialParticipant": null,
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521e0e6c0017f74887000003",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328090400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328086800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Infant",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5a9",
  "insurance_providers": [{
    "_id": "521e0e650017f74887000001",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "521e0e650017f74887000002",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-62240559256D",
  "measure_ids": ["1401", "0060", "0002", "0024", "0004", "0384", "0083", "0059"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "fed089904c10b81c036adddedddebe7b",
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5b2",
  "birthdate": 981039600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217668f0017f7698300009c",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.20"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Major Depressive Disorder-Active (Code List: 2.16.840.1.113883.3.526.3.1491)",
    "end_time": 1326630000,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1326630000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "5217668f0017f7698300009b",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1326632400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1326628800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217668f0017f7698300009e",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1350306000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1350302400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Peds",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5b2",
  "insurance_providers": [{
    "_id": "521766870017f7698300009a",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000c9",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0108", "0036", "1365", "0002", "0024", "0004", "0384", "0041"],
  "measure_period_end": 1325307600000,
  "measure_period_start": 1293858000000,
  "medical_record_number": "e05ff19bd33566173fd742d4b9831f1f",
  "medications": [{
    "_id": "5217668f0017f7698300009d",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1009145"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Dispensed: ADHD Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1171)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1326632400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.8",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1326632400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["dispensed"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5b4",
  "birthdate": -231415200,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766b20017f769830000a9",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["416053008"]
    },
    "description": "Diagnosis, Active: Breast Cancer ER or PR Positive (Code List: 2.16.840.1.113883.3.526.3.1303)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330678800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766b20017f769830000ae",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["109886000"],
      "ICD-9-CM": ["174.0"],
      "ICD-10-CM": ["C50.011"]
    },
    "description": "Diagnosis, Active: Breast Cancer (Code List: 2.16.840.1.113883.3.526.3.389)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330680600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521766b20017f769830000aa",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330682400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330678800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766b20017f769830000af",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1336212000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1336208400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Cancer_Adult_Female",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5b4",
  "insurance_providers": [{
    "_id": "521766a70017f769830000a8",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000ca",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0387", "0384", "0002", "0028", "0033", "0024", "0004", "0031", "0032"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "846c1c2ba8370c2f5504b315cc4b1d5d",
  "procedures": [{
    "_id": "521766b20017f769830000ab",
    "codes": {
      "SNOMED-CT": ["116783008"]
    },
    "description": "Procedure, Result: Clinical Staging Procedure (Code List: 2.16.840.1.113883.3.526.3.1098)",
    "end_time": 1330682400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.63",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330680600,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766b20017f769830000ac",
      "codes": {
        "SNOMED-CT": ["433431000124101"]
      },
      "description": "Breast Cancer Regional Lymph Node Status N3"
    }, {
      "_id": "521766b20017f769830000ad",
      "codes": {
        "SNOMED-CT": ["433411000124107"]
      },
      "description": "Breast Distant Metastasis Status M0"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5ae",
  "birthdate": 554824800,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217663f0017f76983000061",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["185"],
      "SNOMED-CT": ["254900004"],
      "ICD-10-CM": ["C61"]
    },
    "description": "Diagnosis, Active: Prostate Cancer (Code List: 2.16.840.1.113883.3.526.3.319)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217663f0017f76983000062",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["109838007"],
      "ICD-9-CM": ["153.0"],
      "ICD-10-CM": ["C18.0"]
    },
    "description": "Diagnosis, Active: Colon Cancer (Code List: 2.16.840.1.113883.3.526.3.391)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "5217663f0017f7698300005a",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1332766800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1332761400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217663f0017f76983000067",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1335186000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1335182400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Cancer_Adult_Male",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5ae",
  "insurance_providers": [{
    "_id": "52165efc044a115bac000001",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "52165efc044a115bac000002",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-5D1EF9B76A48",
  "measure_ids": ["0385", "0389", "0421", "0384", "0028", "0034", "0110", "0038", "0002", "0031", "0004", "0387", "1365"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "cce1bd3b83676d7a9b286b374b4c34f8",
  "procedures": [{
    "_id": "5217663f0017f7698300005d",
    "codes": {
      "SNOMED-CT": ["116783008"]
    },
    "description": "Procedure, Result: Clinical Staging Procedure (Code List: 2.16.840.1.113883.3.526.3.1098)",
    "end_time": 1332765000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.63",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217663f0017f7698300005e",
      "codes": {
        "SNOMED-CT": ["433581000124101"]
      },
      "description": "Colon Distant Metastasis Status M0"
    }, {
      "_id": "5217663f0017f7698300005f",
      "codes": {
        "SNOMED-CT": ["433571000124104"]
      },
      "description": "Colon Cancer Regional Lymph Node Status N2b"
    }, {
      "_id": "5217663f0017f76983000060",
      "codes": {
        "SNOMED-CT": ["433491000124102"]
      },
      "description": "Colon Cancer Primary Tumor Size T4a"
    }]
  }, {
    "_id": "5217663f0017f76983000063",
    "codes": {
      "SNOMED-CT": ["116783008"]
    },
    "description": "Procedure, Result: Clinical Staging Procedure (Code List: 2.16.840.1.113883.3.526.3.1098)",
    "end_time": 1332765000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.63",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217663f0017f76983000064",
      "codes": {
        "SNOMED-CT": ["433361000124104"]
      },
      "description": "Prostate Cancer Primary Tumor Size T2a"
    }]
  }, {
    "_id": "5217663f0017f76983000068",
    "codes": {
      "LOINC": ["25031-6"]
    },
    "description": "Diagnostic Study, Performed: Bone Scan (Code List: 2.16.840.1.113883.3.526.3.320)",
    "end_time": 1335184200,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.3",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1335182400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "5217663f0017f76983000069",
    "codes": {
      "SNOMED-CT": ["10492003"],
      "CPT": ["55810"]
    },
    "description": "Procedure, Performed: Prostate Cancer Treatment (Code List: 2.16.840.1.113883.3.526.3.398)",
    "end_time": 1335186000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1335184200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "5217663f0017f7698300006a",
    "codes": {
      "CPT": ["77427"],
      "SNOMED-CT": ["84755001"]
    },
    "description": "Procedure, Performed: Radiation Treatment Management (Code List: 2.16.840.1.113883.3.526.3.1026)",
    "end_time": 1335186000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1335185100,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "5217663f0017f7698300005b",
    "codes": {
      "LOINC": ["10508-0"]
    },
    "description": "Laboratory Test, Result: Prostate Specific Antigen Test (Code List: 2.16.840.1.113883.3.526.3.401)",
    "end_time": 1332761400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1332761400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217663f0017f7698300005c",
      "scalar": "6",
      "units": "ng/mL"
    }]
  }, {
    "_id": "5217663f0017f76983000065",
    "codes": {
      "LOINC": ["35266-6"]
    },
    "description": "Laboratory Test, Result: Gleason Score (Code List: 2.16.840.1.113883.3.526.3.397)",
    "end_time": 1332763200,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217663f0017f76983000066",
      "scalar": "4",
      "units": ""
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5ab",
  "birthdate": 981039600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217662a0017f76983000045",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["042"],
      "SNOMED-CT": ["111880001"],
      "ICD-10-CM": ["B20"]
    },
    "description": "Diagnosis, Active: HIV (Code List: 2.16.840.1.113883.3.464.1003.120.12.1003)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 981190800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217662a0017f76983000047",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["109564008"],
      "ICD-9-CM": ["521.00"],
      "ICD-10-CM": ["K02.3"]
    },
    "description": "Diagnosis, Active: Dental Caries (Code List: 2.16.840.1.113883.3.464.1003.125.12.1004)",
    "end_time": 1336046400,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1336042800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "5217662a0017f76983000046",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1336046400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1336042800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Dental_Peds",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5ab",
  "insurance_providers": [{
    "_id": "521766230017f76983000044",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000cb",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["ChildDentalDecay", "0036", "PrimaryCariesPrevention", "0004", "0028", "0002", "0041", "0384", "0403", "0024"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "b5633133e3421216ced2bdef4dbf382d",
  "procedures": [{
    "_id": "5217662a0017f76983000048",
    "codes": {
      "SNOMED-CT": ["234723000"],
      "CDT": ["D1206"]
    },
    "description": "Procedure, Performed: Fluoride Varnish Application for Children (Code List: 2.16.840.1.113883.3.464.1003.125.12.1002)",
    "end_time": 1336046400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1336042800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5af",
  "birthdate": 381423600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217665b0017f7698300006d",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["190330002"],
      "ICD-9-CM": ["250.00"],
      "ICD-10-CM": ["E10.10"]
    },
    "description": "Diagnosis, Active: Diabetes (Code List: 2.16.840.1.113883.3.464.1003.103.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330250400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "5217665b0017f7698300006c",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330250400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330246800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Diabetes_Adult",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5af",
  "insurance_providers": [{
    "_id": "521766400017f7698300006b",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000cc",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0055", "0052", "0059", "0036", "0056", "0062", "0064", "0032", "CholesterolScreeningRisk", "0024", "0002", "0043", "0004", "0384", "0389"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "0a26a978d07240b0f917e96727db31d8",
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "5217665b0017f7698300006e",
    "codes": {
      "LOINC": ["17855-8"]
    },
    "description": "Laboratory Test, Result: HbA1c Laboratory Test (Code List: 2.16.840.1.113883.3.464.1003.198.12.1013)",
    "end_time": 1330250400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330250400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217665b0017f7698300006f",
      "scalar": "8",
      "units": "%"
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5c5",
  "birthdate": 1010156400,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767a50017f76983000160",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["190330002"],
      "ICD-9-CM": ["250.00"],
      "ICD-10-CM": ["E10.10"]
    },
    "description": "Diagnosis, Active: Diabetes (Code List: 2.16.840.1.113883.3.464.1003.103.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1296554400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521767a50017f76983000161",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99381"]
    },
    "description": "Encounter, Performed: Diabetes Visit (Code List: 2.16.840.1.113883.3.464.1003.103.12.1012)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1296558000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1296554400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767a50017f76983000162",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99381"]
    },
    "description": "Encounter, Performed: Diabetes Visit (Code List: 2.16.840.1.113883.3.464.1003.103.12.1012)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1325376000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1325376000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767a50017f76983000163",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99381"]
    },
    "description": "Encounter, Performed: Diabetes Visit (Code List: 2.16.840.1.113883.3.464.1003.103.12.1012)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1349871300,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1349870400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Diabetes_Peds",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5c5",
  "insurance_providers": [{
    "_id": "520b3c45044a111cf000000e",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "520b3c45044a111cf000000f",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-57F49972361A",
  "measure_ids": ["0060", "ChildDentalDecay", "0024", "0022", "0034", "0002", "0038", "0004", "0384", "PrimaryCariesPrevention", "0033", "1365", "0041"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "ee85c89f24946e2ddca12c6edc5181dc",
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5ac",
  "birthdate": -912416400,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766300017f7698300004c",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["362.02"],
      "SNOMED-CT": ["4855003"],
      "ICD-10-CM": ["E08.319"]
    },
    "description": "Diagnosis, Active: Diabetic Retinopathy (Code List: 2.16.840.1.113883.3.526.3.327)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1325679000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766300017f7698300004d",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["111513000"]
    },
    "description": "Diagnosis, Active: Primary Open Angle Glaucoma (POAG) (Code List: 2.16.840.1.113883.3.526.3.326)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1325680200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521766300017f7698300004b",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["92002"]
    },
    "description": "Encounter, Performed: Ophthalmological Services (Code List: 2.16.840.1.113883.3.526.3.1285)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1325682000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766300017f76983000050",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["92002"]
    },
    "description": "Encounter, Performed: Ophthalmological Services (Code List: 2.16.840.1.113883.3.526.3.1285)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328187600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328184000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Eye_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5ac",
  "insurance_providers": [{
    "_id": "5217662a0017f76983000049",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000cd",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0086", "0088", "0564", "0055", "0089", "0002", "0419", "0384"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "5f118631f09abdbdeb1962dc28bfeb27",
  "procedures": [{
    "_id": "521766300017f7698300004a",
    "codes": {
      "SNOMED-CT": ["10178000"],
      "CPT": ["66840"]
    },
    "description": "Procedure, Performed: Cataract Surgery (Code List: 2.16.840.1.113883.3.526.3.1411)",
    "end_time": 1325682000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766300017f7698300004e",
    "codes": {
      "LOINC": ["32451-7"]
    },
    "description": "Diagnostic Study, Result: Macular Exam (Code List: 2.16.840.1.113883.3.526.3.1251)",
    "end_time": 1325680200,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.11",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325680200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766300017f7698300004f",
      "codes": {
        "SNOMED-CT": ["193350004"]
      },
      "description": "Macular Edema Findings Present"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5c9",
  "birthdate": -91962000,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521768090017f7698300018a",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["250.40"],
      "SNOMED-CT": ["75524006"]
    },
    "description": "Diagnosis, Active: CHD or CHD Risk Equivalent (Code List: 2.16.840.1.113883.3.600.863)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1332756000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521768090017f7698300018b",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["161894002"],
      "ICD-9-CM": ["721.3"],
      "ICD-10-CM": ["M43.27"]
    },
    "description": "Diagnosis, Active: Low Back Pain (Code List: 2.16.840.1.113883.3.464.1003.113.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1332756000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521768090017f7698300018f",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["160603005"]
    },
    "description": "Patient Characteristic: Current Cigarette Smoker (Code List: 2.16.840.1.113883.3.600.2390)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.1001",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521768090017f7698300018d",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1332759600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1332756000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521768090017f7698300018e",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1340622000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Adult",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5c9",
  "insurance_providers": [{
    "_id": "521767ea0017f76983000189",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000ce",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["CholesterolScreeningTest", "BPScreening", "0421", "0419", "ClosingReferralLoop", "0710", "0052", "0041", "0038", "0110", "0418", "0028", "CholesterolScreeningRisk", "0104", "0002", "0004", "DementiaCognitive", "0384", "FastingLDLTest", "0389"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "b54a4e3ab37de7e5f8094793afb8a699",
  "procedures": [{
    "_id": "521768090017f7698300018c",
    "codes": {
      "SNOMED-CT": ["103697008"]
    },
    "description": "Intervention, Performed: Referral (Code List: 2.16.840.1.113883.3.464.1003.101.12.1046)",
    "end_time": 1332756900,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.46",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1332756000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": []
}, {
  "_id": "5203afe2f7305cbf316eb5c1",
  "birthdate": -788688000,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767720017f76983000124",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10091002"],
      "ICD-9-CM": ["428.0"],
      "ICD-10-CM": ["I50.1"]
    },
    "description": "Diagnosis, Active: Heart Failure (Code List: 2.16.840.1.113883.3.526.3.376)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1327831200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521767720017f76983000125",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["094.1"],
      "SNOMED-CT": ["51928006"],
      "ICD-10-CM": ["A52.17"]
    },
    "description": "Diagnosis, Active: Dementia & Mental Degenerations (Code List: 2.16.840.1.113883.3.526.3.1005)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1327834800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521767720017f7698300011f",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1312196400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1312192800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767720017f76983000121",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1317466800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1317463200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767720017f76983000123",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1327834800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1327831200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767720017f76983000126",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1338548400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1338544800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Geriatric",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5c1",
  "insurance_providers": [{
    "_id": "5217675e0017f7698300011e",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000cf",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["FSAHip", "0034", "FSAKnee", "DementiaCognitive", "FSACHF", "0036", "0104", "0004", "0055", "0002", "0041", "0022", "0384", "0033", "0043"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "20a80b26a1bfa70740e243ea5ac1fea6",
  "procedures": [{
    "_id": "521767720017f76983000120",
    "codes": {
      "SNOMED-CT": ["15163009"],
      "CPT": ["27130"],
      "HCPCS": ["S2118"]
    },
    "description": "Procedure, Performed: Primary THA Procedure (Code List: 2.16.840.1.113883.3.464.1003.198.12.1006)",
    "end_time": 1314874800,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1314871200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521767720017f76983000122",
    "codes": {
      "SNOMED-CT": ["179344006"],
      "CPT": ["27447"]
    },
    "description": "Procedure, Performed: Primary TKA Procedure (Code List: 2.16.840.1.113883.3.464.1003.198.12.1007)",
    "end_time": 1320145200,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1320141600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5b3",
  "birthdate": 791650800,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217b0e80017f7451900003d",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["195708003"],
      "ICD-9-CM": ["460"],
      "ICD-10-CM": ["J00"]
    },
    "description": "Diagnosis, Active: Upper Respiratory Infection (Code List: 2.16.840.1.113883.3.464.1003.102.12.1022)",
    "end_time": 1330426800,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1327921200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217b0e80017f74519000040",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["426656000"],
      "ICD-10-CM": ["J45.30"]
    },
    "description": "Diagnosis, Active: Persistent Asthma (Code List: 2.16.840.1.113883.3.464.1003.102.12.1023)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335787500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217b0e80017f74519000041",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["034.0"],
      "SNOMED-CT": ["1532007"],
      "ICD-10-CM": ["J02.8"]
    },
    "description": "Diagnosis, Active: Acute Pharyngitis (Code List: 2.16.840.1.113883.3.464.1003.102.12.1011)",
    "end_time": 1338379500,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335787500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "5217b0e80017f7451900003c",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1327924800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1327921200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217b0e80017f7451900003f",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1335790800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1335787200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Peds",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5b3",
  "insurance_providers": [{
    "_id": "5217b0d40017f7451900003a",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5217b0d40017f7451900003b",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-5D1EF9B76A48",
  "measure_ids": ["0033", "0041", "0002", "0418", "0060", "0024", "0069", "0038", "0036", "0028", "0110", "0004", "0018", "FSAHip", "0384", "CholesterolScreeningRisk"],
  "measure_period_end": 1325307600000,
  "measure_period_start": 1293858000000,
  "medical_record_number": "d045df54952043573bb6a94c374c8420",
  "medications": [{
    "_id": "5217b0e80017f7451900003e",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["105152"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Antibiotic Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1001)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1327924800,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1327924800,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217b0e80017f74519000042",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["105152"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Antibiotic Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1001)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1335788100,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1335788100,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217b0e80017f74519000043",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["105152"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Active: Antibiotic Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1001)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1338379200,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.13",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1335789000,
    "statusOfMedication": null,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "5217b0e80017f74519000044",
    "codes": {
      "LOINC": ["10524-7"]
    },
    "description": "Laboratory Test, Order: Pap Test (Code List: 2.16.840.1.113883.3.464.1003.108.12.1017)",
    "end_time": 1335789000,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.50",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1335789000,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5b9",
  "birthdate": 878317200,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521e31570017f7cf83000016",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["042"],
      "SNOMED-CT": ["111880001"],
      "ICD-10-CM": ["B20"]
    },
    "description": "Diagnosis, Active: HIV (Code List: 2.16.840.1.113883.3.464.1003.120.12.1003)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330601400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521e31570017f7cf83000015",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99202"]
    },
    "description": "Encounter, Performed: HIV Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1047)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330603200,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521e31570017f7cf83000017",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99202"]
    },
    "description": "Encounter, Performed: HIV Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1047)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1341144000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1341140400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "HIV_Peds",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5b9",
  "insurance_providers": [{
    "_id": "521e314f0017f7cf83000013",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "521e314f0017f7cf83000014",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": "40280381-3E93-D1AF-013F-3F5C54B20354",
  "measure_ids": ["0405", "0038", "0407", "0055", "0002", "0004", "0024", "0403", "0384"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "929dd1f2c4c54c024fd4d18b1307fdb1",
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "521e31570017f7cf83000018",
    "codes": {
      "LOINC": ["24467-3"]
    },
    "description": "Laboratory Test, Result: CD4+ Count (Code List: 2.16.840.1.113883.3.464.1003.121.12.1004)",
    "end_time": 1341140400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1341140400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521e31570017f7cf83000019",
      "scalar": "150",
      "units": "mm3"
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5c6",
  "birthdate": -880893000,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "52308b100017f7b584000004",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["093.20"],
      "SNOMED-CT": ["8722008"],
      "ICD-10-CM": ["A52.03"]
    },
    "description": "Diagnosis, Active: Valvular Heart Disease (Code List: 2.16.840.1.113883.3.464.1003.104.12.1017)",
    "end_time": 1309514400,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1305021600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "52308b100017f7b584000005",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["195080001"],
      "ICD-9-CM": ["427.31"],
      "ICD-10-CM": ["I48.0"]
    },
    "description": "Diagnosis, Active: Atrial Fibrillation/Flutter (Code List: 2.16.840.1.113883.3.117.1.7.1.202)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1305021600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "52308b100017f7b584000008",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10091002"],
      "ICD-9-CM": ["428.0"],
      "ICD-10-CM": ["I50.1"]
    },
    "description": "Diagnosis, Active: Heart Failure (Code List: 2.16.840.1.113883.3.526.3.376)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "52308b100017f7b58400000c",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["123641001"],
      "ICD-9-CM": ["411.0"],
      "ICD-10-CM": ["I20.0"]
    },
    "description": "Diagnosis, Active: Coronary Artery Disease No MI (Code List: 2.16.840.1.113883.3.526.3.369)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "52308b100017f7b58400000d",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["981000124106"]
    },
    "description": "Diagnosis, Active: Moderate or Severe LVSD (Code List: 2.16.840.1.113883.3.526.3.1090)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "52308b100017f7b58400000e",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10725009"],
      "ICD-9-CM": ["401.1"]
    },
    "description": "Diagnosis, Active: Hypertension (Code List: 2.16.840.1.113883.3.464.1003.104.12.1016)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "52308b100017f7b584000013",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["123641001"],
      "ICD-9-CM": ["411.0"],
      "ICD-10-CM": ["I20.0"]
    },
    "description": "Diagnosis, Active: Ischemic Vascular Disease (Code List: 2.16.840.1.113883.3.464.1003.104.12.1003)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "52308b100017f7b584000006",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1305025200,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1305021600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "52308b100017f7b584000007",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330606800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330603200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "52308b100017f7b584000017",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1341147600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1341144000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "52308b100017f7b58400001a",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1356008400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1356004800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Heart_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5c6",
  "insurance_providers": [{
    "_id": "52308afc0017f7b584000001",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "52308afc0017f7b584000002",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-66BC02DA4DEE",
  "measure_ids": ["0070", "0081", "CholesterolScreeningTest", "CholesterolScreeningRisk", "HypertensionImprovement", "FSACHF", "0075", "0083", "0387", "0018", "0032", "0002", "0041", "0004", "ADE_TTR", "0068", "0384", "0062", "FastingLDLTest", "0060"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "2678a4e396aaec03b860d5aeadcad8e6",
  "medications": [{
    "_id": "52308b100017f7b584000003",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["855288"]
    },
    "cumulativeMedicationDuration": {
      "scalar": "391",
      "units": "days"
    },
    "deliveryMethod": null,
    "description": "Medication, Active: Warfarin (Code List: 2.16.840.1.113883.3.117.1.7.1.232)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": null,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.13",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1305021600,
    "statusOfMedication": null,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "52308b100017f7b584000016",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["855288"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Active: Warfarin (Code List: 2.16.840.1.113883.3.117.1.7.1.232)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": null,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.13",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1330606800,
    "statusOfMedication": null,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "52308b100017f7b584000009",
    "codes": {
      "LOINC": ["8480-6"]
    },
    "description": "Physical Exam: Systolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1032)",
    "end_time": 1330603500,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "52308b100017f7b58400000a",
      "scalar": "150",
      "units": "mmHg"
    }]
  }, {
    "_id": "52308b100017f7b584000014",
    "codes": {
      "LOINC": ["8462-4"]
    },
    "description": "Physical Exam, Finding: Diastolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1033)",
    "end_time": 1330603500,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "52308b100017f7b584000015",
      "scalar": "90",
      "units": "mmHg"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "52308b100017f7b58400000b",
    "codes": {
      "LOINC": ["12773-8"]
    },
    "description": "Laboratory Test, Performed: LDL Code (Code List: 2.16.840.1.113883.3.600.872)",
    "end_time": 1330603500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.5",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "52308b100017f7b58400000f",
    "codes": {
      "LOINC": ["34714-6"]
    },
    "description": "Laboratory Test, Result: INR (Code List: 2.16.840.1.113883.3.117.1.7.1.213)",
    "end_time": 1330603500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "52308b100017f7b584000010",
      "scalar": "2.2",
      "units": ""
    }]
  }, {
    "_id": "52308b100017f7b584000011",
    "codes": {
      "LOINC": ["2085-9"]
    },
    "description": "Laboratory Test, Result: HDL-C Laboratory Test (Code List: 2.16.840.1.113883.3.464.1003.104.12.1012)",
    "end_time": 1330603500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "52308b100017f7b584000012",
      "scalar": "37",
      "units": "mg/dL"
    }]
  }, {
    "_id": "52308b100017f7b584000018",
    "codes": {
      "LOINC": ["34714-6"]
    },
    "description": "Laboratory Test, Result: INR (Code List: 2.16.840.1.113883.3.117.1.7.1.213)",
    "end_time": 1341144300,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1341144300,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "52308b100017f7b584000019",
      "scalar": "2.0",
      "units": ""
    }]
  }, {
    "_id": "52308b100017f7b58400001b",
    "codes": {
      "LOINC": ["34714-6"]
    },
    "description": "Laboratory Test, Result: INR (Code List: 2.16.840.1.113883.3.117.1.7.1.213)",
    "end_time": 1356005100,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1356005100,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "52308b100017f7b58400001c",
      "scalar": "2.7",
      "units": ""
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5b7",
  "birthdate": 596991600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766ef0017f769830000c9",
    "causeOfDeath": null,
    "codes": {
      "ICD-10-CM": ["O66.2"],
      "ICD-9-CM": ["V27.0"]
    },
    "description": "Diagnosis, Active: Live Birth or Delivery (Code List: 2.16.840.1.113883.3.67.1.101.1.273)",
    "end_time": 1328094000,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1328090400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521766ef0017f769830000c7",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328094000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328090400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Pregnancy_Adult",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5b7",
  "insurance_providers": [{
    "_id": "521766e40017f769830000c6",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d0",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "A",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0608", "0403", "0033", "0407", "0405", "0002", "0041", "0004", "0419", "0384", "0038"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "61aa020431420dce8f53b74352a990fe",
  "procedures": [{
    "_id": "521766ef0017f769830000c8",
    "codes": {
      "SNOMED-CT": ["10745001"],
      "CPT": ["59400"]
    },
    "description": "Procedure, Performed: Delivery (Code List: 2.16.840.1.113883.3.67.1.101.1.278)",
    "end_time": 1328094000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328090400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": []
}, {
  "_id": "5203afe2f7305cbf316eb5b6",
  "birthdate": 665420400,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766e30017f769830000bd",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.21"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Major Depression (Code List: 2.16.840.1.113883.3.464.1003.105.12.1007)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1349093100,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766e30017f769830000c2",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["305.00"],
      "SNOMED-CT": ["7200002"],
      "ICD-10-CM": ["F10"]
    },
    "description": "Diagnosis, Active: Alcohol and Drug Dependence (Code List: 2.16.840.1.113883.3.464.1003.106.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1351771200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521766e30017f769830000bb",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1320152400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1320148800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766e30017f769830000bc",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1349096400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1349092800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766e30017f769830000c1",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1351774800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1351771200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766e30017f769830000c5",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["171047005"]
    },
    "description": "Encounter, Performed: Alcohol and Drug Dependence Treatment (Code List: 2.16.840.1.113883.3.464.1003.106.12.1005)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1351774800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1351773900,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5b6",
  "insurance_providers": [{
    "_id": "521766d80017f769830000ba",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d1",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0710", "0105", "0108", "0036", "0712", "0004", "0104", "0002", "0110", "0384", "CholesterolScreeningRisk", "0418", "0419", "0024"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "7a86cc6d87cb84461ea190e7c706d81b",
  "medications": [{
    "_id": "521766e30017f769830000c0",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1000048"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Ordered: BH Antidepressant medication (Code List: 2.16.840.1.113883.3.1257.1.972)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1349096400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1349096400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521766e30017f769830000be",
    "codes": {
      "SNOMED-CT": ["105355005"],
      "CPT": ["99408"],
      "HCPCS": ["H0001"]
    },
    "description": "Procedure, Performed: BH Assessment for alcohol or other drugs (Code List: 2.16.840.1.113883.3.1257.1.1604)",
    "end_time": 1349093100,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1349093100,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766e30017f769830000bf",
    "codes": {
      "SNOMED-CT": ["225337009"]
    },
    "description": "Intervention, Performed: Suicide Risk Assessment (Code List: 2.16.840.1.113883.3.526.3.1484)",
    "end_time": 1349093100,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.46",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1349093100,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766e30017f769830000c3",
    "codes": {
      "LOINC": ["44249-1"]
    },
    "description": "Risk Category Assessment: PHQ-9 Tool (Code List: 2.16.840.1.113883.3.67.1.101.11.723)",
    "end_time": 1351773000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1351773000,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766e30017f769830000c4",
      "codes": {
        "LOINC": ["44249-1"]
      },
      "description": "PHQ-9 Tool"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5c8",
  "birthdate": 1320156000,
  "clinicalTrialParticipant": null,
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521767ea0017f76983000187",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328090400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328086800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Infant",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5c8",
  "insurance_providers": [{
    "_id": "521767e30017f76983000186",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d2",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["1401", "0060", "0031", "0002", "0024", "0004", "0384", "1365"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "fdea0c22270417d9e59f20b07f642679",
  "procedures": [{
    "_id": "521767ea0017f76983000188",
    "codes": {
      "SNOMED-CT": ["428231000124106"]
    },
    "description": "Intervention, Performed: Maternal Post Partum Depression Care (Code List: 2.16.840.1.113883.3.464.1003.111.12.1013)",
    "end_time": 1328088600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.46",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328088600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5bb",
  "birthdate": 981039600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217672b0017f769830000f0",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.20"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Major Depressive Disorder-Active (Code List: 2.16.840.1.113883.3.526.3.1491)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1328185800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "5217672b0017f769830000ef",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328187600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328184000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217672b0017f769830000f3",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1329224400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1329220800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Peds",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5bb",
  "insurance_providers": [{
    "_id": "521767250017f769830000ee",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d3",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0108", "0036", "1365", "0002", "0028", "0004", "0384"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "91bd37f9cebf7b6ef9f72d7fd6148a81",
  "medications": [{
    "_id": "5217672b0017f769830000f2",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1009145"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Dispensed: ADHD Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1171)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1328187600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.8",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1328187600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["dispensed"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "5217672b0017f769830000f1",
    "codes": {
      "SNOMED-CT": ["225337009"]
    },
    "description": "Intervention, Performed: Suicide Risk Assessment (Code List: 2.16.840.1.113883.3.526.3.1484)",
    "end_time": 1328187000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.46",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328187000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5ad",
  "birthdate": -231415200,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766350017f76983000053",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["416053008"]
    },
    "description": "Diagnosis, Active: Breast Cancer ER or PR Positive (Code List: 2.16.840.1.113883.3.526.3.1303)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330678800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766360017f76983000057",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["109886000"],
      "ICD-9-CM": ["174.0"],
      "ICD-10-CM": ["C50.011"]
    },
    "description": "Diagnosis, Active: Breast Cancer (Code List: 2.16.840.1.113883.3.526.3.389)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330680600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521766350017f76983000052",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330682400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330678800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766360017f76983000059",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1336212000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1336208400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Cancer_Adult_Female",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5ad",
  "insurance_providers": [{
    "_id": "521766300017f76983000051",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d4",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0387", "0384", "0028", "0002", "0041", "0004"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "1be81ce59da982792026cc82d95bc10e",
  "medications": [{
    "_id": "521766360017f76983000058",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1098617"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Tamoxifen or Aromatase Inhibitor Therapy (Code List: 2.16.840.1.113883.3.526.3.1315)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1330682400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1330682400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521766350017f76983000054",
    "codes": {
      "SNOMED-CT": ["116783008"]
    },
    "description": "Procedure, Result: Clinical Staging Procedure (Code List: 2.16.840.1.113883.3.526.3.1098)",
    "end_time": 1330680600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.63",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330680600,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766350017f76983000055",
      "codes": {
        "SNOMED-CT": ["433431000124101"]
      },
      "description": "Breast Cancer Regional Lymph Node Status N3"
    }, {
      "_id": "521766350017f76983000056",
      "codes": {
        "SNOMED-CT": ["433411000124107"]
      },
      "description": "Breast Distant Metastasis Status M0"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5b0",
  "allergies": [],
  "birthdate": 554824800,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766630017f76983000079",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["109838007"],
      "ICD-9-CM": ["153.0"],
      "ICD-10-CM": ["C18.0"]
    },
    "description": "Diagnosis, Active: Colon Cancer (Code List: 2.16.840.1.113883.3.526.3.391)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766630017f7698300007a",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["185"],
      "SNOMED-CT": ["254900004"],
      "ICD-10-CM": ["C61"]
    },
    "description": "Diagnosis, Active: Prostate Cancer (Code List: 2.16.840.1.113883.3.526.3.319)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521766630017f76983000072",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1332766800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1332761400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766630017f7698300007e",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1335186000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1335182400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Cancer_Adult_Male",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5b0",
  "insurance_providers": [{
    "_id": "52165f54044a115bac000014",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "52165f54044a115bac000015",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-6B81E6E455A5",
  "measure_ids": ["0385", "0389", "0421", "0384", "0028", "0034", "0038", "0002", "0004"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "0085074bb549ffefffa6e16ff34df140",
  "medications": [{
    "_id": "521766630017f7698300007d",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["200327"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Chemotherapy for Colon Cancer - capecitabine (Code List: 2.16.840.1.113883.3.526.3.1288)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1332765000,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1332765000,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521766630017f76983000075",
    "codes": {
      "SNOMED-CT": ["116783008"]
    },
    "description": "Procedure, Result: Clinical Staging Procedure (Code List: 2.16.840.1.113883.3.526.3.1098)",
    "end_time": 1332765000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.63",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766630017f76983000076",
      "codes": {
        "SNOMED-CT": ["433581000124101"]
      },
      "description": "Colon Distant Metastasis Status M0"
    }, {
      "_id": "521766630017f76983000077",
      "codes": {
        "SNOMED-CT": ["433491000124102"]
      },
      "description": "Colon Cancer Primary Tumor Size T4a"
    }, {
      "_id": "521766630017f76983000078",
      "codes": {
        "SNOMED-CT": ["433571000124104"]
      },
      "description": "Colon Cancer Regional Lymph Node Status N2b"
    }]
  }, {
    "_id": "521766630017f7698300007b",
    "codes": {
      "SNOMED-CT": ["116783008"]
    },
    "description": "Procedure, Result: Clinical Staging Procedure (Code List: 2.16.840.1.113883.3.526.3.1098)",
    "end_time": 1332765000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.63",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766630017f7698300007c",
      "codes": {
        "SNOMED-CT": ["433361000124104"]
      },
      "description": "Prostate Cancer Primary Tumor Size T2a"
    }]
  }, {
    "_id": "521766630017f7698300007f",
    "codes": {
      "SNOMED-CT": ["10492003"],
      "CPT": ["55810"]
    },
    "description": "Procedure, Performed: Prostate Cancer Treatment (Code List: 2.16.840.1.113883.3.526.3.398)",
    "end_time": 1335186000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1335184200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766630017f76983000080",
    "codes": {
      "CPT": ["77427"],
      "SNOMED-CT": ["84755001"]
    },
    "description": "Procedure, Performed: Radiation Treatment Management (Code List: 2.16.840.1.113883.3.526.3.1026)",
    "end_time": 1335186000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1335185100,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766630017f76983000081",
    "codes": {
      "LOINC": ["38208-5"]
    },
    "description": "Risk Category Assessment: Standardized Pain Assessment Tool (Code List: 2.16.840.1.113883.3.526.3.1028)",
    "end_time": 1335185400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1335185400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766630017f76983000082",
      "scalar": "performed",
      "units": ""
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "521766630017f76983000070",
    "codes": {
      "LOINC": ["10508-0"]
    },
    "description": "Laboratory Test, Result: Prostate Specific Antigen Test (Code List: 2.16.840.1.113883.3.526.3.401)",
    "end_time": 1332761400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1332761400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766630017f76983000071",
      "scalar": "6",
      "units": "ng/mL"
    }]
  }, {
    "_id": "521766630017f76983000073",
    "codes": {
      "LOINC": ["35266-6"]
    },
    "description": "Laboratory Test, Result: Gleason Score (Code List: 2.16.840.1.113883.3.526.3.397)",
    "end_time": 1332763200,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1332763200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766630017f76983000074",
      "scalar": "4",
      "units": ""
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5c0",
  "birthdate": 381403800,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217675e0017f76983000113",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["190330002"],
      "ICD-9-CM": ["250.00"],
      "ICD-10-CM": ["E10.10"]
    },
    "description": "Diagnosis, Active: Diabetes (Code List: 2.16.840.1.113883.3.464.1003.103.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1270116000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217675e0017f76983000119",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["127013003"],
      "ICD-9-CM": ["250.40"]
    },
    "description": "Diagnosis, Active: Diabetic Nephropathy (Code List: 2.16.840.1.113883.3.464.1003.109.12.1004)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1333274400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "5217675e0017f76983000114",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1333274400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1333270800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Diabetes_Adult",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5c0",
  "insurance_providers": [{
    "_id": "521767430017f76983000112",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d5",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0055", "0052", "0059", "0036", "0056", "0062", "0064", "CholesterolScreeningRisk", "0032", "0024", "0041", "0002", "0004", "0384"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "343731b99c6bdb35a1fc31ce9ed6f889",
  "procedures": [{
    "_id": "5217675e0017f76983000115",
    "codes": {
      "SNOMED-CT": ["134388005"]
    },
    "description": "Physical Exam, Performed: Sensory Exam of Foot (Code List: 2.16.840.1.113883.3.464.1003.103.12.1014)",
    "end_time": 1333272600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.57",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333272600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "5217675e0017f76983000116",
    "codes": {
      "SNOMED-CT": ["252779009"]
    },
    "description": "Physical Exam, Performed: Retinal or Dilated Eye Exam (Code List: 2.16.840.1.113883.3.464.1003.115.12.1088)",
    "end_time": 1333272600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.57",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333272600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "5217675e0017f76983000117",
    "codes": {
      "SNOMED-CT": ["401191002"]
    },
    "description": "Physical Exam, Performed: Visual Exam of Foot (Code List: 2.16.840.1.113883.3.464.1003.103.12.1013)",
    "end_time": 1333272600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.57",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333272600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "5217675e0017f76983000118",
    "codes": {
      "SNOMED-CT": ["91161007"]
    },
    "description": "Physical Exam, Performed: Pulse Exam of Foot (Code List: 2.16.840.1.113883.3.464.1003.103.12.1015)",
    "end_time": 1333272600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.57",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333272600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "5217675e0017f7698300011a",
    "codes": {
      "LOINC": ["13457-7"]
    },
    "description": "Laboratory Test, Result: LDL-C Laboratory Test (Code List: 2.16.840.1.113883.3.526.3.1248)",
    "end_time": 1333274400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1333274400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217675e0017f7698300011b",
      "scalar": "88",
      "units": "mg/dL"
    }]
  }, {
    "_id": "5217675e0017f7698300011c",
    "codes": {
      "LOINC": ["17855-8"]
    },
    "description": "Laboratory Test, Result: HbA1c Laboratory Test (Code List: 2.16.840.1.113883.3.464.1003.198.12.1013)",
    "end_time": 1333274400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1333274400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217675e0017f7698300011d",
      "scalar": "10",
      "units": "%"
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5c3",
  "birthdate": 1012575600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "52286d930017f75a69000003",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["190330002"],
      "ICD-9-CM": ["250.00"],
      "ICD-10-CM": ["E10.10"]
    },
    "description": "Diagnosis, Active: Diabetes (Code List: 2.16.840.1.113883.3.464.1003.103.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1296561600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "52286d930017f75a69000004",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99381"]
    },
    "description": "Encounter, Performed: Diabetes Visit (Code List: 2.16.840.1.113883.3.464.1003.103.12.1012)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1296565200,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1296561600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "52286d930017f75a69000005",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99381"]
    },
    "description": "Encounter, Performed: Diabetes Visit (Code List: 2.16.840.1.113883.3.464.1003.103.12.1012)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328097600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328094000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "52286d930017f75a69000008",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99381"]
    },
    "description": "Encounter, Performed: Diabetes Visit (Code List: 2.16.840.1.113883.3.464.1003.103.12.1012)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1349871300,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1349870400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Diabetes_Peds",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5c3",
  "insurance_providers": [{
    "_id": "52286d870017f75a69000001",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "52286d870017f75a69000002",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-57F49972361A",
  "measure_ids": ["0060", "0041", "0062", "0002", "0036", "0033", "0004", "0384", "1365"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "eb6af018e11320f5c163624beb83767d",
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "52286d930017f75a69000006",
    "codes": {
      "LOINC": ["17855-8"]
    },
    "description": "Laboratory Test, Result: HbA1c Laboratory Test (Code List: 2.16.840.1.113883.3.464.1003.198.12.1013)",
    "end_time": 1328097600,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1328097600,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "52286d930017f75a69000007",
      "scalar": "7",
      "units": "%"
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5bc",
  "birthdate": -912416400,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767330017f769830000f5",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["111513000"]
    },
    "description": "Diagnosis, Active: Primary Open Angle Glaucoma (POAG) (Code List: 2.16.840.1.113883.3.526.3.326)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521767330017f769830000f6",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["362.02"],
      "SNOMED-CT": ["4855003"],
      "ICD-10-CM": ["E08.319"]
    },
    "description": "Diagnosis, Active: Diabetic Retinopathy (Code List: 2.16.840.1.113883.3.526.3.327)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521767330017f769830000fb",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["92002"]
    },
    "description": "Encounter, Performed: Ophthalmological Services (Code List: 2.16.840.1.113883.3.526.3.1285)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1325682000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767330017f76983000102",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["92002"]
    },
    "description": "Encounter, Performed: Ophthalmological Services (Code List: 2.16.840.1.113883.3.526.3.1285)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328187600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328184000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Eye_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5bc",
  "insurance_providers": [{
    "_id": "5217672b0017f769830000f4",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d6",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0086", "0088", "0089", "0564", "0068", "0565", "0032", "0002", "0041", "0004", "0384"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "a6300c43651965991a4308ffaeb5381d",
  "procedures": [{
    "_id": "521767330017f769830000f7",
    "codes": {
      "LOINC": ["71484-0"]
    },
    "description": "Diagnostic Study, Result: Cup to Disc Ratio (Code List: 2.16.840.1.113883.3.526.3.1333)",
    "end_time": 1325678400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.11",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767330017f769830000f8",
      "scalar": "0.8",
      "units": ""
    }]
  }, {
    "_id": "521767330017f769830000f9",
    "codes": {
      "LOINC": ["71486-5"]
    },
    "description": "Diagnostic Study, Result: Optic Disc Exam for Structural Abnormalities (Code List: 2.16.840.1.113883.3.526.3.1334)",
    "end_time": 1325678400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.11",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767330017f769830000fa",
      "scalar": "positive",
      "units": ""
    }]
  }, {
    "_id": "521767330017f769830000fc",
    "codes": {
      "SNOMED-CT": ["10178000"],
      "CPT": ["66840"]
    },
    "description": "Procedure, Performed: Cataract Surgery (Code List: 2.16.840.1.113883.3.526.3.1411)",
    "end_time": 1325682000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325678400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521767330017f769830000fd",
    "codes": {
      "LOINC": ["32451-7"]
    },
    "description": "Diagnostic Study Result: Macular Exam (Code List: 2.16.840.1.113883.3.526.3.1251)",
    "end_time": 1325678700,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.11",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325678700,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767330017f769830000fe",
      "codes": {
        "SNOMED-CT": ["428341000124108"]
      },
      "description": "Macular Edema Findings Absent"
    }, {
      "_id": "521767330017f769830000ff",
      "codes": {
        "SNOMED-CT": ["193349004"]
      },
      "description": "Level of Severity of Retinopathy Findings"
    }]
  }, {
    "_id": "521767330017f76983000100",
    "codes": {
      "SNOMED-CT": ["428341000124108"]
    },
    "description": "Communication: From Provider to Provider: Macular Edema Findings Absent (Code List: 2.16.840.1.113883.3.526.3.1286)",
    "end_time": 1325682000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.29",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325681100,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767330017f76983000101",
    "codes": {
      "SNOMED-CT": ["193349004"]
    },
    "description": "Communication: From Provider to Provider: Level of Severity of Retinopathy Findings (Code List: 2.16.840.1.113883.3.526.3.1324)",
    "end_time": 1325682000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.29",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1325681100,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767330017f76983000103",
    "codes": {
      "SNOMED-CT": ["419775003"]
    },
    "description": "Physical Exam, Finding: Best Corrected Visual Acuity (Code List: 2.16.840.1.113883.3.526.3.1488)",
    "end_time": 1328185800,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328185800,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767330017f76983000104",
      "codes": {
        "SNOMED-CT": ["422497000"]
      },
      "description": "Visual acuity 20/40 or Better"
    }]
  }, {
    "_id": "521767330017f76983000105",
    "codes": {
      "SNOMED-CT": ["13767004"],
      "CPT": ["65235"]
    },
    "description": "Procedure, Performed: Removal Procedures (Code List: 2.16.840.1.113883.3.526.3.1436)",
    "end_time": 1328187600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328186700,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5b1",
  "birthdate": -91962000,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766870017f76983000085",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["161894002"],
      "ICD-9-CM": ["721.3"],
      "ICD-10-CM": ["M43.27"]
    },
    "description": "Diagnosis, Active: Low Back Pain (Code List: 2.16.840.1.113883.3.464.1003.113.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1333188000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766870017f7698300008a",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["250.40"],
      "SNOMED-CT": ["75524006"]
    },
    "description": "Diagnosis, Active: CHD or CHD Risk Equivalent (Code List: 2.16.840.1.113883.3.600.863)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1333191600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766870017f76983000094",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["160603005"]
    },
    "description": "Patient Characteristic: Tobacco User (Code List: 2.16.840.1.113883.3.526.3.1170)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.1001",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521766870017f76983000084",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1333191600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1333188000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766870017f76983000091",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1340622000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Adult",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5b1",
  "insurance_providers": [{
    "_id": "521766640017f76983000083",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d7",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["CholesterolScreeningTest", "BPScreening", "0421", "0419", "ClosingReferralLoop", "0710", "0052", "0041", "0038", "0110", "0418", "0028", "CholesterolScreeningRisk", "0104", "0031", "0032", "0002", "0018", "0043", "0004", "0384", "0108", "FastingLDLTest"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "511b530c8662f8df97eb97b3eefa0618",
  "medications": [{
    "_id": "521766870017f76983000097",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1046847"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Tobacco Use Cessation Pharmacotherapy (Code List: 2.16.840.1.113883.3.526.3.1190)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1340622000,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1340622000,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521766870017f76983000086",
    "codes": {
      "SNOMED-CT": ["103697008"]
    },
    "description": "Intervention, Performed: Referral (Code List: 2.16.840.1.113883.3.464.1003.101.12.1046)",
    "end_time": 1333188000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.46",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333188000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766870017f76983000087",
    "codes": {
      "SNOMED-CT": ["428191000124101"]
    },
    "description": "Procedure, Performed: Current Medications Documented SNMD (Code List: 2.16.840.1.113883.3.600.1.462)",
    "end_time": 1333188900,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333188900,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766870017f76983000088",
    "codes": {
      "SNOMED-CT": ["371530004"]
    },
    "description": "Communication: From Provider to Provider: Consultant Report (Code List: 2.16.840.1.113883.3.464.1003.121.12.1006)",
    "end_time": 1333191600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.29",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333191600,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521766870017f76983000089",
    "codes": {
      "LOINC": ["24665-2"]
    },
    "description": "Diagnostic Study, Performed: X-Ray of Lower Spine (Code List: 2.16.840.1.113883.3.464.1003.113.12.1033)",
    "end_time": 1333191600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.3",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1333191600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766870017f7698300008b",
    "codes": {
      "LOINC": ["8480-6"]
    },
    "description": "Physical Exam, Finding: Systolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1032)",
    "end_time": 1340618400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766870017f7698300008c",
      "scalar": "110",
      "units": "mmHg"
    }]
  }, {
    "_id": "521766870017f7698300008d",
    "codes": {
      "LOINC": ["8462-4"]
    },
    "description": "Physical Exam, Finding: Diastolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1033)",
    "end_time": 1340618400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766870017f7698300008e",
      "scalar": "75",
      "units": "mmHg"
    }]
  }, {
    "_id": "521766870017f76983000092",
    "codes": {
      "LOINC": ["39156-5"]
    },
    "description": "Physical Exam, Finding: BMI LOINC Value (Code List: 2.16.840.1.113883.3.600.1.681)",
    "end_time": 1340618400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766870017f76983000093",
      "scalar": "22",
      "units": "kg/m2"
    }]
  }, {
    "_id": "521766870017f76983000098",
    "codes": {
      "LOINC": ["24604-1"],
      "HCPCS": ["G0202"]
    },
    "description": "Diagnostic Study, Result: Mammogram (Code List: 2.16.840.1.113883.3.464.1003.108.12.1018)",
    "end_time": 1340622000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.11",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1340622000,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766870017f76983000099",
      "codes": {
        "LOINC": ["24604-1"],
        "HCPCS": ["G0202"]
      },
      "description": "Mammogram"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "521766870017f7698300008f",
    "codes": {
      "LOINC": ["12773-8"]
    },
    "description": "Laboratory Test, Result: LDL Code (Code List: 2.16.840.1.113883.3.600.872)",
    "end_time": 1340618400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1340618400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766870017f76983000090",
      "scalar": "90",
      "units": "mg/dL"
    }]
  }, {
    "_id": "521766870017f76983000095",
    "codes": {
      "LOINC": ["10524-7"]
    },
    "description": "Laboratory Test, Result: Pap Test (Code List: 2.16.840.1.113883.3.464.1003.108.12.1017)",
    "end_time": 1340620200,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1340620200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766870017f76983000096",
      "codes": {
        "LOINC": ["10524-7"]
      },
      "description": "Pap Test"
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5b8",
  "birthdate": -788695200,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767000017f769830000d5",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10091002"],
      "ICD-9-CM": ["428.0"],
      "ICD-10-CM": ["I50.1"]
    },
    "description": "Diagnosis, Active: Heart Failure (Code List: 2.16.840.1.113883.3.526.3.376)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1328090400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521767000017f769830000da",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["094.1"],
      "SNOMED-CT": ["51928006"],
      "ICD-10-CM": ["A52.17"]
    },
    "description": "Diagnosis, Active: Dementia & Mental Degenerations (Code List: 2.16.840.1.113883.3.526.3.1005)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1328094000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521767000017f769830000cb",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1312196400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1312192800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767000017f769830000d0",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1317466800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1317463200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767000017f769830000d4",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328094000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328090400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767000017f769830000dd",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1338548400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1338544800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Geriatric",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5b8",
  "insurance_providers": [{
    "_id": "521766ef0017f769830000ca",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d8",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["FSAHip", "0034", "FSAKnee", "DementiaCognitive", "FSACHF", "0036", "0104", "0022", "0043", "0101", "0004", "0002", "0041", "0384", "0024"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "470f57b022eaeffd4d599078e851a56d",
  "medications": [{
    "_id": "521767000017f769830000d9",
    "administrationTiming": null,
    "codes": {
      "CVX": ["33"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Pneumococcal Vaccine (Code List: 2.16.840.1.113883.3.464.1003.110.12.1027)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1328094000,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1328094000,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "521767000017f769830000de",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1000351"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: High Risk Medications for the Elderly (Code List: 2.16.840.1.113883.3.464.1003.196.12.1253)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1338548400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1338548400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521767000017f769830000cc",
    "codes": {
      "LOINC": ["71955-9"]
    },
    "description": "Functional Status, Result: Functional Status Assessment for Knee Replacement (Code List: 2.16.840.1.113883.3.464.1003.118.12.1030)",
    "end_time": 1312196400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.88",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1312192800,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000cd",
    "codes": {
      "SNOMED-CT": ["12350003"],
      "CPT": ["44388"],
      "HCPCS": ["G0105"]
    },
    "description": "Procedure, Performed: Colonoscopy (Code List: 2.16.840.1.113883.3.464.1003.108.12.1020)",
    "end_time": 1312196400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1312192800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000ce",
    "codes": {
      "LOINC": ["71955-9"]
    },
    "description": "Functional Status, Result: Functional Status Assessment  for Hip Replacement (Code List: 2.16.840.1.113883.3.464.1003.118.12.1029)",
    "end_time": 1312196400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.88",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1312192800,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000cf",
    "codes": {
      "SNOMED-CT": ["15163009"],
      "CPT": ["27130"],
      "HCPCS": ["S2118"]
    },
    "description": "Procedure, Performed: Primary THA Procedure (Code List: 2.16.840.1.113883.3.464.1003.198.12.1006)",
    "end_time": 1314874800,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1314871200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000d1",
    "codes": {
      "SNOMED-CT": ["179344006"],
      "CPT": ["27447"]
    },
    "description": "Procedure, Performed: Primary TKA Procedure (Code List: 2.16.840.1.113883.3.464.1003.198.12.1007)",
    "end_time": 1320148800,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1320145200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000d2",
    "codes": {
      "LOINC": ["71938-5"]
    },
    "description": "Functional Status, Result: Functional Status Assessment for Heart Failure (Code List: 2.16.840.1.113883.3.464.1003.118.12.1031)",
    "end_time": 1328090400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.88",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328090400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000d3",
    "codes": {
      "LOINC": ["71955-9"]
    },
    "description": "Functional Status, Result: Functional Status Assessment  for Hip Replacement (Code List: 2.16.840.1.113883.3.464.1003.118.12.1029)",
    "end_time": 1328091300,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.88",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328090400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000d6",
    "codes": {
      "LOINC": ["71955-9"]
    },
    "description": "Functional Status, Result: Functional Status Assessment for Knee Replacement (Code List: 2.16.840.1.113883.3.464.1003.118.12.1030)",
    "end_time": 1328092200,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.88",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328091300,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000d7",
    "codes": {
      "LOINC": ["58151-2"]
    },
    "description": "Risk Category Assessment: Standardized Tools for Assessment of Cognition (Code List: 2.16.840.1.113883.3.526.3.1006)",
    "end_time": 1328092200,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1328092200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767000017f769830000d8",
      "scalar": "positive",
      "units": ""
    }]
  }, {
    "_id": "521767000017f769830000db",
    "codes": {
      "LOINC": ["71938-5"]
    },
    "description": "Functional Status, Result: Functional Status Assessment for Heart Failure (Code List: 2.16.840.1.113883.3.464.1003.118.12.1031)",
    "end_time": 1338544800,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.88",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1338544800,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }, {
    "_id": "521767000017f769830000dc",
    "codes": {
      "LOINC": ["73830-2"]
    },
    "description": "Risk Category Assessment: Falls Screening (Code List: 2.16.840.1.113883.3.464.1003.118.12.1028)",
    "end_time": 1338548400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1338544800,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5a6",
  "birthdate": 791650800,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217af3b0017f7ca1a000005",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["195708003"],
      "ICD-9-CM": ["460"],
      "ICD-10-CM": ["J00"]
    },
    "description": "Diagnosis, Active: Upper Respiratory Infection (Code List: 2.16.840.1.113883.3.464.1003.102.12.1022)",
    "end_time": 1329308100,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1327925700,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217af3b0017f7ca1a000008",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.21"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Depression diagnosis (Code List: 2.16.840.1.113883.3.600.145)",
    "end_time": 1333110600,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1327926600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217af3b0017f7ca1a00000d",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["426656000"],
      "ICD-10-CM": ["J45.30"]
    },
    "description": "Diagnosis, Active: Persistent Asthma (Code List: 2.16.840.1.113883.3.464.1003.102.12.1023)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335787500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217af3b0017f7ca1a000012",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["034.0"],
      "SNOMED-CT": ["1532007"],
      "ICD-10-CM": ["J02.8"]
    },
    "description": "Diagnosis, Active: Acute Pharyngitis (Code List: 2.16.840.1.113883.3.464.1003.102.12.1011)",
    "end_time": 1338381000,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335789000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "5217af3b0017f7ca1a000003",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1327928400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1327924800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217af3b0017f7ca1a000009",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1335790800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1335787200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Peds",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5a6",
  "insurance_providers": [{
    "_id": "5217af270017f7ca1a000001",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5217af270017f7ca1a000002",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": "40280381-3D61-56A7-013E-5D1EF9B76A48",
  "measure_ids": ["0033", "0041", "0002", "0418", "0060", "0024", "0069", "0038", "0036", "0018", "0034", "0004", "0031", "1365", "0384", "DementiaCognitive"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "0dbaf9336f7aa1590265250a0eebe548",
  "medications": [{
    "_id": "5217af3b0017f7ca1a00000c",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1085805"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Dispensed: Preferred Asthma Therapy (Code List: 2.16.840.1.113883.3.464.1003.196.12.1212)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1335787500,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.8",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1335787500,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["dispensed"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217af3b0017f7ca1a000014",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["105152"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Antibiotic Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1001)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1335789600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1335789600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "5217af3b0017f7ca1a000004",
    "codes": {
      "SNOMED-CT": ["442333005"],
      "CPT": ["90653"]
    },
    "description": "Procedure, Performed: Influenza Vaccination (Code List: 2.16.840.1.113883.3.526.3.402)",
    "end_time": 1327924800,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1327924800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "5217af3b0017f7ca1a000006",
    "codes": {
      "LOINC": ["73831-0"]
    },
    "description": "Risk Category Assessment: Adolescent Depression Screening (Code List: 2.16.840.1.113883.3.600.2452)",
    "end_time": 1327926300,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1327926300,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217af3b0017f7ca1a000007",
      "codes": {
        "SNOMED-CT": ["428171000124102"]
      },
      "description": "Negative Depression Screening"
    }]
  }, {
    "_id": "5217af3b0017f7ca1a000013",
    "codes": {
      "SNOMED-CT": ["11816003"],
      "CPT": ["97802"]
    },
    "description": "Intervention, Performed: Counseling for Nutrition (Code List: 2.16.840.1.113883.3.464.1003.195.12.1003)",
    "end_time": 1335789900,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.46",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1335789000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "5217af3b0017f7ca1a00000a",
    "codes": {
      "LOINC": ["11268-0"]
    },
    "description": "Laboratory Test, Result: Group A Streptococcus Test (Code List: 2.16.840.1.113883.3.464.1003.198.12.1012)",
    "end_time": 1335787200,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1335787200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217af3b0017f7ca1a00000b",
      "scalar": "positive",
      "units": ""
    }]
  }, {
    "_id": "5217af3b0017f7ca1a00000e",
    "codes": {
      "LOINC": ["13217-5"]
    },
    "description": "Laboratory Test, Result: Chlamydia Screening (Code List: 2.16.840.1.113883.3.464.1003.110.12.1052)",
    "end_time": 1335787500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1335787500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "5217af3b0017f7ca1a00000f",
      "codes": {
        "LOINC": ["13217-5"]
      },
      "description": "Chlamydia Screening"
    }]
  }, {
    "_id": "5217af3b0017f7ca1a000010",
    "codes": {
      "LOINC": ["10524-7"]
    },
    "description": "Laboratory Test, Order: Pap Test (Code List: 2.16.840.1.113883.3.464.1003.108.12.1017)",
    "end_time": 1335788100,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.50",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1335788100,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "values": [{
      "_id": "5217af3b0017f7ca1a000011",
      "scalar": "performed",
      "units": ""
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5c4",
  "birthdate": 878317200,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521e30800017f7cf8300000b",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["042"],
      "SNOMED-CT": ["111880001"],
      "ICD-10-CM": ["B20"]
    },
    "description": "Diagnosis, Active: HIV (Code List: 2.16.840.1.113883.3.464.1003.120.12.1003)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521e30800017f7cf8300000a",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99202"]
    },
    "description": "Encounter, Performed: HIV Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1047)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330603200,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521e30800017f7cf8300000e",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99202"]
    },
    "description": "Encounter, Performed: HIV Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1047)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1341144000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1341140400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521e30800017f7cf83000012",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "SNOMED-CT": ["185349003"],
      "CPT": ["99202"]
    },
    "description": "Encounter, Performed: HIV Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1047)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1346500800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1346497200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "HIV_Peds",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5c4",
  "insurance_providers": [{
    "_id": "521e30750017f7cf83000008",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "521e30750017f7cf83000009",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": "40280381-3E93-D1AF-013F-3F5C54B20354",
  "measure_ids": ["0405", "0038", "0407", "0036", "0002", "0041", "0004", "0024", "0403", "0384", "HIVRNAControl"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "29cecb1da08efd331fce823e12b607d5",
  "medications": [{
    "_id": "521e30800017f7cf83000011",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["142118"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Pneumocystis Jiroveci Pneumonia (PCP) Prophylaxis (Code List: 2.16.840.1.113883.3.464.1003.196.12.1076)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1346497200,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1346497200,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "521e30800017f7cf8300000c",
    "codes": {
      "LOINC": ["24467-3"]
    },
    "description": "Laboratory Test, Result: CD4+ Count (Code List: 2.16.840.1.113883.3.464.1003.121.12.1004)",
    "end_time": 1341140400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1341140400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521e30800017f7cf8300000d",
      "scalar": "150",
      "units": "mm3"
    }]
  }, {
    "_id": "521e30800017f7cf8300000f",
    "codes": {
      "LOINC": ["20447-9"]
    },
    "description": "Laboratory Test, Result: HIV Viral Load (Code List: 2.16.840.1.113883.3.464.1003.120.12.1002)",
    "end_time": 1341140400,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1341140400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521e30800017f7cf83000010",
      "scalar": "150",
      "units": "mL"
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5aa",
  "birthdate": -880880400,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766220017f7698300002b",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10091002"],
      "ICD-9-CM": ["428.0"],
      "ICD-10-CM": ["I50.1"]
    },
    "description": "Diagnosis, Active: Heart Failure (Code List: 2.16.840.1.113883.3.526.3.376)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766220017f76983000030",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["981000124106"]
    },
    "description": "Diagnosis, Active: Moderate or Severe LVSD (Code List: 2.16.840.1.113883.3.526.3.1090)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766220017f76983000032",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["123641001"],
      "ICD-9-CM": ["411.0"],
      "ICD-10-CM": ["I20.0"]
    },
    "description": "Diagnosis, Active: Ischemic Vascular Disease (Code List: 2.16.840.1.113883.3.464.1003.104.12.1003)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766220017f76983000033",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["123641001"],
      "ICD-9-CM": ["411.0"],
      "ICD-10-CM": ["I20.0"]
    },
    "description": "Diagnosis, Active: Coronary Artery Disease No MI (Code List: 2.16.840.1.113883.3.526.3.369)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766230017f7698300003e",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10725009"],
      "ICD-9-CM": ["401.1"]
    },
    "description": "Diagnosis, Active: Hypertension (Code List: 2.16.840.1.113883.3.464.1003.104.12.1016)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330605000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521766220017f7698300002a",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330606800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330603200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766230017f7698300003f",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1356008400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1356004800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Heart_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5aa",
  "insurance_providers": [{
    "_id": "5217660c0017f76983000029",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000d9",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0070", "0081", "CholesterolScreeningTest", "CholesterolScreeningRisk", "HypertensionImprovement", "FSACHF", "0075", "0083", "0387", "0018", "0068", "0004", "0002", "0086", "0419", "0421", "0384", "ADE_TTR", "FastingLDLTest", "0405", "0024"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "bd2d8e0fd774e32f623e1fe5ad44781f",
  "medications": [{
    "_id": "521766220017f76983000031",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1000001"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: ACE inhibitor or ARB (Code List: 2.16.840.1.113883.3.526.3.1139)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1330603500,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1330603500,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "521766220017f76983000034",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["200031"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Beta Blocker Therapy for LVSD (Code List: 2.16.840.1.113883.3.526.3.1184)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1330603500,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1330603500,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "521766220017f76983000037",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["197374"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Active: Aspirin and Other Anti-thrombotics (Code List: 2.16.840.1.113883.3.464.1003.196.12.1211)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": null,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.13",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1330603500,
    "statusOfMedication": null,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521766220017f7698300002c",
    "codes": {
      "LOINC": ["8480-6"]
    },
    "description": "Physical Exam, Finding: Systolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1032)",
    "end_time": 1330603500,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766220017f7698300002d",
      "scalar": "150 ",
      "units": "mmHg"
    }]
  }, {
    "_id": "521766220017f7698300002e",
    "codes": {
      "LOINC": ["8462-4"]
    },
    "description": "Physical Exam, Finding: Diastolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1033)",
    "end_time": 1330603500,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766220017f7698300002f",
      "scalar": "60 ",
      "units": "mmHg"
    }]
  }, {
    "_id": "521766230017f76983000040",
    "codes": {
      "LOINC": ["8480-6"]
    },
    "description": "Physical Exam, Finding: Systolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1032)",
    "end_time": 1356005100,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1356005100,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766230017f76983000041",
      "scalar": "130",
      "units": "mmHg"
    }]
  }, {
    "_id": "521766230017f76983000042",
    "codes": {
      "LOINC": ["8462-4"]
    },
    "description": "Physical Exam, Finding: Diastolic Blood Pressure (Code List: 2.16.840.1.113883.3.526.3.1033)",
    "end_time": 1356005100,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.18",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1356005100,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766230017f76983000043",
      "scalar": "60",
      "units": "mmHg"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "521766220017f76983000035",
    "codes": {
      "LOINC": ["13457-7"]
    },
    "description": "Laboratory Test, Result: LDL-C Laboratory Test (Code List: 2.16.840.1.113883.3.526.3.1248)",
    "end_time": 1330603500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766220017f76983000036",
      "scalar": "80",
      "units": "mg/dL"
    }]
  }, {
    "_id": "521766220017f76983000038",
    "codes": {
      "LOINC": ["2085-9"]
    },
    "description": "Laboratory Test, Result: HDL-C Laboratory Test (Code List: 2.16.840.1.113883.3.464.1003.104.12.1012)",
    "end_time": 1330603500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766220017f76983000039",
      "scalar": "50",
      "units": "mg/dL"
    }]
  }, {
    "_id": "521766230017f7698300003a",
    "codes": {
      "LOINC": ["2093-3"]
    },
    "description": "Laboratory Test, Result: Total Cholesterol Laboratory Test (Code List: 2.16.840.1.113883.3.464.1003.104.12.1013)",
    "end_time": 1330603500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766230017f7698300003b",
      "scalar": "157",
      "units": ""
    }]
  }, {
    "_id": "521766230017f7698300003c",
    "codes": {
      "LOINC": ["12951-0"]
    },
    "description": "Laboratory Test, Result: Triglycerides (Code List: 2.16.840.1.113883.3.600.883)",
    "end_time": 1330603500,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.12",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766230017f7698300003d",
      "scalar": "90",
      "units": "mg/dL"
    }]
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5ba",
  "birthdate": 596991600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767240017f769830000e6",
    "causeOfDeath": null,
    "codes": {
      "ICD-10-CM": ["O66.2"],
      "ICD-9-CM": ["V27.0"]
    },
    "description": "Diagnosis, Active: Live Birth or Delivery (Code List: 2.16.840.1.113883.3.67.1.101.1.273)",
    "end_time": 1350734400,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1350730800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521767240017f769830000e7",
    "causeOfDeath": null,
    "codes": {
      "ICD-10-CM": ["O62.3"]
    },
    "description": "Diagnosis, Active: Pregnancy Dx (Code List: 2.16.840.1.113883.3.600.1.1623)",
    "end_time": 1330599600,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330596000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521767240017f769830000eb",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330599600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330596000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767240017f769830000ed",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1350734400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1350730800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Pregnancy_Adult",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5ba",
  "insurance_providers": [{
    "_id": "521767080017f769830000e5",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000da",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "B",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0608", "0403", "0033", "0407", "0405", "0028", "0002", "0052", "0004", "0421", "0384"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "88130abfa702d8f53ac7be76e9d24a58",
  "procedures": [{
    "_id": "521767240017f769830000e9",
    "codes": {
      "LOINC": ["24533-2"]
    },
    "description": "Diagnostic Study, Order: X-Ray Study (all inclusive) (Code List: 2.16.840.1.113883.3.464.1003.198.12.1034)",
    "end_time": 1330599600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.40",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null
  }, {
    "_id": "521767240017f769830000ec",
    "codes": {
      "SNOMED-CT": ["10745001"],
      "CPT": ["59400"]
    },
    "description": "Procedure, Performed: Delivery (Code List: 2.16.840.1.113883.3.67.1.101.1.278)",
    "end_time": 1350734400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1350730800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": [{
    "_id": "521767240017f769830000e8",
    "codes": {
      "LOINC": ["19080-1"]
    },
    "description": "Laboratory Test, Ordered: Pregnancy Test (Code List: 2.16.840.1.113883.3.464.1003.111.12.1011)",
    "end_time": 1330596000,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.50",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330596000,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null
  }, {
    "_id": "521767240017f769830000ea",
    "codes": {
      "LOINC": ["10674-0"],
      "CPT": ["80055"]
    },
    "description": "Laboratory Test, Performed: HBsAg (Code List: 2.16.840.1.113883.3.67.1.101.1.279)",
    "end_time": 1330599600,
    "free_text": null,
    "interpretation": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.5",
    "reason": null,
    "referenceRange": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }]
}, {
  "_id": "5203afe2f7305cbf316eb5c2",
  "birthdate": 665404200,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767840017f7698300014e",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.21"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Major Depression (Code List: 2.16.840.1.113883.3.464.1003.105.12.1007)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1317472200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521767840017f7698300014a",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1317474000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1317470400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767840017f7698300014f",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1339938000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1339934400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5c2",
  "insurance_providers": [{
    "_id": "5217677d0017f76983000149",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000db",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "C",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0105", "0710", "0002", "0004", "0031", "0384", "0421", "0418"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "185be4f0c1ea87f63e4326e45db87bdf",
  "medications": [{
    "_id": "521767840017f7698300014b",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1000048"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Dispensed: Antidepressant Medication (Code List: 2.16.840.1.113883.3.464.1003.196.12.1213)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1317470400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.8",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1317470400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["dispensed"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521767840017f7698300014c",
    "codes": {
      "LOINC": ["44249-1"]
    },
    "description": "Risk Category Assessment: PHQ-9 Tool (Code List: 2.16.840.1.113883.3.67.1.101.11.723)",
    "end_time": 1317472200,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1317472200,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767840017f7698300014d",
      "scalar": "10",
      "units": "points"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5c7",
  "birthdate": -1041237000,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767e30017f76983000181",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10091002"],
      "ICD-9-CM": ["428.0"],
      "ICD-10-CM": ["I50.1"]
    },
    "description": "Diagnosis, Active: Heart Failure (Code List: 2.16.840.1.113883.3.526.3.376)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521767e30017f76983000182",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["109267002"],
      "ICD-9-CM": ["141.0"],
      "ICD-10-CM": ["C00.0"]
    },
    "description": "Diagnosis, Active: All Cancer (Code List: 2.16.840.1.113883.3.464.1003.108.12.1011)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330603500,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521767e30017f76983000183",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["10725009"],
      "ICD-9-CM": ["401.1"]
    },
    "description": "Diagnosis, Active: Essential Hypertension (Code List: 2.16.840.1.113883.3.464.1003.104.12.1011)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1341136800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521767e30017f76983000180",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330606800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330603200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767e30017f76983000184",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1341140400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1341136800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Adult",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5c7",
  "insurance_providers": [{
    "_id": "521767b90017f7698300017f",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000dc",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "C",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["CholesterolScreeningTest", "BPScreening", "0421", "0419", "ClosingReferralLoop", "0710", "0052", "0041", "0038", "0110", "0418", "0028", "CholesterolScreeningRisk", "0104", "0031", "0032", "0002", "0018", "FSACHF", "0033", "0004", "0384", "BPScreen", "FastingLDLTest", "0405"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "d156a6d38e10efc30eda3cace7456537",
  "medications": [],
  "procedures": [{
    "_id": "521767e30017f76983000185",
    "codes": {
      "SNOMED-CT": ["108241001"],
      "CPT": ["90920"],
      "HCPCS": ["G0257"]
    },
    "description": "Procedure, Performed: Dialysis Services (Code List: 2.16.840.1.113883.3.464.1003.109.12.1013)",
    "end_time": 1341147600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.6",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1341136800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": []
}, {
  "_id": "5203afe2f7305cbf316eb5a8",
  "birthdate": 949417200,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "5217660c0017f76983000023",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["102872000"],
      "ICD-9-CM": ["633.11"],
      "ICD-10-CM": ["O00.1"]
    },
    "description": "Diagnosis, Active: Pregnancy (Code List: 2.16.840.1.113883.3.526.3.378)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335785400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217660c0017f76983000024",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["426656000"],
      "ICD-10-CM": ["J45.30"]
    },
    "description": "Diagnosis, Active: Persistent Asthma (Code List: 2.16.840.1.113883.3.464.1003.102.12.1023)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335785400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217660c0017f76983000025",
    "causeOfDeath": null,
    "codes": {
      "ICD-9-CM": ["034.0"],
      "SNOMED-CT": ["1532007"],
      "ICD-10-CM": ["J02.8"]
    },
    "description": "Diagnosis, Active: Acute Pharyngitis (Code List: 2.16.840.1.113883.3.464.1003.102.12.1011)",
    "end_time": 1338377400,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335785400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217660c0017f76983000027",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["195708003"],
      "ICD-9-CM": ["460"],
      "ICD-10-CM": ["J00"]
    },
    "description": "Diagnosis, Active: Upper Respiratory Infection (Code List: 2.16.840.1.113883.3.464.1003.102.12.1022)",
    "end_time": 1335785400,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335785400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "5217660c0017f76983000028",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["190905008"],
      "ICD-9-CM": ["277.00"],
      "ICD-10-CM": ["E84.0"]
    },
    "description": "Diagnosis, Active: Cystic Fibrosis (Code List: 2.16.840.1.113883.3.464.1003.102.12.1002)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1335787200,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "EXCL",
  "effective_time": null,
  "encounters": [{
    "_id": "5217660c0017f7698300001c",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1323090000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1323086400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217660c0017f7698300001e",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1328356800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1328353200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217660c0017f76983000020",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1334494800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1334491200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217660c0017f76983000022",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1335787200,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1335783600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Peds",
  "gender": "F",
  "id": "5203afe2f7305cbf316eb5a8",
  "insurance_providers": [{
    "_id": "521765e60017f7698300001b",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000dd",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "C",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0033", "0041", "0002", "0418", "0060", "0024", "0069", "0038", "0036", "0018", "0052", "0004", "0108", "0384", "1365"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "5407e0ea5126420644b503c66153eb3c",
  "medications": [{
    "_id": "5217660c0017f7698300001d",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1009145"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Active: ADHD Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1171)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": null,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.13",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1323086400,
    "statusOfMedication": null,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217660c0017f7698300001f",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1009145"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Dispensed: ADHD Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1171)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1328356800,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.8",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1328356800,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["dispensed"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217660c0017f76983000021",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["105152"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Active: Antibiotic Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1001)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": null,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.13",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1334493000,
    "statusOfMedication": null,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217660c0017f76983000026",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["105152"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Order: Antibiotic Medications (Code List: 2.16.840.1.113883.3.464.1003.196.12.1001)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1335785400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.17",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1335785400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["ordered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": []
}, {
  "_id": "5203afe2f7305cbf316eb5b5",
  "birthdate": 65804400,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521766d80017f769830000b2",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.21"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Depression diagnosis (Code List: 2.16.840.1.113883.3.600.145)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330596000,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766d80017f769830000b3",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["161894002"],
      "ICD-9-CM": ["721.3"],
      "ICD-10-CM": ["M43.27"]
    },
    "description": "Diagnosis, Active: Low Back Pain (Code List: 2.16.840.1.113883.3.464.1003.113.12.1001)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330597800,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766d80017f769830000b4",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["162607003"]
    },
    "description": "Diagnosis, Active: Limited Life Expectancy (Code List: 2.16.840.1.113883.3.526.3.1259)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }, {
    "_id": "521766d80017f769830000b5",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["109267002"],
      "ICD-9-CM": ["141.0"],
      "ICD-10-CM": ["C00.0"]
    },
    "description": "Diagnosis, Active: All Cancer (Code List: 2.16.840.1.113883.3.464.1003.108.12.1011)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521766d80017f769830000b1",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1330599600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1330596000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521766d80017f769830000b9",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1341140400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1341136800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "Heart_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5b5",
  "insurance_providers": [{
    "_id": "521766b20017f769830000b0",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000de",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "C",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0070", "0081", "CholesterolScreeningTest", "CholesterolScreeningRisk", "HypertensionImprovement", "FSACHF", "0075", "0083", "0387", "0018", "0068", "0004", "0002", "0036", "0052", "0419", "0028", "0043", "ADE_TTR", "0418", "0384", "0712", "0421", "DementiaCognitive"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "8130b2ff5774f1593c86eba8dca4c37b",
  "medications": [],
  "procedures": [{
    "_id": "521766d80017f769830000b6",
    "codes": {
      "SNOMED-CT": ["428191000124101"]
    },
    "description": "Procedure, Performed: Current Medications Documented SNMD (Code List: 2.16.840.1.113883.3.600.1.462)",
    "end_time": 1330599600,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": true,
    "negationReason": {
      "code_system": "SNOMED-CT",
      "code": "183932001"
    },
    "oid": "2.16.840.1.113883.3.560.1.106",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null
  }, {
    "_id": "521766d80017f769830000b7",
    "codes": {
      "LOINC": ["73832-8"]
    },
    "description": "Risk Category Assessment: Adult Depression Screening (Code List: 2.16.840.1.113883.3.600.2449)",
    "end_time": 1330600500,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1330599600,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521766d80017f769830000b8",
      "codes": {
        "SNOMED-CT": ["428171000124102"]
      },
      "description": "Depression Screening Result"
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": []
}, {
  "_id": "5203afe2f7305cbf316eb5be",
  "birthdate": 663240600,
  "clinicalTrialParticipant": null,
  "conditions": [{
    "_id": "521767390017f7698300010a",
    "causeOfDeath": null,
    "codes": {
      "SNOMED-CT": ["14183003"],
      "ICD-9-CM": ["296.21"],
      "ICD-10-CM": ["F32.0"]
    },
    "description": "Diagnosis, Active: Major Depression (Code List: 2.16.840.1.113883.3.464.1003.105.12.1007)",
    "end_time": null,
    "free_text": null,
    "mood_code": "EVN",
    "name": null,
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.2",
    "ordinality": null,
    "priority": null,
    "reason": null,
    "severity": null,
    "specifics": null,
    "start_time": 1316867400,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "time_of_death": null,
    "type": null
  }],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "521767390017f76983000108",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1316869200,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1316865600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "521767390017f7698300010d",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1351774800,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1351771200,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "BH_Adult",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5be",
  "insurance_providers": [{
    "_id": "521767330017f76983000106",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000df",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "D",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0105", "0710", "0002", "0004", "0384", "0018"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "697e147f076648275e518e7b3ff41dcd",
  "medications": [{
    "_id": "521767390017f76983000107",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1000048"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Dispensed: Antidepressant Medication (Code List: 2.16.840.1.113883.3.464.1003.196.12.1213)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1316865600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.8",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1316865600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["dispensed"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "521767390017f76983000109",
    "administrationTiming": null,
    "codes": {
      "RxNorm": ["1000048"]
    },
    "cumulativeMedicationDuration": {
      "scalar": "106",
      "units": "days"
    },
    "deliveryMethod": null,
    "description": "Medication, Active: Antidepressant Medication (Code List: 2.16.840.1.113883.3.464.1003.196.12.1213)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1325937600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.13",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1316867400,
    "statusOfMedication": null,
    "status_code": {
      "SNOMED-CT": ["55561003"],
      "HL7 ActStatus": ["active"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "procedures": [{
    "_id": "521767390017f7698300010b",
    "codes": {
      "LOINC": ["44249-1"]
    },
    "description": "Risk Category Assessment: PHQ-9 Tool (Code List: 2.16.840.1.113883.3.67.1.101.11.723)",
    "end_time": 1316867400,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1316867400,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767390017f7698300010c",
      "scalar": "10",
      "units": ""
    }]
  }, {
    "_id": "521767390017f7698300010e",
    "codes": {
      "LOINC": ["44249-1"]
    },
    "description": "Risk Category Assessment: PHQ-9 Tool (Code List: 2.16.840.1.113883.3.67.1.101.11.723)",
    "end_time": 1351773000,
    "free_text": null,
    "incisionTime": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.21",
    "ordinality": null,
    "performer_id": null,
    "reason": null,
    "site": null,
    "source": null,
    "specifics": null,
    "start_time": 1351773000,
    "status_code": {
      "HL7 ActStatus": [null]
    },
    "time": null,
    "values": [{
      "_id": "521767390017f7698300010f",
      "scalar": "4",
      "units": ""
    }]
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}, {
  "_id": "5203afe2f7305cbf316eb5bf",
  "birthdate": 1276869600,
  "clinicalTrialParticipant": null,
  "conditions": [],
  "deathdate": null,
  "description": "",
  "description_category": "DENOM",
  "effective_time": null,
  "encounters": [{
    "_id": "521767430017f76983000111",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1333278000,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1333274400,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Peds",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5bf",
  "insurance_providers": [{
    "_id": "521767390017f76983000110",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000e0",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "D",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0038", "0069", "0405", "0002", "0041", "0004", "0384", "0108"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "258ee9087c5a5fe359ceb3aafff0dd76",
  "medications": [],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep",
  "vital_signs": []
}, {
  "_id": "5203afe2f7305cbf316eb5bd",
  "birthdate": 1276869600,
  "clinicalTrialParticipant": null,
  "conditions": [],
  "deathdate": null,
  "description": "",
  "description_category": "NUMER",
  "effective_time": null,
  "encounters": [{
    "_id": "5217677d0017f7698300012b",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1283335200,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1283331600,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217677d0017f76983000132",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1298973600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1298970000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217677d0017f7698300013d",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1322733600,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1322730000,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }, {
    "_id": "5217677d0017f76983000146",
    "admitTime": null,
    "admitType": null,
    "codes": {
      "CPT": ["99201"]
    },
    "description": "Encounter, Performed: Office Visit (Code List: 2.16.840.1.113883.3.464.1003.101.12.1001)",
    "dischargeDisposition": null,
    "dischargeTime": null,
    "end_time": 1333274400,
    "free_text": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.79",
    "performer_id": null,
    "reason": null,
    "specifics": null,
    "start_time": 1333270800,
    "status_code": {
      "HL7 ActStatus": ["performed"]
    },
    "time": null,
    "transferFrom": null,
    "transferTo": null
  }],
  "ethnicity": {
    "code": "2186-5",
    "name": "Not Hispanic or Latino",
    "codeSystem": "CDC Race"
  },
  "expired": false,
  "first": "GP_Peds",
  "gender": "M",
  "id": "5203afe2f7305cbf316eb5bd",
  "insurance_providers": [{
    "_id": "521767730017f76983000127",
    "codes": {
      "SOP": ["349"]
    },
    "description": null,
    "end_time": null,
    "financial_responsibility_type": {
      "code": "SELF",
      "codeSystem": "HL7 Relationship Code"
    },
    "free_text": null,
    "member_id": "1234567890",
    "mood_code": "EVN",
    "name": "Other",
    "negationInd": null,
    "negationReason": null,
    "oid": null,
    "payer": {
      "_id": "5260698801fbdf80bb0000e1",
      "name": "Other"
    },
    "reason": null,
    "relationship": null,
    "specifics": null,
    "start_time": 1199163600,
    "status_code": null,
    "time": null,
    "type": "OT"
  }],
  "languages": [],
  "last": "E",
  "marital_status": null,
  "measure_id": null,
  "measure_ids": ["0038", "0069", "0022", "0002", "0036", "0004", "0384", "0108"],
  "measure_period_end": 1356930000000,
  "measure_period_start": 1325394000000,
  "medical_record_number": "ce83c561f62e245ad4e0ca648e9de0dd",
  "medications": [{
    "_id": "5217677c0017f76983000128",
    "administrationTiming": null,
    "codes": {
      "CVX": ["20"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: DTaP Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1214)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000129",
    "administrationTiming": null,
    "codes": {
      "CVX": ["20"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: DTaP Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1214)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1322733600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1322733600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300012a",
    "administrationTiming": null,
    "codes": {
      "CVX": ["48"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hemophilus Influenze B (HiB) Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1217)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1283335200,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1283335200,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300012c",
    "administrationTiming": null,
    "codes": {
      "CVX": ["33"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Pneumococcal Conjugate Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1221)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1283335200,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1283335200,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300012d",
    "administrationTiming": null,
    "codes": {
      "CVX": ["08"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hepatitis B Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1216)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1283335200,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1283335200,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300012e",
    "administrationTiming": null,
    "codes": {
      "CVX": ["10"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Inactivated Polio Vaccine (IPV) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1219)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1283335200,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1283335200,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300012f",
    "administrationTiming": null,
    "codes": {
      "CVX": ["20"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: DTaP Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1214)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1283335200,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1283335200,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000130",
    "administrationTiming": null,
    "codes": {
      "CVX": ["48"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hemophilus Influenze B (HiB) Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1217)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1322733600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1322733600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000131",
    "administrationTiming": null,
    "codes": {
      "CVX": ["48"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hemophilus Influenze B (HiB) Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1217)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1298973600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1298973600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000133",
    "administrationTiming": null,
    "codes": {
      "CVX": ["33"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Pneumococcal Conjugate Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1221)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1298973600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1298973600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000134",
    "administrationTiming": null,
    "codes": {
      "CVX": ["111"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Influenza Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1218)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1298973600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1298973600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000135",
    "administrationTiming": null,
    "codes": {
      "CVX": ["10"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Inactivated Polio Vaccine (IPV) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1219)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1298973600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1298973600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000136",
    "administrationTiming": null,
    "codes": {
      "CVX": ["116"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Rotavirus Vaccine (3 dose schedule) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1223)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1298973600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1298973600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000137",
    "administrationTiming": null,
    "codes": {
      "CVX": ["20"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: DTaP Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1214)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1298973600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1298973600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000138",
    "administrationTiming": null,
    "codes": {
      "CVX": ["08"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hepatitis B Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1216)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1298973600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1298973600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000139",
    "administrationTiming": null,
    "codes": {
      "CVX": ["10"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Inactivated Polio Vaccine (IPV) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1219)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1322733600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1322733600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300013a",
    "administrationTiming": null,
    "codes": {
      "CVX": ["33"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Pneumococcal Conjugate Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1221)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1322733600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1322733600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300013b",
    "administrationTiming": null,
    "codes": {
      "CVX": ["08"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hepatitis B Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1216)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1322733600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1322733600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300013c",
    "administrationTiming": null,
    "codes": {
      "CVX": ["111"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Influenza Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1218)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1322733600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1322733600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300013e",
    "administrationTiming": null,
    "codes": {
      "CVX": ["116"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Rotavirus Vaccine (3 dose schedule) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1223)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1322733600,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1322733600,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f7698300013f",
    "administrationTiming": null,
    "codes": {
      "CVX": ["33"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Pneumococcal Conjugate Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1221)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000140",
    "administrationTiming": null,
    "codes": {
      "CVX": ["08"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hepatitis B Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1216)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000141",
    "administrationTiming": null,
    "codes": {
      "CVX": ["111"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Influenza Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1218)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000142",
    "administrationTiming": null,
    "codes": {
      "CVX": ["21"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Varicella Zoster Vaccine (VZV) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1170)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000143",
    "administrationTiming": null,
    "codes": {
      "CVX": ["10"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Inactivated Polio Vaccine (IPV) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1219)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1330596000,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1330596000,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000144",
    "administrationTiming": null,
    "codes": {
      "CVX": ["03"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Measles, Mumps and Rubella (MMR) Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1224)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000145",
    "administrationTiming": null,
    "codes": {
      "CVX": ["83"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hepatitis A Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1215)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000147",
    "administrationTiming": null,
    "codes": {
      "CVX": ["48"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Hemophilus Influenze B (HiB) Vaccine (Code List: 2.16.840.1.113883.3.464.1003.196.12.1217)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }, {
    "_id": "5217677d0017f76983000148",
    "administrationTiming": null,
    "codes": {
      "CVX": ["116"]
    },
    "cumulativeMedicationDuration": null,
    "deliveryMethod": null,
    "description": "Medication, Administered: Rotavirus Vaccine (3 dose schedule) (Code List: 2.16.840.1.113883.3.464.1003.196.12.1223)",
    "dose": null,
    "doseIndicator": null,
    "doseRestriction": null,
    "end_time": 1333274400,
    "freeTextSig": null,
    "free_text": null,
    "fulfillmentInstructions": null,
    "indication": null,
    "mood_code": "EVN",
    "negationInd": null,
    "negationReason": null,
    "oid": "2.16.840.1.113883.3.560.1.14",
    "patientInstructions": null,
    "productForm": null,
    "reaction": null,
    "reason": null,
    "route": null,
    "site": null,
    "specifics": null,
    "start_time": 1333274400,
    "statusOfMedication": null,
    "status_code": {
      "HL7 ActStatus": ["administered"]
    },
    "time": null,
    "typeOfMedication": null,
    "vehicle": null
  }],
  "race": {
    "code": "1002-5",
    "name": "American Indian or Alaska Native",
    "codeSystem": "CDC Race"
  },
  "religious_affiliation": null,
  "source_data_criteria": [],
  "test_id": null,
  "title": null,
  "type": "ep"
}]);