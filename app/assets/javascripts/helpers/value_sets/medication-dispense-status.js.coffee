@MedicationDispenseStatusValueSet = class MedicationDispenseStatusValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "medication-dispense-status",
    "meta": {
      "lastUpdated": "2019-10-24T11:53:00+11:00",
      "profile": [
        "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
      ]
    },
    "text": {
      "status": "generated",
      "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>MedicationDispenseStatus</h2><div><p>A coded concept specifying the state of the dispense event.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-medication-dispense-status.html\"><code>http://hl7.org/fhir/medication-dispense-status</code></a></li></ul></div>"
    },
    "extension": [
      {
        "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-ballot-status",
        "valueString": "Informative"
      },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger": 2
      },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
        "valueCode": "phx"
      }
    ],
    "url": "http://hl7.org/fhir/ValueSet/medication-dispense-status",
    "identifier": [
      {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.339"
      }
    ],
    "version": "3.0.2",
    "name": "MedicationDispenseStatus",
    "status": "draft",
    "experimental": false,
    "date": "2019-10-24T11:53:00+11:00",
    "publisher": "HL7 (FHIR Project)",
    "contact": [
      {
        "telecom": [
          {
            "system": "url",
            "value": "http://hl7.org/fhir"
          },
          {
            "system": "email",
            "value": "fhir@lists.hl7.org"
          }
        ]
      }
    ],
    "description": "A coded concept specifying the state of the dispense event.",
    "immutable": true,
    "compose": {
      "include": [
        {
          "system": "http://hl7.org/fhir/medication-dispense-status",
          "concept" : [
            {
              "code": "preparation",
              "display": "Preparation",
              "definition": "The core event has not started yet, but some staging activities have begun (e.g. initial compounding or packaging of medication). Preparation stages may be tracked for billing purposes."
            },
            {
              "code": "in-progress",
              "display": "In Progress",
              "definition": "The dispense has started but has not yet completed."
            },
            {
              "code": "on-hold",
              "display": "On Hold",
              "definition": "Actions implied by the administration have been temporarily halted, but are expected to continue later. May also be called \"suspended\""
            },
            {
              "code": "completed",
              "display": "Completed",
              "definition": "All actions that are implied by the dispense have occurred."
            },
            {
              "code": "entered-in-error",
              "display": "Entered in-Error",
              "definition": "The dispense was entered in error and therefore nullified."
            },
            {
              "code": "stopped",
              "display": "Stopped",
              "definition": "Actions implied by the dispense have been permanently halted, before all of them occurred."
            }
          ]
        }
      ]
    }
  }