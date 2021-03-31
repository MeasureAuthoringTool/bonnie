# http://hl7.org/fhir/valueset-administration-method-codes.html
@AdministrationMethodCodesValueSet = class AdministrationMethodCodesValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "administration-method-codes",
    "url" : "http://hl7.org/fhir/ValueSet/administration-method-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.97"
    }],
    "version" : "4.0.1",
    "name" : "SNOMEDCTAdministrationMethodCodes",
    "title" : "SNOMED CT Administration Method Codes",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "FHIR Project team",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "This value set includes some method codes from SNOMED CT - provided as an exemplar",
    "copyright" : "This value set includes content from SNOMED CT, which is copyright Â© 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement",
    "compose" : {
      "include" : [
        {
          "system" : "http://snomed.info/sct",
          "concept" : [
            {
              "code": "417924000",
              "display": "Apply"
            },
            {
              "code": "418283001",
              "display": "Administer"
            },
            {
              "code": "419385000",
              "display": "Use"
            },
            {
              "code": "419582001",
              "display": "Give"
            },
            {
              "code": "419652001",
              "display": "Take"
            },
            {
              "code": "419747000",
              "display": "Chew"
            },
            {
              "code": "420045007",
              "display": "Suck"
            },
            {
              "code": "420246001",
              "display": "At"
            },
            {
              "code": "420247005",
              "display": "Dosing instruction imperative"
            },
            {
              "code": "420295001",
              "display": "Only"
            },
            {
              "code": "420341009",
              "display": "Constant"
            },
            {
              "code": "420360002",
              "display": "Sniff"
            },
            {
              "code": "420484009",
              "display": "Subtract - dosing instruction fragment"
            },
            {
              "code": "420503003",
              "display": "As"
            },
            {
              "code": "420561004",
              "display": "Or"
            },
            {
              "code": "420604000",
              "display": "Finish"
            },
            {
              "code": "420606003",
              "display": "Shampoo"
            },
            {
              "code": "420620005",
              "display": "Push"
            },
            {
              "code": "420652005",
              "display": "Until gone"
            },
            {
              "code": "420771004",
              "display": "Upon"
            },
            {
              "code": "420806001",
              "display": "Per"
            },
            {
              "code": "420883007",
              "display": "Sparingly"
            },
            {
              "code": "420942008",
              "display": "Call"
            },
            {
              "code": "420974001",
              "display": "When"
            },
            {
              "code": "421035004",
              "display": "To"
            },
            {
              "code": "421066005",
              "display": "Place"
            },
            {
              "code": "421067001",
              "display": "Then"
            },
            {
              "code": "421134003",
              "display": "Inhale"
            },
            {
              "code": "421139008",
              "display": "Hold"
            },
            {
              "code": "421206002",
              "display": "Multiply"
            },
            {
              "code": "421257003",
              "display": "Insert"
            },
            {
              "code": "421286000",
              "display": "Discontinue"
            },
            {
              "code": "421298005",
              "display": "Swish and swallow"
            },
            {
              "code": "421399004",
              "display": "Dilute"
            },
            {
              "code": "421463005",
              "display": "With"
            },
            {
              "code": "421484000",
              "display": "Then discontinue"
            },
            {
              "code": "421521009",
              "display": "Swallow"
            },
            {
              "code": "421538008",
              "display": "Instill"
            },
            {
              "code": "421548005",
              "display": "Until"
            },
            {
              "code": "421612001",
              "display": "Every"
            },
            {
              "code": "421682005",
              "display": "Dissolve"
            },
            {
              "code": "421718005",
              "display": "Before"
            },
            {
              "code": "421723005",
              "display": "Now"
            },
            {
              "code": "421769005",
              "display": "Follow directions"
            },
            {
              "code": "421803000",
              "display": "If"
            },
            {
              "code": "421805007",
              "display": "Swish"
            },
            {
              "code": "421829000",
              "display": "And"
            },
            {
              "code": "421832002",
              "display": "Twice"
            },
            {
              "code": "421939007",
              "display": "Follow"
            },
            {
              "code": "421984009",
              "display": "Until finished"
            },
            {
              "code": "421994004",
              "display": "During"
            },
            {
              "code": "422033008",
              "display": "Divide"
            },
            {
              "code": "422106007",
              "display": "Add"
            },
            {
              "code": "422114001",
              "display": "Once"
            },
            {
              "code": "422145002",
              "display": "Inject"
            },
            {
              "code": "422152000",
              "display": "Wash"
            },
            {
              "code": "422219000",
              "display": "Sprinkle"
            },
            {
              "code": "422327006",
              "display": "Then stop"
            }
          ]
        }
      ]
    }
  }
