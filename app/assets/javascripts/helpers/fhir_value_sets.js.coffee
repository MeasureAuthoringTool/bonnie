@FhirValueSets = class FhirValueSets

  @bindingsCodeSystemMap: ->
    return @_codeSystemMap if @_codeSystemMap?
    @_codeSystemMap = {}
    # TODO: move this to parser
    @_codeSystemMap['http://snomed.info/sct'] = 'SNOMED CT'
    @_codeSystemMap['http://hl7.org/fhir/CodeSystem/medication-statement-status'] = 'medication-statement-status'
    @_codeSystemMap['http://hl7.org/fhir/CodeSystem/medicationrequest-intent'] = 'medicationrequest-intent'
    @_codeSystemMap['http://hl7.org/fhir/CodeSystem/medicationrequest-status'] = 'medicationrequest-status'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/discharge-disposition'] = 'discharge-disposition'
    @_codeSystemMap['http://hl7.org/fhir/encounter-status'] = 'encounter-status'
    @_codeSystemMap['http://hl7.org/fhir/event-status'] = 'event-status'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/condition-ver-status'] = 'condition-ver-status'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/condition-clinical'] = 'condition-clinical'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/allergyintolerance-clinical'] = 'allergyintolerance-clinical'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/allergyintolerance-verification'] = 'allergyintolerance-verification'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/condition-category'] = 'ConditionCategoryCodes'
    @_codeSystemMap['http://hl7.org/fhir/us/core/CodeSystem/condition-category'] = 'USCoreConditionCategoryExtensionCodes'
    @_codeSystemMap['http://hl7.org/fhir/request-status'] = 'request-status'
    @_codeSystemMap['http://hl7.org/fhir/request-intent'] = 'request-intent'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/admit-source'] = 'admit-source'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/v3-ActCode'] = 'ActCode'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/reason-medication-given'] = 'ReasonMedicationGivenCodes'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/medicationrequest-category'] = 'MedicationRequestCategoryCodes'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/v3-GTSAbbreviation'] = 'GTSAbbreviation'
    @_codeSystemMap['http://terminology.hl7.org/CodeSystem/medicationrequest-status-reason'] = 'MedicationRequest Status Reason Codes'

    return @_codeSystemMap

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

  # Desciption  https://hl7.org/fhir/R4/codesystem-event-status.html
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

#  Description https://hl7.org/fhir/R4/valueset-device-kind.html
# Used in:
# Resource: ChargeItem.product[x] (Reference(Device|Medication|Substance)|CodeableConcept / Example)
# Resource: DeviceRequest.code[x] (Reference(Device)|CodeableConcept / Example)
# Resource: Procedure.usedCode (CodeableConcept / Example)
# Resource: DeviceDefinition.type (CodeableConcept / Example)
# Extension: https://hl7.org/fhir/StructureDefinition/observation-deviceCode: deviceCode (CodeableConcept / Example)
  @DEVICE_KIND_VS =
    {
      "resourceType" : "ValueSet",
      "id" : "device-kind",
      "meta" : {
        "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
      },
      "text" : {
        "status" : "generated",
        "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>FHIR Device Types</h2><div><p>Codes used to identify medical devices. Includes concepts from SNOMED CT (http://www.snomed.org/) where concept is-a 49062001 (Device)  and is provided as a suggestive example.</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  49062001 (Device)</li></ul></div>"
      },
      "extension" : [{
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
        "valueCode" : "oo"
      },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
          "valueCode" : "draft"
        },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
          "valueInteger" : 1
        }],
      "url" : "http://hl7.org/fhir/ValueSet/device-kind",
      "identifier" : [{
        "system" : "urn:ietf:rfc:3986",
        "value" : "urn:oid:2.16.840.1.113883.4.642.3.208"
      }],
      "version" : "4.0.1",
      "name" : "FHIRDeviceTypes",
      "title" : "FHIR Device Types",
      "status" : "draft",
      "experimental" : false,
      "date" : "2019-11-01T09:29:23+11:00",
      "publisher" : "HL7 Orders and Observations Workgroup",
      "contact" : [{
        "telecom" : [{
          "system" : "url",
          "value" : "http://hl7.org/fhir"
        }]
      }],
      "description" : "Codes used to identify medical devices. Includes concepts from SNOMED CT (http://www.snomed.org/) where concept is-a 49062001 (Device)  and is provided as a suggestive example.",
      "copyright" : "This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
      "compose" : {
        "include" : [
          {
            "system" : "http://snomed.info/sct",
            "concept": [
              {
                "code": "49062001",
                "display": "Device (physical object)"
              },
              {
                "code": "156009",
                "display": "Spine board"
              },
              {
                "code": "271003",
                "display": "Bone plate"
              },
              {
                "code": "287000",
                "display": "Air receiver"
              },
              {
                "code": "291005",
                "display": "Atomizer"
              },
              {
                "code": "678001",
                "display": "Epilator"
              },
              {
                "code": "739006",
                "display": "Bicycle ergometer"
              },
              {
                "code": "793009",
                "display": "Mechanical power press"
              },
              {
                "code": "882002",
                "display": "Diagnostic implant"
              },
              {
                "code": "972002",
                "display": "Air filter, device"
              },
              {
                "code": "989005",
                "display": "Linen cloth"
              },
              {
                "code": "994005",
                "display": "Brush, device"
              },
              {
                "code": "1211003",
                "display": "Treadmill, device"
              },
              {
                "code": "1333003",
                "display": "Emesis basin, device"
              },
              {
                "code": "1422002",
                "display": "Plastic mold, device"
              },
              {
                "code": "1579007",
                "display": "Surgical drill, device"
              },
              {
                "code": "1766001",
                "display": "Toboggan, device"
              },
              {
                "code": "1941006",
                "display": "Silk cloth"
              },
              {
                "code": "1962007",
                "display": "Dike, device"
              },
              {
                "code": "2248009",
                "display": "Tracheal tube cuff"
              },
              {
                "code": "2282003",
                "display": "Breast implant"
              },
              {
                "code": "2287009",
                "display": "Nail file, device"
              },
              {
                "code": "2468001",
                "display": "Breath analyzer, device"
              },
              {
                "code": "2478003",
                "display": "Ocular prosthesis"
              },
              {
                "code": "2491002",
                "display": "Intra-aortic balloon catheter, device"
              },
              {
                "code": "3201004",
                "display": "Tent, device"
              },
              {
                "code": "3319006",
                "display": "Artificial liver, device"
              },
              {
                "code": "4408003",
                "display": "Endoscopic camera, device"
              },
              {
                "code": "4632004",
                "display": "Hair cloth"
              },
              {
                "code": "4816004",
                "display": "Metal device"
              },
              {
                "code": "5041003",
                "display": "Adhesive strip, device"
              },
              {
                "code": "5042005",
                "display": "Patient scale, device"
              },
              {
                "code": "5159002",
                "display": "Physiologic monitoring system, device"
              },
              {
                "code": "5679009",
                "display": "Bed sheet"
              },
              {
                "code": "6012004",
                "display": "Hearing aid"
              },
              {
                "code": "6097006",
                "display": "T-tube"
              },
              {
                "code": "6822006",
                "display": "Microwave oven"
              },
              {
                "code": "6919005",
                "display": "Protective clothing material"
              },
              {
                "code": "6972009",
                "display": "Lithotripter"
              },
              {
                "code": "7007007",
                "display": "Radiographic-fluoroscopic unit"
              },
              {
                "code": "7402007",
                "display": "Probe"
              },
              {
                "code": "7406005",
                "display": "Crib"
              },
              {
                "code": "7704007",
                "display": "Stabilizing appliance"
              },
              {
                "code": "7733008",
                "display": "Hydrocephalic shunt catheter"
              },
              {
                "code": "7968002",
                "display": "Three-wheeled all-terrain vehicle"
              },
              {
                "code": "7971005",
                "display": "Fogarty catheter"
              },
              {
                "code": "8060009",
                "display": "Denture"
              },
              {
                "code": "8118007",
                "display": "Crane"
              },
              {
                "code": "8170008",
                "display": "Adhesive"
              },
              {
                "code": "8384009",
                "display": "Band saw"
              },
              {
                "code": "8407004",
                "display": "Bile collection bag"
              },
              {
                "code": "8434001",
                "display": "Gaol"
              },
              {
                "code": "8451008",
                "display": "Intramedullary nail"
              },
              {
                "code": "8615009",
                "display": "Blood electrolyte analyzer"
              },
              {
                "code": "8643000",
                "display": "Mortising machine"
              },
              {
                "code": "8682003",
                "display": "Protective shield"
              },
              {
                "code": "9017009",
                "display": "Ventricular intracranial catheter"
              },
              {
                "code": "9096001",
                "display": "Support"
              },
              {
                "code": "9129003",
                "display": "Feeding catheter"
              },
              {
                "code": "9419002",
                "display": "Bobsled"
              },
              {
                "code": "9458007",
                "display": "Elastic bandage"
              },
              {
                "code": "9611009",
                "display": "Dermatotome"
              },
              {
                "code": "9883003",
                "display": "Cargo handling gear"
              },
              {
                "code": "10244001",
                "display": "Needle guide"
              },
              {
                "code": "10371004",
                "display": "Electrostimulating analgesia unit"
              },
              {
                "code": "10507000",
                "display": "Toeboard"
              },
              {
                "code": "10826000",
                "display": "Industrial saw"
              },
              {
                "code": "10850003",
                "display": "Radiographic-therapeutic unit"
              },
              {
                "code": "10906003",
                "display": "Vein stripper"
              },
              {
                "code": "11141007",
                "display": "Bone growth stimulator"
              },
              {
                "code": "11158002",
                "display": "Electromyographic monitor and recorder"
              },
              {
                "code": "11358008",
                "display": "Prosthetic valve"
              },
              {
                "code": "11987000",
                "display": "Clinical chemistry analyzer"
              },
              {
                "code": "12150006",
                "display": "Cannula"
              },
              {
                "code": "12183004",
                "display": "Upper limb prosthesis"
              },
              {
                "code": "12198002",
                "display": "Ice skate"
              },
              {
                "code": "12953007",
                "display": "File"
              },
              {
                "code": "13118005",
                "display": "Wool cloth"
              },
              {
                "code": "13219008",
                "display": "Gastroscope"
              },
              {
                "code": "13288007",
                "display": "Monitors"
              },
              {
                "code": "13459008",
                "display": "Temporary artificial heart prosthesis"
              },
              {
                "code": "13764006",
                "display": "Uterine sound"
              },
              {
                "code": "13855007",
                "display": "Pillow"
              },
              {
                "code": "13905003",
                "display": "Tennis ball"
              },
              {
                "code": "14106009",
                "display": "Cardiac pacemaker implant"
              },
              {
                "code": "14108005",
                "display": "Cage"
              },
              {
                "code": "14116001",
                "display": "Analgesia unit"
              },
              {
                "code": "14208000",
                "display": "Oil well"
              },
              {
                "code": "14288003",
                "display": "Nasal septum button"
              },
              {
                "code": "14339000",
                "display": "Button"
              },
              {
                "code": "14364002",
                "display": "Camera"
              },
              {
                "code": "14423008",
                "display": "Adhesive bandage"
              },
              {
                "code": "14519003",
                "display": "Aspirator"
              },
              {
                "code": "14548009",
                "display": "Harrington rod"
              },
              {
                "code": "14762000",
                "display": "Alloy steel chain sling"
              },
              {
                "code": "14789005",
                "display": "Prosthetic implant"
              },
              {
                "code": "15000008",
                "display": "Air-conditioner"
              },
              {
                "code": "15340005",
                "display": "Wood's light"
              },
              {
                "code": "15447007",
                "display": "Arthroplasty prosthesis"
              },
              {
                "code": "15644007",
                "display": "Anesthesia unit"
              },
              {
                "code": "15869005",
                "display": "Dosimeter, device"
              },
              {
                "code": "15873008",
                "display": "Boiler, device"
              },
              {
                "code": "15922004",
                "display": "Gown, device"
              },
              {
                "code": "16056004",
                "display": "Boots"
              },
              {
                "code": "16349000",
                "display": "Orthopedic equipment"
              },
              {
                "code": "16417001",
                "display": "Commercial breathing supply hoses diving operation, device"
              },
              {
                "code": "16470007",
                "display": "Electrode, device"
              },
              {
                "code": "16497000",
                "display": "Electric clipper, device"
              },
              {
                "code": "16524003",
                "display": "Cotton cloth"
              },
              {
                "code": "16540000",
                "display": "Umbrella catheter, device"
              },
              {
                "code": "16650009",
                "display": "Splint, device"
              },
              {
                "code": "17102003",
                "display": "NG - Nasogastric tube"
              },
              {
                "code": "17107009",
                "display": "Prosthetic mitral valve"
              },
              {
                "code": "17207004",
                "display": "Mattress, device"
              },
              {
                "code": "17306006",
                "display": "Hernia belt, device"
              },
              {
                "code": "17404008",
                "display": "Cardiac compression board, device"
              },
              {
                "code": "17472008",
                "display": "Knife, device"
              },
              {
                "code": "18151003",
                "display": "Punch, device"
              },
              {
                "code": "18153000",
                "display": "Fluorescence immunoassay analyzer, device"
              },
              {
                "code": "18411005",
                "display": "Chisel, device"
              },
              {
                "code": "18666004",
                "display": "Finespun glass"
              },
              {
                "code": "19257004",
                "display": "Defibrillator, device"
              },
              {
                "code": "19328000",
                "display": "Blanket, device"
              },
              {
                "code": "19443004",
                "display": "Radioactive implant, device"
              },
              {
                "code": "19627002",
                "display": "Leather"
              },
              {
                "code": "19762002",
                "display": "Leather belt"
              },
              {
                "code": "19817005",
                "display": "Fan blade, device"
              },
              {
                "code": "19892000",
                "display": "Scale, device"
              },
              {
                "code": "19923001",
                "display": "Catheter, device"
              },
              {
                "code": "20195009",
                "display": "Leg prosthesis, device"
              },
              {
                "code": "20235003",
                "display": "Toothbrush, device"
              },
              {
                "code": "20273004",
                "display": "Industrial machine, device"
              },
              {
                "code": "20359006",
                "display": "Contraceptive diaphragm, device"
              },
              {
                "code": "20406008",
                "display": "Back rests, device"
              },
              {
                "code": "20428008",
                "display": "Oxygen tent, device"
              },
              {
                "code": "20513005",
                "display": "Power tool, device"
              },
              {
                "code": "20568009",
                "display": "Urinary catheter, device"
              },
              {
                "code": "20613002",
                "display": "Cystoscope, device"
              },
              {
                "code": "20861007",
                "display": "Plug pack, device"
              },
              {
                "code": "20867006",
                "display": "Experimental implant, device"
              },
              {
                "code": "20873007",
                "display": "Plastic cloth-like material"
              },
              {
                "code": "20997002",
                "display": "Hand tool, device"
              },
              {
                "code": "21079000",
                "display": "Carbon monoxide analyzer, device"
              },
              {
                "code": "21546008",
                "display": "Icebox"
              },
              {
                "code": "21870002",
                "display": "Transluminal extraction catheter, device"
              },
              {
                "code": "21944004",
                "display": "Abdominal binder, device"
              },
              {
                "code": "22251003",
                "display": "Timer, device"
              },
              {
                "code": "22283009",
                "display": "Artificial membrane, device"
              },
              {
                "code": "22566001",
                "display": "Cytology brush, device"
              },
              {
                "code": "22662007",
                "display": "Retaining harness, device"
              },
              {
                "code": "22679001",
                "display": "Handcuffs, device"
              },
              {
                "code": "22744006",
                "display": "Artificial hair wig, device"
              },
              {
                "code": "22852002",
                "display": "Therapeutic implant, device"
              },
              {
                "code": "23228005",
                "display": "Arthroscope, device"
              },
              {
                "code": "23366006",
                "display": "Motorized wheelchair device"
              },
              {
                "code": "23699001",
                "display": "Baseball, device"
              },
              {
                "code": "23785007",
                "display": "Arthroscopic irrigation/distension pump, device"
              },
              {
                "code": "23973005",
                "display": "Indwelling urinary catheter, device"
              },
              {
                "code": "24073000",
                "display": "Mechanical cardiac valve prosthesis"
              },
              {
                "code": "24110008",
                "display": "Anoscope, device"
              },
              {
                "code": "24174009",
                "display": "Bronchoscope, device"
              },
              {
                "code": "24230000",
                "display": "Vibrator, device"
              },
              {
                "code": "24290003",
                "display": "Cardiac valve bioprosthesis"
              },
              {
                "code": "24402003",
                "display": "Stepladder, device"
              },
              {
                "code": "24470005",
                "display": "Wrench, device"
              },
              {
                "code": "24513003",
                "display": "Plastic boots"
              },
              {
                "code": "24697008",
                "display": "Ostomy belt, device"
              },
              {
                "code": "24767007",
                "display": "Eustachian tube prosthesis, device"
              },
              {
                "code": "25005004",
                "display": "Snare, device"
              },
              {
                "code": "25062003",
                "display": "Feeding tube, device"
              },
              {
                "code": "25152007",
                "display": "Squeeze cage, device"
              },
              {
                "code": "25510005",
                "display": "Heart valve prosthesis"
              },
              {
                "code": "25632005",
                "display": "Hockey puck, device"
              },
              {
                "code": "25680008",
                "display": "Scaffold, device"
              },
              {
                "code": "25742001",
                "display": "Orthodontic appliance, device"
              },
              {
                "code": "25937001",
                "display": "Neurostimulation device"
              },
              {
                "code": "26128008",
                "display": "Bougie, device"
              },
              {
                "code": "26239002",
                "display": "Soccer ball, device"
              },
              {
                "code": "26334009",
                "display": "Dockboard, device"
              },
              {
                "code": "26397000",
                "display": "Reservoir bag"
              },
              {
                "code": "26412008",
                "display": "ET - Endotracheal tube"
              },
              {
                "code": "26579007",
                "display": "Holter valve, device"
              },
              {
                "code": "26719000",
                "display": "Celestin tube, device"
              },
              {
                "code": "26882005",
                "display": "Rongeur, device"
              },
              {
                "code": "27042007",
                "display": "Needle adapter, device"
              },
              {
                "code": "27065002",
                "display": "Suture"
              },
              {
                "code": "27091001",
                "display": "Dumbwaiter, device"
              },
              {
                "code": "27126002",
                "display": "Power belt, device"
              },
              {
                "code": "27229001",
                "display": "Spray booth, device"
              },
              {
                "code": "27606000",
                "display": "Dental prosthesis, device"
              },
              {
                "code": "27785006",
                "display": "Athletic supporter, device"
              },
              {
                "code": "27812008",
                "display": "Electric heating pad, device"
              },
              {
                "code": "27976001",
                "display": "Woodworking machinery, device"
              },
              {
                "code": "27991004",
                "display": "Thermometer, device"
              },
              {
                "code": "28026003",
                "display": "Hairbrush, device"
              },
              {
                "code": "29292008",
                "display": "Fur garment"
              },
              {
                "code": "29319002",
                "display": "Forceps, device"
              },
              {
                "code": "29396008",
                "display": "Resuscitator, device"
              },
              {
                "code": "30012001",
                "display": "Elevator, device"
              },
              {
                "code": "30070001",
                "display": "Multistage suspension scaffolding, device"
              },
              {
                "code": "30115002",
                "display": "Shield, device"
              },
              {
                "code": "30176005",
                "display": "Baseball bat, device"
              },
              {
                "code": "30234008",
                "display": "Medical laboratory analyzer, device"
              },
              {
                "code": "30610008",
                "display": "Epidural catheter, device"
              },
              {
                "code": "30661003",
                "display": "Cosmetic prosthesis, device"
              },
              {
                "code": "30929000",
                "display": "Ligator, device"
              },
              {
                "code": "30968007",
                "display": "Drainage bag, device"
              },
              {
                "code": "31030004",
                "display": "Peritoneal catheter, device"
              },
              {
                "code": "31031000",
                "display": "Internal fixator"
              },
              {
                "code": "31174004",
                "display": "Lumbosacral belt, device"
              },
              {
                "code": "31791005",
                "display": "Traction belt, device"
              },
              {
                "code": "31878003",
                "display": "Surgical scissors, device"
              },
              {
                "code": "32033000",
                "display": "Arterial pressure monitor, device"
              },
              {
                "code": "32356002",
                "display": "Machine guarding, device"
              },
              {
                "code": "32504006",
                "display": "Screwdriver, device"
              },
              {
                "code": "32634007",
                "display": "Fixed ladder, device"
              },
              {
                "code": "32667006",
                "display": "Oral airway"
              },
              {
                "code": "32711007",
                "display": "Ostomy collection bag, device"
              },
              {
                "code": "32712000",
                "display": "Drain, device"
              },
              {
                "code": "32871007",
                "display": "Tweezer, device"
              },
              {
                "code": "33194000",
                "display": "Welding equipment, device"
              },
              {
                "code": "33352006",
                "display": "Ax, device"
              },
              {
                "code": "33388001",
                "display": "Carbon dioxide analyzer, device"
              },
              {
                "code": "33482001",
                "display": "Rubber boots"
              },
              {
                "code": "33686008",
                "display": "Stylet, device"
              },
              {
                "code": "33690005",
                "display": "Sharp instrument, device"
              },
              {
                "code": "33802005",
                "display": "Enema bag, device"
              },
              {
                "code": "33894003",
                "display": "Experimental device"
              },
              {
                "code": "33918000",
                "display": "Rubberized cloth"
              },
              {
                "code": "34164001",
                "display": "POP - Plaster of Paris cast"
              },
              {
                "code": "34188004",
                "display": "Straightjacket, device"
              },
              {
                "code": "34234003",
                "display": "Plastic tube, device"
              },
              {
                "code": "34263000",
                "display": "Medical balloon, device"
              },
              {
                "code": "34362008",
                "display": "Vascular device"
              },
              {
                "code": "34759008",
                "display": "Urethral catheter, device"
              },
              {
                "code": "35398009",
                "display": "Ostomy appliance, device"
              },
              {
                "code": "35593004",
                "display": "Wire ligature, device"
              },
              {
                "code": "35870000",
                "display": "Cerebrospinal catheter, device"
              },
              {
                "code": "36365007",
                "display": "Ice-pick, device"
              },
              {
                "code": "36370000",
                "display": "Aspirator trap bottle, device"
              },
              {
                "code": "36645008",
                "display": "Stimulator, device"
              },
              {
                "code": "36761001",
                "display": "Natural hair wig, device"
              },
              {
                "code": "36965003",
                "display": "Hemodialysis machine, device"
              },
              {
                "code": "36977008",
                "display": "Peripheral nerve stimulator"
              },
              {
                "code": "37189001",
                "display": "Magnetic detector, device"
              },
              {
                "code": "37270008",
                "display": "Endoscope, device"
              },
              {
                "code": "37284003",
                "display": "Bag, device"
              },
              {
                "code": "37311003",
                "display": "Stone retrieval basket, device"
              },
              {
                "code": "37347002",
                "display": "Dildo, device"
              },
              {
                "code": "37360008",
                "display": "Patient isolator, device"
              },
              {
                "code": "37503007",
                "display": "Protective blind, device"
              },
              {
                "code": "37759000",
                "display": "Surgical instrument, device"
              },
              {
                "code": "37874008",
                "display": "Continuing positive airway pressure unit, device"
              },
              {
                "code": "37953008",
                "display": "Bedside rails, device"
              },
              {
                "code": "38126007",
                "display": "Protective lenses"
              },
              {
                "code": "38141007",
                "display": "Tourniquet, device"
              },
              {
                "code": "38277008",
                "display": "Protective device"
              },
              {
                "code": "38806006",
                "display": "Hockey stick, device"
              },
              {
                "code": "38862006",
                "display": "Sheet metal bending equipment"
              },
              {
                "code": "38871002",
                "display": "Metallic cloth"
              },
              {
                "code": "39590006",
                "display": "Air compressor, device"
              },
              {
                "code": "39690000",
                "display": "Sphygmomanometer, device"
              },
              {
                "code": "39768008",
                "display": "Rasp, device"
              },
              {
                "code": "39790008",
                "display": "Non-electric heating pad, device"
              },
              {
                "code": "39802000",
                "display": "Tongue blade, device"
              },
              {
                "code": "39821008",
                "display": "Positron emission tomography unit, device"
              },
              {
                "code": "39849001",
                "display": "Nasal oxygen cannula"
              },
              {
                "code": "39869006",
                "display": "Alarm, device"
              },
              {
                "code": "40388003",
                "display": "Biomedical implant"
              },
              {
                "code": "40519001",
                "display": "Binder, device"
              },
              {
                "code": "41157002",
                "display": "Orthopedic immobilizer"
              },
              {
                "code": "41323003",
                "display": "Urinary collection bag, device"
              },
              {
                "code": "41525006",
                "display": "Artificial structure, device"
              },
              {
                "code": "41684000",
                "display": "Industrial tool, device"
              },
              {
                "code": "42152006",
                "display": "Metal tube, device"
              },
              {
                "code": "42305009",
                "display": "Ambulation device"
              },
              {
                "code": "42380001",
                "display": "Ear plug, device"
              },
              {
                "code": "42451009",
                "display": "Blood warmer, device"
              },
              {
                "code": "42716000",
                "display": "Wool"
              },
              {
                "code": "42882002",
                "display": "Hypodermic spray, device"
              },
              {
                "code": "43001000",
                "display": "Phlebotomy kit, device"
              },
              {
                "code": "43192004",
                "display": "Bone pencil, device"
              },
              {
                "code": "43252007",
                "display": "Cochlear implant"
              },
              {
                "code": "43725001",
                "display": "Airway equipment"
              },
              {
                "code": "43734006",
                "display": "Blood administration set, device"
              },
              {
                "code": "43770009",
                "display": "Doppler device"
              },
              {
                "code": "43983001",
                "display": "Shoes"
              },
              {
                "code": "44056008",
                "display": "Caliper, device"
              },
              {
                "code": "44396004",
                "display": "Magnet, device"
              },
              {
                "code": "44492001",
                "display": "Industrial robot, device"
              },
              {
                "code": "44668000",
                "display": "Pump, device"
              },
              {
                "code": "44738004",
                "display": "Laryngoscope, device"
              },
              {
                "code": "44806002",
                "display": "Esophageal bougie, device"
              },
              {
                "code": "44845007",
                "display": "Golf ball, device"
              },
              {
                "code": "44907005",
                "display": "Four-wheeled all-terrain vehicle, device"
              },
              {
                "code": "44959004",
                "display": "Angioplasty balloon catheter, device"
              },
              {
                "code": "45633005",
                "display": "Peritoneal dialyzer, device"
              },
              {
                "code": "45901004",
                "display": "Penrose drain, device"
              },
              {
                "code": "46181005",
                "display": "Automatic fire extinguisher system, device"
              },
              {
                "code": "46265007",
                "display": "Artificial lashes, device"
              },
              {
                "code": "46299005",
                "display": "Sanitary belt, device"
              },
              {
                "code": "46364009",
                "display": "Clamp, device"
              },
              {
                "code": "46440007",
                "display": "Basketball, device"
              },
              {
                "code": "46625003",
                "display": "Suppository"
              },
              {
                "code": "46666003",
                "display": "Chain, device"
              },
              {
                "code": "46949002",
                "display": "Deck machinery, device"
              },
              {
                "code": "47162009",
                "display": "Mirror, device"
              },
              {
                "code": "47326004",
                "display": "Electrical utilization equipment, device"
              },
              {
                "code": "47424002",
                "display": "Apgar scoring timer, device"
              },
              {
                "code": "47528002",
                "display": "Ureteric catheter"
              },
              {
                "code": "47731004",
                "display": "Birthing chair, device"
              },
              {
                "code": "47734007",
                "display": "Chromic catgut suture"
              },
              {
                "code": "47776004",
                "display": "Mittens"
              },
              {
                "code": "47942000",
                "display": "Proctoscope, device"
              },
              {
                "code": "48066006",
                "display": "Circular portable saw, device"
              },
              {
                "code": "48096001",
                "display": "Bathtub rails, device"
              },
              {
                "code": "48240003",
                "display": "Training equipment, device"
              },
              {
                "code": "48246009",
                "display": "Studgun, device"
              },
              {
                "code": "48295009",
                "display": "Vascular filter, device"
              },
              {
                "code": "48473008",
                "display": "Protective body armor, device"
              },
              {
                "code": "48822005",
                "display": "Bilirubin light, device"
              },
              {
                "code": "48990009",
                "display": "Strap, device"
              },
              {
                "code": "49448001",
                "display": "Razor, device"
              },
              {
                "code": "49890001",
                "display": "Hospital cart, device"
              },
              {
                "code": "50121007",
                "display": "Glasses"
              },
              {
                "code": "50457005",
                "display": "Workover rig service to oil well, device"
              },
              {
                "code": "50483000",
                "display": "Oil rig"
              },
              {
                "code": "50851003",
                "display": "Penile tumescence monitor, device"
              },
              {
                "code": "51016001",
                "display": "Hammer, device"
              },
              {
                "code": "51086006",
                "display": "Shower curtain, device"
              },
              {
                "code": "51324004",
                "display": "Stripper, device"
              },
              {
                "code": "51685009",
                "display": "Roller skate, device"
              },
              {
                "code": "51791000",
                "display": "Measuring tape, device"
              },
              {
                "code": "51832004",
                "display": "Valved tube, device"
              },
              {
                "code": "51883004",
                "display": "Sling, device"
              },
              {
                "code": "52124006",
                "display": "Central line"
              },
              {
                "code": "52161002",
                "display": "Molten lava"
              },
              {
                "code": "52291003",
                "display": "Gloves"
              },
              {
                "code": "52520009",
                "display": "Ladder, device"
              },
              {
                "code": "52537002",
                "display": "Aspirator collection canister, device"
              },
              {
                "code": "52624007",
                "display": "Radiofrequency generator, device"
              },
              {
                "code": "52773007",
                "display": "Ski, device"
              },
              {
                "code": "52809000",
                "display": "Nasopharyngeal catheter, device"
              },
              {
                "code": "52893008",
                "display": "Blood gas/pH analyzer, device"
              },
              {
                "code": "53167006",
                "display": "Platform suspended boom, device"
              },
              {
                "code": "53177008",
                "display": "Nasal balloon, device"
              },
              {
                "code": "53217009",
                "display": "Artificial lung, device"
              },
              {
                "code": "53350007",
                "display": "Prosthesis, device"
              },
              {
                "code": "53535004",
                "display": "Retractor, device"
              },
              {
                "code": "53639001",
                "display": "Stethoscope, device"
              },
              {
                "code": "53671008",
                "display": "Gastric balloon, device"
              },
              {
                "code": "53996008",
                "display": "Penile prosthesis, device"
              },
              {
                "code": "54234007",
                "display": "Cryogenic analgesia unit, device"
              },
              {
                "code": "54638004",
                "display": "Towel, device"
              },
              {
                "code": "54953005",
                "display": "Computerized axial tomography scanner, device"
              },
              {
                "code": "55091003",
                "display": "Blood coagulation analyzer, device"
              },
              {
                "code": "55206006",
                "display": "Suture button, device"
              },
              {
                "code": "55216003",
                "display": "Amnioscope, device"
              },
              {
                "code": "55337009",
                "display": "Auscultoscope, device"
              },
              {
                "code": "55567004",
                "display": "Bassinet, device"
              },
              {
                "code": "55658008",
                "display": "Hot object"
              },
              {
                "code": "55986002",
                "display": "Tong, device"
              },
              {
                "code": "56144002",
                "display": "Back braces, device"
              },
              {
                "code": "56353002",
                "display": "Staple, device"
              },
              {
                "code": "56547001",
                "display": "Trephine, device"
              },
              {
                "code": "56896002",
                "display": "Pacemaker catheter, device"
              },
              {
                "code": "56961003",
                "display": "Cardiac transvenous pacemaker, device"
              },
              {
                "code": "57118008",
                "display": "Perfusion pump, device"
              },
              {
                "code": "57134006",
                "display": "Clinical instrument"
              },
              {
                "code": "57368009",
                "display": "Contact lens"
              },
              {
                "code": "57395004",
                "display": "Physical restraint equipment, device"
              },
              {
                "code": "57730005",
                "display": "Abrasive grinding, device"
              },
              {
                "code": "58153004",
                "display": "Android, device"
              },
              {
                "code": "58253008",
                "display": "Suction catheter, device"
              },
              {
                "code": "58514003",
                "display": "Infant scale, device"
              },
              {
                "code": "58878002",
                "display": "Protective vest, device"
              },
              {
                "code": "58938008",
                "display": "WC - Wheelchair"
              },
              {
                "code": "59102007",
                "display": "Ice bag, device"
              },
              {
                "code": "59127000",
                "display": "Apnea alarm, device"
              },
              {
                "code": "59153008",
                "display": "Barge, device"
              },
              {
                "code": "59160002",
                "display": "Chipguard, device"
              },
              {
                "code": "59181002",
                "display": "Oxygen analyzer, device"
              },
              {
                "code": "59432006",
                "display": "Ligature, device"
              },
              {
                "code": "59746007",
                "display": "Needle holder, device"
              },
              {
                "code": "59772003",
                "display": "Culdoscope, device"
              },
              {
                "code": "59782002",
                "display": "Speculum, device"
              },
              {
                "code": "59833007",
                "display": "Collapsible balloon, device"
              },
              {
                "code": "60054005",
                "display": "SB - Seat belt"
              },
              {
                "code": "60110001",
                "display": "Wig, device"
              },
              {
                "code": "60150003",
                "display": "Skipole, device"
              },
              {
                "code": "60161006",
                "display": "Acupuncture needle, device"
              },
              {
                "code": "60185003",
                "display": "Carbon dioxide absorber, device"
              },
              {
                "code": "60311007",
                "display": "Leather boots"
              },
              {
                "code": "60773001",
                "display": "Injector"
              },
              {
                "code": "60806001",
                "display": "Whirlpool bath"
              },
              {
                "code": "60957001",
                "display": "Otoscope"
              },
              {
                "code": "61330002",
                "display": "Nasopharyngeal airway device"
              },
              {
                "code": "61512008",
                "display": "Tennis racket"
              },
              {
                "code": "61835000",
                "display": "Dilator"
              },
              {
                "code": "61968008",
                "display": "Syringe"
              },
              {
                "code": "61979003",
                "display": "Antiembolic device"
              },
              {
                "code": "62336005",
                "display": "Electric cable"
              },
              {
                "code": "62495008",
                "display": "Gamma counter"
              },
              {
                "code": "62614002",
                "display": "Overhead and gantry crane"
              },
              {
                "code": "62980002",
                "display": "Tubular bandage"
              },
              {
                "code": "63112008",
                "display": "Bone wire"
              },
              {
                "code": "63173005",
                "display": "Hat band"
              },
              {
                "code": "63289001",
                "display": "Metal nail"
              },
              {
                "code": "63336000",
                "display": "Bone plug"
              },
              {
                "code": "63548003",
                "display": "Derrick"
              },
              {
                "code": "63562005",
                "display": "Cervical collar"
              },
              {
                "code": "63619003",
                "display": "Fiberoptic cable"
              },
              {
                "code": "63653004",
                "display": "Medical device"
              },
              {
                "code": "63797009",
                "display": "Traction unit"
              },
              {
                "code": "63839002",
                "display": "Electroejaculator"
              },
              {
                "code": "63995005",
                "display": "Bandage"
              },
              {
                "code": "64174005",
                "display": "Snowmobile"
              },
              {
                "code": "64255007",
                "display": "Esophageal balloon"
              },
              {
                "code": "64565002",
                "display": "Air tool"
              },
              {
                "code": "64571008",
                "display": "Hair clipper"
              },
              {
                "code": "64883003",
                "display": "Inhalation analgesia unit"
              },
              {
                "code": "64973003",
                "display": "Scissors"
              },
              {
                "code": "64989000",
                "display": "Escalator"
              },
              {
                "code": "65053001",
                "display": "Electrical battery"
              },
              {
                "code": "65105002",
                "display": "Surgical drapes"
              },
              {
                "code": "65268008",
                "display": "Chart recorder"
              },
              {
                "code": "65473004",
                "display": "Microscope"
              },
              {
                "code": "65577000",
                "display": "X-ray shield"
              },
              {
                "code": "65818007",
                "display": "Stent"
              },
              {
                "code": "66222000",
                "display": "Hospital robot"
              },
              {
                "code": "66415006",
                "display": "Audiometric testing equipment"
              },
              {
                "code": "66435007",
                "display": "Electric bed"
              },
              {
                "code": "66494009",
                "display": "Face cloth"
              },
              {
                "code": "67270000",
                "display": "Hip prosthesis"
              },
              {
                "code": "67387001",
                "display": "Coronary perfusion catheter"
              },
              {
                "code": "67670006",
                "display": "Radiographic-tomographic unit"
              },
              {
                "code": "67777003",
                "display": "Moving walk"
              },
              {
                "code": "67829007",
                "display": "Esophagoscope"
              },
              {
                "code": "67920005",
                "display": "Aerial lift"
              },
              {
                "code": "67966000",
                "display": "Enema tube"
              },
              {
                "code": "68080007",
                "display": "Radiographic unit"
              },
              {
                "code": "68181008",
                "display": "Vibrating electric heating pad"
              },
              {
                "code": "68183006",
                "display": "Bone screw"
              },
              {
                "code": "68276009",
                "display": "Bottle"
              },
              {
                "code": "68325009",
                "display": "Sound"
              },
              {
                "code": "68597009",
                "display": "Support belt"
              },
              {
                "code": "68685003",
                "display": "Household robot"
              },
              {
                "code": "68842005",
                "display": "Gastroduodenoscope"
              },
              {
                "code": "69670004",
                "display": "Patient utensil kit"
              },
              {
                "code": "69805005",
                "display": "Insulin pump"
              },
              {
                "code": "69922008",
                "display": "Tracheostomy button"
              },
              {
                "code": "70080007",
                "display": "Bayonet"
              },
              {
                "code": "70300000",
                "display": "Skull tongs"
              },
              {
                "code": "70303003",
                "display": "Freezer"
              },
              {
                "code": "70453008",
                "display": "Sled"
              },
              {
                "code": "70665002",
                "display": "Blood pressure cuff"
              },
              {
                "code": "70793005",
                "display": "Recreation equipment"
              },
              {
                "code": "70872004",
                "display": "Wash basin"
              },
              {
                "code": "71384000",
                "display": "Warmer"
              },
              {
                "code": "71483007",
                "display": "Diving stage"
              },
              {
                "code": "71545009",
                "display": "Humidifier"
              },
              {
                "code": "71601002",
                "display": "Proctosigmoidoscope"
              },
              {
                "code": "71667001",
                "display": "Bone wax"
              },
              {
                "code": "71948003",
                "display": "Autoclave"
              },
              {
                "code": "72070000",
                "display": "Ring"
              },
              {
                "code": "72188006",
                "display": "Tissue expander"
              },
              {
                "code": "72302000",
                "display": "Lead cable"
              },
              {
                "code": "72506001",
                "display": "Implantable defibrillator"
              },
              {
                "code": "72742007",
                "display": "Aspirator collection bottle"
              },
              {
                "code": "73027007",
                "display": "Infant incubator"
              },
              {
                "code": "73534004",
                "display": "Artificial skin"
              },
              {
                "code": "73562006",
                "display": "Transilluminator"
              },
              {
                "code": "73571002",
                "display": "Intravenous analgesia unit"
              },
              {
                "code": "73618007",
                "display": "Power saw"
              },
              {
                "code": "73878004",
                "display": "Hand saw"
              },
              {
                "code": "73985004",
                "display": "Face protection in construction industry"
              },
              {
                "code": "74094004",
                "display": "Belt"
              },
              {
                "code": "74108008",
                "display": "Recorder"
              },
              {
                "code": "74300007",
                "display": "Sanitary pad"
              },
              {
                "code": "74444006",
                "display": "AL - Artificial limb"
              },
              {
                "code": "74566002",
                "display": "Crutch"
              },
              {
                "code": "74884005",
                "display": "Boatswain's chair"
              },
              {
                "code": "75075000",
                "display": "Shoring and bracing (masonry and woodwork)"
              },
              {
                "code": "75187009",
                "display": "Local anesthesia kit"
              },
              {
                "code": "75192006",
                "display": "Arterial cannula"
              },
              {
                "code": "75751006",
                "display": "Manual respirator"
              },
              {
                "code": "75780002",
                "display": "Artificial kidney"
              },
              {
                "code": "75963008",
                "display": "Skateboard"
              },
              {
                "code": "76091005",
                "display": "Stainless steel wire suture"
              },
              {
                "code": "76123001",
                "display": "Glass tube"
              },
              {
                "code": "76428000",
                "display": "Elbow joint prosthesis"
              },
              {
                "code": "76433001",
                "display": "Apron"
              },
              {
                "code": "76664007",
                "display": "Artificial pancreas"
              },
              {
                "code": "76705002",
                "display": "Applicator stick"
              },
              {
                "code": "76825006",
                "display": "Abrasive wheel machinery"
              },
              {
                "code": "76937009",
                "display": "Guillotine"
              },
              {
                "code": "77444004",
                "display": "Pins"
              },
              {
                "code": "77541009",
                "display": "Band"
              },
              {
                "code": "77720000",
                "display": "Clips"
              },
              {
                "code": "77755003",
                "display": "Chemical fiber cloth"
              },
              {
                "code": "77777004",
                "display": "Bone staple"
              },
              {
                "code": "78279003",
                "display": "Nail clipper"
              },
              {
                "code": "78498003",
                "display": "Testicular prosthesis"
              },
              {
                "code": "78641001",
                "display": "Nylon suture"
              },
              {
                "code": "78886001",
                "display": "Electronic monitor"
              },
              {
                "code": "79051006",
                "display": "Greenfield filter"
              },
              {
                "code": "79068005",
                "display": "Needle"
              },
              {
                "code": "79218005",
                "display": "Vehicle-mounted work platform"
              },
              {
                "code": "79287008",
                "display": "Tampon"
              },
              {
                "code": "79401009",
                "display": "Chute"
              },
              {
                "code": "79438009",
                "display": "Foot protection"
              },
              {
                "code": "79481007",
                "display": "Swing or sliding cut-off saw"
              },
              {
                "code": "79593001",
                "display": "Transvenous electrode"
              },
              {
                "code": "79618001",
                "display": "Storage tank"
              },
              {
                "code": "79811009",
                "display": "Electric blanket"
              },
              {
                "code": "79834000",
                "display": "Hickman line"
              },
              {
                "code": "79952001",
                "display": "Swan-Ganz catheter, device"
              },
              {
                "code": "80278003",
                "display": "Pediatric bed"
              },
              {
                "code": "80404000",
                "display": "Chain fall"
              },
              {
                "code": "80617005",
                "display": "Analysers"
              },
              {
                "code": "80664005",
                "display": "Motor home"
              },
              {
                "code": "80853009",
                "display": "Tendon hammer"
              },
              {
                "code": "80950008",
                "display": "Oven"
              },
              {
                "code": "81293006",
                "display": "Textile material"
              },
              {
                "code": "81317009",
                "display": "Socket wrench"
              },
              {
                "code": "81320001",
                "display": "Enzyme immunoassay analyzer"
              },
              {
                "code": "81826000",
                "display": "All-terrain vehicle"
              },
              {
                "code": "81892008",
                "display": "Radial saw"
              },
              {
                "code": "82379000",
                "display": "Hemostat"
              },
              {
                "code": "82449006",
                "display": "Peripheral intravenous catheter"
              },
              {
                "code": "82657000",
                "display": "Bony tissue forceps"
              },
              {
                "code": "82830000",
                "display": "Robotic arm"
              },
              {
                "code": "82879008",
                "display": "Safety belt"
              },
              {
                "code": "83059008",
                "display": "Tube"
              },
              {
                "code": "83315005",
                "display": "Audio analgesia unit"
              },
              {
                "code": "83320005",
                "display": "Dip tank"
              },
              {
                "code": "83369007",
                "display": "Plastic shoes"
              },
              {
                "code": "83517001",
                "display": "Robot"
              },
              {
                "code": "83903000",
                "display": "Man lift"
              },
              {
                "code": "84023008",
                "display": "Ski tow"
              },
              {
                "code": "84330009",
                "display": "Pliers"
              },
              {
                "code": "84444002",
                "display": "Chain saw"
              },
              {
                "code": "84546002",
                "display": "Barricade"
              },
              {
                "code": "84599008",
                "display": "Detonating cord"
              },
              {
                "code": "84610002",
                "display": "Implantable dental prosthesis"
              },
              {
                "code": "84683006",
                "display": "Aortic valve prosthesis"
              },
              {
                "code": "84756000",
                "display": "Adhesive tape"
              },
              {
                "code": "85106006",
                "display": "Boring machine"
              },
              {
                "code": "85329008",
                "display": "Abortion pump"
              },
              {
                "code": "85455005",
                "display": "Cart"
              },
              {
                "code": "85684007",
                "display": "Engraving press"
              },
              {
                "code": "86056006",
                "display": "Golf club"
              },
              {
                "code": "86174004",
                "display": "Laparoscope"
              },
              {
                "code": "86184003",
                "display": "Electrocardiographic monitor and recorder"
              },
              {
                "code": "86407004",
                "display": "Table"
              },
              {
                "code": "86453006",
                "display": "Defibrillator paddle"
              },
              {
                "code": "86572008",
                "display": "Arteriovenous shunt catheter"
              },
              {
                "code": "86768006",
                "display": "Balloon pump"
              },
              {
                "code": "86816008",
                "display": "Diving ladder"
              },
              {
                "code": "86967005",
                "display": "Tool"
              },
              {
                "code": "87088005",
                "display": "Soldering iron"
              },
              {
                "code": "87140005",
                "display": "Clothing material"
              },
              {
                "code": "87405001",
                "display": "Cane"
              },
              {
                "code": "87710003",
                "display": "Physical restraint structure"
              },
              {
                "code": "87717000",
                "display": "Tester"
              },
              {
                "code": "87851008",
                "display": "Blood cell counter and analyzer"
              },
              {
                "code": "88063004",
                "display": "Footwear"
              },
              {
                "code": "88168006",
                "display": "Maximum security cell"
              },
              {
                "code": "88208003",
                "display": "Intravenous anesthesia administration set"
              },
              {
                "code": "88765001",
                "display": "Artificial tissue"
              },
              {
                "code": "88959008",
                "display": "Hypodermic needle"
              },
              {
                "code": "89149003",
                "display": "Stretcher"
              },
              {
                "code": "89236003",
                "display": "Leather shoes"
              },
              {
                "code": "89509004",
                "display": "Blood culture analyzer"
              },
              {
                "code": "90003000",
                "display": "Magnetic resonance imaging unit"
              },
              {
                "code": "90035000",
                "display": "Alcohol sponge"
              },
              {
                "code": "90082007",
                "display": "Cast cutter"
              },
              {
                "code": "90134004",
                "display": "Metal periosteal implant"
              },
              {
                "code": "90412006",
                "display": "Colonoscope"
              },
              {
                "code": "90504001",
                "display": "Auricular prosthesis"
              },
              {
                "code": "90913005",
                "display": "Rubber shoes"
              },
              {
                "code": "90948003",
                "display": "Abrasive blast by cleaning nozzles"
              },
              {
                "code": "91294003",
                "display": "Thomas collar"
              },
              {
                "code": "91318002",
                "display": "Hyperbaric chamber"
              },
              {
                "code": "91535004",
                "display": "Basin"
              },
              {
                "code": "91537007",
                "display": "Hospital bed"
              },
              {
                "code": "102303004",
                "display": "Vascular prosthesis"
              },
              {
                "code": "102304005",
                "display": "Measuring ruler"
              },
              {
                "code": "102305006",
                "display": "Intramedullary reamer"
              },
              {
                "code": "102306007",
                "display": "Reamer"
              },
              {
                "code": "102307003",
                "display": "Surgical knife"
              },
              {
                "code": "102308008",
                "display": "Scalpel"
              },
              {
                "code": "102309000",
                "display": "Surgical saw"
              },
              {
                "code": "102310005",
                "display": "Gigli's wire saw"
              },
              {
                "code": "102311009",
                "display": "Starck dilator"
              },
              {
                "code": "102312002",
                "display": "Atherectomy device"
              },
              {
                "code": "102313007",
                "display": "Rotational atherectomy device"
              },
              {
                "code": "102314001",
                "display": "Embolization coil"
              },
              {
                "code": "102315000",
                "display": "Embolization ball"
              },
              {
                "code": "102316004",
                "display": "Embolization particulate"
              },
              {
                "code": "102317008",
                "display": "Guiding catheter"
              },
              {
                "code": "102318003",
                "display": "Implantable venous catheter"
              },
              {
                "code": "102319006",
                "display": "Percutaneous transluminal angioplasty balloon"
              },
              {
                "code": "102320000",
                "display": "Detachable balloon"
              },
              {
                "code": "102321001",
                "display": "Operating microscope"
              },
              {
                "code": "102322008",
                "display": "External prosthesis for sonographic procedure"
              },
              {
                "code": "102323003",
                "display": "Water bag prosthesis for imaging procedure"
              },
              {
                "code": "102324009",
                "display": "Saline bag prosthesis for imaging procedure"
              },
              {
                "code": "102325005",
                "display": "Gel prosthesis for imaging procedure"
              },
              {
                "code": "102326006",
                "display": "Dagger"
              },
              {
                "code": "102327002",
                "display": "Dirk"
              },
              {
                "code": "102328007",
                "display": "Sword"
              },
              {
                "code": "102384007",
                "display": "Motor vehicle airbag"
              },
              {
                "code": "102385008",
                "display": "Front airbag"
              },
              {
                "code": "102386009",
                "display": "Front driver airbag"
              },
              {
                "code": "102387000",
                "display": "Front passenger airbag"
              },
              {
                "code": "102388005",
                "display": "Side airbag"
              },
              {
                "code": "102402008",
                "display": "Snowboard"
              },
              {
                "code": "102403003",
                "display": "Water ski"
              },
              {
                "code": "105784003",
                "display": "Life support equipment"
              },
              {
                "code": "105785002",
                "display": "Adhesive, bandage AND/OR suture"
              },
              {
                "code": "105787005",
                "display": "Belt AND/OR binder"
              },
              {
                "code": "105788000",
                "display": "Probe, sound, bougie AND/OR airway"
              },
              {
                "code": "105789008",
                "display": "Cannula, tube AND/OR catheter"
              },
              {
                "code": "105790004",
                "display": "Bag, balloon AND/OR bottle"
              },
              {
                "code": "105791000",
                "display": "Pump, injector AND/OR aspirator"
              },
              {
                "code": "105792007",
                "display": "Analgesia AND/OR anesthesia unit"
              },
              {
                "code": "105793002",
                "display": "Monitor, alarm AND/OR stimulator"
              },
              {
                "code": "105794008",
                "display": "Scope AND/OR camera"
              },
              {
                "code": "105809003",
                "display": "Physical restraint equipment AND/OR structure"
              },
              {
                "code": "108874005",
                "display": "Silicone plug"
              },
              {
                "code": "109184000",
                "display": "Pregnancy testing kit"
              },
              {
                "code": "109226007",
                "display": "Dental pin"
              },
              {
                "code": "109227003",
                "display": "Hand joint prosthesis"
              },
              {
                "code": "109228008",
                "display": "Knee joint prosthesis"
              },
              {
                "code": "111041008",
                "display": "Artificial nails"
              },
              {
                "code": "111042001",
                "display": "Artificial organ"
              },
              {
                "code": "111043006",
                "display": "Medical tuning fork"
              },
              {
                "code": "111044000",
                "display": "Bone tap"
              },
              {
                "code": "111045004",
                "display": "Exerciser"
              },
              {
                "code": "111047007",
                "display": "Urethral bougie"
              },
              {
                "code": "111048002",
                "display": "Rhinoscope"
              },
              {
                "code": "111052002",
                "display": "Protective breast plate"
              },
              {
                "code": "111060001",
                "display": "Industrial sewing machine"
              },
              {
                "code": "111062009",
                "display": "Food waste disposal equipment"
              },
              {
                "code": "115961006",
                "display": "Soft Cast"
              },
              {
                "code": "115962004",
                "display": "Fiberglass cast"
              },
              {
                "code": "116146000",
                "display": "Blood product unit"
              },
              {
                "code": "116204000",
                "display": "Catheter tip"
              },
              {
                "code": "116205004",
                "display": "Blood bag"
              },
              {
                "code": "116206003",
                "display": "Plasma bag"
              },
              {
                "code": "116250002",
                "display": "Filter"
              },
              {
                "code": "116251003",
                "display": "Wick"
              },
              {
                "code": "118294000",
                "display": "Solid-state laser"
              },
              {
                "code": "118295004",
                "display": "Gas laser"
              },
              {
                "code": "118296003",
                "display": "Chemical laser"
              },
              {
                "code": "118297007",
                "display": "Excimer laser"
              },
              {
                "code": "118298002",
                "display": "Dye laser"
              },
              {
                "code": "118299005",
                "display": "Diode laser"
              },
              {
                "code": "118301003",
                "display": "Nd:YVO>4< laser"
              },
              {
                "code": "118302005",
                "display": "Nd:YLF laser"
              },
              {
                "code": "118303000",
                "display": "Nd:Glass laser"
              },
              {
                "code": "118304006",
                "display": "Chromium sapphire laser device"
              },
              {
                "code": "118305007",
                "display": "Er:Glass laser"
              },
              {
                "code": "118306008",
                "display": "Erbium-YAG laser"
              },
              {
                "code": "118307004",
                "display": "Ho:YLF laser"
              },
              {
                "code": "118308009",
                "display": "Holmium-YAG laser"
              },
              {
                "code": "118309001",
                "display": "Ti:sapphire laser device"
              },
              {
                "code": "118310006",
                "display": "Alexandrite laser"
              },
              {
                "code": "118311005",
                "display": "Argon laser"
              },
              {
                "code": "118312003",
                "display": "CO2 laser"
              },
              {
                "code": "118313008",
                "display": "He laser"
              },
              {
                "code": "118314002",
                "display": "Helium cadmium laser"
              },
              {
                "code": "118315001",
                "display": "HeNe laser"
              },
              {
                "code": "118316000",
                "display": "Krypton laser"
              },
              {
                "code": "118317009",
                "display": "Neon gas laser"
              },
              {
                "code": "118318004",
                "display": "Nitrogen gas laser"
              },
              {
                "code": "118319007",
                "display": "Xenon gas laser"
              },
              {
                "code": "118320001",
                "display": "Copper vapor laser"
              },
              {
                "code": "118321002",
                "display": "Gold vapor laser"
              },
              {
                "code": "118322009",
                "display": "DF laser"
              },
              {
                "code": "118323004",
                "display": "DF-CO>2< laser device"
              },
              {
                "code": "118324005",
                "display": "HF laser"
              },
              {
                "code": "118325006",
                "display": "ArF laser"
              },
              {
                "code": "118326007",
                "display": "KrF laser"
              },
              {
                "code": "118327003",
                "display": "KrCl laser"
              },
              {
                "code": "118328008",
                "display": "XeCl laser"
              },
              {
                "code": "118329000",
                "display": "XeFl laser"
              },
              {
                "code": "118330005",
                "display": "Free electron laser"
              },
              {
                "code": "118331009",
                "display": "Tunable dye laser"
              },
              {
                "code": "118332002",
                "display": "Tunable dye argon laser"
              },
              {
                "code": "118333007",
                "display": "Gallium arsenide laser"
              },
              {
                "code": "118334001",
                "display": "Gallium aluminum arsenide laser"
              },
              {
                "code": "118335000",
                "display": "Lead-salt laser"
              },
              {
                "code": "118336004",
                "display": "Rhodamine 6G dye laser"
              },
              {
                "code": "118337008",
                "display": "Coumarin C30 dye laser"
              },
              {
                "code": "118338003",
                "display": "Coumarin 102 dye laser"
              },
              {
                "code": "118342000",
                "display": "Diode pumped laser"
              },
              {
                "code": "118343005",
                "display": "Flashlamp pumped laser device"
              },
              {
                "code": "118346002",
                "display": "Pulsed dye laser"
              },
              {
                "code": "118347006",
                "display": "QS laser"
              },
              {
                "code": "118348001",
                "display": "Flashlamp pulsed dye laser"
              },
              {
                "code": "118349009",
                "display": "CW CO>2< laser"
              },
              {
                "code": "118350009",
                "display": "High energy pulsed CO>2< laser"
              },
              {
                "code": "118351008",
                "display": "Frequency doubled Nd:YAG laser"
              },
              {
                "code": "118354000",
                "display": "Continuous wave laser"
              },
              {
                "code": "118355004",
                "display": "Pulsed laser"
              },
              {
                "code": "118356003",
                "display": "Metal vapor laser"
              },
              {
                "code": "118357007",
                "display": "KTP laser"
              },
              {
                "code": "118371004",
                "display": "Ion laser"
              },
              {
                "code": "118372006",
                "display": "Plastic implant"
              },
              {
                "code": "118373001",
                "display": "Silastic implant"
              },
              {
                "code": "118374007",
                "display": "Silicone implant"
              },
              {
                "code": "118375008",
                "display": "Cardiac septum prosthesis"
              },
              {
                "code": "118376009",
                "display": "Thermocouple"
              },
              {
                "code": "118377000",
                "display": "Biopsy needle"
              },
              {
                "code": "118378005",
                "display": "Pacemaker pulse generator"
              },
              {
                "code": "118379002",
                "display": "Automatic implantable cardioverter sensing electrodes"
              },
              {
                "code": "118380004",
                "display": "Implantable defibrillator leads"
              },
              {
                "code": "118381000",
                "display": "Implantable cardioverter leads"
              },
              {
                "code": "118382007",
                "display": "Neuropacemaker device"
              },
              {
                "code": "118383002",
                "display": "External fixation device"
              },
              {
                "code": "118384008",
                "display": "Long arm splint"
              },
              {
                "code": "118385009",
                "display": "Short arm splint"
              },
              {
                "code": "118386005",
                "display": "Figure of eight plaster cast"
              },
              {
                "code": "118387001",
                "display": "Halo jacket"
              },
              {
                "code": "118388006",
                "display": "Body cast, shoulder to hips"
              },
              {
                "code": "118389003",
                "display": "Body cast, shoulder to hips including head, Minerva type"
              },
              {
                "code": "118390007",
                "display": "Body cast, shoulder to hips including one thigh"
              },
              {
                "code": "118391006",
                "display": "Body cast, shoulder to hips including both thighs"
              },
              {
                "code": "118392004",
                "display": "Shoulder cast"
              },
              {
                "code": "118393009",
                "display": "Long arm cylinder"
              },
              {
                "code": "118394003",
                "display": "Forearm cylinder"
              },
              {
                "code": "118396001",
                "display": "Cylinder cast, thigh to ankle"
              },
              {
                "code": "118397005",
                "display": "Long leg cast"
              },
              {
                "code": "118398000",
                "display": "Long leg cast, walker or ambulatory type"
              },
              {
                "code": "118399008",
                "display": "Long leg cast, brace type"
              },
              {
                "code": "118400001",
                "display": "Short leg cast below knee to toes"
              },
              {
                "code": "118401002",
                "display": "Short leg cast below knee to toes, walking or ambulatory type"
              },
              {
                "code": "118402009",
                "display": "Clubfoot cast"
              },
              {
                "code": "118403004",
                "display": "Clubfoot cast, short leg"
              },
              {
                "code": "118404005",
                "display": "Clubfoot cast, long leg"
              },
              {
                "code": "118405006",
                "display": "Spica cast"
              },
              {
                "code": "118406007",
                "display": "Hip spica cast, both legs"
              },
              {
                "code": "118407003",
                "display": "Hip spica cast, one leg"
              },
              {
                "code": "118408008",
                "display": "Hip spica cast, one and one-half spica"
              },
              {
                "code": "118409000",
                "display": "Patellar tendon bearing cast"
              },
              {
                "code": "118410005",
                "display": "Boot cast"
              },
              {
                "code": "118411009",
                "display": "Sugar tong cast"
              },
              {
                "code": "118412002",
                "display": "Gauntlet cast"
              },
              {
                "code": "118413007",
                "display": "Complete cast"
              },
              {
                "code": "118414001",
                "display": "Pressure dressing"
              },
              {
                "code": "118415000",
                "display": "Packing material"
              },
              {
                "code": "118416004",
                "display": "Wound packing material"
              },
              {
                "code": "118418003",
                "display": "Trocar"
              },
              {
                "code": "118419006",
                "display": "Umbrella device"
              },
              {
                "code": "118420000",
                "display": "Atrial septal umbrella"
              },
              {
                "code": "118421001",
                "display": "King-Mills umbrella device"
              },
              {
                "code": "118422008",
                "display": "Mobitz-Uddin umbrella device"
              },
              {
                "code": "118423003",
                "display": "Rashkind umbrella device"
              },
              {
                "code": "118424009",
                "display": "Reservoir device"
              },
              {
                "code": "118425005",
                "display": "Ventricular reservoir"
              },
              {
                "code": "118426006",
                "display": "Ommaya reservoir"
              },
              {
                "code": "118427002",
                "display": "Rickham reservoir"
              },
              {
                "code": "118428007",
                "display": "Flexible fiberoptic endoscope"
              },
              {
                "code": "118429004",
                "display": "Flexible fiberoptic laryngoscope with strobe"
              },
              {
                "code": "118643004",
                "display": "Cast"
              },
              {
                "code": "122456005",
                "display": "Laser"
              },
              {
                "code": "123636009",
                "display": "SS - Silk suture"
              },
              {
                "code": "126064005",
                "display": "Gastrostomy tube, device"
              },
              {
                "code": "126065006",
                "display": "Jejunostomy tube, device"
              },
              {
                "code": "128981007",
                "display": "Baffle"
              },
              {
                "code": "129113006",
                "display": "Intra-aortic balloon pump"
              },
              {
                "code": "129121000",
                "display": "Tracheostomy tube"
              },
              {
                "code": "129247000",
                "display": "Fine biopsy needle"
              },
              {
                "code": "129248005",
                "display": "Core biopsy needle"
              },
              {
                "code": "129460009",
                "display": "Compression paddle"
              },
              {
                "code": "129462001",
                "display": "Catheter guide wire"
              },
              {
                "code": "129463006",
                "display": "J wire"
              },
              {
                "code": "129464000",
                "display": "Medical administrative equipment"
              },
              {
                "code": "129465004",
                "display": "Medical record"
              },
              {
                "code": "129466003",
                "display": "Patient chart"
              },
              {
                "code": "129467007",
                "display": "Identification plate"
              },
              {
                "code": "134823007",
                "display": "Sterile absorbent dressing pad"
              },
              {
                "code": "134963007",
                "display": "Wound drainage pouch dressing"
              },
              {
                "code": "170615005",
                "display": "Home nebulizer"
              },
              {
                "code": "182562006",
                "display": "Plaster jacket"
              },
              {
                "code": "182563001",
                "display": "Shoulder spica"
              },
              {
                "code": "182564007",
                "display": "Humeral U-slab"
              },
              {
                "code": "182565008",
                "display": "Long arm slab"
              },
              {
                "code": "182566009",
                "display": "Humeral hanging slab"
              },
              {
                "code": "182567000",
                "display": "Forearm slab"
              },
              {
                "code": "182568005",
                "display": "Scaphoid cast"
              },
              {
                "code": "182569002",
                "display": "Bennett cast"
              },
              {
                "code": "182570001",
                "display": "Hip spica"
              },
              {
                "code": "182571002",
                "display": "Long leg spica"
              },
              {
                "code": "182572009",
                "display": "Below knee non-weight-bearing cast"
              },
              {
                "code": "182573004",
                "display": "Below knee weight-bearing cast"
              },
              {
                "code": "182574005",
                "display": "Plaster stripper"
              },
              {
                "code": "182576007",
                "display": "Humeral brace"
              },
              {
                "code": "182577003",
                "display": "Functional elbow brace"
              },
              {
                "code": "182578008",
                "display": "Forearm brace"
              },
              {
                "code": "182579000",
                "display": "Hip brace"
              },
              {
                "code": "182580002",
                "display": "Femoral brace"
              },
              {
                "code": "182581003",
                "display": "Tibial brace"
              },
              {
                "code": "182587004",
                "display": "Body support"
              },
              {
                "code": "182588009",
                "display": "Spinal frame"
              },
              {
                "code": "182589001",
                "display": "Corset support"
              },
              {
                "code": "182590005",
                "display": "Cardiac bed"
              },
              {
                "code": "182591009",
                "display": "Water bed"
              },
              {
                "code": "182592002",
                "display": "High air loss bed"
              },
              {
                "code": "182839003",
                "display": "Automated drug microinjector"
              },
              {
                "code": "183116000",
                "display": "Dental aid"
              },
              {
                "code": "183125006",
                "display": "Ear fitting hearing aid"
              },
              {
                "code": "183135000",
                "display": "Mobility aid"
              },
              {
                "code": "183141007",
                "display": "Inshoe orthosis"
              },
              {
                "code": "183143005",
                "display": "Surgical stockings"
              },
              {
                "code": "183144004",
                "display": "Antiembolic stockings"
              },
              {
                "code": "183146002",
                "display": "ZF - Zimmer frame"
              },
              {
                "code": "183147006",
                "display": "Tripod"
              },
              {
                "code": "183148001",
                "display": "RGO - Reciprocating gait orthosis"
              },
              {
                "code": "183149009",
                "display": "Hip guidance orthosis"
              },
              {
                "code": "183150009",
                "display": "Standing frame"
              },
              {
                "code": "183152001",
                "display": "Hip abduction orthosis"
              },
              {
                "code": "183153006",
                "display": "Hip-knee-ankle-foot orthosis"
              },
              {
                "code": "183154000",
                "display": "Knee-ankle-foot orthosis"
              },
              {
                "code": "183155004",
                "display": "Flexible knee support"
              },
              {
                "code": "183156003",
                "display": "Collateral ligament brace"
              },
              {
                "code": "183157007",
                "display": "Anterior cruciate ligament brace"
              },
              {
                "code": "183158002",
                "display": "Posterior cruciate ligament brace"
              },
              {
                "code": "183159005",
                "display": "Ground reaction orthosis"
              },
              {
                "code": "183160000",
                "display": "Rigid ankle-foot orthosis"
              },
              {
                "code": "183161001",
                "display": "Flexible ankle-foot orthosis"
              },
              {
                "code": "183162008",
                "display": "Double below-knee iron"
              },
              {
                "code": "183164009",
                "display": "Inside iron"
              },
              {
                "code": "183165005",
                "display": "Outside iron"
              },
              {
                "code": "183166006",
                "display": "Inside T-strap"
              },
              {
                "code": "183170003",
                "display": "Hindquarter prosthesis"
              },
              {
                "code": "183171004",
                "display": "Hip disarticulation prosthesis"
              },
              {
                "code": "183172006",
                "display": "Above knee prosthesis"
              },
              {
                "code": "183173001",
                "display": "Through knee prosthesis"
              },
              {
                "code": "183174007",
                "display": "Below knee prosthesis"
              },
              {
                "code": "183175008",
                "display": "Syme's prosthesis"
              },
              {
                "code": "183176009",
                "display": "Midfoot amputation prosthesis"
              },
              {
                "code": "183177000",
                "display": "Shoe filler"
              },
              {
                "code": "183183002",
                "display": "Milwaukee brace"
              },
              {
                "code": "183184008",
                "display": "Boston brace"
              },
              {
                "code": "183185009",
                "display": "Jewett brace"
              },
              {
                "code": "183187001",
                "display": "Halo device"
              },
              {
                "code": "183188006",
                "display": "Four poster brace"
              },
              {
                "code": "183189003",
                "display": "Rigid collar"
              },
              {
                "code": "183190007",
                "display": "Flexible collar"
              },
              {
                "code": "183192004",
                "display": "Shoulder abduction brace"
              },
              {
                "code": "183193009",
                "display": "Elbow brace"
              },
              {
                "code": "183194003",
                "display": "Passive wrist extension splint"
              },
              {
                "code": "183195002",
                "display": "Active wrist extension splint"
              },
              {
                "code": "183196001",
                "display": "Passive finger extension splint"
              },
              {
                "code": "183197005",
                "display": "Active finger extension splint"
              },
              {
                "code": "183198000",
                "display": "Kleinert traction"
              },
              {
                "code": "183199008",
                "display": "Passive thumb splint"
              },
              {
                "code": "183200006",
                "display": "Active thumb splint"
              },
              {
                "code": "183202003",
                "display": "Shin splint"
              },
              {
                "code": "183204002",
                "display": "Excretory control aid"
              },
              {
                "code": "183235008",
                "display": "Facial non-surgical prosthesis"
              },
              {
                "code": "183236009",
                "display": "Breast non-surgical prosthesis"
              },
              {
                "code": "183240000",
                "display": "Patient-propelled wheelchair"
              },
              {
                "code": "183241001",
                "display": "Pedal powered wheelchair"
              },
              {
                "code": "183248007",
                "display": "Attendant powered wheelchair"
              },
              {
                "code": "183249004",
                "display": "Wheelchair seating"
              },
              {
                "code": "183250004",
                "display": "Molded wheelchair seat"
              },
              {
                "code": "183251000",
                "display": "Matrix seat"
              },
              {
                "code": "201706006",
                "display": "Intracranial pressure transducer"
              },
              {
                "code": "223394001",
                "display": "Equipment for positioning"
              },
              {
                "code": "224684009",
                "display": "Top security prison"
              },
              {
                "code": "224685005",
                "display": "Category B prison"
              },
              {
                "code": "224686006",
                "display": "Low security prison"
              },
              {
                "code": "224823002",
                "display": "Street lighting"
              },
              {
                "code": "224824008",
                "display": "Sign posting"
              },
              {
                "code": "224825009",
                "display": "Street name sign"
              },
              {
                "code": "224826005",
                "display": "Building name sign"
              },
              {
                "code": "224827001",
                "display": "Pedestrian direction sign"
              },
              {
                "code": "224828006",
                "display": "Traffic sign"
              },
              {
                "code": "224898003",
                "display": "Orthotic device"
              },
              {
                "code": "224899006",
                "display": "Walking aid"
              },
              {
                "code": "224900001",
                "display": "Communication aid"
              },
              {
                "code": "228167008",
                "display": "Corset"
              },
              {
                "code": "228235002",
                "display": "Slippers"
              },
              {
                "code": "228236001",
                "display": "Mules"
              },
              {
                "code": "228237005",
                "display": "Slippersox"
              },
              {
                "code": "228239008",
                "display": "Trainers"
              },
              {
                "code": "228240005",
                "display": "Plimsolls"
              },
              {
                "code": "228241009",
                "display": "Sandals"
              },
              {
                "code": "228242002",
                "display": "Gum boots"
              },
              {
                "code": "228243007",
                "display": "Chappel"
              },
              {
                "code": "228259007",
                "display": "Fastening"
              },
              {
                "code": "228260002",
                "display": "Velcro"
              },
              {
                "code": "228261003",
                "display": "Buckle"
              },
              {
                "code": "228262005",
                "display": "Zipper"
              },
              {
                "code": "228264006",
                "display": "Small button"
              },
              {
                "code": "228265007",
                "display": "Medium button"
              },
              {
                "code": "228266008",
                "display": "Large button"
              },
              {
                "code": "228267004",
                "display": "Press stud"
              },
              {
                "code": "228268009",
                "display": "Hook and eye"
              },
              {
                "code": "228270000",
                "display": "Laces"
              },
              {
                "code": "228271001",
                "display": "Shoe laces"
              },
              {
                "code": "228731007",
                "display": "Radiotherapy equipment and appliances"
              },
              {
                "code": "228732000",
                "display": "Beam direction shell"
              },
              {
                "code": "228733005",
                "display": "Head and neck beam direction shell"
              },
              {
                "code": "228734004",
                "display": "Body beam direction shell"
              },
              {
                "code": "228735003",
                "display": "Beam modifier"
              },
              {
                "code": "228736002",
                "display": "Surface bolus"
              },
              {
                "code": "228737006",
                "display": "Surface compensator"
              },
              {
                "code": "228738001",
                "display": "Cutout"
              },
              {
                "code": "228739009",
                "display": "Shielding block"
              },
              {
                "code": "228740006",
                "display": "Lung block"
              },
              {
                "code": "228741005",
                "display": "Humerus block"
              },
              {
                "code": "228742003",
                "display": "Scrotal block"
              },
              {
                "code": "228743008",
                "display": "Kidney block"
              },
              {
                "code": "228744002",
                "display": "Eye block"
              },
              {
                "code": "228745001",
                "display": "Bite block"
              },
              {
                "code": "228746000",
                "display": "Wedge filter"
              },
              {
                "code": "228747009",
                "display": "Kilovoltage grid"
              },
              {
                "code": "228748004",
                "display": "Brachytherapy implant"
              },
              {
                "code": "228749007",
                "display": "Single plane implant"
              },
              {
                "code": "228750007",
                "display": "Two plane implant"
              },
              {
                "code": "228751006",
                "display": "Semicircular implant"
              },
              {
                "code": "228752004",
                "display": "Regular volume implant"
              },
              {
                "code": "228753009",
                "display": "Irregular volume implant"
              },
              {
                "code": "228754003",
                "display": "Brachytherapy surface mold"
              },
              {
                "code": "228755002",
                "display": "Two plane mold"
              },
              {
                "code": "228756001",
                "display": "Single plane mold"
              },
              {
                "code": "228757005",
                "display": "Cylinder mold"
              },
              {
                "code": "228759008",
                "display": "Adhesive felt mold"
              },
              {
                "code": "228760003",
                "display": "Elastoplast mold"
              },
              {
                "code": "228761004",
                "display": "Collimator"
              },
              {
                "code": "228762006",
                "display": "Multileaf collimator"
              },
              {
                "code": "228763001",
                "display": "Asymmetric jaws collimator"
              },
              {
                "code": "228765008",
                "display": "Standard collimator"
              },
              {
                "code": "228766009",
                "display": "Form of brachytherapy source"
              },
              {
                "code": "228767000",
                "display": "Wire source"
              },
              {
                "code": "228768005",
                "display": "Seeds source"
              },
              {
                "code": "228770001",
                "display": "Hairpins source"
              },
              {
                "code": "228771002",
                "display": "Needles source"
              },
              {
                "code": "228772009",
                "display": "Pellets source"
              },
              {
                "code": "228773004",
                "display": "Capsules source"
              },
              {
                "code": "228774005",
                "display": "Chains source"
              },
              {
                "code": "228775006",
                "display": "Tubes source"
              },
              {
                "code": "228776007",
                "display": "Rods source"
              },
              {
                "code": "228777003",
                "display": "Grains source"
              },
              {
                "code": "228778008",
                "display": "Plaque source"
              },
              {
                "code": "228869008",
                "display": "Manual wheelchair"
              },
              {
                "code": "229772003",
                "display": "Bed"
              },
              {
                "code": "229839006",
                "display": "Functional foot orthosis"
              },
              {
                "code": "229840008",
                "display": "Non-functional foot orthosis"
              },
              {
                "code": "229841007",
                "display": "Detachable pad for the foot"
              },
              {
                "code": "229842000",
                "display": "Detachable toe prop"
              },
              {
                "code": "229843005",
                "display": "Detachable horseshoe pad"
              },
              {
                "code": "243135003",
                "display": "Spacer"
              },
              {
                "code": "243719003",
                "display": "Near low vision aid - integral eyeglass magnifier"
              },
              {
                "code": "243720009",
                "display": "Near low vision aid - clip-on eyeglass magnifier"
              },
              {
                "code": "243722001",
                "display": "Near low vision aid - integral eyeglass telescope"
              },
              {
                "code": "243723006",
                "display": "Near low vision aid - clip-on eyeglass telescope"
              },
              {
                "code": "255296002",
                "display": "Wedge"
              },
              {
                "code": "255712000",
                "display": "Television"
              },
              {
                "code": "255716002",
                "display": "Latex rubber gloves"
              },
              {
                "code": "256245006",
                "display": "Textiles"
              },
              {
                "code": "256246007",
                "display": "Cotton - textile"
              },
              {
                "code": "256247003",
                "display": "Flax"
              },
              {
                "code": "256562002",
                "display": "Cotton wool"
              },
              {
                "code": "256563007",
                "display": "Cotton wool roll"
              },
              {
                "code": "256564001",
                "display": "Cotton wool pledget"
              },
              {
                "code": "256589007",
                "display": "Dental rubber dam"
              },
              {
                "code": "256590003",
                "display": "Endodontic sponge"
              },
              {
                "code": "256593001",
                "display": "Orthodontic elastic"
              },
              {
                "code": "256641009",
                "display": "Ribbon gauze"
              },
              {
                "code": "256642002",
                "display": "Wet ribbon gauze"
              },
              {
                "code": "256643007",
                "display": "Dry ribbon gauze"
              },
              {
                "code": "257192006",
                "display": "Aid to vision"
              },
              {
                "code": "257193001",
                "display": "Telescopic eyeglasses"
              },
              {
                "code": "257194007",
                "display": "Video"
              },
              {
                "code": "257211007",
                "display": "Cylinder cutter"
              },
              {
                "code": "257212000",
                "display": "Rotary cutter"
              },
              {
                "code": "257213005",
                "display": "Rotary cutter with steel blades"
              },
              {
                "code": "257214004",
                "display": "Rotary cutter with plastic blades"
              },
              {
                "code": "257215003",
                "display": "Nail instrument"
              },
              {
                "code": "257216002",
                "display": "Flexible endoscope"
              },
              {
                "code": "257217006",
                "display": "Rigid endoscope"
              },
              {
                "code": "257218001",
                "display": "Flexible cystoscope"
              },
              {
                "code": "257219009",
                "display": "Rigid cystoscope"
              },
              {
                "code": "257220003",
                "display": "Hysteroscope"
              },
              {
                "code": "257221004",
                "display": "Flexible hysteroscope"
              },
              {
                "code": "257222006",
                "display": "Rigid hysteroscope"
              },
              {
                "code": "257223001",
                "display": "Contact hysteroscope"
              },
              {
                "code": "257224007",
                "display": "Panoramic hysteroscope"
              },
              {
                "code": "257225008",
                "display": "Flexible bronchoscope"
              },
              {
                "code": "257226009",
                "display": "Rigid bronchoscope"
              },
              {
                "code": "257227000",
                "display": "Standard laryngoscope"
              },
              {
                "code": "257228005",
                "display": "Fiberlight anesthetic laryngoscope"
              },
              {
                "code": "257229002",
                "display": "Pharyngeal mirror"
              },
              {
                "code": "257230007",
                "display": "Obstetric forceps"
              },
              {
                "code": "257231006",
                "display": "Barnes forceps"
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

  # Description http://hl7.org/fhir/R4/valueset-body-site.html
  @BODY_SITE_VS =
    {
      "resourceType" : "ValueSet",
      "id" : "body-site",
      "meta" : {
        "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
        "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
      },
      "text" : {
        "status" : "generated",
        "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>SNOMED CT Body Structures</h2><div><p>This value set includes all codes from <a href=\"http://snomed.info/sct\">SNOMED CT</a> where concept is-a 442083009 (Anatomical or acquired body site (body structure)).</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  442083009 (Anatomical or acquired body structure)</li></ul></div>"
      },
      "extension" : [{
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
        "valueCode" : "oo"
      },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
          "valueCode" : "draft"
        },
        {
          "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
          "valueInteger" : 1
        }],
      "url" : "http://hl7.org/fhir/ValueSet/body-site",
      "identifier" : [{
        "system" : "urn:ietf:rfc:3986",
        "value" : "urn:oid:2.16.840.1.113883.4.642.3.141"
      }],
      "version" : "4.0.1",
      "name" : "SNOMEDCTBodyStructures",
      "title" : "SNOMED CT Body Structures",
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
      "description" : "This value set includes all codes from [SNOMED CT](http://snomed.info/sct) where concept is-a 442083009 (Anatomical or acquired body site (body structure)).",
      "copyright" : "This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
      "compose" : {
        "include" : [{
          "system" : "http://snomed.info/sct",
          "concept": [
            {
              "code": "442083009",
              "display": "Health Concern",
              "definition": "Additional health concerns from other stakeholders which are outside the provider’s problem list."
            },
            {
              "code": "106004",
              "display": "Posterior carpal region"
            },
            {
              "code": "107008",
              "display": "Fetal part of placenta"
            },
            {
              "code": "108003",
              "display": "Condylar emissary vein"
            },
            {
              "code": "110001",
              "display": "Visceral layer of Bowman's capsule"
            },
            {
              "code": "111002",
              "display": "Parathyroid gland"
            },
            {
              "code": "116007",
              "display": "Subcutaneous tissue of medial surface of index finger"
            },
            {
              "code": "124002",
              "display": "Coronoid process of mandible"
            },
            {
              "code": "149003",
              "display": "Central pair of microtubules, cilium or flagellum, not bacterial"
            },
            {
              "code": "155008",
              "display": "Deep circumflex artery of ilium"
            },
            {
              "code": "167005",
              "display": "Supraclavicular part of brachial plexus"
            },
            {
              "code": "202009",
              "display": "Anterior division of renal artery"
            },
            {
              "code": "205006",
              "display": "Left commissure of aortic valve"
            },
            {
              "code": "206007",
              "display": "Gluteus maximus muscle"
            },
            {
              "code": "221001",
              "display": "Articular surface, phalanges, of fourth metacarpal bone"
            },
            {
              "code": "227002",
              "display": "Canal of Hering"
            },
            {
              "code": "233006",
              "display": "Hepatocolic ligament"
            },
            {
              "code": "235004",
              "display": "Superior labial artery"
            },
            {
              "code": "246001",
              "display": "Lateral vestibular nucleus"
            },
            {
              "code": "247005",
              "display": "Mesotympanum"
            },
            {
              "code": "251007",
              "display": "Pectoral region"
            },
            {
              "code": "256002",
              "display": "Kupffer cell"
            },
            {
              "code": "263002",
              "display": "Thoracic nerve"
            },
            {
              "code": "266005",
              "display": "Right lower lobe of lung"
            },
            {
              "code": "272005",
              "display": "Superior articular process of lumbar vertebra"
            },
            {
              "code": "273000",
              "display": "Lateral myocardium"
            },
            {
              "code": "283001",
              "display": "Central axillary lymph node"
            },
            {
              "code": "284007",
              "display": "Flexor tendon and tendon sheath of fourth toe"
            },
            {
              "code": "289002",
              "display": "Metacarpophalangeal joint of index finger"
            },
            {
              "code": "301000",
              "display": "Fifth metatarsal bone"
            },
            {
              "code": "311007",
              "display": "Plantar surface of great toe"
            },
            {
              "code": "315003",
              "display": "Skin of umbilicus"
            },
            {
              "code": "318001",
              "display": "Cardiac impression of liver"
            },
            {
              "code": "344001",
              "display": "Ankle"
            },
            {
              "code": "345000",
              "display": "Penetrating atrioventricular bundle"
            },
            {
              "code": "356000",
              "display": "Reticular corium"
            },
            {
              "code": "393006",
              "display": "Wall of urinary bladder"
            },
            {
              "code": "402006",
              "display": "Dental branches of inferior alveolar artery"
            },
            {
              "code": "405008",
              "display": "Posterior temporal diploic vein"
            },
            {
              "code": "414003",
              "display": "Gastric fundus"
            },
            {
              "code": "420002",
              "display": "Anastomosis, heterocladic"
            },
            {
              "code": "422005",
              "display": "Inferior surface of tongue"
            },
            {
              "code": "446003",
              "display": "Trochanteric bursa"
            },
            {
              "code": "457008",
              "display": "Collateral ligament"
            },
            {
              "code": "461002",
              "display": "Lateral corticospinal tract"
            },
            {
              "code": "464005",
              "display": "Basophilic normoblast"
            },
            {
              "code": "465006",
              "display": "Ascending frontal gyrus"
            },
            {
              "code": "471000",
              "display": "Flexor hallucis longus in leg"
            },
            {
              "code": "480000",
              "display": "Cardiopulmonary circulatory system"
            },
            {
              "code": "485005",
              "display": "TC - Transverse colon"
            },
            {
              "code": "528006",
              "display": "Costal surface of lung"
            },
            {
              "code": "552004",
              "display": "Vagus nerve parasympathetic fibers to cardiac plexus"
            },
            {
              "code": "565008",
              "display": "Intervertebral disc space of fifth lumbar vertebra"
            },
            {
              "code": "582005",
              "display": "Head of phalanx of great toe"
            },
            {
              "code": "587004",
              "display": "Capsule of proximal interphalangeal joint of third toe"
            },
            {
              "code": "589001",
              "display": "Interventricular septum"
            },
            {
              "code": "595000",
              "display": "Palpebral fissure"
            },
            {
              "code": "608002",
              "display": "Subcutaneous tissue of philtrum"
            },
            {
              "code": "621009",
              "display": "Multivesicular body, internal vesicles"
            },
            {
              "code": "635006",
              "display": "Tuberosity of distal phalanx of little toe"
            },
            {
              "code": "650002",
              "display": "Superior articular process of seventh thoracic vertebra"
            },
            {
              "code": "660006",
              "display": "Tracheal mucous membrane"
            },
            {
              "code": "661005",
              "display": "Jaw region"
            },
            {
              "code": "667009",
              "display": "Embryological structure"
            },
            {
              "code": "688000",
              "display": "Fetal hyaloid artery"
            },
            {
              "code": "691000",
              "display": "Small intestine submucosa"
            },
            {
              "code": "692007",
              "display": "Body of ischium"
            },
            {
              "code": "723004",
              "display": "Dense intermediate filament bundles"
            },
            {
              "code": "774007",
              "display": "Head and neck"
            },
            {
              "code": "790007",
              "display": "Visceral surface of liver"
            },
            {
              "code": "798000",
              "display": "Deep temporal veins"
            },
            {
              "code": "808000",
              "display": "Posterior intercostal artery"
            },
            {
              "code": "809008",
              "display": "Fetal chondrocranium"
            },
            {
              "code": "823005",
              "display": "Posterior cervical spinal cord nerve root"
            },
            {
              "code": "830004",
              "display": "Spinous process of fifth thoracic vertebra"
            },
            {
              "code": "836005",
              "display": "Oral region of face"
            },
            {
              "code": "885000",
              "display": "Lamina muscularis of colonic mucous membrane"
            },
            {
              "code": "895007",
              "display": "Anterior cruciate ligament of knee joint"
            },
            {
              "code": "917004",
              "display": "Superior laryngeal aperture"
            },
            {
              "code": "921006",
              "display": "Thyrohyoid branch of ansa cervicalis"
            },
            {
              "code": "947002",
              "display": "Crus of diaphragm"
            },
            {
              "code": "955009",
              "display": "Bronchus"
            },
            {
              "code": "976004",
              "display": "Ovarian vein"
            },
            {
              "code": "996007",
              "display": "Meningeal branch of occipital artery"
            },
            {
              "code": "1005009",
              "display": "Entire diaphragmatic lymph node"
            },
            {
              "code": "1012000",
              "display": "Structure of fibrous portion of pericardium"
            },
            {
              "code": "1015003",
              "display": "Structure of peritonsillar tissue"
            },
            {
              "code": "1028005",
              "display": "Sebaceous gland structure"
            },
            {
              "code": "1030007",
              "display": "Structure of vesicular bursa of sternohyoid muscle"
            },
            {
              "code": "1063000",
              "display": "Frontozygomatic suture of skull"
            },
            {
              "code": "1075005",
              "display": "Promonocyte"
            },
            {
              "code": "1076006",
              "display": "Subcutaneous prepatellar bursa"
            },
            {
              "code": "1086007",
              "display": "Female"
            },
            {
              "code": "1087003",
              "display": "Sternothyroid muscle"
            },
            {
              "code": "1092001",
              "display": "Superior occipital gyrus"
            },
            {
              "code": "1099005",
              "display": "Thymic cortex"
            },
            {
              "code": "1101003",
              "display": "Cranial cavity"
            },
            {
              "code": "1106008",
              "display": "Major calyx"
            },
            {
              "code": "1110006",
              "display": "Tarsal gland"
            },
            {
              "code": "1122009",
              "display": "Inferior longitudinal muscle of tongue"
            },
            {
              "code": "1136004",
              "display": "Aortopulmonary septum"
            },
            {
              "code": "1159005",
              "display": "Frenulum linguae"
            },
            {
              "code": "1172006",
              "display": "Odontoid process of axis"
            },
            {
              "code": "1173001",
              "display": "Mandibular nerve"
            },
            {
              "code": "1174007",
              "display": "Chromosomes, group E"
            },
            {
              "code": "1193009",
              "display": "Teres major muscle"
            },
            {
              "code": "1216008",
              "display": "Synostosis"
            },
            {
              "code": "1231004",
              "display": "Central nervous system meninges"
            },
            {
              "code": "1236009",
              "display": "Duodenal serosa"
            },
            {
              "code": "1243003",
              "display": "Inferior articular process of sixth cervical vertebra"
            },
            {
              "code": "1246006",
              "display": "Dorsal digital nerves of radial nerve"
            },
            {
              "code": "1263005",
              "display": "Distinctive arrangement of microtubules"
            },
            {
              "code": "1277008",
              "display": "Vertebral nerve"
            },
            {
              "code": "1307006",
              "display": "Glottis"
            },
            {
              "code": "1311000",
              "display": "Telogen hair"
            },
            {
              "code": "1350001",
              "display": "Deep flexor tendon of index finger"
            },
            {
              "code": "1353004",
              "display": "Gastric serosa"
            },
            {
              "code": "1403006",
              "display": "Vastus lateralis muscle"
            },
            {
              "code": "1425000",
              "display": "Posterior limb of stapes"
            },
            {
              "code": "1439000",
              "display": "Paravesicular lymph node"
            },
            {
              "code": "1441004",
              "display": "Laryngeal saccule"
            },
            {
              "code": "1456008",
              "display": "Yellow fibrocartilage"
            },
            {
              "code": "1467009",
              "display": "Parietal branch of superficial temporal artery"
            },
            {
              "code": "1484003",
              "display": "Structure of metatarsal region of foot"
            },
            {
              "code": "1490004",
              "display": "Soft tissues of trunk"
            },
            {
              "code": "1502004",
              "display": "Anterior cecal artery"
            },
            {
              "code": "1511004",
              "display": "Ejaculatory duct"
            },
            {
              "code": "1516009",
              "display": "Frontomental diameter of head"
            },
            {
              "code": "1527006",
              "display": "Lamina of fourth thoracic vertebra"
            },
            {
              "code": "1537001",
              "display": "Intervertebral disc of eleventh thoracic vertebra"
            },
            {
              "code": "1541002",
              "display": "Coccygeal plexus"
            },
            {
              "code": "1562001",
              "display": "Nucleus pulposus of intervertebral disc of third lumbar vertebra"
            },
            {
              "code": "1569005",
              "display": "Nail of third toe"
            },
            {
              "code": "1580005",
              "display": "Nucleus ventralis lateralis"
            },
            {
              "code": "1581009",
              "display": "Ileal artery"
            },
            {
              "code": "1584001",
              "display": "Symphysis"
            },
            {
              "code": "1600003",
              "display": "Splenius capitis muscle"
            },
            {
              "code": "1605008",
              "display": "Histioblast"
            },
            {
              "code": "1610007",
              "display": "Otoconia"
            },
            {
              "code": "1611006",
              "display": "Paramammary lymph node"
            },
            {
              "code": "1617005",
              "display": "Intrinsic larynx"
            },
            {
              "code": "1620002",
              "display": "Metaphase nucleus"
            },
            {
              "code": "1626008",
              "display": "Third thoracic vertebra"
            },
            {
              "code": "1627004",
              "display": "Medial collateral ligament of knee joint"
            },
            {
              "code": "1630006",
              "display": "Supraorbital vein"
            },
            {
              "code": "1631005",
              "display": "Foregut"
            },
            {
              "code": "1650005",
              "display": "Hilum of left lung"
            },
            {
              "code": "1655000",
              "display": "Transverse peduncular tract nucleus"
            },
            {
              "code": "1659006",
              "display": "Nucleus medialis dorsalis"
            },
            {
              "code": "1684009",
              "display": "Ligamentum teres of liver"
            },
            {
              "code": "1706004",
              "display": "Thymic lobule"
            },
            {
              "code": "1707008",
              "display": "Ventral nuclear group of thalamus"
            },
            {
              "code": "1711002",
              "display": "Periorbital region"
            },
            {
              "code": "1716007",
              "display": "Cupula ampullaris"
            },
            {
              "code": "1721005",
              "display": "Right tonsil"
            },
            {
              "code": "1729007",
              "display": "Central tegmental tract"
            },
            {
              "code": "1732005",
              "display": "TD - Thoracic duct"
            },
            {
              "code": "1765002",
              "display": "Structure of lymphatic vessel of thorax"
            },
            {
              "code": "1780008",
              "display": "Premelanosome"
            },
            {
              "code": "1781007",
              "display": "Sacroiliac region"
            },
            {
              "code": "1797002",
              "display": "Naris"
            },
            {
              "code": "1818002",
              "display": "Greater circulus arteriosus of iris"
            },
            {
              "code": "1825009",
              "display": "Root of nose"
            },
            {
              "code": "1832000",
              "display": "Scleral conjunctiva"
            },
            {
              "code": "1840006",
              "display": "Arrector pili muscle"
            },
            {
              "code": "1849007",
              "display": "Pharyngeal recess"
            },
            {
              "code": "1853009",
              "display": "Structure of suprahyoid muscle"
            },
            {
              "code": "1874005",
              "display": "Promontory lymph node"
            },
            {
              "code": "1893007",
              "display": "Joint of upper extremity"
            },
            {
              "code": "1895000",
              "display": "Musculophrenic vein"
            },
            {
              "code": "1902009",
              "display": "Skin of external ear"
            },
            {
              "code": "1910005",
              "display": "Ear"
            },
            {
              "code": "1918003",
              "display": "Suprarenal aorta"
            },
            {
              "code": "1927002",
              "display": "Left elbow"
            },
            {
              "code": "1992003",
              "display": "Porus acusticus internus"
            },
            {
              "code": "1997009",
              "display": "Cingulum dentis"
            },
            {
              "code": "2010005",
              "display": "Clavicular facet of scapula"
            },
            {
              "code": "2020000",
              "display": "Superior thoracic artery"
            },
            {
              "code": "2031008",
              "display": "Structure of anterior median fissure of spinal cord"
            },
            {
              "code": "2033006",
              "display": "Right fallopian tube"
            },
            {
              "code": "2044003",
              "display": "Vaginal nerves"
            },
            {
              "code": "2048000",
              "display": "Lingual tonsil"
            },
            {
              "code": "2049008",
              "display": "Chorionic villi"
            },
            {
              "code": "2059009",
              "display": "Skin of ear lobule"
            },
            {
              "code": "2071003",
              "display": "Reticular formation of spinal cord"
            },
            {
              "code": "2076008",
              "display": "Head of phalanx of hand"
            },
            {
              "code": "2083001",
              "display": "Nucleus ambiguus"
            },
            {
              "code": "2095001",
              "display": "Accessory sinus"
            },
            {
              "code": "2123001",
              "display": "Mammilloinfundibular nucleus"
            },
            {
              "code": "2150006",
              "display": "Urinary tract transitional epithelial cell"
            },
            {
              "code": "2156000",
              "display": "Glial cell"
            },
            {
              "code": "2160002",
              "display": "Ligamentum arteriosum"
            },
            {
              "code": "2175005",
              "display": "Pharyngeal cavity"
            },
            {
              "code": "2182009",
              "display": "Endometrial zona basalis"
            },
            {
              "code": "2192001",
              "display": "Clavicular part of pectoralis major muscle"
            },
            {
              "code": "2205003",
              "display": "Lamina of fifth thoracic vertebra"
            },
            {
              "code": "2209009",
              "display": "Cerebral basal surface"
            },
            {
              "code": "2236006",
              "display": "Lesser osseous pelvis"
            },
            {
              "code": "2246008",
              "display": "Type I hair cell"
            },
            {
              "code": "2255006",
              "display": "Subserosa"
            },
            {
              "code": "2285001",
              "display": "Structure of torcular Herophili"
            },
            {
              "code": "2292006",
              "display": "Structure of nasopharyngeal gland"
            },
            {
              "code": "2302002",
              "display": "Vein of the knee"
            },
            {
              "code": "2305000",
              "display": "Structure of spinous process of cervical vertebra"
            },
            {
              "code": "2306004",
              "display": "Structure of base of third metacarpal bone"
            },
            {
              "code": "2327009",
              "display": "Salivary seromucous gland"
            },
            {
              "code": "2330002",
              "display": "Structure of segmental bronchial branches"
            },
            {
              "code": "2332005",
              "display": "Metencephalon of foetus"
            },
            {
              "code": "2334006",
              "display": "Renal calyx"
            },
            {
              "code": "2349003",
              "display": "Structure of nasal suture of skull"
            },
            {
              "code": "2372001",
              "display": "Structure of medial surface of toe"
            },
            {
              "code": "2383005",
              "display": "Structure of papillary muscles of right ventricle"
            },
            {
              "code": "2389009",
              "display": "Structure of superior margin of adrenal gland"
            },
            {
              "code": "2395005",
              "display": "Structure of transverse facial artery"
            },
            {
              "code": "2397002",
              "display": "Structure of first metatarsal facet of medial cuneiform bone"
            },
            {
              "code": "2400006",
              "display": "Universal designation 21"
            },
            {
              "code": "2402003",
              "display": "Structure of dorsum of foot"
            },
            {
              "code": "2421006",
              "display": "Structure of submaxillary ganglion"
            },
            {
              "code": "2433001",
              "display": "Structure of digital tendon and tendon sheath of foot"
            },
            {
              "code": "2436009",
              "display": "Tunica intima of vein"
            },
            {
              "code": "2453002",
              "display": "Subcutaneous tissue structure of posterior surface of forearm"
            },
            {
              "code": "2454008",
              "display": "Structure of articular surface, third metacarpal, of second metacarpal bone"
            },
            {
              "code": "2484000",
              "display": "Skin structure of frenulum of clitoris"
            },
            {
              "code": "2489005",
              "display": "Structure of medial check ligament of eye"
            },
            {
              "code": "2499000",
              "display": "Entire cisterna pontis"
            },
            {
              "code": "2502001",
              "display": "Membrane of lysosome"
            },
            {
              "code": "2504000",
              "display": "Structure of pancreatic plexus"
            },
            {
              "code": "2510000",
              "display": "Femoral triangle structure"
            },
            {
              "code": "2539000",
              "display": "Structure of superior rectal artery"
            },
            {
              "code": "2543001",
              "display": "Structure of cuboid articular facet of fourth metatarsal bone"
            },
            {
              "code": "2550002",
              "display": "Bone structure of phalanx of thumb"
            },
            {
              "code": "2577006",
              "display": "Structure of gracilis muscle"
            },
            {
              "code": "2579009",
              "display": "Plasmablast"
            },
            {
              "code": "2592007",
              "display": "All extremities"
            },
            {
              "code": "2600000",
              "display": "Structure of flexor pollicis longus muscle tendon"
            },
            {
              "code": "2620004",
              "display": "Intervertebral disc structure of third thoracic vertebra"
            },
            {
              "code": "2639009",
              "display": "Neuroendocrine tissue"
            },
            {
              "code": "2653009",
              "display": "Structure of posterior thalamic radiation of internal capsule"
            },
            {
              "code": "2666009",
              "display": "Structure of semispinalis capitis muscle"
            },
            {
              "code": "2672009",
              "display": "Structure of anterior cutaneous branch of lumbosacral plexus"
            },
            {
              "code": "2675006",
              "display": "Structure of anterior ethmoidal artery"
            },
            {
              "code": "2681003",
              "display": "Structure of dorsal nerve of penis"
            },
            {
              "code": "2682005",
              "display": "Bladder mucosa"
            },
            {
              "code": "2686008",
              "display": "Structure of medial olfactory gyrus"
            },
            {
              "code": "2687004",
              "display": "Structure of Bowman space"
            },
            {
              "code": "2695000",
              "display": "Left maxillary sinus structure"
            },
            {
              "code": "2703009",
              "display": "Entire calcarine artery"
            },
            {
              "code": "2712006",
              "display": "Structure of capsule of ankle joint"
            },
            {
              "code": "2718005",
              "display": "Structure of apical foramen of tooth"
            },
            {
              "code": "2726002",
              "display": "Structure of fold for stapes"
            },
            {
              "code": "2730004",
              "display": "Entire vitelline vein of placenta"
            },
            {
              "code": "2739003",
              "display": "Endometrial structure"
            },
            {
              "code": "2741002",
              "display": "Structure of medial occipitotemporal gyrus"
            },
            {
              "code": "2746007",
              "display": "Circular layer of gastric muscularis"
            },
            {
              "code": "2748008",
              "display": "Spinal cord structure"
            },
            {
              "code": "2759004",
              "display": "Eccrine gland structure"
            },
            {
              "code": "2771005",
              "display": "Lamina propria of ureter"
            },
            {
              "code": "2789006",
              "display": "Apocrine gland structure"
            },
            {
              "code": "2792005",
              "display": "Structure of pars tensa of tympanic membrane"
            },
            {
              "code": "2803000",
              "display": "Structure of tendon sheath of popliteus muscle"
            },
            {
              "code": "2810006",
              "display": "Structure of cremasteric fascia"
            },
            {
              "code": "2812003",
              "display": "Structure of head of femur"
            },
            {
              "code": "2824005",
              "display": "Structure of spinous process of fourth thoracic vertebra"
            },
            {
              "code": "2826007",
              "display": "Structure of lamina of fourth lumbar vertebra"
            },
            {
              "code": "2830005",
              "display": "Structure of dorsal digital nerves of lateral hallux and medial second toe"
            },
            {
              "code": "2839006",
              "display": "Structure of perivesicular tissues of seminal vesicles"
            },
            {
              "code": "2841007",
              "display": "Renal artery structure"
            },
            {
              "code": "2845003",
              "display": "Structure of respiratory epithelium"
            },
            {
              "code": "2848001",
              "display": "Structure of superficial epigastric artery"
            },
            {
              "code": "2855004",
              "display": "Structure of accessory cephalic vein"
            },
            {
              "code": "2861001",
              "display": "Entire gland (organ)"
            },
            {
              "code": "2894003",
              "display": "Structure of posterior epiglottis"
            },
            {
              "code": "2905008",
              "display": "Structure of anterior ligament of uterus"
            },
            {
              "code": "2909002",
              "display": "Structure of posterior portion of diaphragmatic aspect of liver"
            },
            {
              "code": "2920002",
              "display": "Structure of facial nerve motor branch"
            },
            {
              "code": "2922005",
              "display": "Structure of posterior papillary muscle of left ventricle"
            },
            {
              "code": "2923000",
              "display": "Subcutaneous tissue structure of supraorbital area"
            },
            {
              "code": "2954001",
              "display": "Supernumerary deciduous tooth"
            },
            {
              "code": "2969000",
              "display": "Anatomical space structure"
            },
            {
              "code": "2979003",
              "display": "Bone structure of medial cuneiform"
            },
            {
              "code": "2986006",
              "display": "Structure of talar facet of navicular bone of foot"
            },
            {
              "code": "2998001",
              "display": "Entire right margin of uterus"
            },
            {
              "code": "3003007",
              "display": "Internal capsule anterior limb structure"
            },
            {
              "code": "3008003",
              "display": "White fibrocartilage"
            },
            {
              "code": "3028004",
              "display": "Transitional epithelial cell"
            },
            {
              "code": "3039001",
              "display": "Subcutaneous tissue structure of thigh"
            },
            {
              "code": "3042007",
              "display": "Structure of glomerular urinary pole"
            },
            {
              "code": "3054007",
              "display": "Structure of articular surface, metacarpal, of phalanx of thumb"
            },
            {
              "code": "3055008",
              "display": "Structure of bone marrow of vertebral body"
            },
            {
              "code": "3056009",
              "display": "Structure of anteroventral nucleus of thalamus"
            },
            {
              "code": "3057000",
              "display": "Nerve structure"
            },
            {
              "code": "3058005",
              "display": "PNS - Peripheral nervous system"
            },
            {
              "code": "3062004",
              "display": "Spinal arachnoid"
            },
            {
              "code": "3068000",
              "display": "Structure of seminal vesicle lumen"
            },
            {
              "code": "3081007",
              "display": "Mitochondrion in division"
            },
            {
              "code": "3093003",
              "display": "Structure of tendinous arch of pelvic fascia"
            },
            {
              "code": "3100007",
              "display": "Clinical crown of tooth"
            },
            {
              "code": "3113001",
              "display": "Structure of suprachoroidal space"
            },
            {
              "code": "3117000",
              "display": "Structure of dorsal surface of index finger"
            },
            {
              "code": "3118005",
              "display": "Structure of trabecula carnea of left ventricle"
            },
            {
              "code": "3120008",
              "display": "Pleural membrane structure"
            },
            {
              "code": "3134008",
              "display": "Structure of head of fourth metatarsal bone"
            },
            {
              "code": "3138006",
              "display": "Bone tissue"
            },
            {
              "code": "3153003",
              "display": "Structure of tractus olivocochlearis"
            },
            {
              "code": "3156006",
              "display": "Structure of obturator artery"
            },
            {
              "code": "3159004",
              "display": "Structure of costocervical trunk"
            },
            {
              "code": "3169005",
              "display": "Spinal nerve structure"
            },
            {
              "code": "3178004",
              "display": "Structure of raphe of soft palate"
            },
            {
              "code": "3194006",
              "display": "Endocardium of right atrium"
            },
            {
              "code": "3198009",
              "display": "Monostomatic sublingual gland"
            },
            {
              "code": "3215002",
              "display": "Subcutaneous tissue structure of nuchal region"
            },
            {
              "code": "3222005",
              "display": "All large arteries"
            },
            {
              "code": "3227004",
              "display": "Left coronary artery main stem"
            },
            {
              "code": "3236000",
              "display": "Structure of posterior segment of right upper lobe of lung"
            },
            {
              "code": "3243006",
              "display": "Structure of parametrial lymph node"
            },
            {
              "code": "3255000",
              "display": "Papillary area"
            },
            {
              "code": "3262009",
              "display": "Structure of root canal of tooth"
            },
            {
              "code": "3279003",
              "display": "Structure of pedicle of third cervical vertebra"
            },
            {
              "code": "3295003",
              "display": "Structure of ventral anterior nucleus of thalamus"
            },
            {
              "code": "3301002",
              "display": "Tectopontine fibers"
            },
            {
              "code": "3302009",
              "display": "Splenic branch of splenic artery"
            },
            {
              "code": "3315000",
              "display": "Structure of vestibulospinal tract"
            },
            {
              "code": "3332001",
              "display": "Occipitofrontal diameter of head"
            },
            {
              "code": "3336003",
              "display": "Haversian canal"
            },
            {
              "code": "3341006",
              "display": "Right lung structure"
            },
            {
              "code": "3350008",
              "display": "Entire right commissure of pulmonic valve"
            },
            {
              "code": "3362007",
              "display": "Intertragal incisure structure"
            },
            {
              "code": "3366005",
              "display": "Structure of anterior papillary muscle of left ventricle"
            },
            {
              "code": "3370002",
              "display": "Structure of supporting tissue of rectum"
            },
            {
              "code": "3374006",
              "display": "Secondary spermatocyte"
            },
            {
              "code": "3377004",
              "display": "Structure of agger nasi"
            },
            {
              "code": "3382006",
              "display": "Structure of rima oris"
            },
            {
              "code": "3383001",
              "display": "Nonsegmented basophil"
            },
            {
              "code": "3394002",
              "display": "Suboccipitobregmatic diameter of head"
            },
            {
              "code": "3395001",
              "display": "Structure of superior palpebral arch"
            },
            {
              "code": "3396000",
              "display": "Structure of mesogastrium"
            },
            {
              "code": "3400000",
              "display": "Cell of bone"
            },
            {
              "code": "3409004",
              "display": "Structure of lateral margin of forearm"
            },
            {
              "code": "3417007",
              "display": "Structure of rotator muscle"
            },
            {
              "code": "3438001",
              "display": "Deep lymphatic of upper extremity"
            },
            {
              "code": "3444002",
              "display": "Thalamostriate vein"
            },
            {
              "code": "3447009",
              "display": "Penetrated oocyte"
            },
            {
              "code": "3460003",
              "display": "Structure of anterodorsal nucleus of thalamus"
            },
            {
              "code": "3462006",
              "display": "Structure of commissure of tricuspid valve"
            },
            {
              "code": "3471002",
              "display": "Posterior midline of trunk"
            },
            {
              "code": "3478008",
              "display": "Structure of vastus medialis muscle"
            },
            {
              "code": "3481003",
              "display": "Structure of embryonic testis"
            },
            {
              "code": "3488009",
              "display": "Annulate lamella, cisternal lumen"
            },
            {
              "code": "3490005",
              "display": "Subcutaneous tissue structure of suboccipital region"
            },
            {
              "code": "3524005",
              "display": "Structure of lateral wall of mastoid antrum"
            },
            {
              "code": "3538003",
              "display": "Structure of capsule of proximal tibiofibular joint"
            },
            {
              "code": "3541007",
              "display": "Structure of dorsal metatarsal artery"
            },
            {
              "code": "3553006",
              "display": "Structure of thyroid capsule"
            },
            {
              "code": "3556003",
              "display": "Structure of dorsal nucleus of trapezoid body"
            },
            {
              "code": "3563003",
              "display": "Muscularis of ureter"
            },
            {
              "code": "3572006",
              "display": "Vertebral body"
            },
            {
              "code": "3578005",
              "display": "Structure of body of gallbladder"
            },
            {
              "code": "3582007",
              "display": "Structure of gastrophrenic ligament"
            },
            {
              "code": "3584008",
              "display": "T10 dorsal arch"
            },
            {
              "code": "3594003",
              "display": "Structure of straight part of longus colli muscle"
            },
            {
              "code": "3608004",
              "display": "Ischiococcygeus muscle"
            },
            {
              "code": "3609007",
              "display": "Structure of occipital branch of posterior auricular artery"
            },
            {
              "code": "3646006",
              "display": "Lamellipodium"
            },
            {
              "code": "3663005",
              "display": "Structure of tympanic ostium of Eustachian tube"
            },
            {
              "code": "3665003",
              "display": "Pelvic wall structure"
            },
            {
              "code": "3670005",
              "display": "Entire subpyloric lymph node"
            },
            {
              "code": "3711007",
              "display": "Great vessel"
            },
            {
              "code": "3743007",
              "display": "Structure of lateral thoracic artery"
            },
            {
              "code": "3761003",
              "display": "Structure of nucleus pulposus of intervertebral disc of first thoracic vertebra"
            },
            {
              "code": "3766008",
              "display": "Subcutaneous tissue structure of lower extremity"
            },
            {
              "code": "3785006",
              "display": "Entire dorsal metacarpal ligament"
            },
            {
              "code": "3788008",
              "display": "Structure of apical segment of right lower lobe of lung"
            },
            {
              "code": "3789000",
              "display": "Enteroendocrine cell"
            },
            {
              "code": "3810000",
              "display": "Septal cartilage structure"
            },
            {
              "code": "3838008",
              "display": "Structure of apex of coccyx"
            },
            {
              "code": "3860006",
              "display": "Structure of transplanted liver"
            },
            {
              "code": "3865001",
              "display": "Structure of interscapular region of back"
            },
            {
              "code": "3867009",
              "display": "Structure of dorsal surface of great toe"
            },
            {
              "code": "3876002",
              "display": "Subcutaneous tissue structure of femoral region"
            },
            {
              "code": "3877006",
              "display": "Structure of common carotid plexus"
            },
            {
              "code": "3910004",
              "display": "Subcutaneous tissue structure of lateral surface of fourth toe"
            },
            {
              "code": "3916005",
              "display": "Structure of occipital lymph node"
            },
            {
              "code": "3924000",
              "display": "Structure of pericardiophrenic artery"
            },
            {
              "code": "3931001",
              "display": "OW - Oval window"
            },
            {
              "code": "3935005",
              "display": "Head of tenth rib structure"
            },
            {
              "code": "3937002",
              "display": "Structure of entorhinal cortex"
            },
            {
              "code": "3954005",
              "display": "Lacrimal sac structure"
            },
            {
              "code": "3956007",
              "display": "Structure of fifth metatarsal articular facet of fourth metatarsal bone"
            },
            {
              "code": "3959000",
              "display": "Structure of rectus capitis muscle"
            },
            {
              "code": "3960005",
              "display": "Olfactory tract structure"
            },
            {
              "code": "3964001",
              "display": "Structure of gyrus of brain"
            },
            {
              "code": "3966004",
              "display": "Entire parietal branch of anterior cerebral artery"
            },
            {
              "code": "3977005",
              "display": "Subcutaneous tissue structure of concha"
            },
            {
              "code": "3984002",
              "display": "Deep vein of clitoris"
            },
            {
              "code": "3989007",
              "display": "Structure of medial globus pallidus"
            },
            {
              "code": "4015004",
              "display": "Chromosomes, group A"
            },
            {
              "code": "4019005",
              "display": "Posterior commissure of labium majorum"
            },
            {
              "code": "4029003",
              "display": "Eosinophilic progranulocyte"
            },
            {
              "code": "4061004",
              "display": "Lateral orbital wall"
            },
            {
              "code": "4066009",
              "display": "Structure of capsule of proximal interphalangeal joint of index finger"
            },
            {
              "code": "4072009",
              "display": "Structure of fourth coccygeal vertebra"
            },
            {
              "code": "4081003",
              "display": "Entire dorsal lingual vein"
            },
            {
              "code": "4093007",
              "display": "Structure of vagus nerve bronchial branch"
            },
            {
              "code": "4111006",
              "display": "Macula of the saccule"
            },
            {
              "code": "4117005",
              "display": "Lumbosacral spinal cord central canal structure"
            },
            {
              "code": "4121003",
              "display": "Structure of superior frontal sulcus"
            },
            {
              "code": "4146003",
              "display": "Structure of artery of extremity"
            },
            {
              "code": "4148002",
              "display": "Structure of palmar surface of little finger"
            },
            {
              "code": "4150005",
              "display": "Celiac nervous plexus structure"
            },
            {
              "code": "4158003",
              "display": "Abdominal aortic plexus structure"
            },
            {
              "code": "4159006",
              "display": "Hyparterial bronchus"
            },
            {
              "code": "4180000",
              "display": "Both lower extremities"
            },
            {
              "code": "4193005",
              "display": "Entire extensor tendon and tendon sheath of fifth toe"
            },
            {
              "code": "4205002",
              "display": "Türk cell"
            },
            {
              "code": "4212006",
              "display": "Epithelial cells"
            },
            {
              "code": "4215008",
              "display": "Head of second rib structure"
            },
            {
              "code": "4247003",
              "display": "Bone structure of first metacarpal"
            },
            {
              "code": "4258007",
              "display": "Posterior tibial vein"
            },
            {
              "code": "4268002",
              "display": "Lateral spinorubral tract"
            },
            {
              "code": "4276000",
              "display": "Structure of inferior articular process of seventh cervical vertebra"
            },
            {
              "code": "4281009",
              "display": "Structure of middle portion of ileum"
            },
            {
              "code": "4295007",
              "display": "Structure of paracortical area of lymph node"
            },
            {
              "code": "4303006",
              "display": "Cartilage canal"
            },
            {
              "code": "4312008",
              "display": "Anterior midline of abdomen"
            },
            {
              "code": "4317002",
              "display": "Structure of spinalis muscle"
            },
            {
              "code": "4328003",
              "display": "Protoplasmic astrocyte"
            },
            {
              "code": "4335006",
              "display": "Upper jaw region"
            },
            {
              "code": "4352005",
              "display": "Structure of subchorionic space"
            },
            {
              "code": "4358009",
              "display": "Structure of lateral surface of little finger"
            },
            {
              "code": "4360006",
              "display": "Stratum spinosum structure"
            },
            {
              "code": "4369007",
              "display": "Small intestine mucous membrane structure"
            },
            {
              "code": "4371007",
              "display": "Structure of fourth metatarsal facet of lateral cuneiform bone"
            },
            {
              "code": "4375003",
              "display": "Structure of incisure of cartilaginous portion of auditory canal"
            },
            {
              "code": "4377006",
              "display": "Structure of parafascicular nucleus of thalamus"
            },
            {
              "code": "4394008",
              "display": "Scala vestibuli structure"
            },
            {
              "code": "4402002",
              "display": "Structure of anterior articular surface for talus"
            },
            {
              "code": "4419000",
              "display": "Tracheal submucosa"
            },
            {
              "code": "4421005",
              "display": "Cellular structures"
            },
            {
              "code": "4430002",
              "display": "Structure of clivus ossis sphenoidalis"
            },
            {
              "code": "4432005",
              "display": "Structure of ductus arteriosus"
            },
            {
              "code": "4442007",
              "display": "Dental arch structure"
            },
            {
              "code": "4486002",
              "display": "Structure of accessory sinus gland"
            },
            {
              "code": "4524000",
              "display": "Structure of subclavian plexus"
            },
            {
              "code": "4527007",
              "display": "Joint structure of lower extremity"
            },
            {
              "code": "4537002",
              "display": "Structure of internal medullary lamina of thalamus"
            },
            {
              "code": "4548009",
              "display": "Lamellated granule, as in surfactant-secreting cell"
            },
            {
              "code": "4549001",
              "display": "Entire vagus nerve parasympathetic fibers to liver, gallbladder, bile ducts and pancreas"
            },
            {
              "code": "4566004",
              "display": "Structure of tentorium cerebelli"
            },
            {
              "code": "4573009",
              "display": "Desmosome"
            },
            {
              "code": "4578000",
              "display": "Skin structure of posterior surface of thigh"
            },
            {
              "code": "4583008",
              "display": "Structure of splenius muscle of trunk"
            },
            {
              "code": "4588004",
              "display": "Structure of middle trunk of brachial plexus"
            },
            {
              "code": "4596009",
              "display": "Larynx structure"
            },
            {
              "code": "4603002",
              "display": "Structure of base of phalanx of foot"
            },
            {
              "code": "4606005",
              "display": "Tubercle of eighth rib structure"
            },
            {
              "code": "4621004",
              "display": "Structure of lesser tuberosity of humerus"
            },
            {
              "code": "4624007",
              "display": "Structure of lymphatic cord"
            },
            {
              "code": "4647008",
              "display": "Lipid droplet, homogeneous"
            },
            {
              "code": "4651005",
              "display": "Structure of tunica albuginea of corpus spongiosum"
            },
            {
              "code": "4658004",
              "display": "Skin structure of nuchal region"
            },
            {
              "code": "4677002",
              "display": "Basal lamina, inclusion in subepithelial location"
            },
            {
              "code": "4703008",
              "display": "Cardinal vein structure"
            },
            {
              "code": "4717004",
              "display": "Neutrophilic myelocyte"
            },
            {
              "code": "4718009",
              "display": "Entire venous plexus of the foramen ovale basis cranii"
            },
            {
              "code": "4743003",
              "display": "Structure of ventral sacrococcygeal ligament"
            },
            {
              "code": "4755009",
              "display": "Structure of medial surface of great toe"
            },
            {
              "code": "4759003",
              "display": "Structure of gemellus muscle"
            },
            {
              "code": "4766002",
              "display": "Structure of supracardinal vein"
            },
            {
              "code": "4768001",
              "display": "Structure of perineal nerve"
            },
            {
              "code": "4774001",
              "display": "Structure of phrenic nerve pericardial branch"
            },
            {
              "code": "4775000",
              "display": "Structure of ventral posterior inferior nucleus"
            },
            {
              "code": "4799000",
              "display": "Deiter cell"
            },
            {
              "code": "4810005",
              "display": "Structure of uterine venous plexus"
            },
            {
              "code": "4812002",
              "display": "Anterior tibial compartment structure"
            },
            {
              "code": "4828007",
              "display": "Femoral canal structure"
            },
            {
              "code": "4840007",
              "display": "Subcutaneous tissue structure of ring finger"
            },
            {
              "code": "4843009",
              "display": "Ampulla of semicircular duct"
            },
            {
              "code": "4861000",
              "display": "Structure of tuberculum impar"
            },
            {
              "code": "4866005",
              "display": "Constrictor muscle of pharynx structure"
            },
            {
              "code": "4870002",
              "display": "Structure of dorsal tegmental nuclei of midbrain"
            },
            {
              "code": "4871003",
              "display": "Lamina of modiolus of cochlea"
            },
            {
              "code": "4881004",
              "display": "Entire sublingual vein"
            },
            {
              "code": "4888005",
              "display": "Entire interlobular vein of kidney"
            },
            {
              "code": "4897009",
              "display": "Cell membrane, prokaryotic"
            },
            {
              "code": "4905007",
              "display": "Structure of uterovaginal plexus"
            },
            {
              "code": "4906008",
              "display": "Mastoid antrum structure"
            },
            {
              "code": "4924005",
              "display": "Cerebellar gracile lobule"
            },
            {
              "code": "4942000",
              "display": "Lower limb lymph node structure"
            },
            {
              "code": "4954000",
              "display": "Structure of radial notch of ulna"
            },
            {
              "code": "4956003",
              "display": "Subcutaneous tissue structure of back"
            },
            {
              "code": "4958002",
              "display": "Amygdaloid structure"
            },
            {
              "code": "5001007",
              "display": "Structure of superior temporal sulcus"
            },
            {
              "code": "5023006",
              "display": "Structure of yellow bone marrow"
            },
            {
              "code": "5026003",
              "display": "Structure of posterior surface of prostate"
            },
            {
              "code": "5046008",
              "display": "Structure of superficial dorsal veins of clitoris"
            },
            {
              "code": "5068003",
              "display": "Structure of obturator internus muscle ischial bursa"
            },
            {
              "code": "5069006",
              "display": "Structure of rugal column"
            },
            {
              "code": "5076001",
              "display": "Structure of infrasternal angle"
            },
            {
              "code": "5115006",
              "display": "Structure of posterior auricular vein"
            },
            {
              "code": "5122003",
              "display": "Entire angle of first rib"
            },
            {
              "code": "5128004",
              "display": "Lens zonules"
            },
            {
              "code": "5140004",
              "display": "Permanent upper right 6 tooth"
            },
            {
              "code": "5192008",
              "display": "Structure of intervertebral foramen of twelfth thoracic vertebra"
            },
            {
              "code": "5194009",
              "display": "Structure of epithelium of lens"
            },
            {
              "code": "5195005",
              "display": "Structure of right external carotid artery"
            },
            {
              "code": "5204005",
              "display": "Superior ileocecal recess"
            },
            {
              "code": "5213007",
              "display": "Frontal vein"
            },
            {
              "code": "5225005",
              "display": "Structure of uterine ostium of fallopian tube"
            },
            {
              "code": "5228007",
              "display": "Right cerebral hemisphere structure"
            },
            {
              "code": "5229004",
              "display": "Structure of mucosa of gallbladder"
            },
            {
              "code": "5261000",
              "display": "Structure of thoracic intervertebral disc"
            },
            {
              "code": "5272005",
              "display": "Skin structure of lateral portion of neck"
            },
            {
              "code": "5279001",
              "display": "Structure of foramen singulare"
            },
            {
              "code": "5296000",
              "display": "Structure of anterior mediastinal lymph node"
            },
            {
              "code": "5324007",
              "display": "Structure of superior pole of kidney"
            },
            {
              "code": "5329002",
              "display": "Bone structure of C4"
            },
            {
              "code": "5336001",
              "display": "Structure of inferior frontal gyrus"
            },
            {
              "code": "5347008",
              "display": "Synaptic specialization, cytoplasmic"
            },
            {
              "code": "5362005",
              "display": "Structure of median arcuate ligament of diaphragm"
            },
            {
              "code": "5366008",
              "display": "Hippocampal structure"
            },
            {
              "code": "5379004",
              "display": "Small intestine muscularis propria"
            },
            {
              "code": "5382009",
              "display": "Superior fascia of perineum"
            },
            {
              "code": "5394000",
              "display": "Uterine paracervical lymph node"
            },
            {
              "code": "5398002",
              "display": "Normal fat pad"
            },
            {
              "code": "5403001",
              "display": "Articular process of third lumbar vertebra"
            },
            {
              "code": "5421003",
              "display": "Sex chromosome Y"
            },
            {
              "code": "5427004",
              "display": "Apocrine intraepidermal duct"
            },
            {
              "code": "5458003",
              "display": "Deep artery of clitoris"
            },
            {
              "code": "5459006",
              "display": "Cardiac incisure of stomach"
            },
            {
              "code": "5491007",
              "display": "Lacrimal part of orbicularis oculi muscle"
            },
            {
              "code": "5493005",
              "display": "Metacarpophalangeal joint of little finger"
            },
            {
              "code": "5498001",
              "display": "Superior aberrant ductule of epididymis"
            },
            {
              "code": "5501001",
              "display": "Hyaloid artery"
            },
            {
              "code": "5520004",
              "display": "Subcutaneous tissue of chin"
            },
            {
              "code": "5538001",
              "display": "Tegmental portion of pons"
            },
            {
              "code": "5542003",
              "display": "Crista marginalis of tooth"
            },
            {
              "code": "5544002",
              "display": "Longitudinal layer of duodenal muscularis propria"
            },
            {
              "code": "5560003",
              "display": "Alveolar ridge mucous membrane"
            },
            {
              "code": "5564007",
              "display": "Singlet"
            },
            {
              "code": "5574005",
              "display": "Seventh costal cartilage"
            },
            {
              "code": "5580002",
              "display": "Tendon of supraspinatus muscle"
            },
            {
              "code": "5597008",
              "display": "Retina of right eye"
            },
            {
              "code": "5611001",
              "display": "Anulus fibrosus of intervertebral disc of fifth cervical vertebra"
            },
            {
              "code": "5625000",
              "display": "Navicular facet of intermediate cuneiform bone"
            },
            {
              "code": "5627008",
              "display": "Right visceral pleura"
            },
            {
              "code": "5633004",
              "display": "Muscular portion of interventricular septum"
            },
            {
              "code": "5643001",
              "display": "Canal of stomach"
            },
            {
              "code": "5644007",
              "display": "Fractured membrane P face"
            },
            {
              "code": "5653000",
              "display": "Inner surface of seventh rib"
            },
            {
              "code": "5665001",
              "display": "Retina"
            },
            {
              "code": "5668004",
              "display": "Lower digestive tract"
            },
            {
              "code": "5677006",
              "display": "Lenticular fasciculus"
            },
            {
              "code": "5682004",
              "display": "Subcutaneous tissue of upper extremity"
            },
            {
              "code": "5696005",
              "display": "Articular part of tubercle of ninth rib"
            },
            {
              "code": "5697001",
              "display": "Skin of lateral surface of finger"
            },
            {
              "code": "5709001",
              "display": "Multifidus muscles"
            },
            {
              "code": "5713008",
              "display": "Submandibular triangle"
            },
            {
              "code": "5717009",
              "display": "Temporal fossa"
            },
            {
              "code": "5718004",
              "display": "Tendon and tendon sheath of leg and ankle"
            },
            {
              "code": "5727003",
              "display": "Anterior cervical lymph node"
            },
            {
              "code": "5742000",
              "display": "Skin of forearm"
            },
            {
              "code": "5751008",
              "display": "Subcutaneous tissue of anterior portion of neck"
            },
            {
              "code": "5769004",
              "display": "Endocervical epithelium"
            },
            {
              "code": "5780004",
              "display": "Paradidymis"
            },
            {
              "code": "5798000",
              "display": "Diaphragm"
            },
            {
              "code": "5802004",
              "display": "Medium sized neuron"
            },
            {
              "code": "5814007",
              "display": "Angle of seventh rib"
            },
            {
              "code": "5815008",
              "display": "Superior rectus muscle"
            },
            {
              "code": "5816009",
              "display": "Duodenal fold"
            },
            {
              "code": "5825003",
              "display": "Substantia propria of sclera"
            },
            {
              "code": "5828001",
              "display": "Posterior cord of brachial plexus"
            },
            {
              "code": "5847003",
              "display": "Superior articular process of seventh cervical vertebra"
            },
            {
              "code": "5854009",
              "display": "Orbital plate of ethmoid bone"
            },
            {
              "code": "5868002",
              "display": "Serosa of urinary bladder"
            },
            {
              "code": "5872003",
              "display": "Subcutaneous tissue of lateral border of sole of foot"
            },
            {
              "code": "5881009",
              "display": "Tuberosity of distal phalanx of hand"
            },
            {
              "code": "5882002",
              "display": "Endothelial sieve plate"
            },
            {
              "code": "5889006",
              "display": "Articular surface, third metacarpal, of fourth metacarpal bone"
            },
            {
              "code": "5890002",
              "display": "Posterior cells of ethmoid sinus"
            },
            {
              "code": "5893000",
              "display": "Superior recess of tympanic membrane"
            },
            {
              "code": "5898009",
              "display": "Myotome"
            },
            {
              "code": "5923009",
              "display": "Articular process of twelfth thoracic vertebra"
            },
            {
              "code": "5926001",
              "display": "Bronchial lumen"
            },
            {
              "code": "5928000",
              "display": "Great cardiac vein"
            },
            {
              "code": "5942008",
              "display": "Tensor tympani muscle"
            },
            {
              "code": "5943003",
              "display": "Vestibular vein"
            },
            {
              "code": "5944009",
              "display": "Posterior palatine arch"
            },
            {
              "code": "5948007",
              "display": "Capsule of distal interphalangeal joint of third toe"
            },
            {
              "code": "5951000",
              "display": "Left wrist"
            },
            {
              "code": "5953002",
              "display": "Eighth rib"
            },
            {
              "code": "5976004",
              "display": "Subcutaneous tissue of eyelid"
            },
            {
              "code": "5979006",
              "display": "Episcleral artery"
            },
            {
              "code": "5996007",
              "display": "Chromosomes, group D"
            },
            {
              "code": "6001004",
              "display": "Quadratus lumborum muscle"
            },
            {
              "code": "6004007",
              "display": "Intervertebral disc of second thoracic vertebra"
            },
            {
              "code": "6006009",
              "display": "Circular layer of duodenal muscularis propria"
            },
            {
              "code": "6009002",
              "display": "Mesentery of ascending colon"
            },
            {
              "code": "6013009",
              "display": "Reticuloendothelial system"
            },
            {
              "code": "6014003",
              "display": "Penicilliary arteries"
            },
            {
              "code": "6023000",
              "display": "Heterolysosome"
            },
            {
              "code": "6032003",
              "display": "Columnar epithelial cell"
            },
            {
              "code": "6046003",
              "display": "Outer surface of third rib"
            },
            {
              "code": "6050005",
              "display": "Lacrimal vein"
            },
            {
              "code": "6059006",
              "display": "Metacarpophalangeal joint of middle finger"
            },
            {
              "code": "6062009",
              "display": "Deciduous mandibular right canine tooth"
            },
            {
              "code": "6073002",
              "display": "Ligament of left superior vena cava"
            },
            {
              "code": "6074008",
              "display": "Capsule of temporomandibular joint"
            },
            {
              "code": "6076005",
              "display": "Gastrointestinal subserosa"
            },
            {
              "code": "6104005",
              "display": "Subclavian nerve"
            },
            {
              "code": "6105006",
              "display": "Body of fifth thoracic vertebra"
            },
            {
              "code": "6110005",
              "display": "Facial nerve parasympathetic fibers"
            },
            {
              "code": "6194002",
              "display": "Nail of fourth toe"
            },
            {
              "code": "6216007",
              "display": "Postcapillary venule"
            },
            {
              "code": "6217003",
              "display": "Piriform recess"
            },
            {
              "code": "6229007",
              "display": "Os lacrimale"
            },
            {
              "code": "6253001",
              "display": "Sulcus terminalis cordis"
            },
            {
              "code": "6268000",
              "display": "Accessory phrenic nerves"
            },
            {
              "code": "6269008",
              "display": "Subcutaneous tissue of scalp"
            },
            {
              "code": "6279005",
              "display": "Skin of dorsal surface of finger"
            },
            {
              "code": "6317000",
              "display": "Posterior basal branch of left pulmonary artery"
            },
            {
              "code": "6325003",
              "display": "Aryepiglottic muscle"
            },
            {
              "code": "6326002",
              "display": "Fetal atloid articulation"
            },
            {
              "code": "6335009",
              "display": "Lymphoid follicle of stomach"
            },
            {
              "code": "6359004",
              "display": "Hair medulla"
            },
            {
              "code": "6371005",
              "display": "Lymphatics of thyroid gland"
            },
            {
              "code": "6375001",
              "display": "Cavernous portion of urethra"
            },
            {
              "code": "6392005",
              "display": "Coccygeal nerve"
            },
            {
              "code": "6404004",
              "display": "Ligamentum nuchae"
            },
            {
              "code": "6413002",
              "display": "Presymphysial lymph node"
            },
            {
              "code": "6417001",
              "display": "Medial malleolus"
            },
            {
              "code": "6423006",
              "display": "Supraspinatus muscle"
            },
            {
              "code": "6424000",
              "display": "Structure of radiating portion of cortical lobule of kidney"
            },
            {
              "code": "6445007",
              "display": "Mast cell"
            },
            {
              "code": "6448009",
              "display": "Posterior vagal trunk"
            },
            {
              "code": "6450001",
              "display": "Cytotrophoblast"
            },
            {
              "code": "6472004",
              "display": "Medial aspect of ovary"
            },
            {
              "code": "6504002",
              "display": "Glans clitoridis"
            },
            {
              "code": "6511003",
              "display": "Distal portion of circumflex branch of left coronary artery"
            },
            {
              "code": "6530003",
              "display": "Cardiac valve leaflet"
            },
            {
              "code": "6533001",
              "display": "Colonic haustra"
            },
            {
              "code": "6538005",
              "display": "Thyrocervical trunk"
            },
            {
              "code": "6541001",
              "display": "Anterior commissure of mitral valve"
            },
            {
              "code": "6544009",
              "display": "Gastrohepatic ligament"
            },
            {
              "code": "6550004",
              "display": "Angular incisure of stomach"
            },
            {
              "code": "6551000",
              "display": "Pollicis artery"
            },
            {
              "code": "6553002",
              "display": "Inferior nasal turbinate"
            },
            {
              "code": "6564004",
              "display": "Medial border of sole"
            },
            {
              "code": "6566002",
              "display": "Cerebellar hemisphere"
            },
            {
              "code": "6572002",
              "display": "Base of phalanx of middle finger"
            },
            {
              "code": "6598008",
              "display": "Lingual nerve"
            },
            {
              "code": "6606008",
              "display": "Structure of dorsal intercuneiform ligaments"
            },
            {
              "code": "6608009",
              "display": "Sphenoparietal sinus"
            },
            {
              "code": "6620001",
              "display": "Cuticle of nail"
            },
            {
              "code": "6623004",
              "display": "Sternal muscle"
            },
            {
              "code": "6633007",
              "display": "Right posterior cerebral artery"
            },
            {
              "code": "6643005",
              "display": "Right anterior cerebral artery"
            },
            {
              "code": "6646002",
              "display": "Anterior fossa of cranial cavity"
            },
            {
              "code": "6649009",
              "display": "Uterine subserosa"
            },
            {
              "code": "6651008",
              "display": "Central lobule of cerebellum"
            },
            {
              "code": "6684008",
              "display": "Articular facet of head of fibula"
            },
            {
              "code": "6685009",
              "display": "Right ankle"
            },
            {
              "code": "6711001",
              "display": "Arch of second lumbar vertebra"
            },
            {
              "code": "6720005",
              "display": "Femoral nerve lateral muscular branches"
            },
            {
              "code": "6731002",
              "display": "Pleural recess"
            },
            {
              "code": "6739000",
              "display": "Chorda tympani"
            },
            {
              "code": "6742006",
              "display": "Callosomarginal branch of anterior cerebral artery"
            },
            {
              "code": "6750002",
              "display": "Mitochondrial inclusion"
            },
            {
              "code": "6757004",
              "display": "Right knee"
            },
            {
              "code": "6787005",
              "display": "Tendon and tendon sheath of hand"
            },
            {
              "code": "6789008",
              "display": "Spermatozoa"
            },
            {
              "code": "6799003",
              "display": "Macula of utricle"
            },
            {
              "code": "6805009",
              "display": "Interstitial tissue of spleen"
            },
            {
              "code": "6820003",
              "display": "Obturator nerve anterior branch"
            },
            {
              "code": "6828005",
              "display": "Ligament of lumbosacral joint"
            },
            {
              "code": "6829002",
              "display": "Pars ciliaris of retina"
            },
            {
              "code": "6834003",
              "display": "Axial skeleton"
            },
            {
              "code": "6841009",
              "display": "Corticomedullary junction of kidney"
            },
            {
              "code": "6844001",
              "display": "Spore crystal"
            },
            {
              "code": "6850006",
              "display": "Secondary foot process"
            },
            {
              "code": "6864006",
              "display": "Leaf of epiglottis"
            },
            {
              "code": "6866008",
              "display": "Habenular commissure"
            },
            {
              "code": "6871001",
              "display": "Visceral pericardium"
            },
            {
              "code": "6894000",
              "display": "Medial surface of arm"
            },
            {
              "code": "6902008",
              "display": "Popliteal region"
            },
            {
              "code": "6905005",
              "display": "Subcutaneous tissue of medial surface of third toe"
            },
            {
              "code": "6912001",
              "display": "Lower alveolar ridge mucosa"
            },
            {
              "code": "6914000",
              "display": "Perivascular space"
            },
            {
              "code": "6921000",
              "display": "Right upper extremity"
            },
            {
              "code": "6930008",
              "display": "Jugular arch"
            },
            {
              "code": "6944002",
              "display": "Anterior labial veins"
            },
            {
              "code": "6969002",
              "display": "Lymphocytic tissue"
            },
            {
              "code": "6975006",
              "display": "Anterior myocardium"
            },
            {
              "code": "6981003",
              "display": "Posterior hypothalamic nucleus"
            },
            {
              "code": "6987004",
              "display": "Collateral sulcus"
            },
            {
              "code": "6989001",
              "display": "Thoracolumbar region of back"
            },
            {
              "code": "6991009",
              "display": "Subcutaneous tissue of jaw"
            },
            {
              "code": "7035006",
              "display": "Bile duct mucous membrane"
            },
            {
              "code": "7050002",
              "display": "Subcutaneous tissue of external genitalia"
            },
            {
              "code": "7067009",
              "display": "Right colic artery"
            },
            {
              "code": "7076002",
              "display": "Interstitial tissue of myocardium"
            },
            {
              "code": "7083009",
              "display": "Middle phalanx of index finger"
            },
            {
              "code": "7090004",
              "display": "Supraaortic branches"
            },
            {
              "code": "7091000",
              "display": "Ventral posterolateral nucleus of thalamus"
            },
            {
              "code": "7099003",
              "display": "Attachment plaque of desmosome or hemidesmosome"
            },
            {
              "code": "7117004",
              "display": "Fetal implantation site"
            },
            {
              "code": "7121006",
              "display": "Maxillary right second molar tooth"
            },
            {
              "code": "7148007",
              "display": "Anulus fibrosus of intervertebral disc of thoracic vertebra"
            },
            {
              "code": "7149004",
              "display": "False rib"
            },
            {
              "code": "7154008",
              "display": "Trigeminal ganglion sensory root"
            },
            {
              "code": "7160008",
              "display": "Base of metacarpal bone"
            },
            {
              "code": "7167006",
              "display": "Paraduodenal recess"
            },
            {
              "code": "7173007",
              "display": "Cauda equina"
            },
            {
              "code": "7188002",
              "display": "Gustatory pore"
            },
            {
              "code": "7192009",
              "display": "Isthmus tympani posticus"
            },
            {
              "code": "7227003",
              "display": "Hypoglossal nerve intrinsic tongue muscle branch"
            },
            {
              "code": "7234001",
              "display": "Inferior choroid vein"
            },
            {
              "code": "7242000",
              "display": "Appendiceal muscularis propria"
            },
            {
              "code": "7275008",
              "display": "Lymphatics of appendix and large intestine"
            },
            {
              "code": "7295002",
              "display": "Muscle of perineum"
            },
            {
              "code": "7296001",
              "display": "Deep inguinal ring"
            },
            {
              "code": "7311008",
              "display": "Anterior surface of arm"
            },
            {
              "code": "7344002",
              "display": "Lingual gyrus"
            },
            {
              "code": "7345001",
              "display": "Ciliary processes"
            },
            {
              "code": "7347009",
              "display": "Infratendinous olecranon bursa"
            },
            {
              "code": "7362006",
              "display": "Lymphatic of head"
            },
            {
              "code": "7376007",
              "display": "Left margin of uterus"
            },
            {
              "code": "7378008",
              "display": "Paraventricular nucleus of thalamus"
            },
            {
              "code": "7384006",
              "display": "Plantar calcaneocuboidal ligament"
            },
            {
              "code": "7404008",
              "display": "Anterior semicircular duct"
            },
            {
              "code": "7435002",
              "display": "Ovarian ligament"
            },
            {
              "code": "7471001",
              "display": "Lateral surface of sublingual gland"
            },
            {
              "code": "7477002",
              "display": "Lipid, crystalline"
            },
            {
              "code": "7480001",
              "display": "Iliotibial tract"
            },
            {
              "code": "7494000",
              "display": "Cerebellar lenticular nucleus"
            },
            {
              "code": "7498002",
              "display": "Plantar tarsal ligaments"
            },
            {
              "code": "7507003",
              "display": "Anterior ligament of head of fibula"
            },
            {
              "code": "7524009",
              "display": "Vasa vasorum"
            },
            {
              "code": "7532001",
              "display": "Vagus nerve parasympathetic fibers"
            },
            {
              "code": "7554004",
              "display": "Deep head of flexor pollicis brevis muscle"
            },
            {
              "code": "7566005",
              "display": "Mitotic cell in anaphase"
            },
            {
              "code": "7569003",
              "display": "Finger"
            },
            {
              "code": "7591005",
              "display": "Intervertebral disc space of eleventh thoracic vertebra"
            },
            {
              "code": "7597009",
              "display": "Subcutaneous tissue of vertex"
            },
            {
              "code": "7605000",
              "display": "Connexon"
            },
            {
              "code": "7610001",
              "display": "Tenth thoracic vertebra"
            },
            {
              "code": "7629007",
              "display": "Thalamoolivary tract"
            },
            {
              "code": "7651004",
              "display": "Intervenous tubercle of right atrium"
            },
            {
              "code": "7652006",
              "display": "Frenulum labii"
            },
            {
              "code": "7657000",
              "display": "Femoral artery"
            },
            {
              "code": "7658005",
              "display": "Subtendinous bursa of triceps brachii muscle"
            },
            {
              "code": "7697002",
              "display": "Pontine portion of medial longitudinal fasciculus"
            },
            {
              "code": "7712004",
              "display": "Subdural space of spinal region"
            },
            {
              "code": "7726008",
              "display": "Skin of medial surface of fifth toe"
            },
            {
              "code": "7736000",
              "display": "Posterior choroidal artery"
            },
            {
              "code": "7742001",
              "display": "Palatine duct"
            },
            {
              "code": "7748002",
              "display": "Skin appendage"
            },
            {
              "code": "7755000",
              "display": "Mesovarian margin of ovary"
            },
            {
              "code": "7756004",
              "display": "Lamina of third thoracic vertebra"
            },
            {
              "code": "7764005",
              "display": "Striate artery"
            },
            {
              "code": "7769000",
              "display": "Right foot"
            },
            {
              "code": "7783003",
              "display": "Sympathetic trunk spinal nerve branch"
            },
            {
              "code": "7820009",
              "display": "Lateral posterior nucleus of thalamus"
            },
            {
              "code": "7829005",
              "display": "Anterior surface of manubrium"
            },
            {
              "code": "7832008",
              "display": "Abdominal aorta"
            },
            {
              "code": "7835005",
              "display": "Posterior margin of nasal septum"
            },
            {
              "code": "7840002",
              "display": "Subcutaneous tissue of submental area"
            },
            {
              "code": "7841003",
              "display": "Macrocytic normochromic erythrocyte"
            },
            {
              "code": "7844006",
              "display": "Sternoclavicular joint"
            },
            {
              "code": "7851002",
              "display": "Intracranial subdural space"
            },
            {
              "code": "7854005",
              "display": "Mandibular canal"
            },
            {
              "code": "7872004",
              "display": "Myocardium of ventricle"
            },
            {
              "code": "7874003",
              "display": "Scapular region of back"
            },
            {
              "code": "7880006",
              "display": "Rhopheocytotic vesicle"
            },
            {
              "code": "7884002",
              "display": "Corneal corpuscle"
            },
            {
              "code": "7885001",
              "display": "Rotator cuff including muscles and tendons"
            },
            {
              "code": "7892006",
              "display": "Submucosa of anal canal"
            },
            {
              "code": "7896009",
              "display": "Occipital angle of parietal bone"
            },
            {
              "code": "7911004",
              "display": "Olivocerebellar fibers"
            },
            {
              "code": "7925003",
              "display": "Proximal phalanx of third toe"
            },
            {
              "code": "7936005",
              "display": "Ligament of diaphragm"
            },
            {
              "code": "7944005",
              "display": "Helper cell"
            },
            {
              "code": "7954009",
              "display": "Lamina propria of ethmoid sinus"
            },
            {
              "code": "7967007",
              "display": "First left aortic arch"
            },
            {
              "code": "7986004",
              "display": "Abdominopelvic portion of sympathetic nervous system"
            },
            {
              "code": "7991003",
              "display": "Skin of glans penis"
            },
            {
              "code": "7999001",
              "display": "Articulations of auditory ossicles"
            },
            {
              "code": "8001006",
              "display": "Mucous membrane of tongue"
            },
            {
              "code": "8012006",
              "display": "Anterior communicating artery"
            },
            {
              "code": "8017000",
              "display": "Inflow tract of right ventricle"
            },
            {
              "code": "8024004",
              "display": "Limitans nucleus"
            },
            {
              "code": "8039003",
              "display": "Subcutaneous acromial bursa"
            },
            {
              "code": "8040001",
              "display": "Superficial flexor tendon of little finger"
            },
            {
              "code": "8045006",
              "display": "Membrane-coating granule, amorphous"
            },
            {
              "code": "8057002",
              "display": "Lateral nuclei of globus pallidus"
            },
            {
              "code": "8059004",
              "display": "Pancreatic veins"
            },
            {
              "code": "8067007",
              "display": "Superficial circumflex iliac vein"
            },
            {
              "code": "8068002",
              "display": "Stratum lemnisci of corpora quadrigemina"
            },
            {
              "code": "8079007",
              "display": "Radial nerve"
            },
            {
              "code": "8091003",
              "display": "Intervertebral disc space of twelfth thoracic vertebra"
            },
            {
              "code": "8100009",
              "display": "Infundibulum of Fallopian tube"
            },
            {
              "code": "8111001",
              "display": "Intranuclear crystal"
            },
            {
              "code": "8112008",
              "display": "Hindgut"
            },
            {
              "code": "8119004",
              "display": "Delphian lymph node"
            },
            {
              "code": "8128003",
              "display": "Supraaortic valve area"
            },
            {
              "code": "8133004",
              "display": "Superior anastomotic vein"
            },
            {
              "code": "8157004",
              "display": "Vein of head"
            },
            {
              "code": "8158009",
              "display": "Interlobar duct of pancreas"
            },
            {
              "code": "8159001",
              "display": "Superior colliculus of corpora quadrigemina"
            },
            {
              "code": "8160006",
              "display": "Lateral striate arteries"
            },
            {
              "code": "8161005",
              "display": "Infraorbital nerve"
            },
            {
              "code": "8165001",
              "display": "Superior articular process of fifth thoracic vertebra"
            },
            {
              "code": "8205005",
              "display": "Wrist"
            },
            {
              "code": "8225009",
              "display": "Accessory atrioventricular bundle"
            },
            {
              "code": "8242003",
              "display": "Apical branch of right pulmonary artery"
            },
            {
              "code": "8251006",
              "display": "Osseous portion of Eustachian tube"
            },
            {
              "code": "8264007",
              "display": "Tunica interna of eyeball"
            },
            {
              "code": "8265008",
              "display": "Articular surface, metacarpal, of phalanx of hand"
            },
            {
              "code": "8266009",
              "display": "Small intestine serosa"
            },
            {
              "code": "8279000",
              "display": "Pelvic viscus"
            },
            {
              "code": "8289001",
              "display": "Below knee region"
            },
            {
              "code": "8292002",
              "display": "Interlobular arteries of liver"
            },
            {
              "code": "8314003",
              "display": "Mastoid fontanel of skull"
            },
            {
              "code": "8334002",
              "display": "Lumbar lymph node"
            },
            {
              "code": "8356004",
              "display": "Colic lymph node"
            },
            {
              "code": "8361002",
              "display": "Tunica intima"
            },
            {
              "code": "8369000",
              "display": "Sphincter pupillae muscle"
            },
            {
              "code": "8373002",
              "display": "Jugum of sphenoid bone"
            },
            {
              "code": "8387002",
              "display": "Lamina of eighth thoracic vertebra"
            },
            {
              "code": "8389004",
              "display": "Birth canal"
            },
            {
              "code": "8412003",
              "display": "Iliac fossa"
            },
            {
              "code": "8415001",
              "display": "Renal surface of adrenal gland"
            },
            {
              "code": "8454000",
              "display": "Joint of lumbar vertebra"
            },
            {
              "code": "8464009",
              "display": "Ligament of sacroiliac joint and pubic symphysis"
            },
            {
              "code": "8482007",
              "display": "Sinoatrial node branch of right coronary artery"
            },
            {
              "code": "8483002",
              "display": "Mesial surface of tooth"
            },
            {
              "code": "8496001",
              "display": "Obliquus capitis muscle"
            },
            {
              "code": "8523001",
              "display": "Inferior articular process of twelfth thoracic vertebra"
            },
            {
              "code": "8546004",
              "display": "Posterior intercavernous sinus"
            },
            {
              "code": "8556000",
              "display": "Lipid droplet"
            },
            {
              "code": "8559007",
              "display": "Juxtaintestinal lymph node"
            },
            {
              "code": "8560002",
              "display": "Interclavicular ligament"
            },
            {
              "code": "8568009",
              "display": "Abdominal lymph nodes"
            },
            {
              "code": "8580001",
              "display": "Both feet"
            },
            {
              "code": "8595004",
              "display": "Meissner's plexus"
            },
            {
              "code": "8598002",
              "display": "Acoustic nerve"
            },
            {
              "code": "8600008",
              "display": "Cricoid cartilage"
            },
            {
              "code": "8603005",
              "display": "Adductor hallucis muscle"
            },
            {
              "code": "8604004",
              "display": "Medulla oblongata fasciculus cuneatus"
            },
            {
              "code": "8608001",
              "display": "Right margin of heart"
            },
            {
              "code": "8617001",
              "display": "Zygomatic region of face"
            },
            {
              "code": "8623006",
              "display": "Transplanted ureter"
            },
            {
              "code": "8629005",
              "display": "Superior right pulmonary vein"
            },
            {
              "code": "8640002",
              "display": "Choroidal branches of posterior spinal artery"
            },
            {
              "code": "8668003",
              "display": "Glycogen vacuole"
            },
            {
              "code": "8671006",
              "display": "All toes"
            },
            {
              "code": "8677005",
              "display": "Body of right atrium"
            },
            {
              "code": "8688004",
              "display": "Lateral olfactory gyrus"
            },
            {
              "code": "8695008",
              "display": "Intervertebral foramen of second lumbar vertebra"
            },
            {
              "code": "8710005",
              "display": "Minor sublingual ducts"
            },
            {
              "code": "8711009",
              "display": "Periodontal tissues"
            },
            {
              "code": "8714001",
              "display": "Subcutaneous tissue of interdigital space of hand"
            },
            {
              "code": "8752000",
              "display": "Cavernous portion of internal carotid artery"
            },
            {
              "code": "8770002",
              "display": "Nail of second toe"
            },
            {
              "code": "8775007",
              "display": "Tendinous arch"
            },
            {
              "code": "8784007",
              "display": "Intranuclear body, granular with filamentous capsule"
            },
            {
              "code": "8810002",
              "display": "Corticomedullary junction of adrenal gland"
            },
            {
              "code": "8814006",
              "display": "Iliac tuberosity"
            },
            {
              "code": "8815007",
              "display": "Thenar and hypothenar spaces"
            },
            {
              "code": "8820007",
              "display": "Pedicle of eleventh thoracic vertebra"
            },
            {
              "code": "8821006",
              "display": "Peroneal artery"
            },
            {
              "code": "8827005",
              "display": "Shaft of phalanx of middle finger"
            },
            {
              "code": "8839002",
              "display": "Agranular endoplasmic reticulum, connection with other organelle"
            },
            {
              "code": "8845005",
              "display": "Subtendinous prepatellar bursa"
            },
            {
              "code": "8850004",
              "display": "Proper fasciculus"
            },
            {
              "code": "8854008",
              "display": "Crista galli"
            },
            {
              "code": "8862000",
              "display": "Palmar surface of middle finger"
            },
            {
              "code": "8873007",
              "display": "Mandibular right second premolar tooth"
            },
            {
              "code": "8887007",
              "display": "Brachiocephalic vein"
            },
            {
              "code": "8892009",
              "display": "Diaphragmatic surface of lung"
            },
            {
              "code": "8894005",
              "display": "Gastric cardiac gland"
            },
            {
              "code": "8897003",
              "display": "Lateral glossoepiglottic fold"
            },
            {
              "code": "8907008",
              "display": "Left ulnar artery"
            },
            {
              "code": "8910001",
              "display": "Inferior transverse scapular ligament"
            },
            {
              "code": "8911002",
              "display": "Endocardium of right ventricle"
            },
            {
              "code": "8928004",
              "display": "Inguinal lymph node"
            },
            {
              "code": "8931003",
              "display": "Coracoid process of scapula"
            },
            {
              "code": "8935007",
              "display": "Cerebral meninges"
            },
            {
              "code": "8942007",
              "display": "Trapezoid ligament"
            },
            {
              "code": "8965002",
              "display": "Stratum zonale of corpora quadrigemina"
            },
            {
              "code": "8966001",
              "display": "Left eye"
            },
            {
              "code": "8983005",
              "display": "Joint structure of vertebral column"
            },
            {
              "code": "8988001",
              "display": "Marginal part of orbicularis oris muscle"
            },
            {
              "code": "8993003",
              "display": "Hepatic vein"
            },
            {
              "code": "9000002",
              "display": "Cerebellar peduncle"
            },
            {
              "code": "9003000",
              "display": "Left parietal lobe"
            },
            {
              "code": "9018004",
              "display": "Middle colic vein"
            },
            {
              "code": "9040008",
              "display": "Ascending colon"
            },
            {
              "code": "9055004",
              "display": "Both forearms"
            },
            {
              "code": "9073001",
              "display": "White matter of insula"
            },
            {
              "code": "9081000",
              "display": "Splenic sinusoids"
            },
            {
              "code": "9086005",
              "display": "Superior laryngeal vein"
            },
            {
              "code": "9089003",
              "display": "Arch of foot"
            },
            {
              "code": "9108007",
              "display": "Vein of the scala tympani"
            },
            {
              "code": "9127001",
              "display": "Transverse folds of palate"
            },
            {
              "code": "9156001",
              "display": "Embryo stage 1"
            },
            {
              "code": "9181003",
              "display": "Accessory carpal bone"
            },
            {
              "code": "9185007",
              "display": "Capsule of metatarsophalangeal joint of fifth toe"
            },
            {
              "code": "9186008",
              "display": "Filaments of contractile apparatus"
            },
            {
              "code": "9188009",
              "display": "Intervertebral disc of eighth thoracic vertebra"
            },
            {
              "code": "9208002",
              "display": "Centriole"
            },
            {
              "code": "9212008",
              "display": "Shaft of fifth metatarsal bone"
            },
            {
              "code": "9229006",
              "display": "Rotatores lumborum muscles"
            },
            {
              "code": "9231002",
              "display": "External pudendal veins"
            },
            {
              "code": "9240003",
              "display": "Niemann-Pick cell"
            },
            {
              "code": "9242006",
              "display": "Posterior segment of right lobe of liver"
            },
            {
              "code": "9258009",
              "display": "Gravid uterus"
            },
            {
              "code": "9261005",
              "display": "Tendon and tendon sheath of second toe"
            },
            {
              "code": "9262003",
              "display": "Fascia of pelvis"
            },
            {
              "code": "9284003",
              "display": "Corpus cavernosum of penis"
            },
            {
              "code": "9290004",
              "display": "Posterior intraoccipital synchondrosis"
            },
            {
              "code": "9305001",
              "display": "Labial veins"
            },
            {
              "code": "9317004",
              "display": "Merkel's tactile disc"
            },
            {
              "code": "9320007",
              "display": "Subtendinous iliac bursa"
            },
            {
              "code": "9321006",
              "display": "Tail of epididymis"
            },
            {
              "code": "9325002",
              "display": "Interdental papilla of gingiva"
            },
            {
              "code": "9332006",
              "display": "Lateral ligament of temporomandibular joint"
            },
            {
              "code": "9348007",
              "display": "Skin of medial surface of middle finger"
            },
            {
              "code": "9379006",
              "display": "Permanent teeth"
            },
            {
              "code": "9380009",
              "display": "Pecten ani"
            },
            {
              "code": "9384000",
              "display": "Lumbar vein"
            },
            {
              "code": "9390001",
              "display": "Lymphatics of stomach"
            },
            {
              "code": "9432007",
              "display": "Plantar surface of fourth toe"
            },
            {
              "code": "9438006",
              "display": "Structure of deep cervical lymphatic vessel"
            },
            {
              "code": "9454009",
              "display": "Subclavian vein"
            },
            {
              "code": "9455005",
              "display": "Medial cartilaginous lamina of Eustachian tube"
            },
            {
              "code": "9475001",
              "display": "Amacrine cells of retina"
            },
            {
              "code": "9481009",
              "display": "Afferent glomerular arteriole"
            },
            {
              "code": "9490002",
              "display": "Pulmonary ligament"
            },
            {
              "code": "9498009",
              "display": "Head of metacarpal bone"
            },
            {
              "code": "9502002",
              "display": "Coronal depression of tooth"
            },
            {
              "code": "9512009",
              "display": "Calcaneocuboidal ligament"
            },
            {
              "code": "9535007",
              "display": "Pyramid of medulla oblongata"
            },
            {
              "code": "9558005",
              "display": "Facet for fifth costal cartilage of sternum"
            },
            {
              "code": "9566001",
              "display": "Duodenal lumen"
            },
            {
              "code": "9568000",
              "display": "Subcutaneous tissue of areola"
            },
            {
              "code": "9596006",
              "display": "Deep branch of ulnar nerve"
            },
            {
              "code": "9609000",
              "display": "Posterior process of nasal septal cartilage"
            },
            {
              "code": "9625005",
              "display": "Lanugo hair"
            },
            {
              "code": "9642004",
              "display": "Left superior vena cava"
            },
            {
              "code": "9646001",
              "display": "Superior transverse scapular ligament"
            },
            {
              "code": "9654004",
              "display": "Gastric mucous gland"
            },
            {
              "code": "9659009",
              "display": "Infraclavicular lymph nodes"
            },
            {
              "code": "9662007",
              "display": "Subcutaneous tissue of lower margin of nasal septum"
            },
            {
              "code": "9668006",
              "display": "Ciliary muscle"
            },
            {
              "code": "9677004",
              "display": "Head of second metatarsal bone"
            },
            {
              "code": "9683001",
              "display": "Melanocyte"
            },
            {
              "code": "9684007",
              "display": "Posterior scrotal branches of internal pudendal artery"
            },
            {
              "code": "9708001",
              "display": "Iliac fascia"
            },
            {
              "code": "9732008",
              "display": "Medial supraclavicular nerves"
            },
            {
              "code": "9736006",
              "display": "Right wrist"
            },
            {
              "code": "9743000",
              "display": "Tendon of index finger"
            },
            {
              "code": "9758008",
              "display": "Submucosa of tonsil"
            },
            {
              "code": "9770007",
              "display": "Genital tubercle"
            },
            {
              "code": "9775002",
              "display": "Left carotid sinus"
            },
            {
              "code": "9779008",
              "display": "Distinctive shape of mitochondrial cristae"
            },
            {
              "code": "9783008",
              "display": "Superficial lymphatics of thorax"
            },
            {
              "code": "9791004",
              "display": "Deep venous system of lower extremity"
            },
            {
              "code": "9796009",
              "display": "Skeletal muscle fiber, type IIb"
            },
            {
              "code": "9813009",
              "display": "Fascia of upper extremity"
            },
            {
              "code": "9825007",
              "display": "Proximal phalanx of little toe"
            },
            {
              "code": "9837009",
              "display": "Perforating branches of internal thoracic artery"
            },
            {
              "code": "9840009",
              "display": "Biparietal diameter of head"
            },
            {
              "code": "9841008",
              "display": "Interspinalis thoracis muscles"
            },
            {
              "code": "9846003",
              "display": "Right kidney"
            },
            {
              "code": "9847007",
              "display": "Hilum of adrenal gland"
            },
            {
              "code": "9849005",
              "display": "Fornix of lacrimal sac"
            },
            {
              "code": "9870004",
              "display": "Carunculae hymenales"
            },
            {
              "code": "9875009",
              "display": "Thymus"
            },
            {
              "code": "9878006",
              "display": "Appendicular vein"
            },
            {
              "code": "9880000",
              "display": "Thyroid tubercle"
            },
            {
              "code": "9881001",
              "display": "Peripheral nerve myelinated nerve fiber"
            },
            {
              "code": "9891007",
              "display": "Transverse arytenoid muscle"
            },
            {
              "code": "9898001",
              "display": "Paracentral lobule"
            },
            {
              "code": "9951005",
              "display": "Posterior ethmoidal nerve"
            },
            {
              "code": "9968009",
              "display": "Primary foot process"
            },
            {
              "code": "9970000",
              "display": "Ileocecal ostium"
            },
            {
              "code": "9976006",
              "display": "Rhomboideus cervicis muscle"
            },
            {
              "code": "9994000",
              "display": "Superior articular process of sixth thoracic vertebra"
            },
            {
              "code": "9999005",
              "display": "Duodenal ampulla"
            },
            {
              "code": "10013000",
              "display": "Lateral meniscus of knee joint"
            },
            {
              "code": "10024003",
              "display": "Base of lung"
            },
            {
              "code": "10025002",
              "display": "Base of phalanx of index finger"
            },
            {
              "code": "10026001",
              "display": "Ventral spinocerebellar tract of pons"
            },
            {
              "code": "10036009",
              "display": "Nucleus pulposus of intervertebral disc of eighth thoracic vertebra"
            },
            {
              "code": "10042008",
              "display": "Intervertebral foramen of fifth thoracic vertebra"
            },
            {
              "code": "10047002",
              "display": "Transplanted lung"
            },
            {
              "code": "10052007",
              "display": "Male"
            },
            {
              "code": "10056005",
              "display": "Ophthalmic nerve"
            },
            {
              "code": "10062000",
              "display": "Levator labii superioris muscle"
            },
            {
              "code": "10119003",
              "display": "Deep volar arch of radial artery"
            },
            {
              "code": "10124000",
              "display": "Deep dorsal sacrococcygeal ligament"
            }
          ]
        }]
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
            "system": "medication-admin-status",
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

  # Description  http://hl7.org/fhir/R4/valueset-condition-code.html
  # Used in: MedicationRequest.reasonCode
  @CONDITION_CODES_VS = {
    "resourceType" : "ValueSet",
    "id" : "condition-code",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Condition/Problem/Diagnosis Codes</h2><div><p>Example value set for Condition/Problem/Diagnosis codes.</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  404684003 (Clinical finding)</li><li>Include these codes as defined in <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td></tr><tr><td><a href=\"http://browser.ihtsdotools.org/?perspective=full&amp;conceptId1=160245001\">160245001</a></td><td>No current problems or disability</td><td/></tr></table></li></ul></div>"
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
    "url" : "http://hl7.org/fhir/ValueSet/condition-code",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.161"
    }],
    "version" : "4.0.1",
    "name" : "Condition/Problem/DiagnosisCodes",
    "title" : "Condition/Problem/Diagnosis Codes",
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
    "description" : "Example value set for Condition/Problem/Diagnosis codes.",
    "copyright" : "This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
    "compose" : {
      "include" : [{
        "system" : "http://snomed.info/sct",
        "concept" : [
          {
            "code": "109006",
            "display": "Anxiety disorder of childhood OR adolescence"
          },
          {
            "code": "122003",
            "display": "Choroidal hemorrhage"
          },
          {
            "code": "127009",
            "display": "Spontaneous abortion with laceration of cervix"
          },
          {
            "code": "129007",
            "display": "Homoiothermia"
          },
          {
            "code": "134006",
            "display": "Decreased hair growth"
          },
          {
            "code": "140004",
            "display": "Chronic pharyngitis"
          },
          {
            "code": "144008",
            "display": "Normal peripheral vision"
          },
          {
            "code": "147001",
            "display": "Superficial foreign body of scrotum without major open wound but with infection"
          },
          {
            "code": "150003",
            "display": "Abnormal bladder continence"
          },
          {
            "code": "151004",
            "display": "Meningitis due to gonococcus"
          },
          {
            "code": "162004",
            "display": "Severe manic bipolar I disorder without psychotic features"
          },
          {
            "code": "165002",
            "display": "Accident-prone"
          },
          {
            "code": "168000",
            "display": "Typhlolithiasis"
          },
          {
            "code": "171008",
            "display": "Injury of ascending right colon without open wound into abdominal cavity"
          },
          {
            "code": "172001",
            "display": "Endometritis following molar AND/OR ectopic pregnancy"
          },
          {
            "code": "175004",
            "display": "Supraorbital neuralgia"
          },
          {
            "code": "177007",
            "display": "Poisoning by sawfly larvae"
          },
          {
            "code": "179005",
            "display": "Apraxia of dressing"
          },
          {
            "code": "181007",
            "display": "Hemorrhagic bronchopneumonia"
          },
          {
            "code": "183005",
            "display": "Autoimmune pancytopenia"
          },
          {
            "code": "184004",
            "display": "Withdrawal arrhythmia"
          },
          {
            "code": "188001",
            "display": "Intercostal artery injury"
          },
          {
            "code": "192008",
            "display": "Congenital syphilitic hepatomegaly"
          },
          {
            "code": "193003",
            "display": "Benign hypertensive renal disease"
          },
          {
            "code": "195005",
            "display": "Illegal abortion with endometritis"
          },
          {
            "code": "198007",
            "display": "Disease due to Filoviridae"
          },
          {
            "code": "199004",
            "display": "Decreased lactation"
          },
          {
            "code": "208008",
            "display": "Neurocutaneous melanosis sequence"
          },
          {
            "code": "216004",
            "display": "Delusion of persecution"
          },
          {
            "code": "219006",
            "display": "Alcohol user"
          },
          {
            "code": "222008",
            "display": "Acute epiglottitis with obstruction"
          },
          {
            "code": "223003",
            "display": "Tumor of body of uterus affecting pregnancy"
          },
          {
            "code": "228007",
            "display": "Lucio phenomenon"
          },
          {
            "code": "241006",
            "display": "Motor simple partial status"
          },
          {
            "code": "242004",
            "display": "Noninfectious jejunitis"
          },
          {
            "code": "253005",
            "display": "Sycosis"
          },
          {
            "code": "257006",
            "display": "Acne rosacea, erythematous telangiectatic type"
          },
          {
            "code": "258001",
            "display": "Pseudoknuckle pad"
          },
          {
            "code": "264008",
            "display": "Blind hypertensive eye"
          },
          {
            "code": "276008",
            "display": "Oxytocin poisoning"
          },
          {
            "code": "279001",
            "display": "Senile myocarditis"
          },
          {
            "code": "281004",
            "display": "Alcoholic dementia"
          },
          {
            "code": "282006",
            "display": "Acute myocardial infarction of basal-lateral wall"
          },
          {
            "code": "290006",
            "display": "Melnick-Fraser syndrome"
          },
          {
            "code": "292003",
            "display": "EEG finding"
          },
          {
            "code": "297009",
            "display": "Acute myringitis"
          },
          {
            "code": "299007",
            "display": "Paraffinoma of skin"
          },
          {
            "code": "303002",
            "display": "Apoplectic pancreatitis"
          },
          {
            "code": "308006",
            "display": "Pearly penile papules"
          },
          {
            "code": "310008",
            "display": "Penile boil"
          },
          {
            "code": "313005",
            "display": "Déjà vu"
          },
          {
            "code": "317006",
            "display": "Reactive hypoglycemia"
          },
          {
            "code": "320003",
            "display": "Cervical dilatation, 1cm"
          },
          {
            "code": "324007",
            "display": "Plaster ulcer"
          },
          {
            "code": "330007",
            "display": "Occipital headache"
          },
          {
            "code": "335002",
            "display": "Pylorospasm"
          },
          {
            "code": "341009",
            "display": "ABO incompatibility reaction"
          },
          {
            "code": "349006",
            "display": "Absent tendon reflex"
          },
          {
            "code": "355001",
            "display": "Hemorrhagic shock"
          },
          {
            "code": "357009",
            "display": "Closed fracture trapezoid"
          },
          {
            "code": "358004",
            "display": "Smallpox vaccine poisoning"
          },
          {
            "code": "359007",
            "display": "Kernicterus due to isoimmunization"
          },
          {
            "code": "360002",
            "display": "Acute radiation disease"
          },
          {
            "code": "364006",
            "display": "Acute left-sided heart failure"
          },
          {
            "code": "366008",
            "display": "Hidromeiosis"
          },
          {
            "code": "368009",
            "display": "Heart valve disorder"
          },
          {
            "code": "369001",
            "display": "Normal jugular venous pressure"
          },
          {
            "code": "378007",
            "display": "Morquio syndrome"
          },
          {
            "code": "382009",
            "display": "Legal history finding relating to child"
          },
          {
            "code": "383004",
            "display": "Finding of passive range of hip extension"
          },
          {
            "code": "385006",
            "display": "Secondary peripheral neuropathy"
          },
          {
            "code": "387003",
            "display": "Melanuria"
          },
          {
            "code": "398002",
            "display": "Left axis deviation greater than -90 degrees by EKG"
          },
          {
            "code": "407000",
            "display": "Congenital hepatomegaly"
          },
          {
            "code": "408005",
            "display": "Tooth chattering"
          },
          {
            "code": "409002",
            "display": "Food allergy diet"
          },
          {
            "code": "426008",
            "display": "Superficial injury of ankle without infection"
          },
          {
            "code": "431005",
            "display": "Hypertrophy of scrotum"
          },
          {
            "code": "437009",
            "display": "Abnormal composition of urine"
          },
          {
            "code": "440009",
            "display": "Persistent hyperphenylalaninemia"
          },
          {
            "code": "442001",
            "display": "Secondary hypopituitarism"
          },
          {
            "code": "443006",
            "display": "Cystocele affecting pregnancy"
          },
          {
            "code": "447007",
            "display": "Coach in sports activity accident"
          },
          {
            "code": "450005",
            "display": "Ulcerative stomatitis"
          },
          {
            "code": "452002",
            "display": "Blister of groin without infection"
          },
          {
            "code": "460001",
            "display": "Squamous metaplasia of prostate gland"
          },
          {
            "code": "467003",
            "display": "Old laceration of pelvic floor muscle"
          },
          {
            "code": "470004",
            "display": "Vitreous touch syndrome"
          },
          {
            "code": "479003",
            "display": "Graves' disease with pretibial myxedema AND with thyrotoxic crisis"
          },
          {
            "code": "486006",
            "display": "Acute vascular insufficiency"
          },
          {
            "code": "488007",
            "display": "Fibroid myocarditis"
          },
          {
            "code": "490008",
            "display": "Upper respiratory tract hypersensitivity reaction"
          },
          {
            "code": "496002",
            "display": "Closed traumatic dislocation of third cervical vertebra"
          },
          {
            "code": "504009",
            "display": "Androgen-dependent hirsutism"
          },
          {
            "code": "517007",
            "display": "Foreign body in hypopharynx"
          },
          {
            "code": "518002",
            "display": "Multiple aggregation"
          },
          {
            "code": "520004",
            "display": "Congenital bent nose"
          },
          {
            "code": "527001",
            "display": "Spontaneous fetal evolution, Roederer's method"
          },
          {
            "code": "536002",
            "display": "Glissonian cirrhosis"
          },
          {
            "code": "539009",
            "display": "Conjunctival argyrosis"
          },
          {
            "code": "547009",
            "display": "Hypersecretion of calcitonin"
          },
          {
            "code": "548004",
            "display": "13p partial trisomy syndrome"
          },
          {
            "code": "554003",
            "display": "2p partial trisomy syndrome"
          },
          {
            "code": "555002",
            "display": "Dicentra species poisoning"
          },
          {
            "code": "563001",
            "display": "Nystagmus"
          },
          {
            "code": "568005",
            "display": "Habit disorder"
          },
          {
            "code": "586008",
            "display": "Contact dermatitis due to primrose"
          },
          {
            "code": "590005",
            "display": "Congenital aneurysm of anterior communicating artery"
          },
          {
            "code": "596004",
            "display": "Premenstrual dysphoric disorder"
          },
          {
            "code": "599006",
            "display": "Persistent pneumothorax"
          },
          {
            "code": "600009",
            "display": "Pyromania"
          },
          {
            "code": "602001",
            "display": "Ross river fever"
          },
          {
            "code": "607007",
            "display": "Decreased vital capacity"
          },
          {
            "code": "610000",
            "display": "Spastic aphonia"
          },
          {
            "code": "613003",
            "display": "FRAXA - Fragile X syndrome"
          },
          {
            "code": "615005",
            "display": "Obstruction due to foreign body accidentally left in operative wound AND/OR body cavity during a procedure"
          },
          {
            "code": "616006",
            "display": "Sensorimotor disorder of eyelid"
          },
          {
            "code": "626004",
            "display": "Hypercortisolism due to nonpituitary tumor"
          },
          {
            "code": "631002",
            "display": "Transfusion reaction due to minor incompatibility"
          },
          {
            "code": "634005",
            "display": "Saddle boil"
          },
          {
            "code": "640003",
            "display": "Injury of pneumogastric nerve"
          },
          {
            "code": "643001",
            "display": "Hypertrophy of lip"
          },
          {
            "code": "646009",
            "display": "Idiopathic cyst of anterior chamber"
          },
          {
            "code": "649002",
            "display": "Open fracture of distal end of ulna"
          },
          {
            "code": "651003",
            "display": "Root work"
          },
          {
            "code": "652005",
            "display": "Gangrenous tonsillitis"
          },
          {
            "code": "655007",
            "display": "Abnormal fetal heart beat noted before labor in liveborn infant"
          },
          {
            "code": "658009",
            "display": "Injury of colon without open wound into abdominal cavity"
          },
          {
            "code": "663008",
            "display": "Pulmonary embolism following molar AND/OR ectopic pregnancy"
          },
          {
            "code": "664002",
            "display": "Delayed ovulation"
          },
          {
            "code": "666000",
            "display": "Poisoning by antivaricose drug AND/OR sclerosing agent"
          },
          {
            "code": "675003",
            "display": "Torsion of intestine"
          },
          {
            "code": "682004",
            "display": "Thrombosis complicating pregnancy AND/OR puerperium"
          },
          {
            "code": "685002",
            "display": "Acquired telangiectasia of small AND/OR large intestines"
          },
          {
            "code": "701003",
            "display": "Adult osteochondritis of spine"
          },
          {
            "code": "703000",
            "display": "Congenital adhesion of tongue"
          },
          {
            "code": "714002",
            "display": "Abrasion AND/OR friction burn of toe with infection"
          },
          {
            "code": "715001",
            "display": "Nontraumatic rupture of urethra"
          },
          {
            "code": "718004",
            "display": "Acute bronchiolitis with obstruction"
          },
          {
            "code": "733007",
            "display": "Superficial foreign body of groin without major open wound but with infection"
          },
          {
            "code": "734001",
            "display": "Opocephalus"
          },
          {
            "code": "736004",
            "display": "Abscess of hip"
          },
          {
            "code": "750009",
            "display": "Schistosoma mansoni infection"
          },
          {
            "code": "755004",
            "display": "Postgastrectomy phytobezoar"
          },
          {
            "code": "756003",
            "display": "Chronic rheumatic myopericarditis"
          },
          {
            "code": "758002",
            "display": "Cyst of uterus"
          },
          {
            "code": "775008",
            "display": "Open wound of head with complication"
          },
          {
            "code": "776009",
            "display": "Partial arterial retinal occlusion"
          },
          {
            "code": "781000",
            "display": "Cestrum diurnum poisoning"
          },
          {
            "code": "786005",
            "display": "Clinical stage I B"
          },
          {
            "code": "787001",
            "display": "Rheumatic mitral stenosis with regurgitation"
          },
          {
            "code": "788006",
            "display": "Disease-related diet"
          },
          {
            "code": "792004",
            "display": "CJD - Creutzfeldt-Jakob disease"
          },
          {
            "code": "799008",
            "display": "Sigmoid colon ulcer"
          },
          {
            "code": "801006",
            "display": "Insect bite, nonvenomous, of foot, infected"
          },
          {
            "code": "805002",
            "display": "Pneumoconiosis due to silica"
          },
          {
            "code": "811004",
            "display": "Flail motion"
          },
          {
            "code": "813001",
            "display": "Ankle instability"
          },
          {
            "code": "815008",
            "display": "Episcleritis"
          },
          {
            "code": "816009",
            "display": "Genetic recombination"
          },
          {
            "code": "818005",
            "display": "Third degree burn of multiple sites of lower limb"
          },
          {
            "code": "825003",
            "display": "Superficial injury of axilla with infection"
          },
          {
            "code": "827006",
            "display": "Late congenital syphilis, latent (+ sero., - C.S.F., 2 years OR more)"
          },
          {
            "code": "832007",
            "display": "Moderate major depression"
          },
          {
            "code": "834008",
            "display": "Chair-seated facing coital position"
          },
          {
            "code": "841002",
            "display": "Congenital absence of skull bone"
          },
          {
            "code": "842009",
            "display": "Consanguinity"
          },
          {
            "code": "843004",
            "display": "Poliomyelomalacia"
          },
          {
            "code": "844005",
            "display": "Finding relating to behavior"
          },
          {
            "code": "845006",
            "display": "Inferior mesenteric artery injury"
          },
          {
            "code": "849000",
            "display": "Total cataract"
          },
          {
            "code": "857002",
            "display": "Erythema simplex"
          },
          {
            "code": "862001",
            "display": "Anemia due to chlorate"
          },
          {
            "code": "865004",
            "display": "Hyperalimentation formula for ileus"
          },
          {
            "code": "871005",
            "display": "Contracted pelvis"
          },
          {
            "code": "874002",
            "display": "Therapeutic diuresis"
          },
          {
            "code": "875001",
            "display": "Chalcosis of eye"
          },
          {
            "code": "888003",
            "display": "Foetal or neonatal effect of maternal blood loss"
          },
          {
            "code": "890002",
            "display": "Deep third degree burn of elbow"
          },
          {
            "code": "899001",
            "display": "Axis I diagnosis"
          },
          {
            "code": "903008",
            "display": "Chorioretinal infarction"
          },
          {
            "code": "904002",
            "display": "Pinard's sign"
          },
          {
            "code": "908004",
            "display": "Superficial injury of interscapular region without infection"
          },
          {
            "code": "919001",
            "display": "Pseudohomosexual state"
          },
          {
            "code": "928000",
            "display": "Musculoskeletal disorder"
          },
          {
            "code": "931004",
            "display": "Gestation period, 9 weeks"
          },
          {
            "code": "932006",
            "display": "Flat affect"
          },
          {
            "code": "934007",
            "display": "Thalassemia intermedia"
          },
          {
            "code": "943003",
            "display": "Congenital retinal aneurysm"
          },
          {
            "code": "954008",
            "display": "Renon-Delille syndrome"
          },
          {
            "code": "961007",
            "display": "Erythema nodosum, acute form"
          },
          {
            "code": "962000",
            "display": "Disability evaluation, disability 6%"
          },
          {
            "code": "964004",
            "display": "Open wound of pharynx without complication"
          },
          {
            "code": "965003",
            "display": "Toxic amblyopia"
          },
          {
            "code": "975000",
            "display": "Anorectal agenesis"
          },
          {
            "code": "978003",
            "display": "Chronic infantile eczema"
          },
          {
            "code": "981008",
            "display": "Hemorrhagic proctitis"
          },
          {
            "code": "984000",
            "display": "Perirectal cellulitis"
          },
          {
            "code": "987007",
            "display": "Cellulitis of temple region"
          },
          {
            "code": "991002",
            "display": "Wide QRS complex"
          },
          {
            "code": "998008",
            "display": "Chagas' disease with heart involvement"
          },
          {
            "code": "1003002",
            "display": "Religious discrimination"
          },
          {
            "code": "1020003",
            "display": "Disease due to Nairovirus"
          },
          {
            "code": "1023001",
            "display": "Apneic"
          },
          {
            "code": "1027000",
            "display": "Biliary esophagitis"
          },
          {
            "code": "1031006",
            "display": "Open wound of trachea without complication"
          },
          {
            "code": "1033009",
            "display": "Thoracic arthritis"
          },
          {
            "code": "1034003",
            "display": "Mesenteric-portal fistula"
          },
          {
            "code": "1038000",
            "display": "Disacchariduria"
          },
          {
            "code": "1045000",
            "display": "Colonospasm"
          },
          {
            "code": "1046004",
            "display": "Ureteritis glandularis"
          },
          {
            "code": "1051005",
            "display": "Hyperplasia of islet alpha cells with gastrin excess"
          },
          {
            "code": "1055001",
            "display": "Stenosis of precerebral artery"
          },
          {
            "code": "1059007",
            "display": "Opisthorchiasis"
          },
          {
            "code": "1070000",
            "display": "Facial myokymia"
          },
          {
            "code": "1073003",
            "display": "Xeroderma pigmentosum group B"
          },
          {
            "code": "1074009",
            "display": "Glucocorticoid-responsive primary hyperaldosteronism"
          },
          {
            "code": "1077002",
            "display": "Septal infarction by EKG"
          },
          {
            "code": "1079004",
            "display": "Macular retinal cyst"
          },
          {
            "code": "1085006",
            "display": "Vulval candidiasis"
          },
          {
            "code": "1089000",
            "display": "Congenital sepsis"
          },
          {
            "code": "1102005",
            "display": "Intraerythrocytic parasitosis by Nuttallia"
          },
          {
            "code": "1107004",
            "display": "Early latent syphilis, positive serology, negative cerebrospinal fluid, with relapse after treatment"
          },
          {
            "code": "1108009",
            "display": "Female pattern alopecia"
          },
          {
            "code": "1111005",
            "display": "Normal sebaceous gland activity"
          },
          {
            "code": "1112003",
            "display": "Degenerative disorder of eyelid"
          },
          {
            "code": "1116000",
            "display": "Chronic aggressive type B viral hepatitis"
          },
          {
            "code": "1124005",
            "display": "Postpartum period, 6 days"
          },
          {
            "code": "1125006",
            "display": "Septicemia during labor"
          },
          {
            "code": "1126007",
            "display": "Knee locking"
          },
          {
            "code": "1131009",
            "display": "Congenital valvular insufficiency"
          },
          {
            "code": "1134001",
            "display": "Muehrcke lines"
          },
          {
            "code": "1135000",
            "display": "Solar retinitis"
          },
          {
            "code": "1139006",
            "display": "Confrontation (visual) test"
          },
          {
            "code": "1140008",
            "display": "Thermal hypesthesia"
          },
          {
            "code": "1141007",
            "display": "Circumoral paresthesia"
          },
          {
            "code": "1145003",
            "display": "DSD - Developmental speech disorder"
          },
          {
            "code": "1150009",
            "display": "Congenital microcheilia"
          },
          {
            "code": "1151008",
            "display": "Constricted visual field"
          },
          {
            "code": "1152001",
            "display": "Skin reaction negative"
          },
          {
            "code": "1155004",
            "display": "Myocardial hypertrophy, determined by electrocardiogram"
          },
          {
            "code": "1156003",
            "display": "Cavitary prostatitis"
          },
          {
            "code": "1168007",
            "display": "Allotype"
          },
          {
            "code": "1184008",
            "display": "Glasgow coma scale, 10"
          },
          {
            "code": "1192004",
            "display": "Familial amyloid neuropathy, Finnish type"
          },
          {
            "code": "1194003",
            "display": "Disease condition determination, well controlled"
          },
          {
            "code": "1196001",
            "display": "Chronic bipolar II disorder, most recent episode major depressive"
          },
          {
            "code": "1197005",
            "display": "Carbuncle of heel"
          },
          {
            "code": "1201005",
            "display": "Benign essential hypertension"
          },
          {
            "code": "1203008",
            "display": "Deep third degree burn of forehead AND/OR cheek with loss of body part"
          },
          {
            "code": "1207009",
            "display": "Optic disc glaucomatous atrophy"
          },
          {
            "code": "1208004",
            "display": "Gastroptosis"
          },
          {
            "code": "1212005",
            "display": "Juvenile dermatomyositis"
          },
          {
            "code": "1214006",
            "display": "Infection by Strongyloides"
          },
          {
            "code": "1230003",
            "display": "No diagnosis on Axis 1"
          },
          {
            "code": "1232006",
            "display": "Congenital articular rigidity with myopathy"
          },
          {
            "code": "1239002",
            "display": "Congenital anteversion of femoral neck"
          },
          {
            "code": "1240000",
            "display": "Lying prone"
          },
          {
            "code": "1259003",
            "display": "Schistosis"
          },
          {
            "code": "1261007",
            "display": "Multiple fractures of ribs"
          },
          {
            "code": "1264004",
            "display": "Injury of descending left colon without open wound into abdominal cavity"
          },
          {
            "code": "1271009",
            "display": "Knuckle pads, leuconychia and deafness"
          },
          {
            "code": "1280009",
            "display": "Isologous chimera"
          },
          {
            "code": "1282001",
            "display": "Laryngeal perichondritis"
          },
          {
            "code": "1283006",
            "display": "Visual acuity less than .02 (1/60, count fingers 1 meter) or visual field less than 5 degrees, but better than 5."
          },
          {
            "code": "1284000",
            "display": "Abnormal jaw closure"
          },
          {
            "code": "1286003",
            "display": "Vitamin K deficiency coagulation disorder"
          },
          {
            "code": "1287007",
            "display": "Congenital absence of bile duct"
          },
          {
            "code": "1297003",
            "display": "Infection by Cladosporium carrionii"
          },
          {
            "code": "1308001",
            "display": "Complication of reimplant"
          },
          {
            "code": "1310004",
            "display": "Impaired glucose tolerance associated with genetic syndrome"
          },
          {
            "code": "1317001",
            "display": "Injury of ovary without open wound into abdominal cavity"
          },
          {
            "code": "1318006",
            "display": "Post-translational genetic protein processing"
          },
          {
            "code": "1323006",
            "display": "Kanamycin poisoning"
          },
          {
            "code": "1332008",
            "display": "Conjugated visual deviation"
          },
          {
            "code": "1335005",
            "display": "Peyronies disease"
          },
          {
            "code": "1343000",
            "display": "DTA - Deep transverse arrest"
          },
          {
            "code": "1345007",
            "display": "Hang nail"
          },
          {
            "code": "1351002",
            "display": "Iliac artery injury"
          },
          {
            "code": "1356007",
            "display": "Calculus of common duct with obstruction"
          },
          {
            "code": "1361009",
            "display": "Leucocoria"
          },
          {
            "code": "1363007",
            "display": "Fetal or neonatal effect of chronic maternal respiratory disease"
          },
          {
            "code": "1367008",
            "display": "Injury of superior mesenteric artery"
          },
          {
            "code": "1370007",
            "display": "Open fracture of metacarpal bone(s)"
          },
          {
            "code": "1372004",
            "display": "Unicornate uterus"
          },
          {
            "code": "1376001",
            "display": "Obsessive compulsive personality disorder"
          },
          {
            "code": "1378000",
            "display": "Supination-eversion injury of ankle"
          },
          {
            "code": "1380006",
            "display": "Agoraphobia without history of panic disorder with limited symptom attacks"
          },
          {
            "code": "1383008",
            "display": "Hallucinogen induced mood disorder"
          },
          {
            "code": "1384002",
            "display": "Diffuse cholesteatosis of middle ear"
          },
          {
            "code": "1386000",
            "display": "Intracranial hemorrhage"
          },
          {
            "code": "1387009",
            "display": "Solanum nigrum poisoning"
          },
          {
            "code": "1388004",
            "display": "Metabolic alkalosis"
          },
          {
            "code": "1393001",
            "display": "Lenz-Majewski dysplasia"
          },
          {
            "code": "1395008",
            "display": "Complication of ultrasound therapy"
          },
          {
            "code": "1402001",
            "display": "Frightened"
          },
          {
            "code": "1412008",
            "display": "Anterior subcapsular polar cataract"
          },
          {
            "code": "1415005",
            "display": "Inflammation of lymphatics"
          },
          {
            "code": "1418007",
            "display": "Hypoplastic chondrodystrophy"
          },
          {
            "code": "1419004",
            "display": "Injury of prostate without open wound into abdominal cavity"
          },
          {
            "code": "1426004",
            "display": "Necrotizing glomerulonephritis"
          },
          {
            "code": "1427008",
            "display": "Intraspinal abscess"
          },
          {
            "code": "1430001",
            "display": "Intracranial hemorrhage following injury without open intracranial wound AND with prolonged loss of consciousness (more than 24 hours) without return to pre-existing level"
          },
          {
            "code": "1447000",
            "display": "Icthyoparasitism"
          },
          {
            "code": "1469007",
            "display": "Miscarriage with urinary tract infection"
          },
          {
            "code": "1474004",
            "display": "Hypertensive heart AND renal disease complicating AND/OR reason for care during childbirth"
          },
          {
            "code": "1475003",
            "display": "Herpes labialis"
          },
          {
            "code": "1478001",
            "display": "Obliteration of lymphatic vessel"
          },
          {
            "code": "1479009",
            "display": "20q partial trisomy syndrome"
          },
          {
            "code": "1482004",
            "display": "Chalazion"
          },
          {
            "code": "1486001",
            "display": "Orbital congestion"
          },
          {
            "code": "1488000",
            "display": "PONV - Postoperative nausea and vomiting"
          },
          {
            "code": "1489008",
            "display": "External hordeolum"
          },
          {
            "code": "1492007",
            "display": "Congenital anomaly of large intestine"
          },
          {
            "code": "1493002",
            "display": "Acute endophthalmitis"
          },
          {
            "code": "1499003",
            "display": "Bipolar I disorder, single manic episode with postpartum onset"
          },
          {
            "code": "1512006",
            "display": "Congenital stricture of bile duct"
          },
          {
            "code": "1515008",
            "display": "Gorham disease"
          },
          {
            "code": "1518005",
            "display": "Splenitis"
          },
          {
            "code": "1519002",
            "display": "Congenital phlebectasia"
          },
          {
            "code": "1521007",
            "display": "Blister of buttock without infection"
          },
          {
            "code": "1523005",
            "display": "Clinical stage IV B"
          },
          {
            "code": "1525003",
            "display": "Blister of foot without infection"
          },
          {
            "code": "1531000",
            "display": "Nitrofuran derivative poisoning"
          },
          {
            "code": "1532007",
            "display": "Viral pharyngitis"
          },
          {
            "code": "1534008",
            "display": "Palsy of conjugate gaze"
          },
          {
            "code": "1538006",
            "display": "Central nervous system malformation in foetus affecting obstetrical care"
          },
          {
            "code": "1539003",
            "display": "Nodular tendinous disease of finger"
          },
          {
            "code": "1542009",
            "display": "Omphalocele with obstruction"
          },
          {
            "code": "1544005",
            "display": "Open dislocation of knee"
          },
          {
            "code": "1551001",
            "display": "Osteomyelitis of femur"
          },
          {
            "code": "1556006",
            "display": "Clark melanoma level 4"
          },
          {
            "code": "1563006",
            "display": "Protein S deficiency"
          },
          {
            "code": "1567007",
            "display": "Chronic gastric ulcer without hemorrhage, without perforation AND without obstruction"
          },
          {
            "code": "1588003",
            "display": "Heterosexual precocious puberty"
          },
          {
            "code": "1592005",
            "display": "Failed attempted termination of pregnancy with uremia"
          },
          {
            "code": "1593000",
            "display": "Infantile hemiplegia"
          },
          {
            "code": "1606009",
            "display": "Infection caused by Macracanthorhynchus hirudinaceus"
          },
          {
            "code": "1608005",
            "display": "Increased capillary permeability"
          },
          {
            "code": "1639007",
            "display": "Abnormality of organs AND/OR soft tissues of pelvis affecting pregnancy"
          },
          {
            "code": "1647007",
            "display": "Primaquine poisoning"
          },
          {
            "code": "1648002",
            "display": "Lymphocytic pseudotumor of lung"
          },
          {
            "code": "1654001",
            "display": "Steroid-induced glaucoma"
          },
          {
            "code": "1657008",
            "display": "Toxic effect of phosdrin"
          },
          {
            "code": "1658003",
            "display": "Closed fracture clavicle, lateral end"
          },
          {
            "code": "1663004",
            "display": "Tumor grade G2"
          },
          {
            "code": "1667003",
            "display": "Early fontanel closure"
          },
          {
            "code": "1670004",
            "display": "Cerebral hemiparesis"
          },
          {
            "code": "1671000",
            "display": "Sago spleen"
          },
          {
            "code": "1674008",
            "display": "Meesman's epithelial corneal dystrophy"
          },
          {
            "code": "1679003",
            "display": "Arthritis associated with another disorder"
          },
          {
            "code": "1682008",
            "display": "Transitory amino acid metabolic disorder"
          },
          {
            "code": "1685005",
            "display": "Rat-bite fever"
          },
          {
            "code": "1686006",
            "display": "Sedative, hypnotic AND/OR anxiolytic-induced anxiety disorder"
          },
          {
            "code": "1694004",
            "display": "Accessory lobe of lung"
          },
          {
            "code": "1698001",
            "display": "Ulcer of bile duct"
          },
          {
            "code": "1703007",
            "display": "Increased leg circumference"
          },
          {
            "code": "1705000",
            "display": "Closed fracture of base of neck of femur"
          },
          {
            "code": "1708003",
            "display": "Open dislocation of clavicle"
          },
          {
            "code": "1714005",
            "display": "Photokeratitis"
          },
          {
            "code": "1717003",
            "display": "Guttate hypomelanosis"
          },
          {
            "code": "1723008",
            "display": "Urethral stricture due to schistosomiasis"
          },
          {
            "code": "1724002",
            "display": "Infection caused by Crenosoma"
          },
          {
            "code": "1734006",
            "display": "Fracture of vertebral column with spinal cord injury"
          },
          {
            "code": "1735007",
            "display": "Thrill"
          },
          {
            "code": "1739001",
            "display": "Occipital fracture"
          },
          {
            "code": "1742007",
            "display": "Female hypererotism"
          },
          {
            "code": "1744008",
            "display": "Connation of teeth"
          },
          {
            "code": "1748006",
            "display": "Thrombophlebitis of deep femoral vein"
          },
          {
            "code": "1755008",
            "display": "Healed coronary"
          },
          {
            "code": "1761006",
            "display": "Biliary cirrhosis"
          },
          {
            "code": "1763009",
            "display": "Stromal keratitis"
          },
          {
            "code": "1767005",
            "display": "Fisher syndrome"
          },
          {
            "code": "1769008",
            "display": "Thoracodidymus"
          },
          {
            "code": "1771008",
            "display": "Insulin biosynthesis defect"
          },
          {
            "code": "1776003",
            "display": "RTA - Renal tubular acidosis"
          },
          {
            "code": "1777007",
            "display": "Increased molecular dissociation"
          },
          {
            "code": "1778002",
            "display": "Malocclusion due to abnormal swallowing"
          },
          {
            "code": "1779005",
            "display": "OFD II - Orofacial-digital syndrome II"
          },
          {
            "code": "1794009",
            "display": "Idiopathic corneal edema"
          },
          {
            "code": "1816003",
            "display": "Panic disorder with agoraphobia, severe agoraphobic avoidance AND mild panic attacks"
          },
          {
            "code": "1821000",
            "display": "Chemoreceptor apnea"
          },
          {
            "code": "1822007",
            "display": "Impaired glucose tolerance associated with pancreatic disease"
          },
          {
            "code": "1824008",
            "display": "Allergic gastritis"
          },
          {
            "code": "1826005",
            "display": "Granuloma of lip"
          },
          {
            "code": "1828006",
            "display": "Infestation caused by Gasterophilus hemorrhoidalis"
          },
          {
            "code": "1829003",
            "display": "Microcephalus"
          },
          {
            "code": "1833005",
            "display": "Phacoanaphylactic endophthalmitis"
          },
          {
            "code": "1835003",
            "display": "Necrosis of pancreas"
          },
          {
            "code": "1837006",
            "display": "Orciprenaline poisoning"
          },
          {
            "code": "1845001",
            "display": "Paraparesis"
          },
          {
            "code": "1847009",
            "display": "Endophthalmitis"
          },
          {
            "code": "1848004",
            "display": "Poisoning caused by gaseous anesthetic"
          },
          {
            "code": "1852004",
            "display": "Traumatic injury of sixth cranial nerve"
          },
          {
            "code": "1855002",
            "display": "Developmental academic disorder"
          },
          {
            "code": "1856001",
            "display": "Accessory nose"
          },
          {
            "code": "1857005",
            "display": "Congenital rubella syndrome"
          },
          {
            "code": "1858000",
            "display": "Infection caused by Stilesia globipunctata"
          },
          {
            "code": "1860003",
            "display": "Fluid volume disorder"
          },
          {
            "code": "1865008",
            "display": "Impaired intestinal protein absorption"
          },
          {
            "code": "1869002",
            "display": "Rupture of iris sphincter"
          },
          {
            "code": "1881003",
            "display": "Increased nutritional requirement"
          },
          {
            "code": "1892002",
            "display": "Star figure at the macula"
          },
          {
            "code": "1896004",
            "display": "Ectopic breast tissue"
          },
          {
            "code": "1897008",
            "display": "Amsinckia species poisoning"
          },
          {
            "code": "1899006",
            "display": "Autosomal hereditary disorder"
          },
          {
            "code": "1903004",
            "display": "Infestation caused by Psorergates ovis"
          },
          {
            "code": "1908008",
            "display": "von Willebrand disease, type IIC"
          },
          {
            "code": "1909000",
            "display": "Impairment level: better eye: severe impairment: lesser eye: near-total impairment"
          },
          {
            "code": "1922008",
            "display": "Congenital absence of urethra"
          },
          {
            "code": "1926006",
            "display": "Osteopetrosis"
          },
          {
            "code": "1938002",
            "display": "Emotional AND/OR mental disease in mother complicating pregnancy, childbirth AND/OR puerperium"
          },
          {
            "code": "1939005",
            "display": "Abnormal vascular flow"
          },
          {
            "code": "1943009",
            "display": "Left-right confusion"
          },
          {
            "code": "1953005",
            "display": "Congenital deficiency of pigment of skin"
          },
          {
            "code": "1954004",
            "display": "Dilated cardiomyopathy secondary to toxic reaction"
          },
          {
            "code": "1955003",
            "display": "Preauricular pit"
          },
          {
            "code": "1959009",
            "display": "Encephalartos species poisoning"
          },
          {
            "code": "1961000",
            "display": "Chronic polyarticular juvenile rheumatoid arthritis"
          },
          {
            "code": "1963002",
            "display": "PNH - Paroxysmal nocturnal hemoglobinuria"
          },
          {
            "code": "1965009",
            "display": "Normal skin pH"
          },
          {
            "code": "1967001",
            "display": "Congenital absence of forearm only"
          },
          {
            "code": "1973000",
            "display": "Sedative, hypnotic AND/OR anxiolytic-induced psychotic disorder with delusions"
          },
          {
            "code": "1977004",
            "display": "Oxymetholone poisoning"
          },
          {
            "code": "1979001",
            "display": "Focal choroiditis"
          },
          {
            "code": "1980003",
            "display": "Seromucinous otitis media"
          },
          {
            "code": "1981004",
            "display": "Urhidrosis"
          },
          {
            "code": "1988005",
            "display": "Late effect of injury to nerve roots, spinal plexus AND/OR other nerves of trunk"
          },
          {
            "code": "1989002",
            "display": "Burn of vagina AND/OR uterus"
          },
          {
            "code": "2004005",
            "display": "Normotensive"
          },
          {
            "code": "2012002",
            "display": "Fracture of lunate"
          },
          {
            "code": "2024009",
            "display": "Dilated cardiomyopathy secondary to metazoal myocarditis"
          },
          {
            "code": "2028007",
            "display": "Erythema induratum"
          },
          {
            "code": "2032001",
            "display": "Cerebral edema"
          },
          {
            "code": "2036003",
            "display": "Acquired factor VII deficiency disease"
          },
          {
            "code": "2040007",
            "display": "Neurogenic thoracic outlet syndrome"
          },
          {
            "code": "2041006",
            "display": "Eunuchoid gigantism"
          },
          {
            "code": "2043009",
            "display": "Alcoholic gastritis"
          },
          {
            "code": "2053005",
            "display": "Late effect of injury to blood vessels of thorax, abdomen AND/OR pelvis"
          },
          {
            "code": "2055003",
            "display": "Recurrent erosion syndrome"
          },
          {
            "code": "2058001",
            "display": "Bilateral loss of labyrinthine reactivity"
          },
          {
            "code": "2061000",
            "display": "Conductive hearing loss of combined sites"
          },
          {
            "code": "2065009",
            "display": "Autosomal dominant optic atrophy"
          },
          {
            "code": "2066005",
            "display": "Gastric ulcer with hemorrhage AND perforation but without obstruction"
          },
          {
            "code": "2070002",
            "display": "Burning sensation in eye"
          },
          {
            "code": "2073000",
            "display": "Delusions"
          },
          {
            "code": "2087000",
            "display": "Pulmonary nocardiosis"
          },
          {
            "code": "2089002",
            "display": "Pagets disease of bone"
          },
          {
            "code": "2091005",
            "display": "Pharyngeal diverticulitis"
          },
          {
            "code": "2094002",
            "display": "Carbon disulfide causing toxic effect"
          },
          {
            "code": "2102007",
            "display": "Deep corneal vascularization"
          },
          {
            "code": "2103002",
            "display": "Reflex sympathetic dystrophy of upper extremity"
          },
          {
            "code": "2107001",
            "display": "Anisomelia"
          },
          {
            "code": "2109003",
            "display": "Isolated somatotropin deficiency"
          },
          {
            "code": "2114004",
            "display": "Infection caused by Cysticercus pisiformis"
          },
          {
            "code": "2116002",
            "display": "Intramembranous bone formation"
          },
          {
            "code": "2120003",
            "display": "Weak cry"
          },
          {
            "code": "2121004",
            "display": "Ethopropazine poisoning"
          },
          {
            "code": "2128005",
            "display": "Disorder of adenoid"
          },
          {
            "code": "2129002",
            "display": "Edema of pharynx"
          },
          {
            "code": "2132004",
            "display": "Meconium in amniotic fluid noted before labor in liveborn infant"
          },
          {
            "code": "2134003",
            "display": "Diffuse pain"
          },
          {
            "code": "2136001",
            "display": "Open wound of jaw with complication"
          },
          {
            "code": "2138000",
            "display": "LSP - Left sacroposterior position"
          },
          {
            "code": "2145000",
            "display": "Anal intercourse"
          },
          {
            "code": "2149006",
            "display": "Decreased hormone production"
          },
          {
            "code": "2158004",
            "display": "Infection caused by Contracaecum"
          },
          {
            "code": "2167004",
            "display": "Retinal hemangioblastomatosis"
          },
          {
            "code": "2169001",
            "display": "Thoracic radiculitis"
          },
          {
            "code": "2170000",
            "display": "Gallop rhythm"
          },
          {
            "code": "2176006",
            "display": "Halogen acne"
          },
          {
            "code": "2177002",
            "display": "PHN - Post-herpetic neuralgia"
          },
          {
            "code": "2186007",
            "display": "Compensated metabolic alkalosis"
          },
          {
            "code": "2198002",
            "display": "Visceral epilepsy"
          },
          {
            "code": "2202000",
            "display": "Open posterior dislocation of distal end of femur"
          },
          {
            "code": "2204004",
            "display": "Acquired deformity of pinna"
          },
          {
            "code": "2213002",
            "display": "Congenital anomaly of vena cava"
          },
          {
            "code": "2216005",
            "display": "Nocturnal emission"
          },
          {
            "code": "2217001",
            "display": "Superficial injury of perineum without infection"
          },
          {
            "code": "2219003",
            "display": "Disability evaluation, disability 100%"
          },
          {
            "code": "2224000",
            "display": "Selenium poisoning"
          },
          {
            "code": "2228002",
            "display": "Scintillating scotoma"
          },
          {
            "code": "2229005",
            "display": "Chimera"
          },
          {
            "code": "2231001",
            "display": "Nerve plexus disorder"
          },
          {
            "code": "2237002",
            "display": "Painful breathing -pleurodynia"
          },
          {
            "code": "2239004",
            "display": "Previous pregnancies 6"
          },
          {
            "code": "2241003",
            "display": "X-linked absence of thyroxine-binding globulin"
          },
          {
            "code": "2243000",
            "display": "Hypercalcemia due to hyperthyroidism"
          },
          {
            "code": "2245007",
            "display": "Foreign body in nasopharynx"
          },
          {
            "code": "2251002",
            "display": "Primary hypotony of eye"
          },
          {
            "code": "2256007",
            "display": "Monovular twins"
          },
          {
            "code": "2261009",
            "display": "Obstetrical pulmonary fat embolism"
          },
          {
            "code": "2268003",
            "display": "Victim of homosexual aggression"
          },
          {
            "code": "2284002",
            "display": "Pulsating exophthalmos"
          },
          {
            "code": "2295008",
            "display": "Closed fracture of upper end of forearm"
          },
          {
            "code": "2296009",
            "display": "Iron dextran toxicity"
          },
          {
            "code": "2298005",
            "display": "Focal facial dermal dysplasia"
          },
          {
            "code": "2301009",
            "display": "Psychosomatic factor in physical condition, psychological component of unknown degree"
          },
          {
            "code": "2303007",
            "display": "Inguinal hernia with gangrene"
          },
          {
            "code": "2304001",
            "display": "Intervertebral discitis"
          },
          {
            "code": "2307008",
            "display": "Peripancreatic fat necrosis"
          },
          {
            "code": "2308003",
            "display": "Silent alleles"
          },
          {
            "code": "2312009",
            "display": "Reactive attachment disorder of infancy OR early childhood, inhibited type"
          },
          {
            "code": "2314005",
            "display": "Unprotected intercourse"
          },
          {
            "code": "2326000",
            "display": "Marriage annulment"
          },
          {
            "code": "2339001",
            "display": "Sexual overexposure"
          },
          {
            "code": "2341000",
            "display": "Infection caused by Moniliformis"
          },
          {
            "code": "2351004",
            "display": "Genetic transduction"
          },
          {
            "code": "2355008",
            "display": "Rud syndrome"
          },
          {
            "code": "2359002",
            "display": "Hyper-beta-alaninemia"
          },
          {
            "code": "2365002",
            "display": "Simple chronic pharyngitis"
          },
          {
            "code": "2366001",
            "display": "Late effect of dislocation"
          },
          {
            "code": "2367005",
            "display": "Acute hemorrhagic gastritis"
          },
          {
            "code": "2374000",
            "display": "Monofascicular block"
          },
          {
            "code": "2385003",
            "display": "Cellulitis of pectoral region"
          },
          {
            "code": "2388001",
            "display": "Normal variation in translucency"
          },
          {
            "code": "2390000",
            "display": "Acute gonococcal vulvovaginitis"
          },
          {
            "code": "2391001",
            "display": "Achondrogenesis"
          },
          {
            "code": "2396006",
            "display": "Malignant pyoderma"
          },
          {
            "code": "2398007",
            "display": "Quinidine toxicity by electrocardiogram"
          },
          {
            "code": "2403008",
            "display": "Dependence syndrome"
          },
          {
            "code": "2415007",
            "display": "Lumbosacral root lesion"
          },
          {
            "code": "2418009",
            "display": "Polyester fume causing toxic effect"
          },
          {
            "code": "2419001",
            "display": "Open wound of forehead with complication"
          },
          {
            "code": "2420007",
            "display": "Third degree burn of multiple sites of upper limb"
          },
          {
            "code": "2432006",
            "display": "Cerebrospinal fluid circulation disorder"
          },
          {
            "code": "2435008",
            "display": "Ascaridiasis"
          },
          {
            "code": "2437000",
            "display": "Placenta circumvallata"
          },
          {
            "code": "2438005",
            "display": "Iniencephaly"
          },
          {
            "code": "2439002",
            "display": "Purulent endocarditis"
          },
          {
            "code": "2443003",
            "display": "Hydrogen sulfide poisoning"
          },
          {
            "code": "2452007",
            "display": "Fetal rotation"
          },
          {
            "code": "2463005",
            "display": "Acquired heterochromia of iris"
          },
          {
            "code": "2469009",
            "display": "Onychomalacia"
          },
          {
            "code": "2470005",
            "display": "Brain damage"
          },
          {
            "code": "2471009",
            "display": "Intra-abdominal abscess postprocedure"
          },
          {
            "code": "2472002",
            "display": "Passes no urine"
          },
          {
            "code": "2473007",
            "display": "Intermittent vertical squint"
          },
          {
            "code": "2477008",
            "display": "Superficial phlebitis"
          },
          {
            "code": "2492009",
            "display": "Disorder of nutrition"
          },
          {
            "code": "2495006",
            "display": "Congenital cerebral arteriovenous aneurysm"
          },
          {
            "code": "2496007",
            "display": "Acalculia"
          },
          {
            "code": "2506003",
            "display": "Early onset dysthymia"
          },
          {
            "code": "2513003",
            "display": "Tinea capitis caused by Trichophyton"
          },
          {
            "code": "2518007",
            "display": "Cryptogenic sexual precocity"
          },
          {
            "code": "2521009",
            "display": "Bone conduction better than air"
          },
          {
            "code": "2523007",
            "display": "Salmonella pneumonia"
          },
          {
            "code": "2526004",
            "display": "Noninflammatory disorder of the female genital organs"
          },
          {
            "code": "2528003",
            "display": "Viremia"
          },
          {
            "code": "2532009",
            "display": "Choroidal rupture"
          },
          {
            "code": "2534005",
            "display": "Congenital absence of vena cava"
          },
          {
            "code": "2538008",
            "display": "Ketosis"
          },
          {
            "code": "2541004",
            "display": "Compulsive buying"
          },
          {
            "code": "2554006",
            "display": "Acute purulent pericarditis"
          },
          {
            "code": "2556008",
            "display": "Disease of supporting structures of teeth"
          },
          {
            "code": "2560006",
            "display": "Complex syndactyly of fingers"
          },
          {
            "code": "2562003",
            "display": "Athanasia trifurcata poisoning"
          },
          {
            "code": "2576002",
            "display": "Trachoma"
          },
          {
            "code": "2581006",
            "display": "Clasp knife rigidity"
          },
          {
            "code": "2582004",
            "display": "Deep third degree burn of multiple sites of lower limb"
          },
          {
            "code": "2583009",
            "display": "Filigreed network of venous valves"
          },
          {
            "code": "2584003",
            "display": "Cerebral degeneration in childhood"
          },
          {
            "code": "2585002",
            "display": "Pneumococcal pleurisy"
          },
          {
            "code": "2589008",
            "display": "Acute dacryoadenitis"
          },
          {
            "code": "2591000",
            "display": "Crush injury of shoulder region"
          },
          {
            "code": "2593002",
            "display": "Dubowitz syndrome"
          },
          {
            "code": "2602008",
            "display": "Hemarthrosis of shoulder"
          },
          {
            "code": "2606006",
            "display": "Boil of perineum"
          },
          {
            "code": "2615004",
            "display": "Graafian follicle cyst"
          },
          {
            "code": "2618002",
            "display": "Chronic recurrent major depressive disorder"
          },
          {
            "code": "2622007",
            "display": "Infected ulcer of skin"
          },
          {
            "code": "2624008",
            "display": "Prepubertal periodontitis"
          },
          {
            "code": "2625009",
            "display": "Senter syndrome"
          },
          {
            "code": "2630008",
            "display": "Open wound of finger without complication"
          },
          {
            "code": "2634004",
            "display": "Decreased blood erythrocyte volume"
          },
          {
            "code": "2638001",
            "display": "Hypercalcemia caused by a drug"
          },
          {
            "code": "2640006",
            "display": "Clinical stage 4"
          },
          {
            "code": "2651006",
            "display": "Closed traumatic dislocation of elbow joint"
          },
          {
            "code": "2655002",
            "display": "Invalidism"
          },
          {
            "code": "2657005",
            "display": "Overflow proteinuria"
          },
          {
            "code": "2663001",
            "display": "Palpatory proteinuria"
          },
          {
            "code": "2665008",
            "display": "Coordinate convulsion"
          },
          {
            "code": "2683000",
            "display": "Nonvenomous insect bite of axilla without infection"
          },
          {
            "code": "2689001",
            "display": "Dominant dystrophic epidermolysis bullosa with absence of skin"
          },
          {
            "code": "2694001",
            "display": "Myelophthisic anemia"
          },
          {
            "code": "2704003",
            "display": "Acute disease"
          },
          {
            "code": "2707005",
            "display": "Necrotizing enterocolitis"
          },
          {
            "code": "2713001",
            "display": "Closed pneumothorax"
          },
          {
            "code": "2724004",
            "display": "Auditory recruitment"
          },
          {
            "code": "2725003",
            "display": "Previous abnormality of glucose tolerance"
          },
          {
            "code": "2733002",
            "display": "Heel pain"
          },
          {
            "code": "2736005",
            "display": "Honeycomb atrophy of face"
          },
          {
            "code": "2740001",
            "display": "Gouty proteinuria"
          },
          {
            "code": "2749000",
            "display": "Congenital deformity of hip"
          },
          {
            "code": "2751001",
            "display": "Fibrocalculous pancreatic diabetes"
          },
          {
            "code": "2761008",
            "display": "Decreased stool caliber"
          },
          {
            "code": "2764000",
            "display": "Joint crackle"
          },
          {
            "code": "2770006",
            "display": "Fetal or neonatal effect of antibiotic transmitted via placenta and/or breast milk"
          },
          {
            "code": "2772003",
            "display": "Epidermolysis bullosa acquisita"
          },
          {
            "code": "2775001",
            "display": "Intra-articular loose body"
          },
          {
            "code": "2776000",
            "display": "Organic brain syndrome"
          },
          {
            "code": "2781009",
            "display": "Miscarriage complicated by delayed and/or excessive hemorrhage"
          },
          {
            "code": "2782002",
            "display": "Temporomandibular dysplasia"
          },
          {
            "code": "2783007",
            "display": "Gastrojejunal ulcer without hemorrhage AND without perforation"
          },
          {
            "code": "2786004",
            "display": "Epithelial ovarian tumor, International Federation of Gynecology and Obstetrics stage III"
          },
          {
            "code": "2790002",
            "display": "Impairment level: one eye: total impairment: other eye: not specified"
          },
          {
            "code": "2805007",
            "display": "Phosmet poisoning"
          },
          {
            "code": "2806008",
            "display": "Impaired psychomotor development"
          },
          {
            "code": "2807004",
            "display": "Chronic gastrojejunal ulcer with perforation"
          },
          {
            "code": "2808009",
            "display": "Infection caused by Prosthenorchis elegans"
          },
          {
            "code": "2815001",
            "display": "Sexual pyromania"
          },
          {
            "code": "2816000",
            "display": "Dilated cardiomyopathy secondary to myotonic dystrophy"
          },
          {
            "code": "2818004",
            "display": "Congenital vascular anomaly of eye"
          },
          {
            "code": "2819007",
            "display": "Magnesium sulfate poisoning"
          },
          {
            "code": "2825006",
            "display": "Abrasion and/or friction burn of gum without infection"
          },
          {
            "code": "2828008",
            "display": "Congenital stenosis of nares"
          },
          {
            "code": "2829000",
            "display": "Uhl disease"
          },
          {
            "code": "2831009",
            "display": "Pyloric antral vascular ectasia"
          },
          {
            "code": "2835000",
            "display": "Hemolytic anemia due to cardiac trauma"
          },
          {
            "code": "2836004",
            "display": "Butane causing toxic effect"
          },
          {
            "code": "2838003",
            "display": "Piblokto"
          },
          {
            "code": "2840008",
            "display": "Open fracture of vault of skull with cerebral laceration AND/OR contusion"
          },
          {
            "code": "2850009",
            "display": "Infection caused by Schistosoma incognitum"
          },
          {
            "code": "2853006",
            "display": "Macular keratitis"
          },
          {
            "code": "2856003",
            "display": "Vitamin A-responsive dermatosis"
          },
          {
            "code": "2858002",
            "display": "Postpartum sepsis"
          },
          {
            "code": "2884008",
            "display": "Spherophakia-brachymorphia syndrome"
          },
          {
            "code": "2893009",
            "display": "Anomaly of chromosome pair 10"
          },
          {
            "code": "2897005",
            "display": "Immune thrombocytopenia"
          },
          {
            "code": "2899008",
            "display": "Thought blocking"
          },
          {
            "code": "2900003",
            "display": "Fibromuscular dysplasia of renal artery"
          },
          {
            "code": "2901004",
            "display": "Altered blood passed per rectum"
          },
          {
            "code": "2902006",
            "display": "Decreased lymphocyte life span"
          },
          {
            "code": "2904007",
            "display": "Male infertility"
          },
          {
            "code": "2910007",
            "display": "Discharge from penis"
          },
          {
            "code": "2912004",
            "display": "Cystic-bullous disease of the lung"
          },
          {
            "code": "2917005",
            "display": "Transient hypothyroidism"
          },
          {
            "code": "2918000",
            "display": "Infection caused by Bacteroides"
          },
          {
            "code": "2919008",
            "display": "Nausea, vomiting and diarrhea"
          },
          {
            "code": "2929001",
            "display": "Arterial occlusion"
          },
          {
            "code": "2935001",
            "display": "Antiasthmatic poisoning"
          },
          {
            "code": "2940009",
            "display": "Intrabasal vesicular dermatitis"
          },
          {
            "code": "2946003",
            "display": "Osmotic diarrhea"
          },
          {
            "code": "2951009",
            "display": "Atopic cataract"
          },
          {
            "code": "2955000",
            "display": "Chronic ulcerative pulpitis"
          },
          {
            "code": "2965006",
            "display": "Nevoid congenital alopecia"
          },
          {
            "code": "2967003",
            "display": "Non-comitant strabismus"
          },
          {
            "code": "2972007",
            "display": "Occlusion of anterior spinal artery"
          },
          {
            "code": "2973002",
            "display": "Pelvic organ injury without open wound into abdominal cavity"
          },
          {
            "code": "2978006",
            "display": "Aneurysm of conjunctiva"
          },
          {
            "code": "2981001",
            "display": "Pulsatile mass of abdomen"
          },
          {
            "code": "2989004",
            "display": "Complication following molar AND/OR ectopic pregnancy"
          },
          {
            "code": "2990008",
            "display": "Lymphocytic leukemoid reaction"
          },
          {
            "code": "2992000",
            "display": "Pigmentary pallidal degeneration"
          },
          {
            "code": "2994004",
            "display": "Brain fag"
          },
          {
            "code": "2999009",
            "display": "Injury of ear region"
          },
          {
            "code": "3002002",
            "display": "Thyroid hemorrhage"
          },
          {
            "code": "3004001",
            "display": "Congenital dilatation of esophagus"
          },
          {
            "code": "3006004",
            "display": "Altered consciousness"
          },
          {
            "code": "3009006",
            "display": "Solanum malacoxylon poisoning"
          },
          {
            "code": "3013004",
            "display": "Open wound of ear drum without complication"
          },
          {
            "code": "3014005",
            "display": "Autoeczematization"
          },
          {
            "code": "3018008",
            "display": "Penetration of eyeball with magnetic foreign body"
          },
          {
            "code": "3019000",
            "display": "Closed anterior dislocation of elbow"
          },
          {
            "code": "3021005",
            "display": "Normal gastric acidity"
          },
          {
            "code": "3023008",
            "display": "Acute peptic ulcer without hemorrhage, without perforation AND without obstruction"
          },
          {
            "code": "3032005",
            "display": "Nonvenomous insect bite of cheek without infection"
          },
          {
            "code": "3033000",
            "display": "Bone AND/OR joint disorder of pelvis in mother complicating pregnancy, childbirth AND/OR puerperium"
          },
          {
            "code": "3038009",
            "display": "Acute lymphangitis of umbilicus"
          },
          {
            "code": "3044008",
            "display": "Vitreous prolapse"
          },
          {
            "code": "3053001",
            "display": "Poisoning caused by nitroglycerin"
          },
          {
            "code": "3059002",
            "display": "Acute lymphangitis of thigh"
          },
          {
            "code": "3067005",
            "display": "Weak C phenotype"
          },
          {
            "code": "3071008",
            "display": "Widow"
          },
          {
            "code": "3072001",
            "display": "Hormone-induced hypopituitarism"
          },
          {
            "code": "3073006",
            "display": "Ruvalcaba syndrome"
          },
          {
            "code": "3084004",
            "display": "Nonvenomous insect bite of gum without infection"
          },
          {
            "code": "3089009",
            "display": "Disability evaluation, impairment, class 7"
          },
          {
            "code": "3094009",
            "display": "Vomiting in infants AND/OR children"
          },
          {
            "code": "3095005",
            "display": "Induced malaria"
          },
          {
            "code": "3097002",
            "display": "Superficial injury of lip with infection"
          },
          {
            "code": "3098007",
            "display": "Ventricular septal rupture"
          },
          {
            "code": "3105002",
            "display": "Intron"
          },
          {
            "code": "3109008",
            "display": "Secondary dysthymia early onset"
          },
          {
            "code": "3110003",
            "display": "AOM - Acute otitis media"
          },
          {
            "code": "3119002",
            "display": "Brain stem laceration with open intracranial wound AND loss of consciousness"
          },
          {
            "code": "3129009",
            "display": "Infarction of ovary"
          },
          {
            "code": "3135009",
            "display": "OE - Otitis externa"
          },
          {
            "code": "3140001",
            "display": "Citrullinemia, subacute type"
          },
          {
            "code": "3144005",
            "display": "Staphylococcal pleurisy"
          },
          {
            "code": "3158007",
            "display": "Panic disorder with agoraphobia, agoraphobic avoidance in partial remission AND panic attacks in partial remission"
          },
          {
            "code": "3160009",
            "display": "Infertility of cervical origin"
          },
          {
            "code": "3163006",
            "display": "Acute adenoviral follicular conjunctivitis"
          },
          {
            "code": "3168002",
            "display": "Thrombophlebitis of intracranial venous sinus"
          },
          {
            "code": "3185000",
            "display": "Mood-congruent delusion"
          },
          {
            "code": "3199001",
            "display": "Sprain of shoulder joint"
          },
          {
            "code": "3200003",
            "display": "Sacrocoxalgia"
          },
          {
            "code": "3208005",
            "display": "Open wound of ossicles without complication"
          },
          {
            "code": "3214003",
            "display": "Invasive pulmonary aspergillosis"
          },
          {
            "code": "3217005",
            "display": "Open dislocation of sixth cervical vertebra"
          },
          {
            "code": "3218000",
            "display": "Mycotic disease"
          },
          {
            "code": "3219008",
            "display": "Disease type AND/OR category unknown"
          },
          {
            "code": "3228009",
            "display": "Closed fracture of the radial shaft"
          },
          {
            "code": "3229001",
            "display": "Tracheal ulcer"
          },
          {
            "code": "3230006",
            "display": "Illegal termination of pregnancy with afibrinogenemia"
          },
          {
            "code": "3238004",
            "display": "Pericarditis"
          },
          {
            "code": "3239007",
            "display": "Lymphocyte disorder"
          },
          {
            "code": "3253007",
            "display": "Dyschromia"
          },
          {
            "code": "3254001",
            "display": "Infection caused by Strongyloides westeri"
          },
          {
            "code": "3259006",
            "display": "Homeria species poisoning"
          },
          {
            "code": "3261002",
            "display": "Migratory osteolysis"
          },
          {
            "code": "3263004",
            "display": "Verumontanitis"
          },
          {
            "code": "3272007",
            "display": "Stomatocytosis"
          },
          {
            "code": "3274008",
            "display": "Flat chest"
          },
          {
            "code": "3275009",
            "display": "Behcet syndrome, vascular type"
          },
          {
            "code": "3276005",
            "display": "Toad poisoning"
          },
          {
            "code": "3277001",
            "display": "Terminal mood insomnia"
          },
          {
            "code": "3282008",
            "display": "Arc eye"
          },
          {
            "code": "3283003",
            "display": "Feeling of sand or foreign body in eye"
          },
          {
            "code": "3286006",
            "display": "Patient status determination, greatly improved"
          },
          {
            "code": "3289004",
            "display": "Anisometropia"
          },
          {
            "code": "3291007",
            "display": "Closed fracture of two ribs"
          },
          {
            "code": "3298001",
            "display": "Amnestic syndrome"
          },
          {
            "code": "3303004",
            "display": "Disease caused by Arenavirus"
          },
          {
            "code": "3304005",
            "display": "Bronchial compression"
          },
          {
            "code": "3305006",
            "display": "Disorder of lymphatic vessel"
          },
          {
            "code": "3308008",
            "display": "Atrophic-hyperplastic gastritis"
          },
          {
            "code": "3310005",
            "display": "Foreign body granuloma of skin"
          },
          {
            "code": "3321001",
            "display": "Renal abscess"
          },
          {
            "code": "3323003",
            "display": "Leukoplakia of penis"
          },
          {
            "code": "3327002",
            "display": "Acquired jerk nystagmus"
          },
          {
            "code": "3331008",
            "display": "Open fracture of neck of metacarpal bone"
          },
          {
            "code": "3344003",
            "display": "Toxic labyrinthitis"
          },
          {
            "code": "3345002",
            "display": "Idiopathic osteoporosis"
          },
          {
            "code": "3355003",
            "display": "Anti-common cold drug poisoning"
          },
          {
            "code": "3358001",
            "display": "Lichen ruber moniliformis"
          },
          {
            "code": "3368006",
            "display": "Dull chest pain"
          },
          {
            "code": "3376008",
            "display": "Pseudoptyalism"
          },
          {
            "code": "3381004",
            "display": "Open fracture of astragalus"
          },
          {
            "code": "3387000",
            "display": "Auditory discrimination aphasia"
          },
          {
            "code": "3391005",
            "display": "Negative for tumor cells"
          },
          {
            "code": "3393008",
            "display": "Phlebitis following infusion, perfusion AND/OR transfusion"
          },
          {
            "code": "3398004",
            "display": "Cadmium poisoning"
          },
          {
            "code": "3401001",
            "display": "Cercopithecus herpesvirus 1 disease"
          },
          {
            "code": "3415004",
            "display": "Cyanosis"
          },
          {
            "code": "3419005",
            "display": "Faucial diphtheria"
          },
          {
            "code": "3421000",
            "display": "Open blow-out fracture orbit"
          },
          {
            "code": "3424008",
            "display": "Heart rate fast"
          },
          {
            "code": "3426005",
            "display": "Retained magnetic intraocular foreign body"
          },
          {
            "code": "3427001",
            "display": "Nonglucosuric melituria"
          },
          {
            "code": "3434004",
            "display": "Myotonia"
          },
          {
            "code": "3439009",
            "display": "Severe combined immunodeficiency (SCID) due to absent peripheral T cell maturation"
          },
          {
            "code": "3441005",
            "display": "Disorder of sebaceous gland"
          },
          {
            "code": "3446000",
            "display": "Open fracture of T7-T12 level with spinal cord injury"
          },
          {
            "code": "3449007",
            "display": "Finger agnosia"
          },
          {
            "code": "3456001",
            "display": "Chronic progressive non-hereditary chorea"
          },
          {
            "code": "3458000",
            "display": "Myositis ossificans associated with dermato / polymyositis"
          },
          {
            "code": "3461004",
            "display": "Deep third degree burn of thumb"
          },
          {
            "code": "3464007",
            "display": "Infection caused by Oesophagostomum dentatum"
          },
          {
            "code": "3468005",
            "display": "Neonatal infective mastitis"
          },
          {
            "code": "3469002",
            "display": "Partial thickness burn of thumb"
          },
          {
            "code": "3472009",
            "display": "Spondylolisthesis, grade 4"
          },
          {
            "code": "3474005",
            "display": "Glycine max poisoning"
          },
          {
            "code": "3480002",
            "display": "Burn of wrist"
          },
          {
            "code": "3482005",
            "display": "Postoperative esophagitis"
          },
          {
            "code": "3483000",
            "display": "Chronic peptic ulcer with perforation"
          },
          {
            "code": "3487004",
            "display": "Pulmonary candidiasis"
          },
          {
            "code": "3500002",
            "display": "Open wound of ossicles with complication"
          },
          {
            "code": "3502005",
            "display": "Cervical lymphadenitis"
          },
          {
            "code": "3503000",
            "display": "Gender identity disorder of adolescence, previously asexual"
          },
          {
            "code": "3505007",
            "display": "Nonallopathic lesion of the arm"
          },
          {
            "code": "3506008",
            "display": "Stenosis of retinal artery"
          },
          {
            "code": "3507004",
            "display": "Abscess of thigh"
          },
          {
            "code": "3511005",
            "display": "Infectious thyroiditis"
          },
          {
            "code": "3514002",
            "display": "Peribronchial fibrosis of lung"
          },
          {
            "code": "3519007",
            "display": "Disorder of synovium"
          },
          {
            "code": "3528008",
            "display": "Restricted carbohydrate fat controlled diet"
          },
          {
            "code": "3529000",
            "display": "Infection caused by Sanguinicola"
          },
          {
            "code": "3530005",
            "display": "Bipolar 1 disorder, single manic episode, full remission"
          },
          {
            "code": "3531009",
            "display": "Intrapsychic conflict"
          },
          {
            "code": "3533007",
            "display": "Acute palmoplantar pustular psoriasis"
          },
          {
            "code": "3539006",
            "display": "Enteromenia"
          },
          {
            "code": "3542000",
            "display": "Laceration extending into parenchyma of spleen with open wound into abdominal cavity"
          },
          {
            "code": "3544004",
            "display": "Hair-splitting"
          },
          {
            "code": "3545003",
            "display": "Diastolic dysfunction"
          },
          {
            "code": "3548001",
            "display": "Brachial plexus disorder"
          },
          {
            "code": "3549009",
            "display": "Pancreatic acinar atrophy"
          },
          {
            "code": "3558002",
            "display": "Mesenteric infarction"
          },
          {
            "code": "3560000",
            "display": "Bilateral recurrent inguinal hernia"
          },
          {
            "code": "3570003",
            "display": "Increased blood erythrocyte volume"
          },
          {
            "code": "3571004",
            "display": "Megaloblastic anemia due to pancreatic insufficiency"
          },
          {
            "code": "3577000",
            "display": "Lattice retinal degeneration"
          },
          {
            "code": "3585009",
            "display": "Blinking"
          },
          {
            "code": "3586005",
            "display": "Psychogenic fugue"
          },
          {
            "code": "3589003",
            "display": "Syphilitic pericarditis"
          },
          {
            "code": "3590007",
            "display": "Enteroenteric fistula"
          },
          {
            "code": "3591006",
            "display": "Metabolic acidosis, normal anion gap, bicarbonate losses"
          },
          {
            "code": "3598000",
            "display": "Partial recent retinal detachment with single defect"
          },
          {
            "code": "3611003",
            "display": "Demeton poisoning"
          },
          {
            "code": "3633001",
            "display": "Abscess of hand"
          },
          {
            "code": "3634007",
            "display": "Legal termination of pregnancy complicated by metabolic disorder"
          },
          {
            "code": "3639002",
            "display": "Glossoptosis"
          },
          {
            "code": "3640000",
            "display": "Late effect of traumatic amputation"
          },
          {
            "code": "3641001",
            "display": "Infection caused by Coenurosis serialis"
          },
          {
            "code": "3642008",
            "display": "Steryl-sulfate sulfohydrolase deficiency"
          },
          {
            "code": "3644009",
            "display": "Macerated skin"
          },
          {
            "code": "3649004",
            "display": "Contusion, multiple sites of trunk"
          },
          {
            "code": "3650004",
            "display": "Congenital absence of liver,total"
          },
          {
            "code": "3652007",
            "display": "Overproduction of growth hormone"
          },
          {
            "code": "3657001",
            "display": "Osteospermum species poisoning"
          },
          {
            "code": "3660008",
            "display": "Lethal glossopharyngeal defect"
          },
          {
            "code": "3662000",
            "display": "Rolling hiatus hernia"
          },
          {
            "code": "3677008",
            "display": "Academic problem"
          },
          {
            "code": "3680009",
            "display": "Monocephalus tripus dibrachius"
          },
          {
            "code": "3681008",
            "display": "Thrombophlebitis of torcular Herophili"
          },
          {
            "code": "3696007",
            "display": "Functional dyspepsia"
          },
          {
            "code": "3699000",
            "display": "Transverse deficiency of arm"
          },
          {
            "code": "3703002",
            "display": "Ischiatic hernia with gangrene"
          },
          {
            "code": "3704008",
            "display": "Diffuse endocapillary proliferative glomerulonephritis"
          },
          {
            "code": "3705009",
            "display": "Congenital malformation of anterior chamber of eye"
          },
          {
            "code": "3712000",
            "display": "Degenerated eye"
          },
          {
            "code": "3716002",
            "display": "Thyroid goiter"
          },
          {
            "code": "3720003",
            "display": "Abnormal presence of hemoglobin"
          },
          {
            "code": "3723001",
            "display": "Joint inflammation"
          },
          {
            "code": "3733009",
            "display": "Congenital eventration of right crus of diaphragm"
          },
          {
            "code": "3736001",
            "display": "Open wound of thumbnail with tendon involvement"
          },
          {
            "code": "3738000",
            "display": "VH - Viral hepatitis"
          },
          {
            "code": "3744001",
            "display": "Hyperlipoproteinemia"
          },
          {
            "code": "3745000",
            "display": "Sleep rhythm problem"
          },
          {
            "code": "3747008",
            "display": "EC - Ejection click"
          },
          {
            "code": "3750006",
            "display": "Arteriospasm"
          },
          {
            "code": "3751005",
            "display": "Contusion of labium"
          },
          {
            "code": "3752003",
            "display": "Infection by Trichuris"
          },
          {
            "code": "3754002",
            "display": "Dysplasia of vagina"
          },
          {
            "code": "3755001",
            "display": "PRP - Pityriasis rubra pilaris"
          },
          {
            "code": "3756000",
            "display": "Static ataxia"
          },
          {
            "code": "3759007",
            "display": "Injury of heart with open wound into thorax"
          },
          {
            "code": "3760002",
            "display": "Familial multiple factor deficiency syndrome, type V"
          },
          {
            "code": "3762005",
            "display": "Bilateral recurrent femoral hernia with gangrene"
          },
          {
            "code": "3763000",
            "display": "Expected bereavement due to life event"
          },
          {
            "code": "3783004",
            "display": "Enamel pearls"
          },
          {
            "code": "3797007",
            "display": "Periodontal cyst"
          },
          {
            "code": "3798002",
            "display": "Premature birth of identical twins, both stillborn"
          },
          {
            "code": "3815005",
            "display": "Crohn disease of rectum"
          },
          {
            "code": "3820005",
            "display": "Inner ear conductive hearing loss"
          },
          {
            "code": "3827008",
            "display": "Aneurysm of artery of neck"
          },
          {
            "code": "3830001",
            "display": "Subcutaneous emphysema"
          },
          {
            "code": "3841004",
            "display": "Blister of cheek with infection"
          },
          {
            "code": "3845008",
            "display": "Duplication of intestine"
          },
          {
            "code": "3855007",
            "display": "Disorder of pancreas"
          },
          {
            "code": "3859001",
            "display": "Late effect of open wound of extremities without tendon injury"
          },
          {
            "code": "3873005",
            "display": "Failed attempted termination of pregnancy with acute necrosis of liver"
          },
          {
            "code": "3885002",
            "display": "ABO isoimmunization in pregnancy"
          },
          {
            "code": "3886001",
            "display": "Congenital fecaliths"
          },
          {
            "code": "3899003",
            "display": "Neutropenic typhlitis"
          },
          {
            "code": "3900008",
            "display": "Mixed sensory-motor polyneuropathy"
          },
          {
            "code": "3902000",
            "display": "Non dose-related drug-induced neutropenia"
          },
          {
            "code": "3903005",
            "display": "Closed traumatic pneumothorax"
          },
          {
            "code": "3908001",
            "display": "Infestation caused by Haematopinus"
          },
          {
            "code": "3909009",
            "display": "Coeur en sabot"
          },
          {
            "code": "3913002",
            "display": "Injury of gastrointestinal tract with open wound into abdominal cavity"
          },
          {
            "code": "3914008",
            "display": "Mental disorder in childhood"
          },
          {
            "code": "3928002",
            "display": "Zika virus disease"
          },
          {
            "code": "3939004",
            "display": "Bacterial colony density, transparent"
          },
          {
            "code": "3944006",
            "display": "X-linked placental steryl-sulfatase deficiency"
          },
          {
            "code": "3947004",
            "display": "High oxygen affinity hemoglobin polycythemia"
          },
          {
            "code": "3950001",
            "display": "Birth"
          },
          {
            "code": "3951002",
            "display": "Proctitis"
          },
          {
            "code": "3972004",
            "display": "Idiopathic insomnia"
          },
          {
            "code": "3975002",
            "display": "Deep third degree burn of lower limb"
          },
          {
            "code": "3978000",
            "display": "AIHA - Warm autoimmune hemolytic anemia"
          },
          {
            "code": "3987009",
            "display": "Congenital absence of trachea"
          },
          {
            "code": "3993001",
            "display": "Infection caused by Muellerius"
          },
          {
            "code": "3999002",
            "display": "Acute pyelitis without renal medullary necrosis"
          },
          {
            "code": "4003003",
            "display": "Alphavirus disease"
          },
          {
            "code": "4004009",
            "display": "Monster with cranial anomalies"
          },
          {
            "code": "4006006",
            "display": "Foetal tachycardia affecting management of mother"
          },
          {
            "code": "4009004",
            "display": "Lower urinary tract infection"
          },
          {
            "code": "4016003",
            "display": "Empyema of mastoid"
          },
          {
            "code": "4017007",
            "display": "Increased stratum corneum adhesiveness"
          },
          {
            "code": "4022007",
            "display": "Vulvitis circumscripta plasmacellularis"
          },
          {
            "code": "4026005",
            "display": "Interstitial mastitis associated with childbirth"
          },
          {
            "code": "4030008",
            "display": "Le Dantec virus disease"
          },
          {
            "code": "4038001",
            "display": "Myrotheciotoxicosis"
          },
          {
            "code": "4039009",
            "display": "Multiple vitamin deficiency disease"
          },
          {
            "code": "4040006",
            "display": "Hassall-Henle bodies"
          },
          {
            "code": "4041005",
            "display": "Congenital anomaly of macula"
          },
          {
            "code": "4046000",
            "display": "Degenerative spondylolisthesis"
          },
          {
            "code": "4062006",
            "display": "Lumbosacral plexus lesion"
          },
          {
            "code": "4063001",
            "display": "Achillodynia"
          },
          {
            "code": "4069002",
            "display": "Anoxic brain damage during AND/OR resulting from a procedure"
          },
          {
            "code": "4070001",
            "display": "Palinphrasia"
          },
          {
            "code": "4075006",
            "display": "Peganum harmala poisoning"
          },
          {
            "code": "4082005",
            "display": "Syphilitic myocarditis"
          },
          {
            "code": "4088009",
            "display": "Acquired hydrocephalus"
          },
          {
            "code": "4089001",
            "display": "Meningococcemia"
          },
          {
            "code": "4092002",
            "display": "Nonallopathic lesion of costovertebral region"
          },
          {
            "code": "4103001",
            "display": "Complex partial seizure"
          },
          {
            "code": "4106009",
            "display": "Rotator cuff rupture"
          },
          {
            "code": "4107000",
            "display": "Infertile male syndrome"
          },
          {
            "code": "4113009",
            "display": "Arrested hydrocephalus"
          },
          {
            "code": "4120002",
            "display": "Bronchiolitis"
          },
          {
            "code": "4124006",
            "display": "Insect bite, nonvenomous, of vagina, infected"
          },
          {
            "code": "4127004",
            "display": "Prostatic obstruction"
          },
          {
            "code": "4129001",
            "display": "Argyll-Robertson pupil"
          },
          {
            "code": "4135001",
            "display": "11p partial monosomy syndrome"
          },
          {
            "code": "4136000",
            "display": "Macrodactylia of toes"
          },
          {
            "code": "4142001",
            "display": "Muscular asthenopia"
          },
          {
            "code": "4152002",
            "display": "Acquired hypoprothrombinemia"
          },
          {
            "code": "4160001",
            "display": "Congenital anomaly of upper respiratory system"
          },
          {
            "code": "4168008",
            "display": "Tibial plateau chondromalacia"
          },
          {
            "code": "4170004",
            "display": "Ehlers-Danlos syndrome, procollagen proteinase resistant"
          },
          {
            "code": "4174008",
            "display": "Tripartite placenta"
          },
          {
            "code": "4175009",
            "display": "Infestation by Estrus"
          },
          {
            "code": "4178006",
            "display": "Partial recent retinal detachment with multiple defects"
          },
          {
            "code": "4181001",
            "display": "Normal peak expiratory flow rate"
          },
          {
            "code": "4183003",
            "display": "Charcot-Marie-Tooth disease, type IC"
          },
          {
            "code": "4184009",
            "display": "Congenital malformation of the endocrine glands"
          },
          {
            "code": "4191007",
            "display": "Scaphoid head"
          },
          {
            "code": "4195003",
            "display": "Duplication of anus"
          },
          {
            "code": "4197006",
            "display": "Disability evaluation, impairment, class 5"
          },
          {
            "code": "4199009",
            "display": "18p partial trisomy syndrome"
          },
          {
            "code": "4208000",
            "display": "Closed multiple fractures of both lower limbs"
          },
          {
            "code": "4210003",
            "display": "OH - Ocular hypertension"
          },
          {
            "code": "4223005",
            "display": "Parkinsonism caused by drug"
          },
          {
            "code": "4224004",
            "display": "Complication of infusion"
          },
          {
            "code": "4225003",
            "display": "Nasal tuberculosis"
          },
          {
            "code": "4229009",
            "display": "Phthisical eye"
          },
          {
            "code": "4232007",
            "display": "Chronic vulvitis"
          },
          {
            "code": "4237001",
            "display": "Suppurative pulpitis"
          },
          {
            "code": "4240001",
            "display": "Rupture of aorta"
          },
          {
            "code": "4241002",
            "display": "Listeria infection"
          },
          {
            "code": "4242009",
            "display": "18q partial monosomy syndrome"
          },
          {
            "code": "4244005",
            "display": "Urticaria neonatorum"
          },
          {
            "code": "4248008",
            "display": "Synovitis AND/OR tenosynovitis associated with another disease"
          },
          {
            "code": "4249000",
            "display": "Poor peripheral circulation"
          },
          {
            "code": "4251001",
            "display": "Internal eye sign"
          },
          {
            "code": "4260009",
            "display": "Sacral spinal cord injury without bone injury"
          },
          {
            "code": "4262001",
            "display": "Phlebitis of superior sagittal sinus"
          },
          {
            "code": "4264000",
            "display": "Chronic pericoronitis"
          },
          {
            "code": "4269005",
            "display": "Chronic gastrojejunal ulcer without hemorrhage AND without perforation"
          },
          {
            "code": "4273008",
            "display": "Closed posterior dislocation of elbow"
          },
          {
            "code": "4275001",
            "display": "Conjugate gaze spasm"
          },
          {
            "code": "4278004",
            "display": "Superficial foreign body of axilla without major open wound but with infection"
          },
          {
            "code": "4283007",
            "display": "Mirizzi syndrome"
          },
          {
            "code": "4287008",
            "display": "Chordee of penis"
          },
          {
            "code": "4294006",
            "display": "Isosexual precocious puberty"
          },
          {
            "code": "4300009",
            "display": "Deep third degree burn of forearm"
          },
          {
            "code": "4301008",
            "display": "Autoimmune state"
          },
          {
            "code": "4306003",
            "display": "Cluster B personality disorder"
          },
          {
            "code": "4307007",
            "display": "Pregestational diabetes mellitus AND/OR impaired glucose tolerance, modified White class F"
          },
          {
            "code": "4308002",
            "display": "RSIS - Repetitive strain injury syndrome"
          },
          {
            "code": "4310000",
            "display": "Third degree burn of wrist AND/OR hand"
          },
          {
            "code": "4313003",
            "display": "Acardiacus anceps"
          },
          {
            "code": "4316006",
            "display": "Myometritis"
          },
          {
            "code": "4320005",
            "display": "Factor V deficiency"
          },
          {
            "code": "4324001",
            "display": "Subacute cystitis"
          },
          {
            "code": "4325000",
            "display": "11q partial monosomy syndrome"
          },
          {
            "code": "4332009",
            "display": "Subarachnoid hemorrhage following injury without open intracranial wound AND with concussion"
          },
          {
            "code": "4338008",
            "display": "Arnold nerve reflex cough syndrome"
          },
          {
            "code": "4340003",
            "display": "Acrodermatitis chronica atrophicans"
          },
          {
            "code": "4349002",
            "display": "Open fracture of multiple sites of metacarpus"
          },
          {
            "code": "4354006",
            "display": "Open dislocation of scapula"
          },
          {
            "code": "4356008",
            "display": "Gingival soft tissue recession"
          },
          {
            "code": "4359001",
            "display": "Early congenital syphilis"
          },
          {
            "code": "4364002",
            "display": "Structure of associations"
          },
          {
            "code": "4367009",
            "display": "Hoover sign"
          },
          {
            "code": "4373005",
            "display": "Clubbing of nail"
          },
          {
            "code": "4374004",
            "display": "TV - Congenital tricuspid valve abnormality"
          },
          {
            "code": "4381006",
            "display": "Verbal paraphasia"
          },
          {
            "code": "4386001",
            "display": "Bronchospasm"
          },
          {
            "code": "4390004",
            "display": "Chronic lithium nephrotoxicity"
          },
          {
            "code": "4397001",
            "display": "Partial congenital duodenal obstruction"
          },
          {
            "code": "4399003",
            "display": "Acute hemorrhagic pancreatitis"
          },
          {
            "code": "4403007",
            "display": "Exclamation point hair"
          },
          {
            "code": "4406004",
            "display": "Congenital anomaly of male genital system"
          },
          {
            "code": "4409006",
            "display": "Combined methylmalonic acidemia and homocystinuria due to defects in adenosylcobalamin and methylcobalamin synthesis"
          },
          {
            "code": "4410001",
            "display": "Retroperitoneal hernia with obstruction"
          },
          {
            "code": "4412009",
            "display": "Digital nerve injury"
          },
          {
            "code": "4414005",
            "display": "Infection caused by Setaria"
          },
          {
            "code": "4416007",
            "display": "Heerfordt syndrome"
          },
          {
            "code": "4418008",
            "display": "Gangrenous ergotism"
          },
          {
            "code": "4426000",
            "display": "Ten previous induced terminations of pregnancy"
          },
          {
            "code": "4434006",
            "display": "BS - Bloom syndrome"
          },
          {
            "code": "4439001",
            "display": "Axenfeld-Schurenberg syndrome"
          },
          {
            "code": "4441000",
            "display": "Severe bipolar disorder with psychotic features"
          },
          {
            "code": "4445009",
            "display": "TB - Urogenital tuberculosis"
          },
          {
            "code": "4448006",
            "display": "Allergic headache"
          },
          {
            "code": "4451004",
            "display": "Illegal termination of pregnancy with renal tubular necrosis"
          },
          {
            "code": "4461006",
            "display": "Complication of administrative procedure"
          },
          {
            "code": "4463009",
            "display": "Indiana-Maryland type amyloid polyneuropathy"
          },
          {
            "code": "4464003",
            "display": "Rocio virus disease"
          },
          {
            "code": "4465002",
            "display": "Spherophakia"
          },
          {
            "code": "4468000",
            "display": "Oppenheim gait"
          },
          {
            "code": "4470009",
            "display": "Blanching of skin"
          },
          {
            "code": "4473006",
            "display": "Migraine with aura"
          },
          {
            "code": "4477007",
            "display": "Juvenile myopathy AND lactate acidosis"
          },
          {
            "code": "4478002",
            "display": "Multiple fractures of upper AND lower limbs"
          },
          {
            "code": "4481007",
            "display": "Abnormal gastric secretion regulation"
          },
          {
            "code": "4483005",
            "display": "Syphilitic punched out ulcer"
          },
          {
            "code": "160245001",
            "display": "No current problems or disability"
          }
        ]
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
