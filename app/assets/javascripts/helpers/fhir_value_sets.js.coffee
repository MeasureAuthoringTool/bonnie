@FhirValueSets = class FhirValueSets

  @CONDITION_CLINICAL_VS = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "ConditionClinicalStatusCodes",
    "title": "ConditionClinicalStatusCodes",
    "compose": {
      "include": [
        {
          "system": "condition-clinical",
          "version": "4.0.1",
          "concept": [
            {
              "code": "active",
              "display": "Active"
            },
            {
              "code": "recurrence",
              "display": "Recurrence"
            },
            {
              "code": "relapse",
              "display": "Relapse"
            },
            {
              "code": "inactive",
              "display": "Inactive"
            },
            {
              "code": "remission",
              "display": "Remission"
            },
            {
              "code": "resolved",
              "display": "Resolved"
            }
          ]
        }
      ]
    },
    "url": "http://terminology.hl7.org/CodeSystem/condition-clinical"
    "id": "2.16.840.1.113883.4.642.3.164"
  }

  @CONDITION_VER_STATUS_VS = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "ConditionVerificationStatus",
    "title": "ConditionVerificationStatus",
    "compose": {
      "include": [
        {
          "system": "condition-ver-status",
          "version": "4.0.1",
          "concept": [
            {
              "code": "unconfirmed",
              "display": "Unconfirmed"
            },
            {
              "code": "provisional",
              "display": "Provisional"
            },
            {
              "code": "differential",
              "display": "Differential"
            },
            {
              "code": "confirmed",
              "display": "Confirmed"
            },
            {
              "code": "refuted",
              "display": "Refuted"
            },
            {
              "code": "entered-in-error",
              "display": "Entered in Error"
            }
          ]
        }
      ]
    },
    "url": "http://terminology.hl7.org/CodeSystem/condition-ver-status"
    "id": "2.16.840.1.113883.4.642.3.166"
  }

  @EVENT_STATUS_VS = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "EventStatus",
    "title": "EventStatus",
    "compose": {
      "include": [
        {
          "system": "event-status",
          "version": "4.0.1",
          "concept": [
            {
              "code": "preparation",
              "display": "Preparation"
            },
            {
              "code": "in-progress",
              "display": "In Progress"
            },
            {
              "code": "not-done",
              "display": "Not Done"
            },
            {
              "code": "on-hold",
              "display": "On Hold"
            },
            {
              "code": "stopped",
              "display": "Stopped"
            },
            {
              "code": "completed",
              "display": "Completed"
            },
            {
              "code": "entered-in-error",
              "display": "Entered in Error"
            },{
              "code": "unknown",
              "display": "Unknown"
            }
          ]
        }
      ]
    },
    "url": "http://hl7.org/fhir/event-status"
    "id": "2.16.840.1.113883.4.642.3.109"
  }

  @ENCOUNTER_STATUS_VS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "EncounterStatus",
      "title": "Encounter Status",
      "compose": {
        "include": [
          {
            "system": "encounter-status"
            "version": "4.0.1",
            "concept": [
              {
                "code": "planned",
                "display": "Planned"
              },
              {
                "code": "arrived",
                "display": "Arrived"
              },
              {
                "code": "triaged",
                "display": "Triaged"
              },
              {
                "code": "in-progress",
                "display": "In Progress"
              },
              {
                "code": "onleave",
                "display": "On Leave"
              },
              {
                "code": "finished",
                "display": "Finished"
              },
              {
                "code": "cancelled",
                "display": "Cancelled"
              },
              {
                "code": "entered-in-error",
                "display": "Entered in Error"
              },
              {
                "code": "unknown",
                "display": "Unknown"
              }
            ]
          }
        ]
      },
      "id": "encounter-status",
      "url": "http://hl7.org/fhir/ValueSet/encounter-status",
      "identifier": [{
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.246"
      }]
    }
  ]

  @DISCHARGE_DISPOSITION_VS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "DischargeDisposition",
      "title": "Discharge disposition",
      "compose": {
        "include": [
          {
            "system": "discharge-disposition",
            "version": "4.0.1",
            "concept": [
              {
                "code": "home",
                "display": "Home",
                "definition": "The patient was dicharged and has indicated that they are going to return home afterwards."
              },
              {
                "code": "alt-home",
                "display": "Alternative home",
                "definition": "The patient was discharged and has indicated that they are going to return home afterwards, but not the patient's home - e.g. a family member's home."
              },
              {
                "code": "other-hcf",
                "display": "Other healthcare facility",
                "definition": "The patient was transferred to another healthcare facility."
              },
              {
                "code": "hosp",
                "display": "Hospice",
                "definition": "The patient has been discharged into palliative care."
              },
              {
                "code": "long",
                "display": "Long-term care",
                "definition": "The patient has been discharged into long-term care where is likely to be monitored through an ongoing episode-of-care."
              },
              {
                "code": "aadvice",
                "display": "Left against advice",
                "definition": "The patient self discharged against medical advice."
              },
              {
                "code": "exp",
                "display": "Expired",
                "definition": "The patient has deceased during this encounter."
              },
              {
                "code": "psy",
                "display": "Psychiatric hospital",
                "definition": "The patient has been transferred to a psychiatric facility."
              },
              {
                "code": "rehab",
                "display": "Rehabilitation",
                "definition": "The patient was discharged and is to receive post acute care rehabilitation services."
              },
              {
                "code": "snf",
                "display": "Skilled nursing facility",
                "definition": "The patient has been discharged to a skilled nursing facility for the patient to receive additional care."
              },
              {
                "code": "oth",
                "display": "Other",
                "definition": "The discharge disposition has not otherwise defined."
              }
            ]
          }
        ]
      },
      "id": "encounter-discharge-disposition",
      "url": "http://hl7.org/fhir/ValueSet/encounter-discharge-disposition",
      "identifier": [{
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.259"
      }],
    }
  ]

  @MEDICATION_REQUEST_STATUS_VS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "MedicationrequestStatus",
      "title": "MedicationrequestStatus",
      "compose": {
        "include": [
          {
            "system": "medicationrequest-status",
            "version": "4.0.1",
            "concept": [
              {
                "code": "active",
                "display": "Active"
              },
              {
                "code": "on-hold",
                "display": "On Hold"
              },
              {
                "code": "cancelled",
                "display": "Cancelled"
              },
              {
                "code": "completed",
                "display": "Completed"
              },
              {
                "code": "entered-in-error",
                "display": "Entered in Error"
              },
              {
                "code": "stopped",
                "display": "Stopped"
              },
              {
                "code": "draft",
                "display": "Draft"
              },
              {
                "code": "unknown",
                "display": "Unknown"
              }
            ]
          }
        ]
      },
      "url": "http://hl7.org/fhir/ValueSet/medicationrequest-status"
      "id": "2.16.840.1.113883.4.642.3.1320"
    }
  ]

  @MEDICATION_REQUEST_INTENT_VS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "MedicationRequestIntent",
      "title": "MedicationRequestIntent",
      "compose": {
        "include": [
          {
            "system": "medicationrequest-intent",
            "version": "4.0.1",
            "concept": [
              {
                "code": "proposal",
                "display": "Proposal"
              },
              {
                "code": "plan",
                "display": "Plan"
              },
              {
                "code": "order",
                "display": "Order"
              },
              {
                "code": "original-order",
                "display": "Original Order"
              },
              {
                "code": "reflex-order",
                "display": "Reflex Order"
              },
              {
                "code": "filler-order",
                "display": "Filler Order"
              },
              {
                "code": "instance-order",
                "display": "Instance Order"
              },
              {
                "code": "option",
                "display": "Option"
              }
            ]
          }
        ]
      },
      "url": "http://hl7.org/fhir/ValueSet/medicationrequest-intent"
      "id": "2.16.840.1.113883.4.642.3.1321"
    }
  ]

  @MEDICATION_STATEMENT_STATUS_VS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "MedicationStatusCodes",
      "title": "MedicationStatusCodes",
      "compose": {
        "include": [
          {
            "system": "medication-statement-status",
            "version": "4.0.1",
            "concept": [
              {
                "code": "active",
                "display": "Active"
              },
              {
                "code": "completed",
                "display": "Completed"
              },
              {
                "code": "entered-in-error",
                "display": "Entered in Error"
              },
              {
                "code": "intended",
                "display": "Intended"
              },
              {
                "code": "stopped",
                "display": "Stopped"
              },
              {
                "code": "on-hold",
                "display": "On Hold"
              },
              {
                "code": "unknown",
                "display": "Unknown"
              },
              {
                "code": "not-taken",
                "display": "Not Taken"
              }
            ]
          }
        ]
      },
      "url": "http://hl7.org/fhir/ValueSet/medication-statement-status"
      "id": "2.16.840.1.113883.4.642.3.367"
    }
  ]
