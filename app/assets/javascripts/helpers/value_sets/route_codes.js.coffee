# http://hl7.org/fhir/valueset-route-codes.html
@RouteCodes  = class RouteCodes
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "route-codes",
    "url" : "http://hl7.org/fhir/ValueSet/route-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.98"
    }],
    "version" : "4.0.1",
    "name" : "SNOMEDCTRouteCodes",
    "title" : "SNOMED CT Route Codes",
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
    "description" : "This value set includes all Route codes from SNOMED CT - provided as an exemplar.",
    "copyright" : "This value set includes content from SNOMED CT, which is copyright Â© 2002 International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement.",
    "compose" : {
      "include" : [
        {
          "system" : "http://snomed.info/sct",
          "concept" : [
            {
              "code": "6064005",
              "display": "Topical route"
            },
            {
              "code": "10547007",
              "display": "Auricular use"
            },
            {
              "code": "12130007",
              "display": "Intra-articular route"
            },
            {
              "code": "16857009",
              "display": "Vaginal use"
            },
            {
              "code": "26643006",
              "display": "Oral use"
            },
            {
              "code": "34206005",
              "display": "SC use"
            },
            {
              "code": "37161004",
              "display": "Rectal use"
            },
            {
              "code": "37737002",
              "display": "Intraluminal use"
            },
            {
              "code": "37839007",
              "display": "Sublingual use"
            },
            {
              "code": "38239002",
              "display": "Intraperitoneal use"
            },
            {
              "code": "45890007",
              "display": "Transdermal use"
            },
            {
              "code": "46713006",
              "display": "Nasal use"
            },
            {
              "code": "47625008",
              "display": "Intravenous use"
            },
            {
              "code": "54471007",
              "display": "Buccal use"
            },
            {
              "code": "54485002",
              "display": "Ophthalmic use"
            },
            {
              "code": "58100008",
              "display": "Intra-arterial use"
            },
            {
              "code": "60213007",
              "display": "Intramedullary route"
            },
            {
              "code": "62226000",
              "display": "Intrauterine route"
            },
            {
              "code": "72607000",
              "display": "Intrathecal route"
            },
            {
              "code": "78421000",
              "display": "Intramuscular use"
            },
            {
              "code": "90028008",
              "display": "Urethral use"
            },
            {
              "code": "127490009",
              "display": "Gastrostomy use"
            },
            {
              "code": "127491008",
              "display": "Jejunostomy use"
            },
            {
              "code": "127492001",
              "display": "Nasogastric use"
            },
            {
              "code": "372449004",
              "display": "Dental use"
            },
            {
              "code": "372450004",
              "display": "Endocervical use"
            },
            {
              "code": "372451000",
              "display": "Endosinusial use"
            },
            {
              "code": "372452007",
              "display": "Endotracheopulmonary use"
            },
            {
              "code": "372453002",
              "display": "Extra-amniotic use"
            },
            {
              "code": "372454008",
              "display": "Gastroenteral use"
            },
            {
              "code": "372457001",
              "display": "Gingival use"
            },
            {
              "code": "372458006",
              "display": "Intraamniotic use"
            },
            {
              "code": "372459003",
              "display": "Intrabursal use"
            },
            {
              "code": "372460008",
              "display": "Intracardiac use"
            },
            {
              "code": "372461007",
              "display": "Intracavernous use"
            },
            {
              "code": "372463005",
              "display": "Intracoronary use"
            },
            {
              "code": "372464004",
              "display": "Intradermal use"
            },
            {
              "code": "372465003",
              "display": "Intradiscal use"
            },
            {
              "code": "372466002",
              "display": "Intralesional use"
            },
            {
              "code": "372467006",
              "display": "Intralymphatic use"
            },
            {
              "code": "372468001",
              "display": "Intraocular use"
            },
            {
              "code": "372469009",
              "display": "Intrapleural use"
            },
            {
              "code": "372470005",
              "display": "Intrasternal use"
            },
            {
              "code": "372471009",
              "display": "Intravesical use"
            },
            {
              "code": "372473007",
              "display": "Oromucosal use"
            },
            {
              "code": "372474001",
              "display": "Periarticular use"
            },
            {
              "code": "372475000",
              "display": "Perineural use"
            },
            {
              "code": "372476004",
              "display": "Subconjunctival use"
            },
            {
              "code": "404815008",
              "display": "Transmucosal route"
            },
            {
              "code": "404818005",
              "display": "Intratracheal route"
            },
            {
              "code": "404819002",
              "display": "Intrabiliary route"
            },
            {
              "code": "404820008",
              "display": "Epidural route"
            },
            {
              "code": "416174007",
              "display": "Suborbital route"
            },
            {
              "code": "417070009",
              "display": "Caudal route"
            },
            {
              "code": "417255000",
              "display": "Intraosseous route"
            },
            {
              "code": "417950001",
              "display": "Intrathoracic route"
            },
            {
              "code": "417985001",
              "display": "Enteral route"
            },
            {
              "code": "417989007",
              "display": "Intraductal route"
            },
            {
              "code": "418091004",
              "display": "Intratympanic route"
            },
            {
              "code": "418114005",
              "display": "Intravenous central route"
            },
            {
              "code": "418133000",
              "display": "Intramyometrial route"
            },
            {
              "code": "418136008",
              "display": "Gastro-intestinal stoma route"
            },
            {
              "code": "418162004",
              "display": "Colostomy route"
            },
            {
              "code": "418204005",
              "display": "Periurethral route"
            },
            {
              "code": "418287000",
              "display": "Intracoronal route"
            },
            {
              "code": "418321004",
              "display": "Retrobulbar route"
            },
            {
              "code": "418331006",
              "display": "Intracartilaginous route"
            },
            {
              "code": "418401004",
              "display": "Intravitreal route"
            },
            {
              "code": "418418000",
              "display": "Intraspinal route"
            },
            {
              "code": "418441008",
              "display": "Orogastric route"
            },
            {
              "code": "418511008",
              "display": "Transurethral route"
            },
            {
              "code": "418586008",
              "display": "Intratendinous route"
            },
            {
              "code": "418608002",
              "display": "Intracorneal route"
            },
            {
              "code": "418664002",
              "display": "Oropharyngeal route"
            },
            {
              "code": "418722009",
              "display": "Peribulbar route"
            },
            {
              "code": "418730005",
              "display": "Nasojejunal route"
            },
            {
              "code": "418743005",
              "display": "Fistula route"
            },
            {
              "code": "418813001",
              "display": "Surgical drain route"
            },
            {
              "code": "418821007",
              "display": "Intracameral route"
            },
            {
              "code": "418851001",
              "display": "Paracervical route"
            },
            {
              "code": "418877009",
              "display": "Intrasynovial route"
            },
            {
              "code": "418887008",
              "display": "Intraduodenal route"
            },
            {
              "code": "418892005",
              "display": "Intracisternal route"
            },
            {
              "code": "418947002",
              "display": "Intratesticular route"
            },
            {
              "code": "418987007",
              "display": "Intracranial route"
            },
            {
              "code": "419021003",
              "display": "Tumor cavity route"
            },
            {
              "code": "419165009",
              "display": "Paravertebral route"
            },
            {
              "code": "419231003",
              "display": "Intrasinal route"
            },
            {
              "code": "419243002",
              "display": "Transcervical route"
            },
            {
              "code": "419320008",
              "display": "Subtendinous route"
            },
            {
              "code": "419396008",
              "display": "Intraabdominal route"
            },
            {
              "code": "419601003",
              "display": "Subgingival route"
            },
            {
              "code": "419631009",
              "display": "Intraovarian route"
            },
            {
              "code": "419684008",
              "display": "Ureteral route"
            },
            {
              "code": "419762003",
              "display": "Peritendinous route"
            },
            {
              "code": "419778001",
              "display": "Intrabronchial route"
            },
            {
              "code": "419810008",
              "display": "Intraprostatic route"
            },
            {
              "code": "419874009",
              "display": "Submucosal route"
            },
            {
              "code": "419894000",
              "display": "Surgical cavity route"
            },
            {
              "code": "419954003",
              "display": "Ileostomy route"
            },
            {
              "code": "419993007",
              "display": "Intravenous peripheral route"
            },
            {
              "code": "420047004",
              "display": "Periosteal route"
            },
            {
              "code": "420163009",
              "display": "Esophagostomy route"
            },
            {
              "code": "420168000",
              "display": "Urostomy route"
            },
            {
              "code": "420185003",
              "display": "Laryngeal route"
            },
            {
              "code": "420201002",
              "display": "Intrapulmonary route"
            },
            {
              "code": "420204005",
              "display": "Mucous fistula route"
            },
            {
              "code": "420218003",
              "display": "Nasoduodenal route"
            },
            {
              "code": "420254004",
              "display": "Body cavity route"
            },
            {
              "code": "420287000",
              "display": "Intraventricular route - cardiac"
            },
            {
              "code": "420719007",
              "display": "Intracerebroventricular route"
            },
            {
              "code": "428191002",
              "display": "Percutaneous route"
            },
            {
              "code": "429817007",
              "display": "Interstitial route"
            },
            {
              "code": "445752009",
              "display": "Intraesophageal route"
            },
            {
              "code": "445754005",
              "display": "Intragingival route"
            },
            {
              "code": "445755006",
              "display": "Intravascular route"
            },
            {
              "code": "445756007",
              "display": "Intradural route"
            },
            {
              "code": "445767008",
              "display": "Intrameningeal route"
            },
            {
              "code": "445768003",
              "display": "Intragastric route"
            },
            {
              "code": "445769006",
              "display": "Intracorpus cavernosum route"
            },
            {
              "code": "445771006",
              "display": "Intrapericardial route"
            },
            {
              "code": "445913005",
              "display": "Intralingual route"
            },
            {
              "code": "445941009",
              "display": "Intrahepatic route"
            },
            {
              "code": "446105004",
              "display": "Conjunctival route"
            },
            {
              "code": "446407004",
              "display": "Intraepicardial route"
            },
            {
              "code": "446435000",
              "display": "Transendocardial route"
            },
            {
              "code": "446442000",
              "display": "Transplacental route"
            },
            {
              "code": "446540005",
              "display": "Intracerebral route"
            },
            {
              "code": "447026006",
              "display": "Intraileal route"
            },
            {
              "code": "447052000",
              "display": "Periodontal route"
            },
            {
              "code": "447080003",
              "display": "Peridural route"
            },
            {
              "code": "447081004",
              "display": "Lower respiratory tract route"
            },
            {
              "code": "447121004",
              "display": "Intramammary route"
            },
            {
              "code": "447122006",
              "display": "Intratumor route"
            },
            {
              "code": "447227007",
              "display": "Transtympanic route"
            },
            {
              "code": "447229005",
              "display": "Transtracheal route"
            },
            {
              "code": "447694001",
              "display": "Respiratory tract route"
            },
            {
              "code": "447964005",
              "display": "Digestive tract route"
            },
            {
              "code": "448077001",
              "display": "Intraepidermal route"
            },
            {
              "code": "448491004",
              "display": "Intrajejunal route"
            },
            {
              "code": "448492006",
              "display": "Intracolonic route"
            },
            {
              "code": "448598008",
              "display": "Cutaneous route"
            },
            {
              "code": "697971008",
              "display": "Arteriovenous fistula route"
            },
            {
              "code": "711360002",
              "display": "Intraneural route"
            },
            {
              "code": "711378007",
              "display": "Intramural route"
            },
            {
              "code": "714743009",
              "display": "Extracorporeal route"
            },
            {
              "code": "718329006",
              "display": "Infiltration route"
            },
            {
              "code": "1611000175109",
              "display": "Sublesional route"
            },
            {
              "code": "180677251000087104",
              "display": "Intraventricular"
            },
            {
              "code": "461657851000087101",
              "display": "Translingual"
            }
          ]
        }
      ]
    }
  }
