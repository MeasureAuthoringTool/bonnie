# Desciption http://hl7.org/fhir/valueset-identifier-type.html
@IdentifierTypeValueSet = class IdentifierTypeValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "identifier-type",
    "url" : "http://hl7.org/fhir/ValueSet/identifier-type",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.45"
    }],
    "version" : "4.0.1",
    "name" : "Identifier Type Codes",
    "title" : "IdentifierType",
    "status" : "active",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "A coded type for an identifier that can be used to determine which identifier to use for a specific purpose.",
    "compose" : {
      "include" : [
        {
          "system" : "http://terminology.hl7.org/CodeSystem/v2-0203",
          "concept" : [
            {
              "code" : "DL",
              "display": "Driver's license number"
            },
            {
              "code" : "PPN",
              "display": "Passport number"
            },
            {
              "code" : "BRN",
              "display": "Breed Registry Number"
            },
            {
              "code" : "MR",
              "display": "Medical record number"
            },
            {
              "code" : "MCN",
              "display": "Microchip Number"
            },
            {
              "code" : "EN",
              "display": "Employer number"
            },
            {
              "code" : "TAX",
              "display": "Tax ID number"
            },
            {
              "code" : "NIIP",
              "display": "National Insurance Payor Identifier (Payor)"
            },
            {
              "code" : "PRN",
              "display": "Provider number"
            },
            {
              "code" : "MD",
              "display": "Medical License number"
            },
            {
              "code" : "DR",
              "display": "Donor Registration Number"
            },
            {
              "code" : "ACSN",
              "display": "Accession ID"
            },
            {
              "code" : "UDI",
              "display": "Universal Device Identifier"
            },
            {
              "code" : "SNO",
              "display": "Serial Number"
            },
            {
              "code" : "SB",
              "display": "Social Beneficiary Identifier"
            },
            {
              "code" : "PLAC",
              "display": "Placer Identifier"
            },
            {
              "code" : "FILL",
              "display": "Filler Identifier"
            },
            {
              "code" : "JHN",
              "display": "Jurisdictional health number (Canada)"
            }
          ]
        }
      ]
    }
  }
