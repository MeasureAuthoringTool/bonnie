@CommunicationNotDoneReason =  class CommunicationNotDoneReason
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "communication-not-done-reason",
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
    "url" : "http://hl7.org/fhir/ValueSet/communication-not-done-reason",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.174"
    }],
    "version" : "4.0.1",
    "name" : "CommunicationNotDoneReason",
    "title" : "CommunicationNotDoneReason",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "description" : "Codes for the reason why a communication did not happen.",
    "immutable" : true,
    "compose" : {
      "include" : [
        {
          "system" : "http://terminology.hl7.org/CodeSystem/communication-not-done-reason",
          "concept": [
            {
              "code": "unknown",
              "display": "Unknown"
            },
            {
              "code": "system-error",
              "display": "System Error"
            },
            {
              "code": "invalid-phone-number",
              "display": "Invalid Phone Number"
            },
            {
              "code": "recipient-unavailable",
              "display": "Recipient Unavailable"
            },
            {
              "code": "family-objection",
              "display": "Family Objection"
            },
            {
              "code": "patient-objection",
              "display": "Patient Objection"
            }
          ]
        }
      ]
    }
  }
