# Description http://hl7.org/fhir/valueset-additional-instruction-codes.html
@AdditionalDosageInstructionsValueSet = class AdditionalDosageInstructionsValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "additional-instruction-codes",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "url" : "http://hl7.org/fhir/ValueSet/additional-instruction-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.95"
    }],
    "version" : "4.0.1",
    "name" : "SNOMEDCTAdditionalDosageInstructions",
    "title" : "SNOMED CT Additional Dosage Instructions",
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
    "description" : "This value set includes all SNOMED CT Additional Dosage Instructions.",
    "copyright" : "This resource includes content from SNOMED Clinical TermsÂ® (SNOMED CTÂ®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
    "compose" : {
      "include" : [
        {
          "system" : "http://snomed.info/sct",
          "concept" : [
            {
              "code" : "311501008",
              "display" : "Half to one hour before food"
            },
            {
              "code" : "311504000",
              "display" : "With or after food"
            },
            {
              "code" : "417929005",
              "display" : "Times"
            },
            {
              "code" : "417980006",
              "display" : "Contains aspirin"
            },
            {
              "code" : "417995008",
              "display" : "Dissolve or mix with water before taking"
            },
            {
              "code" : "418071006",
              "display" : "Warning. Causes drowsiness which may continue the next day. If affected do not drive or operate machinery. Avoid alcoholic drink"
            },
            {
              "code" : "418194009",
              "display" : "Contains an aspirin-like medicine"
            },
            {
              "code" : "418281004",
              "display" : "Do not take anything containing aspirin while taking this medicine",
            },
            {
              "code" : "418443006",
              "display" : "Do not take more than . . . in 24 hours or . . . in any one week"
            },
            {
              "code" : "418521000",
              "display" : "Avoid exposure of skin to direct sunlight or sun lamps"
            },
            {
              "code" : "418577003",
              "display" : "Take at regular intervals. Complete the prescribed course unless otherwise directed"
            },
            {
              "code" : "418637003",
              "display" : "Do not take with any other paracetamol products"
            },
            {
              "code" : "418639000",
              "display" : "Warning. May cause drowsiness"
            },
            {
              "code" : "418693002",
              "display" : "Swallowed whole, not chewed"
            },
            {
              "code" : "418849000",
              "display" : "Warning. Follow the printed instructions you have been given with this medicine"
            },
            {
              "code" : "418850000",
              "display" : "Contains aspirin and paracetamol. Do not take with any other paracetamol products"
            },
            {
              "code" : "418914006",
              "display" : "Warning. May cause drowsiness. If affected do not drive or operate machinery. Avoid alcoholic drink"
            },
            {
              "code" : "418954008",
              "display" : "Warning. May cause drowsiness. If affected do not drive or operate machinery"
            },
            {
              "code" : "418991002",
              "display" : "Sucked or chewed"
            },
            {
              "code" : "419111009",
              "display" : "Allow to dissolve under the tongue. Do not transfer from this container. Keep tightly closed. Discard eight weeks after opening"
            },
            {
              "code" : "419115000",
              "display" : "Do not take milk, indigestion remedies, or medicines containing iron or zinc at the same time of day as this medicine"
            },
            {
              "code" : "419303009",
              "display" : "With plenty of water",
            },
            {
              "code" : "419437002",
              "display" : "Do not take more than 2 at any one time. Do not take more than 8 in 24 hours"
            },
            {
              "code" : "419439004",
              "display" : "Caution flammable: keep away from fire or flames"
            },
            {
              "code" : "419444006",
              "display" : "Do not stop taking this medicine except on your doctor's advice"
            },
            {
              "code" : "419473009",
              "display" : "Each"
            },
            {
              "code" : "419529008",
              "display" : "Dissolved under the tongue"
            },
            {
              "code" : "419822006",
              "display" : "Warning. Avoid alcoholic drink"
            },
            {
              "code" : "419974005",
              "display" : "This medicine may color the urine"
            },
            {
              "code" : "420003005",
              "display" : "Do not take more than . . . in 24 hours"
            },
            {
              "code" : "420082003",
              "display" : "Do not take indigestion remedies or medicines containing iron or zinc at the same time of day as this medicine"
            },
            {
              "code" : "420110001",
              "display" : "Do not take indigestion remedies at the same time of day as this medicine"
            },
            {
              "code" : "420162004",
              "display" : "To be spread thinly"
            },
            {
              "code" : "420652005",
              "display" : "Until gone"
            },
            {
              "code" : "421484000",
              "display" : "Then discontinue"
            },
            {
              "code" : "421769005",
              "display" : "Follow directions"
            },
            {
              "code" : "421984009",
              "display" : "Until finished"
            },
            {
              "code" : "422327006",
              "display" : "Then stop"
            },
            {
              "code" : "428579001",
              "display" : "Use with caution"
            },
            {
              "code" : "717154004",
              "display" : "Take on an empty stomach"
            }
          ]
        }
      ]
    }
  }
