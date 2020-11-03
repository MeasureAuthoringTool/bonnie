# Description http://hl7.org/fhir/R4/valueset-body-site.html
@ObservationStatusValueSet = class ObservationStatusValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "observation-status",
    "meta": {
      "lastUpdated": "2019-11-01T09:29:23.356+11:00",
      "profile": [
        "http://hl7.org/fhir/StructureDefinition/shareablevalueset"
      ]
    },
    "text": {
      "status": "generated",
      "div": "<div>!-- Snipped for Brevity --></div>"
    },
    "url": "http://hl7.org/fhir/ValueSet/observation-status",
    "identifier": [
      {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.400"
      }
    ],
    "version": "4.0.1",
    "name": "ObservationStatus",
    "title": "ObservationStatus",
    "status": "active",
    "experimental": false,
    "date": "2019-11-01T09:29:23+11:00",
    "publisher": "HL7 (FHIR Project)",
    "description": "Codes providing the status of an observation.",
    "immutable": true,
    "compose": {
      "include": [
        {
          "system": "http://hl7.org/fhir/observation-status",
          "concept": [
            {
              "code": "registered",
              "display": "Registered"
            },
            {
              "code": "preliminary",
              "display": "Preliminary"
            },
            {
              "code": "final",
              "display": "Final"
            },
            {
              "code": "amended",
              "display": "Amended"
            },
            {
              "code": "corrected",
              "display": "Corrected"
            },
            {
              "code": "cancelled",
              "display": "Cancelled"
            },
            {
              "code": "etentered-in-error",
              "display": "Entered in Error"
            },
            {
              "code": "unknown",
              "display": "Unknown"
            },
          ]
        }
      ]
    }
  }
