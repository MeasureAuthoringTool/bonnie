@ConditionSeverityValueSet = class ConditionSeverityValueSet
  @JSON = {
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
