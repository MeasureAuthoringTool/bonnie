@FhirValueSets = class FhirValueSets

  #  Description  https://terminology.hl7.org/1.0.0/ValueSet-condition-clinical
  @CONDITION_CLINICAL_VS = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "ConditionClinicalStatusCodes",
    "title": "ConditionClinicalStatusCodes",
    "compose": {
      "include": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
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
    "url": "http://terminology.hl7.org/ValueSet/condition-clinical",
    "identifier": [
      {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.164"
      }
    ],
    "id": "2.16.840.1.113883.4.642.3.164"
  }

  # Description   https://terminology.hl7.org/ValueSet/condition-ver-status
  @CONDITION_VER_STATUS_VS = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "ConditionVerificationStatus",
    "title": "ConditionVerificationStatus",
    "compose": {
      "include": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
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
    "url": "http://terminology.hl7.org/ValueSet/condition-ver-status",
    "identifier": [
      {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.166"
      }
    ],
    "id": "2.16.840.1.113883.4.642.3.166"
  }

  @CONDITION_SEVERITY_VS = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "Condition/DiagnosisSeverity",
    "title": "Condition/Diagnosis Severity",
    "compose": {
      "include": [
        {
          "system": "http://snomed.info/sct",
          "version": "4.0.1",
          "concept": [
            {
              "code": "24484000",
              "display": "Severe"
            },
            {
              "code": "6736007",
              "display": "Moderate"
            },
            {
              "code": "255604002",
              "display": "Mild"
            }
          ]
        }
      ]
    },
    "url": "http://hl7.org/fhir/ValueSet/condition-severity",
    "identifier": [
      {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.168"
      }
    ],
    "id": "2.16.840.1.113883.4.642.3.168"
  }

  # Description  https://hl7.org/fhir/R4/codesystem-event-status.html
  @EVENT_STATUS_VS = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "EventStatus",
    "title": "EventStatus",
    "compose": {
      "include": [
        {
          "system": "http://hl7.org/fhir/event-status",
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

  # Description   https://hl7.org/fhir/R4/valueset-encounter-status.html
  @ENCOUNTER_STATUS_VS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "EncounterStatus",
      "title": "Encounter Status",
      "compose": {
        "include": [
          {
            "system": "http://hl7.org/fhir/encounter-status"
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

  # Description https://hl7.org/fhir/R4/valueset-encounter-discharge-disposition.html
  @DISCHARGE_DISPOSITION_VS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "DischargeDisposition",
      "title": "Discharge disposition",
      "compose": {
        "include": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/discharge-disposition",
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

  # Description   https://hl7.org/fhir/R4/valueset-medicationrequest-status.html
  @MEDICATION_REQUEST_STATUS_VS =
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "MedicationrequestStatus",
      "title": "MedicationrequestStatus",
      "compose": {
        "include": [
          {
            "system": "http://hl7.org/fhir/CodeSystem/medicationrequest-status",
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

  # Description   https://hl7.org/fhir/R4/valueset-medicationrequest-intent.html
  @MEDICATION_REQUEST_INTENT_VS =
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "MedicationRequestIntent",
      "title": "MedicationRequestIntent",
      "compose": {
        "include": [
          {
            "system": "http://hl7.org/fhir/CodeSystem/medicationrequest-intent",
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

  # Description https://hl7.org/fhir/R4/valueset-medication-statement-status.html
  @MEDICATION_STATEMENT_STATUS_VS =
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "MedicationStatusCodes",
      "title": "MedicationStatusCodes",
      "compose": {
        "include": [
          {
            "system": "http://hl7.org/fhir/CodeSystem/medication-statement-status",
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

  # Description   https://hl7.org/fhir/R4/valueset-procedure-category.html
  # https://confluence.ihtsdotools.org/display/FHIR/Procedure
  @PROCEDURE_CATEGORY_VS =
    {
      "version": "4.0.1",
      "url": "http://hl7.org/fhir/ValueSet/procedure-category",
      "title": "Procedure Category Codes (SNOMED CT)",
      "text": {
        "status": "generated",
        "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Procedure Category Codes (SNOMED CT)</h2><div><p>Procedure Category code: A selection of relevant SNOMED CT codes.</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include these codes as defined in <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=24642003\">24642003</a></td><td>Psychiatry procedure or service</td><td/></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=409063005\">409063005</a></td><td>Counselling</td><td/></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=409073007\">409073007</a></td><td>Education</td><td/></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=387713003\">387713003</a></td><td>Surgical procedure</td><td/></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=103693007\">103693007</a></td><td>Diagnostic procedure</td><td/></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=46947000\">46947000</a></td><td>Chiropractic manipulation</td><td/></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=410606002\">410606002</a></td><td>Social service procedure</td><td/></tr></table></li></ul></div>"
      },
      "status": "draft",
      "resourceType": "ValueSet",
      "publisher": "FHIR Project team",
      "name": "ProcedureCategoryCodes(SNOMEDCT)",
      "meta": {
        "lastUpdated": "2019-11-01T09:29:23.356+11:00",
        "profile": [
          "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
        ]
      },
      "identifier": [
        {
          "system": "urn:ietf:rfc:3986",
          "value": "urn:oid:2.16.840.1.113883.4.642.3.430"
        }
      ],
      "id": "procedure-category",
      "extension": [
        {
          "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
          "valueCode": "pc"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
          "valueCode": "draft"
        },
        {
          "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
          "valueInteger": 1
        }
      ],
      "experimental": false,
      "description": "Procedure Category code: A selection of relevant SNOMED CT codes.",
      "date": "2019-11-01T09:29:23+11:00",
      "copyright": "This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
      "contact": [
        {
          "telecom": [
            {
              "system": "url",
              "value": "http://hl7.org/fhir"
            }
          ]
        }
      ],
      "compose": {
        "include": [
          {
            "system": "http://snomed.info/sct",
            "concept": [
              {
                "code": "24642003",
                "display": "Psychiatry procedure or service"
              },
              {
                "code": "409063005",
                "display": "Counselling"
              },
              {
                "code": "409073007",
                "display": "Education"
              },
              {
                "code": "387713003",
                "display": "Surgical procedure"
              },
              {
                "code": "103693007",
                "display": "Diagnostic procedure"
              },
              {
                "code": "46947000",
                "display": "Chiropractic manipulation"
              },
              {
                "code": "410606002",
                "display": "Social service procedure"
              }
            ]
          }
        ]
      }
    }

  # Description   https://hl7.org/fhir/R4/valueset-procedure-not-performed-reason.html
  @PROCEDURE_NOT_PERFORMED_REASON_VS =
    {
      "resourceType" : "ValueSet",
      "id" : "procedure-not-performed-reason",
      "meta" : {
        "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
      },
      "text" : {
        "status" : "generated",
        "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Procedure Not Performed Reason (SNOMED-CT)</h2><div><p>Situation codes describing the reason that a procedure, which might otherwise be expected, was not performed, or a procedure that was started and was not completed. Consists of SNOMED CT codes, children of procedure contraindicated (183932001), procedure discontinued (416406003), procedure not done (416237000), procedure not indicated (428119001), procedure not offered (416064006), procedure not wanted (416432009), procedure refused (183944003), and procedure stopped (394908001).</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  183932001 (Procedure contraindicated)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416406003 (Procedure discontinued)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416237000 (Procedure not done)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  428119001 (Procedure not indicated)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416064006 (Procedure not offered)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  416432009 (Procedure not wanted)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  183944003 (Procedure refused)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  394908001 (Procedure stopped)</li></ul></div>"
      },
      "extension" : [{
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
        "valueCode" : "pc"
      },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
          "valueCode" : "draft"
        },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
          "valueInteger" : 1
        }],
      "url" : "http://hl7.org/fhir/ValueSet/procedure-not-performed-reason",
      "identifier" : [{
        "system" : "urn:ietf:rfc:3986",
        "value" : "urn:oid:2.16.840.1.113883.4.642.3.431"
      }],
      "version" : "4.0.1",
      "name" : "ProcedureNotPerformedReason(SNOMED-CT)",
      "title" : "Procedure Not Performed Reason (SNOMED-CT)",
      "status" : "active",
      "experimental" : false,
      "date" : "2019-11-01T09:29:23+11:00",
      "publisher" : "Health Level Seven, Inc. - CQI WG",
      "contact" : [{
        "telecom" : [{
          "system" : "url",
          "value" : "http://hl7.org/special/committees/CQI"
        }]
      }],
      "description" : "Situation codes describing the reason that a procedure, which might otherwise be expected, was not performed, or a procedure that was started and was not completed. Consists of SNOMED CT codes, children of procedure contraindicated (183932001), procedure discontinued (416406003), procedure not done (416237000), procedure not indicated (428119001), procedure not offered (416064006), procedure not wanted (416432009), procedure refused (183944003), and procedure stopped (394908001).",
      "copyright" : "This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
      "compose" : {
        "include" : [
          {
            "system" : "http://snomed.info/sct",
            "concept": [
              {
                "code": "183932001",
                "display": "Procedure contraindicated"
              },
              {
                "code": "416406003",
                "display": "Procedure discontinued"
              },
              {
                "code": "416237000",
                "display": "Procedure not done"
              },
              {
                "code": "428119001",
                "display": "Procedure not indicated"
              },
              {
                "code": "416064006",
                "display": "Procedure not offered"
              },
              {
                "code": "416432009",
                "display": "Procedure not wanted"
              },
              {
                "code": "183944003",
                "display": "Procedure refused"
              },
              {
                "code": "394908001",
                "display": "Procedure stopped"
              }
            ]
          }
        ]
      }
    }



  # Description https://hl7.org/fhir/R4/valueset-allergyintolerance-clinical.html
  @ALLERGYINTOLERANCE_CLINICAL_VS =
    {
      "resourceType" : "ValueSet",
      "id" : "allergyintolerance-clinical",
      "meta" : {
        "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
      },
      "text" : {
        "status" : "generated",
        "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>AllergyIntolerance Clinical Status Codes</h2><div><p>Preferred value set for AllergyIntolerance Clinical Status.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-allergyintolerance-clinical.html\"><code>http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical</code></a></li></ul></div>"
      },
      "extension" : [{
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
        "valueCode" : "pc"
      },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
          "valueCode" : "trial-use"
        },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
          "valueInteger" : 3
        }],
      "url" : "http://hl7.org/fhir/ValueSet/allergyintolerance-clinical",
      "identifier" : [{
        "system" : "urn:ietf:rfc:3986",
        "value" : "urn:oid:2.16.840.1.113883.4.642.3.1372"
      }],
      "version" : "4.0.1",
      "name" : "AllergyIntoleranceClinicalStatusCodes",
      "title" : "AllergyIntolerance Clinical Status Codes",
      "status" : "draft",
      "experimental" : false,
      "date" : "2019-11-01T09:29:23+11:00",
      "publisher" : "FHIR Project team",
      "contact" : [{
        "telecom" : [{
          "system" : "url",
          "value" : "http://hl7.org/fhir"
        }]
      }],
      "description" : "Preferred value set for AllergyIntolerance Clinical Status.",
      "immutable" : true,
      "compose" : {
        "include" : [
          {
            "system" : "http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical",
            "concept": [
              {
                "code" : "active",
                "display" : "Active",
                "definition" : "The subject is currently experiencing, or is at risk of, a reaction to the identified substance."
              },
              {
                "code": "inactive",
                "display": "Inactive",
                "definition": "The subject is no longer at risk of a reaction to the identified substance."
              },
              {
                "code" : "resolved",
                "display" : "Resolved",
                "definition" : "A reaction to the identified substance has been clinically reassessed by testing or re-exposure and is considered no longer to be present. Re-exposure could be accidental, unplanned, or outside of any clinical setting."
              }
            ]
          }
        ]
      }
    }

  # Description https://hl7.org/fhir/R4/codesystem-allergyintolerance-verification.html
  @ALLERGYINTOLERANCE_VERIFICATION_VS =
    {
      "resourceType" : "ValueSet",
      "id" : "allergyintolerance-verification",
      "meta" : {
        "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
      },
      "text" : {
        "status" : "generated",
        "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>AllergyIntolerance Verification Status Codes</h2><div><p>Preferred value set for AllergyIntolerance Verification Status.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-allergyintolerance-verification.html\"><code>http://terminology.hl7.org/CodeSystem/allergyintolerance-verification</code></a></li></ul></div>"
      },
      "extension" : [{
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
        "valueCode" : "pc"
      },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
          "valueCode" : "trial-use"
        },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
          "valueInteger" : 3
        }],
      "url" : "http://hl7.org/fhir/ValueSet/allergyintolerance-verification",
      "identifier" : [{
        "system" : "urn:ietf:rfc:3986",
        "value" : "urn:oid:2.16.840.1.113883.4.642.3.1370"
      }],
      "version" : "4.0.1",
      "name" : "AllergyIntoleranceVerificationStatusCodes",
      "title" : "AllergyIntolerance Verification Status Codes",
      "status" : "draft",
      "experimental" : false,
      "date" : "2019-11-01T09:29:23+11:00",
      "publisher" : "FHIR Project team",
      "contact" : [{
        "telecom" : [{
          "system" : "url",
          "value" : "http://hl7.org/fhir"
        }]
      }],
      "description" : "Preferred value set for AllergyIntolerance Verification Status.",
      "immutable" : true,
      "compose" : {
        "include" : [
          {
            "system" : "http://terminology.hl7.org/CodeSystem/allergyintolerance-verification",
            "concept": [
              {
                "code": "unconfirmed",
                "display": "Unconfirmed",
              },
              {
                "code": "presumed",
                "display": "Presumed",
                "definition": "The available clinical information supports a high liklihood of the propensity for a reaction to the identified substance."
              },
              {
                "code": "confirmed",
                "display": "Confirmed",
                "definition": "The propensity for a reaction to the identified substance has been objectively verified (which may include clinical evidence by testing, rechallenge, or observation)."
              },
              {
                "code": "refuted",
                "display": "Refuted",
                "definition": "A propensity for a reaction to the identified substance has been disputed or disproven with a sufficient level of clinical certainty to justify invalidating the assertion. This might or might not include testing or rechallenge."
              },
              {
                "code": "entered-in-error",
                "display": "Entered in Error",
                "definition": "The statement was entered in error and is not valid."
              }
            ]
          }
        ]
      }
    }

  @REQUEST_INTENT = {
    "resourceType" : "ValueSet",
    "id" : "request-intent",
    "url" : "http://hl7.org/fhir/ValueSet/request-intent",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.113"
    }],
    "version" : "4.0.1",
    "name" : "RequestIntent",
    "title" : "RequestIntent",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "compose" : {
      "include" : [
        {
          "system" : "http://hl7.org/fhir/request-intent"
          "concept" : [
            {
              "code" : "proposal",
              "display" : "Proposal",
              "definition" : "The request is a suggestion made by someone/something that does not have an intention to ensure it occurs and without providing an authorization to act."
            },
            {
              "code" : "plan",
              "display" : "Plan",
              "definition" : "The request represents an intention to ensure something occurs without providing an authorization for others to act."
            },
            {
              "code" : "directive",
              "display" : "Directive",
              "definition" : "The request represents a legally binding instruction authored by a Patient or RelatedPerson."
            },
            {
              "code" : "order",
              "display" : "Order",
              "definition" : "The request represents a request/demand and authorization for action by a Practitioner."
            },
            {
              "code" : "original-order",
              "display" : "Original Order",
              "definition" : "The request represents an original authorization for action."
            },
            {
              "code" : "reflex-order",
              "display" : "Reflex Order",
              "definition" : "The request represents an automatically generated supplemental authorization for action based on a parent authorization together with initial results of the action taken against that parent authorization."
            },
            {
              "code" : "filler-order",
              "display" : "Filler Order",
              "definition" : "The request represents the view of an authorization instantiated by a fulfilling system representing the details of the fulfiller's intention to act upon a submitted order."
            },
            {
              "code" : "instance-order",
              "display" : "Instance Order",
              "definition" : "An order created in fulfillment of a broader order that represents the authorization for a single activity occurrence.  E.g. The administration of a single dose of a drug."
            }
            {
              "code" : "option",
              "display" : "Option",
              "definition" : "The request represents a component or option for a RequestGroup that establishes timing, conditionality and/or other constraints among a set of requests.  Refer to [[[RequestGroup]]] for additional information on how this status is used."
            }]
        }
      ]
    }
  }

  @REQUEST_STATUS = {
    "resourceType" : "ValueSet",
    "id" : "request-status",
    "url" : "http://hl7.org/fhir/ValueSet/request-status",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.111"
    }],
    "version" : "4.0.1",
    "name" : "RequestStatus",
    "title" : "RequestStatus",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "compose" : {
      "include" : [
        {
          "system" : "http://hl7.org/fhir/request-status"
          "concept" : [
            {
              "code" : "draft",
              "display" : "Draft",
              "definition" : "The request has been created but is not yet complete or ready for action."
            },
            {
              "code" : "active",
              "display" : "Active",
              "definition" : "The request is in force and ready to be acted upon."
            },
            {
              "code" : "on-hold",
              "display" : "On Hold",
              "definition" : "The request (and any implicit authorization to act) has been temporarily withdrawn but is expected to resume in the future."
            },
            {
              "code" : "revoked",
              "display" : "Revoked",
              "definition" : "The request (and any implicit authorization to act) has been terminated prior to the known full completion of the intended actions. No further activity should occur."
            },
            {
              "code" : "completed",
              "display" : "Completed",
              "definition" : "The activity described by the request has been fully performed. No further activity will occur."
            },
            {
              "code" : "entered-in-error",
              "display" : "Reflex Order",
              "definition" : "This request should never have existed and should be considered 'void'. (It is possible that real-world decisions were based on it. If real-world activity has occurred, the status should be \"revoked\" rather than \"entered-in-error\".)."
            },
            {
              "code" : "unknown",
              "display" : "Unknown",
              "definition" : "The authoring/source system does not know which of the status values currently applies for this request. Note: This concept is not to be used for \"other\" - one of the listed statuses is presumed to apply, but the authoring/source system does not know which."
            }
          ]
        }
      ]
    }
  }

  # Description http://hl7.org/fhir/us/core/STU3.1/ValueSet-us-core-condition-category.html
  # JSON        http://hl7.org/fhir/us/core/STU3.1/ValueSet-us-core-condition-category.json
  @CONDITION_CATEGORY_VS =
    {
      "resourceType" : "ValueSet",
      "id" : "us-core-condition-category",
      "url" : "http://hl7.org/fhir/us/core/ValueSet/us-core-condition-category",
      "identifier" : [{
        "system" : "urn:ietf:rfc:3986",
        "value" : "urn:oid:2.16.840.1.113883.4.642.3.162"
      }],
      "version" : "4.0.1",
      "name" : "USCoreConditionCategoryCodes",
      "title" : "US Core Condition Category Codes",
      "status" : "active",
      "experimental" : false,
      "date": "2019-05-21T00:00:00+10:00",
      "publisher": "HL7 US Realm Steering Committee",
      "description": "The US Core Condition Category Codes support the separate concepts of problems and health concerns in Condition.category in order for API consumers to be able to separate health concerns and problems. However this is not mandatory for 2015 certification",
      "immutable" : true,
      "compose" : {
        "include" : [
          {
            "system" : "http://terminology.hl7.org/CodeSystem/condition-category",
            "concept": [
                {
                  "code": "problem-list-item",
                  "display": "Problem List Item",
                  "definition": "An item on a problem list that can be managed over time and can be expressed by a practitioner (e.g. physician, nurse), patient, or related person."
                },
                {
                  "code": "encounter-diagnosis",
                  "display": "Encounter Diagnosis",
                  "definition": "A point in time diagnosis (e.g. from a physician or nurse) in context of an encounter."
                }
              ]
          },
          {
            "system" : "http://hl7.org/fhir/us/core/CodeSystem/condition-category",
            "concept": [
              {
                "code": "health-concern",
                "display": "Health Concern",
                "definition": "Additional health concerns from other stakeholders which are outside the provider’s problem list."
              }
            ]
          }
        ]
      }
    }

  # Description https://hl7.org/fhir/R4/valueset-medication-admin-status.html
  @MEDICATION_ADMIN_STATUS_VS =
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "MedicationAdministration Status Codes",
      "title": "Medication administration status codes",
      "compose": {
        "include": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/medication-admin-status",
            "version": "4.0.1",
            "concept": [
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
                "code": "unknown",
                "display": "Unknown"
              }
            ]
          }
        ]
      },
      "url": "http://hl7.org/fhir/ValueSet/medication-admin-status"
      "id": "2.16.840.1.113883.4.642.3.340"
    }

  # Description https://hl7.org/fhir/R4/valueset-reason-medication-not-given-codes.html
  # Used in:
  # Resource: MedicationAdministration.statusReason (CodeableConcept)
  @REASON_MEDICATION_NOT_GIVEN_VS = {
    "resourceType" : "ValueSet",
    "id" : "reason-medication-not-given-codes",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>SNOMED CT Reason Medication Not Given Codes</h2><div><p>This value set includes all medication refused, medication not administered, and non-administration of necessary drug or medicine codes from SNOMED CT - provided as an exemplar value set.</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This value set includes content from SNOMED CT, which is copyright 2002 International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  242990004 (Drug not available for administration)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  182895007 (Drug declined by patient)</li></ul></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "phx"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "draft"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 1
      }],
    "url" : "http://hl7.org/fhir/ValueSet/reason-medication-not-given-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.342"
    }],
    "version" : "4.0.1",
    "name" : "SNOMEDCTReasonMedicationNotGivenCodes",
    "title" : "SNOMED CT Reason Medication Not Given Codes",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "This value set includes all medication refused, medication not administered, and non-administration of necessary drug or medicine codes from SNOMED CT - provided as an exemplar value set.",
    "immutable" : true,
    "copyright" : "This value set includes content from SNOMED CT, which is copyright 2002 International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement.",
    "compose" : {
      "include" : [{
        "system" : "http://snomed.info/sct",
        "concept" : [
          {
            "code" : "242990004",
            "display" : "Drug not available for administration"
          },
          {
            "code" : "182895007",
            "display" : "Drug declined by patient"
          }
        ]
      }]
    }
  }

  # Description https://hl7.org/fhir/R4/valueset-route-codes.html
  # Used in:
  # Resource: AllergyIntolerance.reaction.exposureRoute (CodeableConcept)
  # Resource: MedicationAdministration.dosage.route (CodeableConcept)
  # Resource: MedicationKnowledge.intendedRoute (CodeableConcept)
  @ROUTE_CODES_VS = {
    "resourceType" : "ValueSet",
    "id" : "route-codes",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n      <p>The value set to instantiate this attribute should be drawn from a terminologically robust code system that consists of or contains route of administration concepts.</p>\n      <p>Possible sources include:</p>\n      <ul>\n        <li>SNOMED CT - Children of SCTID: 284009009 &quot;route of administration value&quot;</li>\n        <li>ISO 11239 - Routes of administration</li>\n        <li>NCIt - Children of NCIt concept C66729 &quot;route of administration&quot; (note: this covers SDTM and FDA route of administration concepts)</li>\n        <li>EDQM - Route of administration</li>\n      </ul>\n      <p>SNOMED CT is being used here as the example terminology.</p>\n      <p>Note: to avoid confusion with other attributes in this resource concepts that are pre-coordinated with method and/or site of administration \n      (e.g. &quot;intravenous infusion&quot; where &quot;infusion&quot; is the method or &quot;IV into left subclavian vein&quot; where &quot;left subclavian vein&quot; is the site) \n      should not be used in this value set.\n      </p>\n      <p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>  \n    </div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "phx"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "draft"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 1
      }],
    "url" : "http://hl7.org/fhir/ValueSet/route-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.98"
    }],
    "version" : "4.0.1",
    "name" : "SNOMEDCTRouteCodes",
    "title" : "SNOMED CT Route Codes",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "This value set includes all Route codes from SNOMED CT - provided as an exemplar.",
    "copyright" : "This value set includes content from SNOMED CT, which is copyright © 2002 International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement.",
    "compose" : {
      "include" : [{
        "system" : "http://snomed.info/sct",
        "concept" : [
          {
            "code": "6064005",
            "display": "Topical route"
          },
          {
            "code": "10547007",
            "display": "Auricular use"
          },
          {
            "code": "12130007",
            "display": "Intra-articular route"
          },
          {
            "code": "16857009",
            "display": "Vaginal use"
          },
          {
            "code": "26643006",
            "display": "Oral use"
          },
          {
            "code": "34206005",
            "display": "SC use"
          },
          {
            "code": "37161004",
            "display": "Rectal use"
          },
          {
            "code": "37737002",
            "display": "Intraluminal use"
          },
          {
            "code": "37839007",
            "display": "Sublingual use"
          },
          {
            "code": "38239002",
            "display": "Intraperitoneal use"
          },
          {
            "code": "45890007",
            "display": "Transdermal use"
          },
          {
            "code": "46713006",
            "display": "Nasal use"
          },
          {
            "code": "47625008",
            "display": "Intravenous use"
          },
          {
            "code": "54471007",
            "display": "Buccal use"
          },
          {
            "code": "54485002",
            "display": "Ophthalmic use"
          },
          {
            "code": "58100008",
            "display": "Intra-arterial use"
          },
          {
            "code": "60213007",
            "display": "Intramedullary route"
          },
          {
            "code": "62226000",
            "display": "Intrauterine route"
          },
          {
            "code": "72607000",
            "display": "Intrathecal route"
          },
          {
            "code": "78421000",
            "display": "Intramuscular use"
          },
          {
            "code": "90028008",
            "display": "Urethral use"
          },
          {
            "code": "127490009",
            "display": "Gastrostomy use"
          },
          {
            "code": "127491008",
            "display": "Jejunostomy use"
          },
          {
            "code": "127492001",
            "display": "Nasogastric use"
          },
          {
            "code": "372449004",
            "display": "Dental use"
          },
          {
            "code": "372450004",
            "display": "Endocervical use"
          },
          {
            "code": "372451000",
            "display": "Endosinusial use"
          },
          {
            "code": "372452007",
            "display": "Endotracheopulmonary use"
          },
          {
            "code": "372453002",
            "display": "Extra-amniotic use"
          },
          {
            "code": "372454008",
            "display": "Gastroenteral use"
          },
          {
            "code": "372457001",
            "display": "Gingival use"
          },
          {
            "code": "372458006",
            "display": "Intraamniotic use"
          },
          {
            "code": "372459003",
            "display": "Intrabursal use"
          },
          {
            "code": "372460008",
            "display": "Intracardiac use"
          },
          {
            "code": "372461007",
            "display": "Intracavernous use"
          },
          {
            "code": "372463005",
            "display": "Intracoronary use"
          },
          {
            "code": "372464004",
            "display": "Intradermal use"
          },
          {
            "code": "372465003",
            "display": "Intradiscal use"
          },
          {
            "code": "372466002",
            "display": "Intralesional use"
          },
          {
            "code": "372467006",
            "display": "Intralymphatic use"
          },
          {
            "code": "372468001",
            "display": "Intraocular use"
          },
          {
            "code": "372469009",
            "display": "Intrapleural use"
          },
          {
            "code": "372470005",
            "display": "Intrasternal use"
          },
          {
            "code": "372471009",
            "display": "Intravesical use"
          },
          {
            "code": "372473007",
            "display": "Oromucosal use"
          },
          {
            "code": "372474001",
            "display": "Periarticular use"
          },
          {
            "code": "372475000",
            "display": "Perineural use"
          },
          {
            "code": "372476004",
            "display": "Subconjunctival use"
          },
          {
            "code": "404815008",
            "display": "Transmucosal route"
          },
          {
            "code": "404818005",
            "display": "Intratracheal route"
          },
          {
            "code": "404819002",
            "display": "Intrabiliary route"
          },
          {
            "code": "404820008",
            "display": "Epidural route"
          },
          {
            "code": "416174007",
            "display": "Suborbital route"
          },
          {
            "code": "417070009",
            "display": "Caudal route"
          },
          {
            "code": "417255000",
            "display": "Intraosseous route"
          },
          {
            "code": "417950001",
            "display": "Intrathoracic route"
          },
          {
            "code": "417985001",
            "display": "Enteral route"
          },
          {
            "code": "417989007",
            "display": "Intraductal route"
          },
          {
            "code": "418091004",
            "display": "Intratympanic route"
          },
          {
            "code": "418114005",
            "display": "Intravenous central route"
          },
          {
            "code": "418133000",
            "display": "Intramyometrial route"
          },
          {
            "code": "418136008",
            "display": "Gastro-intestinal stoma route"
          },
          {
            "code": "418162004",
            "display": "Colostomy route"
          },
          {
            "code": "418204005",
            "display": "Periurethral route"
          },
          {
            "code": "418287000",
            "display": "Intracoronal route"
          },
          {
            "code": "418321004",
            "display": "Retrobulbar route"
          },
          {
            "code": "418331006",
            "display": "Intracartilaginous route"
          },
          {
            "code": "418401004",
            "display": "Intravitreal route"
          },
          {
            "code": "418418000",
            "display": "Intraspinal route"
          },
          {
            "code": "418441008",
            "display": "Orogastric route"
          },
          {
            "code": "418511008",
            "display": "Transurethral route"
          },
          {
            "code": "418586008",
            "display": "Intratendinous route"
          },
          {
            "code": "418608002",
            "display": "Intracorneal route"
          },
          {
            "code": "418664002",
            "display": "Oropharyngeal route"
          },
          {
            "code": "418722009",
            "display": "Peribulbar route"
          },
          {
            "code": "418730005",
            "display": "Nasojejunal route"
          },
          {
            "code": "418743005",
            "display": "Fistula route"
          },
          {
            "code": "418813001",
            "display": "Surgical drain route"
          },
          {
            "code": "418821007",
            "display": "Intracameral route"
          },
          {
            "code": "418851001",
            "display": "Paracervical route"
          },
          {
            "code": "418877009",
            "display": "Intrasynovial route"
          },
          {
            "code": "418887008",
            "display": "Intraduodenal route"
          },
          {
            "code": "418892005",
            "display": "Intracisternal route"
          },
          {
            "code": "418947002",
            "display": "Intratesticular route"
          },
          {
            "code": "418987007",
            "display": "Intracranial route"
          },
          {
            "code": "419021003",
            "display": "Tumor cavity route"
          },
          {
            "code": "419165009",
            "display": "Paravertebral route"
          },
          {
            "code": "419231003",
            "display": "Intrasinal route"
          },
          {
            "code": "419243002",
            "display": "Transcervical route"
          },
          {
            "code": "419320008",
            "display": "Subtendinous route"
          },
          {
            "code": "419396008",
            "display": "Intraabdominal route"
          },
          {
            "code": "419601003",
            "display": "Subgingival route"
          },
          {
            "code": "419631009",
            "display": "Intraovarian route"
          },
          {
            "code": "419684008",
            "display": "Ureteral route"
          },
          {
            "code": "419762003",
            "display": "Peritendinous route"
          },
          {
            "code": "419778001",
            "display": "Intrabronchial route"
          },
          {
            "code": "419810008",
            "display": "Intraprostatic route"
          },
          {
            "code": "419874009",
            "display": "Submucosal route"
          },
          {
            "code": "419894000",
            "display": "Surgical cavity route"
          },
          {
            "code": "419954003",
            "display": "Ileostomy route"
          },
          {
            "code": "419993007",
            "display": "Intravenous peripheral route"
          },
          {
            "code": "420047004",
            "display": "Periosteal route"
          },
          {
            "code": "420163009",
            "display": "Esophagostomy route"
          },
          {
            "code": "420168000",
            "display": "Urostomy route"
          },
          {
            "code": "420185003",
            "display": "Laryngeal route"
          },
          {
            "code": "420201002",
            "display": "Intrapulmonary route"
          },
          {
            "code": "420204005",
            "display": "Mucous fistula route"
          },
          {
            "code": "420218003",
            "display": "Nasoduodenal route"
          },
          {
            "code": "420254004",
            "display": "Body cavity route"
          },
          {
            "code": "420287000",
            "display": "Intraventricular route - cardiac"
          },
          {
            "code": "420719007",
            "display": "Intracerebroventricular route"
          },
          {
            "code": "428191002",
            "display": "Percutaneous route"
          },
          {
            "code": "429817007",
            "display": "Interstitial route"
          },
          {
            "code": "445752009",
            "display": "Intraesophageal route"
          },
          {
            "code": "445754005",
            "display": "Intragingival route"
          },
          {
            "code": "445755006",
            "display": "Intravascular route"
          },
          {
            "code": "445756007",
            "display": "Intradural route"
          },
          {
            "code": "445767008",
            "display": "Intrameningeal route"
          },
          {
            "code": "445768003",
            "display": "Intragastric route"
          },
          {
            "code": "445769006",
            "display": "Intracorpus cavernosum route"
          },
          {
            "code": "445771006",
            "display": "Intrapericardial route"
          },
          {
            "code": "445913005",
            "display": "Intralingual route"
          },
          {
            "code": "445941009",
            "display": "Intrahepatic route"
          },
          {
            "code": "446105004",
            "display": "Conjunctival route"
          },
          {
            "code": "446407004",
            "display": "Intraepicardial route"
          },
          {
            "code": "446435000",
            "display": "Transendocardial route"
          },
          {
            "code": "446442000",
            "display": "Transplacental route"
          },
          {
            "code": "446540005",
            "display": "Intracerebral route"
          },
          {
            "code": "447026006",
            "display": "Intraileal route"
          },
          {
            "code": "447052000",
            "display": "Periodontal route"
          },
          {
            "code": "447080003",
            "display": "Peridural route"
          },
          {
            "code": "447081004",
            "display": "Lower respiratory tract route"
          },
          {
            "code": "447121004",
            "display": "Intramammary route"
          },
          {
            "code": "447122006",
            "display": "Intratumor route"
          },
          {
            "code": "447227007",
            "display": "Transtympanic route"
          },
          {
            "code": "447229005",
            "display": "Transtracheal route"
          },
          {
            "code": "447694001",
            "display": "Respiratory tract route"
          },
          {
            "code": "447964005",
            "display": "Digestive tract route"
          },
          {
            "code": "448077001",
            "display": "Intraepidermal route"
          },
          {
            "code": "448491004",
            "display": "Intrajejunal route"
          },
          {
            "code": "448492006",
            "display": "Intracolonic route"
          },
          {
            "code": "448598008",
            "display": "Cutaneous route"
          },
          {
            "code": "697971008",
            "display": "Arteriovenous fistula route"
          },
          {
            "code": "711360002",
            "display": "Intraneural route"
          },
          {
            "code": "711378007",
            "display": "Intramural route"
          },
          {
            "code": "714743009",
            "display": "Extracorporeal route"
          },
          {
            "code": "718329006",
            "display": "Infiltration route"
          },
          {
            "code": "1611000175109",
            "display": "Sublesional route"
          },
          {
            "code": "180677251000087104",
            "display": "Intraventricular"
          },
          {
            "code": "461657851000087101",
            "display": "Translingual"
          }
        ]
      }]
    }
  }

  # Description https://hl7.org/fhir/R4/valueset-reason-medication-given-codes.html
  # Used in:
  # Resource: MedicationAdministration.statusReason (CodeableConcept)
  @REASON_MEDICATION_GIVEN_VS = {
    "resourceType" : "ValueSet",
    "id" : "reason-medication-given-codes",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div>!-- Snipped for Brevity --></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "phx"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "draft"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 1
      }],
    "url" : "http://hl7.org/fhir/ValueSet/reason-medication-given-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.344"
    }],
    "version" : "4.0.1",
    "name" : "ReasonMedicationGivenCodes",
    "title" : "Reason Medication Given Codes",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "This value set is provided as an example. The value set to instantiate this attribute should be drawn from a robust terminology code system that consists of or contains concepts to support the medication process.",
    "immutable" : true,
    "compose" : {
      "include" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/reason-medication-given",
        "concept" : [
          {
            "code" : "a",
            "display" : "None",
            "definition": "No reason known."
          },
          {
            "code" : "b",
            "display" : "Given as Ordered",
            "definition": "The administration was following an ordered protocol."
          },
          {
            "code" : "c",
            "display" : "Emergency",
            "definition": "The administration was needed to treat an emergency."
          }
        ]
      }]
    }
  }

  # Description   https://hl7.org/fhir/R4/v3/ActEncounterCode/vs.html
  # Used in:
  # Resource: Encounter.class (Coding)
  @ACT_ENCOUNTER_CODE_VS = {
    "resourceType" : "ValueSet",
    "id" : "v3-ActEncounterCode",
    "language" : "en",
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\"><h2>ActEncounterCode</h2><div><p>Domain provides codes that qualify the ActEncounterClass (ENC)</p>\n</div><p>This value set includes codes based on the following rules:</p><ul><li>Include codes from <a href=\"CodeSystem-v3-ActCode.html\"><code>http://terminology.hl7.org/CodeSystem/v3-ActCode</code></a> where concept  is-a  <a href=\"CodeSystem-v3-ActCode.html#v3-ActCode-_ActEncounterCode\">_ActEncounterCode</a></li><li>Exclude these codes as defined in <a href=\"CodeSystem-v3-ActCode.html\"><code>http://terminology.hl7.org/CodeSystem/v3-ActCode</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td></tr><tr><td><a href=\"CodeSystem-v3-ActCode.html#v3-ActCode-_ActEncounterCode\">_ActEncounterCode</a></td><td>ActEncounterCode</td><td>Domain provides codes that qualify the ActEncounterClass (ENC)</td></tr></table></li></ul></div>"
    },
    "url" : "http://terminology.hl7.org/ValueSet/v3-ActEncounterCode",
    "identifier" : [
      {
        "system" : "urn:ietf:rfc:3986",
        "value" : "urn:oid:2.16.840.1.113883.1.11.13955"
      }
    ],
    "version" : "2.0.0",
    "name" : "ActEncounterCode",
    "title" : "ActEncounterCode",
    "status" : "active",
    "date" : "2014-03-26T00:00:00-04:00",
    "description" : "Domain provides codes that qualify the ActEncounterClass (ENC)",
    "compose" : {
      "include" : [
        {
          "system" : "http://terminology.hl7.org/CodeSystem/v3-ActCode",
          "concept" : [
            {
              "code": "AMB",
              "display": "ambulatory"
            },
            {
              "code": "EMER",
              "display": "emergency"
            },
            {
              "code": "FLD",
              "display": "field"
            },
            {
              "code": "HH",
              "display": "home health"
            },
            {
              "code": "IMP",
              "display": "inpatient encounter"
            },
            {
              "code": "ACUTE",
              "display": "inpatient acute"
            },
            {
              "code": "NONAC",
              "display": "inpatient non-acute"
            },
            {
              "code": "OBSENC",
              "display": "observation encounter"
            },
            {
              "code": "PRENC",
              "display": "pre-admission"
            },
            {
              "code": "SS",
              "display": "short stay"
            },
            {
              "code": "VR",
              "display": "virtual"
            }
          ]
        }
      ]
    }
  }

  # Description   https://hl7.org/fhir/R4/valueset-encounter-admit-source.html
  # Used in:
  # Resource: Encounter.hospitalization.admitSource (CodeableConcepts)
  @ENCOUNTER_ADMIT_SOURCE_VS = {
    "resourceType" : "ValueSet",
    "id" : "encounter-admit-source",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Admit source</h2><div><p>This value set defines a set of codes that can be used to indicate from where the patient came in.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-encounter-admit-source.html\"><code>http://terminology.hl7.org/CodeSystem/admit-source</code></a></li></ul></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "pa"
    }],
    "url" : "http://hl7.org/fhir/ValueSet/encounter-admit-source",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.257"
    }],
    "version" : "4.0.1",
    "name" : "AdmitSource",
    "title" : "Admit source",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "This value set defines a set of codes that can be used to indicate from where the patient came in.",
    "immutable" : true,
    "compose" : {
      "include" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/admit-source",
        "concept" : [
          {
            "code" : "hosp-trans",
            "display" : "Transferred from other hospital",
          },
          {
            "code" : "emd",
            "display" : "From accident/emergency department",
          },
          {
            "code" : "outp",
            "display" : "From outpatient department",
          },
          {
            "code" : "born",
            "display" : "Born in hospital",
          },
          {
            "code" : "gp",
            "display" : "General Practitioner referral",
          },
          {
            "code" : "mp",
            "display" : "Medical Practitioner/physician referral",
          },
          {
            "code" : "nursing",
            "display" : "From nursing home",
          },
          {
            "code" : "psych",
            "display" : "From psychiatric hospital",
          },
          {
            "code" : "rehab",
            "display" : "From rehabilitation facility",
          },
          {
            "code" : "other",
            "display" : "Other",
          }
        ]
      }]
    }
  }

  # Description https://www.hl7.org/fhir/valueset-medicationrequest-category.html
  # Used in:
  # Resource: MedicationRequest.category
  @MEDICATION_REQUEST_CATEGORY_VS = {
    "resourceType" : "ValueSet",
    "id" : "medicationrequest-category",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Medication request  category  codes</h2><div><p>MedicationRequest Category Codes</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-medicationrequest-category.html\"><code>http://terminology.hl7.org/CodeSystem/medicationrequest-category</code></a></li></ul></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "phx"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "draft"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 1
      }],
    "url" : "http://hl7.org/fhir/ValueSet/medicationrequest-category",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.1322"
    }],
    "version" : "4.0.1",
    "name" : "medicationRequest Category Codes",
    "title" : "Medication request  category  codes",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "MedicationRequest Category Codes",
    "immutable" : true,
    "compose" : {
      "include" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/medicationrequest-category",
        "concept" : [
          {
            "code": "inpatient",
            "display": "Inpatient"
          },
          {
            "code": "outpatient",
            "display": "Outpatient"
          },
          {
            "code": "community",
            "display": "Community"
          },
          {
            "code": "discharge",
            "display": "Discharge"
          }
        ]
      }]
    }
  }

  # Description: https://www.hl7.org/fhir/valueset-timing-abbreviation.html
  # See:
  # Dosage - https://www.hl7.org/fhir/dosage.html
  # Timing - https://www.hl7.org/fhir/datatypes.html#Timing
  # Used in MedicationRequest.dosageInstruction.timing.code
  @TIMING_ABBREVIATION_VS = {
    "resourceType" : "ValueSet",
    "id" : "timing-abbreviation",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "extensions",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>TimingAbbreviation</h2><div><p>Code for a known / defined timing pattern.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include these codes as defined in <a href=\"v3/GTSAbbreviation/cs.html\"><code>http://terminology.hl7.org/CodeSystem/v3-GTSAbbreviation</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td><td><b>Definition</b></td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-BID\">BID</a></td><td>BID</td><td>Two times a day at institution specified time</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-TID\">TID</a></td><td>TID</td><td>Three times a day at institution specified time</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-QID\">QID</a></td><td>QID</td><td>Four times a day at institution specified time</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-AM\">AM</a></td><td>AM</td><td>Every morning at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-PM\">PM</a></td><td>PM</td><td>Every afternoon at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-QD\">QD</a></td><td>QD</td><td>Every Day at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-QOD\">QOD</a></td><td>QOD</td><td>Every Other Day at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-Q1H\">Q1H</a></td><td>every hour</td><td>Every hour at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-Q2H\">Q2H</a></td><td>every 2 hours</td><td>Every 2 hours at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-Q3H\">Q3H</a></td><td>every 3 hours</td><td>Every 3 hours at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-Q4H\">Q4H</a></td><td>Q4H</td><td>Every 4 hours at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-Q6H\">Q6H</a></td><td>Q6H</td><td>Every 6 Hours  at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-Q8H\">Q8H</a></td><td>every 8 hours</td><td>Every 8 hours at institution specified times</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-BED\">BED</a></td><td>at bedtime</td><td>At bedtime (institution specified time)</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-WK\">WK</a></td><td>weekly</td><td>Weekly at institution specified time</td></tr><tr><td><a href=\"v3/GTSAbbreviation/cs.html#v3-GTSAbbreviation-MO\">MO</a></td><td>monthly</td><td>Monthly at institution specified time</td></tr></table></li></ul></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "fhir"
    }],
    "url" : "http://hl7.org/fhir/ValueSet/timing-abbreviation",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.78"
    }],
    "version" : "4.0.1",
    "name" : "TimingAbbreviation",
    "title" : "TimingAbbreviation",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      },
        {
          "system" : "email",
          "value" : "fhir@lists.hl7.org"
        }]
    }],
    "description" : "Code for a known / defined timing pattern.",
    "compose" : {
      "include" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/v3-GTSAbbreviation",
        "concept" : [{
          "extension" : [{
            "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
            "valueString" : "Two times a day at institution specified time"
          }],
          "code" : "BID",
          "display" : "BID"
        },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Three times a day at institution specified time"
            }],
            "code" : "TID",
            "display" : "TID"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Four times a day at institution specified time"
            }],
            "code" : "QID",
            "display" : "QID"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every morning at institution specified times"
            }],
            "code" : "AM",
            "display" : "AM"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every afternoon at institution specified times"
            }],
            "code" : "PM",
            "display" : "PM"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every Day at institution specified times"
            }],
            "code" : "QD",
            "display" : "QD"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every Other Day at institution specified times"
            }],
            "code" : "QOD",
            "display" : "QOD"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every hour at institution specified times"
            }],
            "code" : "Q1H",
            "display" : "every hour"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every 2 hours at institution specified times"
            }],
            "code" : "Q2H",
            "display" : "every 2 hours"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every 3 hours at institution specified times"
            }],
            "code" : "Q3H",
            "display" : "every 3 hours"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every 4 hours at institution specified times"
            }],
            "code" : "Q4H",
            "display" : "Q4H"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every 6 Hours  at institution specified times"
            }],
            "code" : "Q6H",
            "display" : "Q6H"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Every 8 hours at institution specified times"
            }],
            "code" : "Q8H",
            "display" : "every 8 hours"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "At bedtime (institution specified time)"
            }],
            "code" : "BED",
            "display" : "at bedtime"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Weekly at institution specified time"
            }],
            "code" : "WK",
            "display" : "weekly"
          },
          {
            "extension" : [{
              "url" : "http://hl7.org/fhir/StructureDefinition/valueset-concept-definition",
              "valueString" : "Monthly at institution specified time"
            }],
            "code" : "MO",
            "display" : "monthly"
          }]
      }]
    }
  }

  # Description  http://hl7.org/fhir/R4/valueset-medicationrequest-status-reason.html
  # Used in: MedicationRequest.statusReason
  @MEDICATION_REQUEST_STATUS_REASON_VS = {
    "resourceType" : "ValueSet",
    "id" : "medicationrequest-status-reason",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Medication request  status  reason  codes</h2><div><p>MedicationRequest Status Reason Codes</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-medicationrequest-status-reason.html\"><code>http://terminology.hl7.org/CodeSystem/medicationrequest-status-reason</code></a></li></ul></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "phx"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "draft"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 1
      }],
    "url" : "http://hl7.org/fhir/ValueSet/medicationrequest-status-reason",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.1324"
    }],
    "version" : "4.0.1",
    "name" : "medicationRequest Status Reason Codes",
    "title" : "Medication request  status  reason  codes",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "MedicationRequest Status Reason Codes",
    "immutable" : true,
    "compose" : {
      "include" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/medicationrequest-status-reason",
        "concept": [{
          "code" : "altchoice",
          "display" : "Try another treatment first",
          "definition" : "This therapy has been ordered as a backup to a preferred therapy. This order will be released when and if the preferred therapy is unsuccessful."
        },
          {
            "code" : "clarif",
            "display" : "Prescription requires clarification",
            "definition" : "Clarification is required before the order can be acted upon."
          },
          {
            "code" : "drughigh",
            "display" : "Drug level too high",
            "definition" : "The current level of the medication in the patient's system is too high. The medication is suspended to allow the level to subside to a safer level."
          },
          {
            "code" : "hospadm",
            "display" : "Admission to hospital",
            "definition" : "The patient has been admitted to a care facility and their community medications are suspended until hospital discharge."
          },
          {
            "code" : "labint",
            "display" : "Lab interference issues",
            "definition" : "The therapy would interfere with a planned lab test and the therapy is being withdrawn until the test is completed."
          },
          {
            "code" : "non-avail",
            "display" : "Patient not available",
            "definition" : "Patient not available for a period of time due to a scheduled therapy, leave of absence or other reason."
          },
          {
            "code" : "preg",
            "display" : "Parent is pregnant/breast feeding",
            "definition" : "The patient is pregnant or breast feeding. The therapy will be resumed when the pregnancy is complete and the patient is no longer breastfeeding."
          },
          {
            "code" : "salg",
            "display" : "Allergy",
            "definition" : "The patient is believed to be allergic to a substance that is part of the therapy and the therapy is being temporarily withdrawn to confirm."
          },
          {
            "code" : "sddi",
            "display" : "Drug interacts with another drug",
            "definition" : "The drug interacts with a short-term treatment that is more urgently required. This order will be resumed when the short-term treatment is complete."
          },
          {
            "code" : "sdupther",
            "display" : "Duplicate therapy",
            "definition" : "The drug interacts with a short-term treatment that is more urgently required. This order will be resumed when the short-term treatment is complete."
          },
          {
            "code" : "sintol",
            "display" : "Suspected intolerance",
            "definition" : "The drug interacts with a short-term treatment that is more urgently required. This order will be resumed when the short-term treatment is complete."
          },
          {
            "code" : "surg",
            "display" : "Patient scheduled for surgery.",
            "definition" : "The drug is contraindicated for patients receiving surgery and the patient is scheduled to be admitted for surgery in the near future. The drug will be resumed when the patient has sufficiently recovered from the surgery."
          },
          {
            "code" : "washout",
            "display" : "Waiting for old drug to wash out",
            "definition" : "The patient was previously receiving a medication contraindicated with the current medication. The current medication will remain on hold until the prior medication has been cleansed from their system."
          }]
      }]
    }
  }
