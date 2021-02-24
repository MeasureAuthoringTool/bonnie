# http://hl7.org/fhir/valueset-dose-rate-type.html
@DoseAndRateType = class DoseAndRateType
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "dose-rate-type",
    "url" : "http://hl7.org/fhir/ValueSet/dose-rate-type",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.981"
    }],
    "version" : "4.0.1",
    "name" : "DoseAndRateType",
    "title" : "DoseAndRateType",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "contact" : [{
      "telecom" : [
        {
          "system" : "url",
          "value" : "http://hl7.org/fhir"
        },
        {
          "system" : "email",
          "value" : "fhir@lists.hl7.org"
        }
      ]
    }],
    "description" : "The kind of dose or rate specified.",
    "immutable" : true,
    "compose" : {
      "include" : [
        {
          "system" : "http://terminology.hl7.org/CodeSystem/dose-rate-type",
          "concept" : [
            {
              "code" : "calculated",
              "display" : "Calculated"
            },
            {
              "code" : "ordered",
              "display" : "Ordered"
            }
          ]
        }
      ]
    }
  }
