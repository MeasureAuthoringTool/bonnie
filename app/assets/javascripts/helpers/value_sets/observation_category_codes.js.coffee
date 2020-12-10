# Description http://hl7.org/fhir/ValueSet/observation-category
@ObservationCategoryCodesValueSet = class ObservationCategoryCodesValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "observation-category",
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
    "url": "http://hl7.org/fhir/ValueSet/observation-category",
    "identifier": [
      {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.4.642.3.403"
      }
    ],
    "version": "4.0.1",
    "name": "ObservationCategoryCodes",
    "title": "Observation Category Codes",
    "status": "draft",
    "experimental": false,
    "date": "2019-11-01T09:29:23+11:00",
    "publisher": "FHIR Project team",
    "description": "Observation Category codes.",
    "compose": {
      "include": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category"
          "concept": [
            {
              "code": "social-history",
              "display": "Social History"
            },
            {
              "code": "vital-signs",
              "display": "Vital Signs"
            },
            {
              "code": "imaging",
              "display": "Imaging"
            },
            {
              "code": "laboratory",
              "display": "Laboratory"
            },
            {
              "code": "procedure",
              "display": "Procedure"
            },
            {
              "code": "survey",
              "display": "Survey"
            },
            {
              "code": "exam",
              "display": "Exam"
            },
            {
              "code": "therapy",
              "display": "Therapy"
            },
            {
              "code": "activity",
              "display": "Activity"
            }
          ]
        }
      ]
    }
  }
