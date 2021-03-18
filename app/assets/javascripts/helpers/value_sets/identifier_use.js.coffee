# Desciption http://hl7.org/fhir/valueset-identifier-use.html
@IdentifierUseValueSet = class IdentifierUseValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "identifier-use",
    "url" : "http://hl7.org/fhir/ValueSet/identifier-use",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.57"
    }],
    "version" : "4.0.1",
    "name" : "IdentifierUse",
    "title" : "IdentifierUse",
    "status" : "active",
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
    "description" : "Identifies the purpose for this identifier, if known .",
    "immutable" : true,
    "compose" : {
      "include" : [
        {
          "system" : "http://hl7.org/fhir/identifier-use",
          "concept" : [
            {
              "code" : "usual",
              "display": "Usual"
            },
            {
              "code" : "official",
              "display": "Official"
            },
            {
              "code" : "temp"
              "display": "Temp"
            },
            {
              "code" : "secondary"
              "display": "Secondary"
            },
            {
              "code" : "old"
              "display": "Old"
            }
          ]
        }
      ]
    }
  }
