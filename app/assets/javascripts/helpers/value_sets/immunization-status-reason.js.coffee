# Desciption http://hl7.org/fhir/R4/valueset-immunization-status-reason.html
@ImmunizationStatusReasonValueSet = class ImmunizationStatusReasonValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "immunization-status-reason",
    "meta": {
      "lastUpdated": "2019-11-01T09:29:23.356+11:00",
      "profile": ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode": "pher"
    },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode": "draft"
      },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger": 1
      }],
    "url": "http://hl7.org/fhir/ValueSet/immunization-status-reason",
    "identifier": [{
      "system": "urn:ietf:rfc:3986",
      "value": "urn:oid:2.16.840.1.113883.4.642.3.992"
    }],
    "version": "4.0.1",
    "name": "ImmunizationStatusReasonCodes",
    "title": "Immunization Status Reason Codes",
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
    "description": "The value set to instantiate this attribute should be drawn from a terminologically robust code system that consists of or contains concepts to support describing the reason why a dose of vaccine was not administered. This value set is provided as a suggestive example.",
    "copyright": "This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
    "compose": {
      "include": [{
        "system": "http://terminology.hl7.org/CodeSystem/v3-ActReason",
        "concept": [
          {
            "code": "IMMUNE",
            "display" : "immunity"
          },
          {
            "code": "MEDPREC",
            "display" : "medical precaution"
          },
          {
            "code": "OSTOCK",
            "display" : "product out of stock"
          },
          {
            "code": "PATOBJ",
            "display" : "patient objection"
          }]
      },
        {
          "system": "http://snomed.info/sct",
          "concept": [
            {
              "code": "171257003",
              "display": "No consent - Tetanus/low dose diphtheria vaccine"
            },
            {
              "code": "171265000",
              "display": "Pertussis vaccine refused"
            },
            {
              "code": "171266004",
              "display": "No consent - diphtheria immunization"
            },
            {
              "code": "171267008",
              "display": "No consent - tetanus immunization"
            },
            {
              "code": "171268003",
              "display": "Polio immunization refused"
            },
            {
              "code": "171269006",
              "display": "No consent - measles immunization"
            },
            {
              "code": "171270007",
              "display": "No consent - rubella immunization"
            },
            {
              "code": "171271006",
              "display": "No consent - BCG"
            },
            {
              "code": "171272004",
              "display": "No consent - influenza immunization"
            },
            {
              "code": "171280006",
              "display": "No consent for MMR"
            },
            {
              "code": "171283008",
              "display": "No consent for any primary immunization"
            },
            {
              "code": "171285001",
              "display": "No consent - pre-school vaccinations"
            },
            {
              "code": "171286000",
              "display": "No consent - school exit vaccinations"
            },
            {
              "code": "171291004",
              "display": "No consent - Haemophilus influenzae type B immunization"
            },
            {
              "code": "171292006",
              "display": "No consent pneumococcal immunization"
            },
            {
              "code": "171293001",
              "display": "No consent for MR - Measles/rubella vaccine"
            },
            {
              "code": "268559007",
              "display": "No consent for any immunization"
            },
            {
              "code": "310839003",
              "display": "No consent for MMR1"
            },
            {
              "code": "310840001",
              "display": "No consent for second measles, mumps and rubella vaccine"
            },
            {
              "code": "314768003",
              "display": "No consent diphtheria, tetanus, pertussis immunization"
            },
            {
              "code": "314769006",
              "display": "No consent tetanus plus diphtheria immunization"
            },
            {
              "code": "314936001",
              "display": "No consent for meningitis C immunization"
            },
            {
              "code": "407598009",
              "display": "No consent for 3rd HIB booster"
            }
          ]
        }]
    }
  }