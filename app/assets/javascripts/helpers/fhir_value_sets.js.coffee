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

  # Description   http://terminology.hl7.org/ValueSet/condition-ver-status
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

  # Desciption  http://hl7.org/fhir/R4/codesystem-event-status.html
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

  # Description   http://hl7.org/fhir/R4/valueset-encounter-status.html
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

  # Description http://hl7.org/fhir/R4/valueset-encounter-discharge-disposition.html
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

  # Description   http://hl7.org/fhir/R4/valueset-medicationrequest-status.html
  @MEDICATION_REQUEST_STATUS_VS = [
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
  ]

  # Description   http://hl7.org/fhir/R4/valueset-medicationrequest-intent.html
  @MEDICATION_REQUEST_INTENT_VS = [
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
  ]

  # Description http://hl7.org/fhir/R4/valueset-medication-statement-status.html
  @MEDICATION_STATEMENT_STATUS_VS = [
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
  ]

  # Description   http://hl7.org/fhir/R4/valueset-procedure-category.html
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

  # Description   http://hl7.org/fhir/R4/valueset-procedure-not-performed-reason.html
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

#  Description http://hl7.org/fhir/R4/valueset-device-kind.html
# Used in:
# Resource: ChargeItem.product[x] (Reference(Device|Medication|Substance)|CodeableConcept / Example)
# Resource: DeviceRequest.code[x] (Reference(Device)|CodeableConcept / Example)
# Resource: Procedure.usedCode (CodeableConcept / Example)
# Resource: DeviceDefinition.type (CodeableConcept / Example)
# Extension: http://hl7.org/fhir/StructureDefinition/observation-deviceCode: deviceCode (CodeableConcept / Example)
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
              }
            ]
          }
        ]
      }
    }

  # Description http://hl7.org/fhir/R4/valueset-allergyintolerance-clinical.html
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

  # Description http://hl7.org/fhir/R4/codesystem-allergyintolerance-verification.html
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

