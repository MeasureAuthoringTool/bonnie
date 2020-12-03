# Description https://www.hl7.org/fhir/valueset-diagnosis-role.html
# Used in:
#  CodeSystem: This value set is the designated 'entire code system' value set for DiagnosisRole
#  Resource: Encounter.diagnosis.use (CodeableConcept / Preferred)
#  Resource: EpisodeOfCare.diagnosis.role (CodeableConcept / Preferred)
@DiagnosisRoleValueSet = class DiagnosisRoleValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "diagnosis-role",
    "meta": {
      "lastUpdated": "2019-11-01T09:29:23.356+11:00",
      "profile": ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text": {
      "status": "generated",
      "div": "<div>!-- Snipped for Brevity --></div>"
    },
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode": "vocab"
    }],
    "url": "http://hl7.org/fhir/ValueSet/diagnosis-role",
    "identifier": [{
      "system": "urn:ietf:rfc:3986",
      "value": "urn:oid:2.16.840.1.113883.4.642.3.49"
    }],
    "version": "4.0.1",
    "name": "DiagnosisRole",
    "title": "DiagnosisRole",
    "status": "draft",
    "experimental": false,
    "date": "2019-11-01T09:29:23+11:00",
    "publisher": "FHIR Project team",
    "contact": [{
      "telecom": [{
        "system": "url",
        "value": "http://hl7.org/fhir"
      }]
    }],
    "description": "This value set defines a set of codes that can be used to express the role of a diagnosis on the Encounter or EpisodeOfCare record.",
    "immutable": true,
    "compose": {
      "include": [{
        "system": "http://terminology.hl7.org/CodeSystem/diagnosis-role",
        "concept": [
          {
            "code": "AD",
            "display": "Admission diagnosis"
          },
          {
            "code": "DD",
            "display": "Discharge diagnosis"
          },
          {
            "code": "CC",
            "display": "Chief complaint"
          },
          {
            "code": "CM",
            "display": "Comorbidity diagnosis"
          },
          {
            "code": "pre-op",
            "display": "pre-op diagnosis"
          },
          {
            "code": "post-op",
            "display": "post-op diagnosis"
          },
          {
            "code": "billing",
            "display": "Billing"
          }]
      }]
    }
  }
