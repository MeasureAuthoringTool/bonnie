# Description http://hl7.org/fhir/valueset-additional-instruction-codes.html
@NegationReasonValueSet = class NegationReasonValueSet
  @MEDICAL_REASON_NOT_DONE = {
    "resourceType": "ValueSet",
    "id": "2.16.840.1.113762.1.4.1021.56",
    "meta": {
      "versionId": "6",
      "lastUpdated": "2019-12-12T01:00:20.000-05:00"
    },
    "text": {},
    "url": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.56",
    "version": "20191212",
    "name": "Medical Reason Not Done SCT",
    "status": "active",
    "date": "2019-12-12T01:00:20-05:00",
    "publisher": "MD Partners Steward",
    "compose": {
      "include": [
        {
          "system": "http://snomed.info/sct",
          "concept": [
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183932001",
              "display": "Procedure contraindicated (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183964008",
              "display": "Treatment not indicated (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183966005",
              "display": "Drug treatment not indicated (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "216952002",
              "display": "Failure in dosage (event)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "266721009",
              "display": "Absent response to treatment (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "269191009",
              "display": "Late effect of medical and surgical care complication (disorder)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "274512008",
              "display": "Drug therapy discontinued (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "31438003",
              "display": "Drug resistance (disorder)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "35688006",
              "display": "Complication of medical care (disorder)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "371133007",
              "display": "Treatment modification (procedure)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "397745006",
              "display": "Medical contraindication (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "407563006",
              "display": "Treatment not tolerated (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "410529002",
              "display": "Not needed (qualifier value)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "410534003",
              "display": "Not indicated (qualifier value)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "410536001",
              "display": "Contraindicated (qualifier value)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "416098002",
              "display": "Allergy to drug (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "416406003",
              "display": "Procedure discontinued (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "419511003",
              "display": "Propensity to adverse reactions to drug (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "428024001",
              "display": "Clinical trial participant (person)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "428119001",
              "display": "Procedure not indicated (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "445528004",
              "display": "Treatment changed (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "59037007",
              "display": "Intolerance to drug (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "62014003",
              "display": "Adverse reaction caused by drug (disorder)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "79899007",
              "display": "Drug interaction (finding)"
            }
          ]
        }
      ]
    }
  }

  @PATIENT_REASON_NOT_DONE = {
    "resourceType": "ValueSet",
    "id": "2.16.840.1.113762.1.4.1021.58",
    "meta": {
      "versionId": "6",
      "lastUpdated": "2019-12-12T01:00:20.000-05:00"
    },
    "text": {},
    "url": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113762.1.4.1021.58",
    "version": "20191212",
    "name": "Patient Reason Not Done SCT",
    "status": "active",
    "date": "2019-12-12T01:00:20-05:00",
    "publisher": "MD Partners Steward",
    "compose": {
      "include": [
        {
          "system": "http://snomed.info/sct",
          "concept": [
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "105480006",
              "display": "Refusal of treatment by patient (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "134397009",
              "display": "Angiotensin converting enzyme inhibitor declined (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "160932005",
              "display": "Financial problem (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "160934006",
              "display": "Financial circumstances change (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182890002",
              "display": "Patient requests alternative treatment (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182895007",
              "display": "Drug declined by patient (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182896008",
              "display": "Drug declined by patient - dislikes taste (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182897004",
              "display": "Drug declined by patient - side effects (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182898009",
              "display": "Drug declined by patient - inconvenient (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182900006",
              "display": "Drug declined by patient - patient beliefs (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182901005",
              "display": "Drug declined by patient - alternative therapy (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182902003",
              "display": "Drug declined by patient - cannot pay script (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182903008",
              "display": "Drug declined by patient - reason unknown (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183944003",
              "display": "Procedure refused (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183945002",
              "display": "Procedure refused for religious reason (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183946001",
              "display": "Procedure refused - uncooperative (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183947005",
              "display": "Refused procedure - after thought (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "183948000",
              "display": "Refused procedure - parent's wish (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "184081006",
              "display": "Patient has moved away (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "185479006",
              "display": "Patient dissatisfied with result (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "185481008",
              "display": "Dissatisfied with doctor (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "224187001",
              "display": "Variable income (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "225928004",
              "display": "Patient self-discharge against medical advice (procedure)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "266710000",
              "display": "Drugs not taken/completed (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "266966009",
              "display": "Family illness (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "275694009",
              "display": "Patient defaulted from follow-up (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "275936005",
              "display": "Patient noncompliance - general (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "281399006",
              "display": "Did not attend (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "310343007",
              "display": "Further opinion sought (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "315640000",
              "display": "Influenza vaccination declined (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "371138003",
              "display": "Refusal of treatment by parents (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "373787003",
              "display": "Treatment delay - patient choice (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "401084003",
              "display": "Angiotensin II receptor antagonist declined (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "406149000",
              "display": "Medication refused (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "408367005",
              "display": "Patient forgets to take medication (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "413310006",
              "display": "Patient non-compliant - refused access to services (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "413311005",
              "display": "Patient non-compliant - refused intervention / support (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "413312003",
              "display": "Patient non-compliant - refused service (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "416432009",
              "display": "Procedure not wanted (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "423656007",
              "display": "Income insufficient to buy necessities (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "424739004",
              "display": "Income sufficient to buy only necessities (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "443390004",
              "display": "Refused (qualifier value)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "609589008",
              "display": "Refused by parents of subject (qualifier value)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "713247000",
              "display": "Procedure discontinued by patient (situation)"
            }
          ]
        }
      ]
    }
  }

  @SYSTEM_REASONS = {
    "resourceType": "ValueSet",
    "id": "2.16.840.1.113883.3.526.3.1009",
    "meta": {
      "versionId": "19",
      "lastUpdated": "2021-02-10T15:14:01.000-05:00"
    },
    "text": {},
    "url": "http://cts.nlm.nih.gov/fhir/ValueSet/2.16.840.1.113883.3.526.3.1009",
    "version": "20170504",
    "name": "System Reason",
    "status": "active",
    "date": "2017-05-04T01:00:13-04:00",
    "publisher": "NCQA PHEMUR",
    "compose": {
      "include": [
        {
          "system": "http://snomed.info/sct",
          "concept": [
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "107724000",
              "display": "Patient transfer (procedure)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182856006",
              "display": "Drug not available - out of stock (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "182857002",
              "display": "Drug not available-off market (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "185335007",
              "display": "Appointment canceled by hospital (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "224194003",
              "display": "Not entitled to benefits (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "224198000",
              "display": "Delay in receiving benefits (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "224199008",
              "display": "Loss of benefits (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "242990004",
              "display": "Drug not available for administration (event)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "266756008",
              "display": "Medical care unavailable (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "270459005",
              "display": "Patient on waiting list (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "309017000",
              "display": "Referred to doctor (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "309846006",
              "display": "Treatment not available (situation)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "419808006",
              "display": "Finding related to health insurance issues (finding)"
            },
            {
              "system": "http://snomed.info/sct",
              "version": "http://snomed.info/sct/731000124108/version/2021-03",
              "code": "424553001",
              "display": "Uninsured medical expenses (finding)"
            }
          ]
        }
      ]
    }
  }
