# Description   https://hl7.org/fhir/R4/valueset-procedure-reason.html
@ProcedureReasonValueSet = class ProcedureReasonValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "procedure-reason",
    "meta": {
      "lastUpdated": "2019-11-01T09:29:23.356+11:00",
      "profile": ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text": {
      "status": "generated",
      "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Procedure Reason Codes</h2><div><p>This example value set defines the set of codes that can be used to indicate a reason for a procedure.</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  404684003 (Clinical finding)</li><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  71388002 (Procedure)</li></ul></div>"
    },
    "extension": [{
      "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode": "pc"
    },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode": "draft"
      },
      {
        "url": "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger": 1
      }],
    "url": "http://hl7.org/fhir/ValueSet/procedure-reason",
    "identifier": [{
      "system": "urn:ietf:rfc:3986",
      "value": "urn:oid:2.16.840.1.113883.4.642.3.432"
    }],
    "version": "4.0.1",
    "name": "ProcedureReasonCodes",
    "title": "Procedure Reason Codes",
    "status": "draft",
    "experimental": false,
    "date": "2019-11-01T09:29:23+11:00",
    "publisher": "Health Level Seven, Inc. - CQI WG",
    "contact": [{
      "telecom": [{
        "system": "url",
        "value": "http://hl7.org/fhir"
      }]
    }],
    "description": "This example value set defines the set of codes that can be used to indicate a reason for a procedure..",
    "copyright": "This resource includes content from SNOMED Clinical TermsÂ® (SNOMED CTÂ®) which is copyright   of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers  of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
    "compose": {
      "include": [
        {
          "system": "http://snomed.info/sct",
          "concept": [
            {
              "code": "109006",
              "display": "Anxiety disorder of childhood OR adolescence"
            },
            {
              "code": "122003",
              "display": "Choroidal hemorrhage"
            },
            {
              "code": "127009",
              "display": "Spontaneous abortion with laceration of cervix"
            },
            {
              "code": "129007",
              "display": "Homoiothermia"
            },
            {
              "code": "134006",
              "display": "Decreased hair growth"
            },
            {
              "code": "140004",
              "display": "Chronic pharyngitis"
            },
            {
              "code": "144008",
              "display": "Normal peripheral vision"
            },
            {
              "code": "147001",
              "display": "Superficial foreign body of scrotum without major open wound but with infection"
            },
            {
              "code": "150003",
              "display": "Abnormal bladder continence"
            },
            {
              "code": "151004",
              "display": "Meningitis due to gonococcus"
            },
            {
              "code": "162004",
              "display": "Severe manic bipolar I disorder without psychotic features"
            },
            {
              "code": "165002",
              "display": "Accident-prone"
            },
            {
              "code": "168000",
              "display": "Typhlolithiasis"
            },
            {
              "code": "171008",
              "display": "Injury of ascending right colon without open wound into abdominal cavity"
            },
            {
              "code": "172001",
              "display": "Endometritis following molar AND/OR ectopic pregnancy"
            },
            {
              "code": "175004",
              "display": "Supraorbital neuralgia"
            },
            {
              "code": "177007",
              "display": "Poisoning by sawfly larvae"
            },
            {
              "code": "179005",
              "display": "Apraxia of dressing"
            },
            {
              "code": "181007",
              "display": "Hemorrhagic bronchopneumonia"
            },
            {
              "code": "183005",
              "display": "Autoimmune pancytopenia"
            },
            {
              "code": "184004",
              "display": "Withdrawal arrhythmia"
            },
            {
              "code": "188001",
              "display": "Intercostal artery injury"
            },
            {
              "code": "192008",
              "display": "Congenital syphilitic hepatomegaly"
            },
            {
              "code": "193003",
              "display": "Benign hypertensive renal disease"
            },
            {
              "code": "195005",
              "display": "Illegal abortion with endometritis"
            },
            {
              "code": "198007",
              "display": "Disease due to Filoviridae"
            },
            {
              "code": "199004",
              "display": "Decreased lactation"
            },
            {
              "code": "208008",
              "display": "Neurocutaneous melanosis sequence"
            },
            {
              "code": "216004",
              "display": "Delusion of persecution"
            },
            {
              "code": "219006",
              "display": "Alcohol user"
            },
            {
              "code": "222008",
              "display": "Acute epiglottitis with obstruction"
            },
            {
              "code": "223003",
              "display": "Tumor of body of uterus affecting pregnancy"
            },
            {
              "code": "228007",
              "display": "Lucio phenomenon"
            },
            {
              "code": "241006",
              "display": "Motor simple partial status"
            },
            {
              "code": "242004",
              "display": "Noninfectious jejunitis"
            },
            {
              "code": "253005",
              "display": "Sycosis"
            },
            {
              "code": "257006",
              "display": "Acne rosacea, erythematous telangiectatic type"
            },
            {
              "code": "258001",
              "display": "Pseudoknuckle pad"
            },
            {
              "code": "264008",
              "display": "Blind hypertensive eye"
            },
            {
              "code": "276008",
              "display": "Oxytocin poisoning"
            },
            {
              "code": "279001",
              "display": "Senile myocarditis"
            },
            {
              "code": "281004",
              "display": "Alcoholic dementia"
            },
            {
              "code": "282006",
              "display": "Acute myocardial infarction of basal-lateral wall"
            },
            {
              "code": "290006",
              "display": "Melnick-Fraser syndrome"
            },
            {
              "code": "292003",
              "display": "EEG finding"
            },
            {
              "code": "297009",
              "display": "Acute myringitis"
            },
            {
              "code": "299007",
              "display": "Paraffinoma of skin"
            },
            {
              "code": "303002",
              "display": "Apoplectic pancreatitis"
            },
            {
              "code": "308006",
              "display": "Pearly penile papules"
            },
            {
              "code": "310008",
              "display": "Penile boil"
            },
            {
              "code": "313005",
              "display": "Déjà vu"
            },
            {
              "code": "317006",
              "display": "Reactive hypoglycemia"
            },
            {
              "code": "320003",
              "display": "Cervical dilatation, 1cm"
            },
            {
              "code": "324007",
              "display": "Plaster ulcer"
            },
            {
              "code": "330007",
              "display": "Occipital headache"
            },
            {
              "code": "335002",
              "display": "Pylorospasm"
            },
            {
              "code": "341009",
              "display": "ABO incompatibility reaction"
            },
            {
              "code": "349006",
              "display": "Absent tendon reflex"
            },
            {
              "code": "355001",
              "display": "Hemorrhagic shock"
            },
            {
              "code": "357009",
              "display": "Closed fracture trapezoid"
            },
            {
              "code": "358004",
              "display": "Smallpox vaccine poisoning"
            },
            {
              "code": "359007",
              "display": "Kernicterus due to isoimmunization"
            },
            {
              "code": "360002",
              "display": "Acute radiation disease"
            },
            {
              "code": "364006",
              "display": "Acute left-sided heart failure"
            },
            {
              "code": "366008",
              "display": "Hidromeiosis"
            },
            {
              "code": "368009",
              "display": "Heart valve disorder"
            },
            {
              "code": "369001",
              "display": "Normal jugular venous pressure"
            },
            {
              "code": "378007",
              "display": "Morquio syndrome"
            },
            {
              "code": "382009",
              "display": "Legal history finding relating to child"
            },
            {
              "code": "383004",
              "display": "Finding of passive range of hip extension"
            },
            {
              "code": "385006",
              "display": "Secondary peripheral neuropathy"
            },
            {
              "code": "387003",
              "display": "Melanuria"
            },
            {
              "code": "398002",
              "display": "Left axis deviation greater than -90 degrees by EKG"
            },
            {
              "code": "407000",
              "display": "Congenital hepatomegaly"
            },
            {
              "code": "408005",
              "display": "Tooth chattering"
            },
            {
              "code": "409002",
              "display": "Food allergy diet"
            },
            {
              "code": "426008",
              "display": "Superficial injury of ankle without infection"
            },
            {
              "code": "431005",
              "display": "Hypertrophy of scrotum"
            },
            {
              "code": "437009",
              "display": "Abnormal composition of urine"
            },
            {
              "code": "440009",
              "display": "Persistent hyperphenylalaninemia"
            },
            {
              "code": "442001",
              "display": "Secondary hypopituitarism"
            },
            {
              "code": "443006",
              "display": "Cystocele affecting pregnancy"
            },
            {
              "code": "447007",
              "display": "Coach in sports activity accident"
            },
            {
              "code": "450005",
              "display": "Ulcerative stomatitis"
            },
            {
              "code": "452002",
              "display": "Blister of groin without infection"
            },
            {
              "code": "460001",
              "display": "Squamous metaplasia of prostate gland"
            },
            {
              "code": "467003",
              "display": "Old laceration of pelvic floor muscle"
            },
            {
              "code": "470004",
              "display": "Vitreous touch syndrome"
            },
            {
              "code": "479003",
              "display": "Graves' disease with pretibial myxedema AND with thyrotoxic crisis"
            },
            {
              "code": "486006",
              "display": "Acute vascular insufficiency"
            },
            {
              "code": "488007",
              "display": "Fibroid myocarditis"
            },
            {
              "code": "490008",
              "display": "Upper respiratory tract hypersensitivity reaction"
            },
            {
              "code": "496002",
              "display": "Closed traumatic dislocation of third cervical vertebra"
            },
            {
              "code": "504009",
              "display": "Androgen-dependent hirsutism"
            },
            {
              "code": "517007",
              "display": "Foreign body in hypopharynx"
            },
            {
              "code": "518002",
              "display": "Multiple aggregation"
            },
            {
              "code": "520004",
              "display": "Congenital bent nose"
            },
            {
              "code": "527001",
              "display": "Spontaneous fetal evolution, Roederer's method"
            },
            {
              "code": "536002",
              "display": "Glissonian cirrhosis"
            },
            {
              "code": "539009",
              "display": "Conjunctival argyrosis"
            },
            {
              "code": "547009",
              "display": "Hypersecretion of calcitonin"
            },
            {
              "code": "548004",
              "display": "13p partial trisomy syndrome"
            },
            {
              "code": "554003",
              "display": "2p partial trisomy syndrome"
            },
            {
              "code": "555002",
              "display": "Dicentra species poisoning"
            },
            {
              "code": "563001",
              "display": "Nystagmus"
            },
            {
              "code": "568005",
              "display": "Habit disorder"
            },
            {
              "code": "586008",
              "display": "Contact dermatitis due to primrose"
            },
            {
              "code": "590005",
              "display": "Congenital aneurysm of anterior communicating artery"
            },
            {
              "code": "596004",
              "display": "Premenstrual dysphoric disorder"
            },
            {
              "code": "599006",
              "display": "Persistent pneumothorax"
            },
            {
              "code": "600009",
              "display": "Pyromania"
            },
            {
              "code": "602001",
              "display": "Ross river fever"
            },
            {
              "code": "607007",
              "display": "Decreased vital capacity"
            },
            {
              "code": "610000",
              "display": "Spastic aphonia"
            },
            {
              "code": "613003",
              "display": "FRAXA - Fragile X syndrome"
            },
            {
              "code": "615005",
              "display": "Obstruction due to foreign body accidentally left in operative wound AND/OR body cavity during a procedure"
            },
            {
              "code": "616006",
              "display": "Sensorimotor disorder of eyelid"
            },
            {
              "code": "626004",
              "display": "Hypercortisolism due to nonpituitary tumor"
            },
            {
              "code": "631002",
              "display": "Transfusion reaction due to minor incompatibility"
            },
            {
              "code": "634005",
              "display": "Saddle boil"
            },
            {
              "code": "640003",
              "display": "Injury of pneumogastric nerve"
            },
            {
              "code": "643001",
              "display": "Hypertrophy of lip"
            },
            {
              "code": "646009",
              "display": "Idiopathic cyst of anterior chamber"
            },
            {
              "code": "649002",
              "display": "Open fracture of distal end of ulna"
            },
            {
              "code": "651003",
              "display": "Root work"
            },
            {
              "code": "652005",
              "display": "Gangrenous tonsillitis"
            },
            {
              "code": "655007",
              "display": "Abnormal fetal heart beat noted before labor in liveborn infant"
            },
            {
              "code": "658009",
              "display": "Injury of colon without open wound into abdominal cavity"
            },
            {
              "code": "663008",
              "display": "Pulmonary embolism following molar AND/OR ectopic pregnancy"
            },
            {
              "code": "664002",
              "display": "Delayed ovulation"
            },
            {
              "code": "666000",
              "display": "Poisoning by antivaricose drug AND/OR sclerosing agent"
            },
            {
              "code": "675003",
              "display": "Torsion of intestine"
            },
            {
              "code": "682004",
              "display": "Thrombosis complicating pregnancy AND/OR puerperium"
            },
            {
              "code": "685002",
              "display": "Acquired telangiectasia of small AND/OR large intestines"
            },
            {
              "code": "701003",
              "display": "Adult osteochondritis of spine"
            },
            {
              "code": "703000",
              "display": "Congenital adhesion of tongue"
            },
            {
              "code": "714002",
              "display": "Abrasion AND/OR friction burn of toe with infection"
            },
            {
              "code": "715001",
              "display": "Nontraumatic rupture of urethra"
            },
            {
              "code": "718004",
              "display": "Acute bronchiolitis with obstruction"
            },
            {
              "code": "733007",
              "display": "Superficial foreign body of groin without major open wound but with infection"
            },
            {
              "code": "734001",
              "display": "Opocephalus"
            },
            {
              "code": "736004",
              "display": "Abscess of hip"
            },
            {
              "code": "750009",
              "display": "Schistosoma mansoni infection"
            },
            {
              "code": "755004",
              "display": "Postgastrectomy phytobezoar"
            },
            {
              "code": "756003",
              "display": "Chronic rheumatic myopericarditis"
            },
            {
              "code": "758002",
              "display": "Cyst of uterus"
            },
            {
              "code": "775008",
              "display": "Open wound of head with complication"
            },
            {
              "code": "776009",
              "display": "Partial arterial retinal occlusion"
            },
            {
              "code": "781000",
              "display": "Cestrum diurnum poisoning"
            },
            {
              "code": "786005",
              "display": "Clinical stage I B"
            },
            {
              "code": "787001",
              "display": "Rheumatic mitral stenosis with regurgitation"
            },
            {
              "code": "788006",
              "display": "Disease-related diet"
            },
            {
              "code": "792004",
              "display": "CJD - Creutzfeldt-Jakob disease"
            },
            {
              "code": "799008",
              "display": "Sigmoid colon ulcer"
            },
            {
              "code": "801006",
              "display": "Insect bite, nonvenomous, of foot, infected"
            },
            {
              "code": "805002",
              "display": "Pneumoconiosis due to silica"
            },
            {
              "code": "811004",
              "display": "Flail motion"
            },
            {
              "code": "813001",
              "display": "Ankle instability"
            },
            {
              "code": "815008",
              "display": "Episcleritis"
            },
            {
              "code": "816009",
              "display": "Genetic recombination"
            },
            {
              "code": "818005",
              "display": "Third degree burn of multiple sites of lower limb"
            },
            {
              "code": "825003",
              "display": "Superficial injury of axilla with infection"
            },
            {
              "code": "827006",
              "display": "Late congenital syphilis, latent (+ sero., - C.S.F., 2 years OR more)"
            },
            {
              "code": "832007",
              "display": "Moderate major depression"
            },
            {
              "code": "834008",
              "display": "Chair-seated facing coital position"
            },
            {
              "code": "841002",
              "display": "Congenital absence of skull bone"
            },
            {
              "code": "842009",
              "display": "Consanguinity"
            },
            {
              "code": "843004",
              "display": "Poliomyelomalacia"
            },
            {
              "code": "844005",
              "display": "Finding relating to behavior"
            },
            {
              "code": "845006",
              "display": "Inferior mesenteric artery injury"
            },
            {
              "code": "849000",
              "display": "Total cataract"
            },
            {
              "code": "857002",
              "display": "Erythema simplex"
            },
            {
              "code": "862001",
              "display": "Anemia due to chlorate"
            },
            {
              "code": "865004",
              "display": "Hyperalimentation formula for ileus"
            },
            {
              "code": "871005",
              "display": "Contracted pelvis"
            },
            {
              "code": "874002",
              "display": "Therapeutic diuresis"
            },
            {
              "code": "875001",
              "display": "Chalcosis of eye"
            },
            {
              "code": "888003",
              "display": "Foetal or neonatal effect of maternal blood loss"
            },
            {
              "code": "890002",
              "display": "Deep third degree burn of elbow"
            },
            {
              "code": "899001",
              "display": "Axis I diagnosis"
            },
            {
              "code": "903008",
              "display": "Chorioretinal infarction"
            },
            {
              "code": "904002",
              "display": "Pinard's sign"
            },
            {
              "code": "908004",
              "display": "Superficial injury of interscapular region without infection"
            },
            {
              "code": "919001",
              "display": "Pseudohomosexual state"
            },
            {
              "code": "928000",
              "display": "Musculoskeletal disorder"
            },
            {
              "code": "931004",
              "display": "Gestation period, 9 weeks"
            },
            {
              "code": "932006",
              "display": "Flat affect"
            },
            {
              "code": "934007",
              "display": "Thalassemia intermedia"
            },
            {
              "code": "943003",
              "display": "Congenital retinal aneurysm"
            },
            {
              "code": "954008",
              "display": "Renon-Delille syndrome"
            },
            {
              "code": "961007",
              "display": "Erythema nodosum, acute form"
            },
            {
              "code": "962000",
              "display": "Disability evaluation, disability 6%"
            },
            {
              "code": "964004",
              "display": "Open wound of pharynx without complication"
            },
            {
              "code": "965003",
              "display": "Toxic amblyopia"
            },
            {
              "code": "975000",
              "display": "Anorectal agenesis"
            },
            {
              "code": "978003",
              "display": "Chronic infantile eczema"
            },
            {
              "code": "981008",
              "display": "Hemorrhagic proctitis"
            },
            {
              "code": "984000",
              "display": "Perirectal cellulitis"
            },
            {
              "code": "987007",
              "display": "Cellulitis of temple region"
            },
            {
              "code": "991002",
              "display": "Wide QRS complex"
            },
            {
              "code": "998008",
              "display": "Chagas' disease with heart involvement"
            },
            {
              "code": "1003002",
              "display": "Religious discrimination"
            },
            {
              "code": "1020003",
              "display": "Disease due to Nairovirus"
            },
            {
              "code": "1023001",
              "display": "Apneic"
            },
            {
              "code": "1027000",
              "display": "Biliary esophagitis"
            },
            {
              "code": "1031006",
              "display": "Open wound of trachea without complication"
            },
            {
              "code": "1033009",
              "display": "Thoracic arthritis"
            },
            {
              "code": "1034003",
              "display": "Mesenteric-portal fistula"
            },
            {
              "code": "1038000",
              "display": "Disacchariduria"
            },
            {
              "code": "1045000",
              "display": "Colonospasm"
            },
            {
              "code": "1046004",
              "display": "Ureteritis glandularis"
            },
            {
              "code": "1051005",
              "display": "Hyperplasia of islet alpha cells with gastrin excess"
            },
            {
              "code": "1055001",
              "display": "Stenosis of precerebral artery"
            },
            {
              "code": "1059007",
              "display": "Opisthorchiasis"
            },
            {
              "code": "1070000",
              "display": "Facial myokymia"
            },
            {
              "code": "1073003",
              "display": "Xeroderma pigmentosum group B"
            },
            {
              "code": "1074009",
              "display": "Glucocorticoid-responsive primary hyperaldosteronism"
            },
            {
              "code": "1077002",
              "display": "Septal infarction by EKG"
            },
            {
              "code": "1079004",
              "display": "Macular retinal cyst"
            },
            {
              "code": "1085006",
              "display": "Vulval candidiasis"
            },
            {
              "code": "1089000",
              "display": "Congenital sepsis"
            },
            {
              "code": "1102005",
              "display": "Intraerythrocytic parasitosis by Nuttallia"
            },
            {
              "code": "1107004",
              "display": "Early latent syphilis, positive serology, negative cerebrospinal fluid, with relapse after treatment"
            },
            {
              "code": "1108009",
              "display": "Female pattern alopecia"
            },
            {
              "code": "1111005",
              "display": "Normal sebaceous gland activity"
            },
            {
              "code": "1112003",
              "display": "Degenerative disorder of eyelid"
            },
            {
              "code": "1116000",
              "display": "Chronic aggressive type B viral hepatitis"
            },
            {
              "code": "1124005",
              "display": "Postpartum period, 6 days"
            },
            {
              "code": "1125006",
              "display": "Septicemia during labor"
            },
            {
              "code": "1126007",
              "display": "Knee locking"
            },
            {
              "code": "1131009",
              "display": "Congenital valvular insufficiency"
            },
            {
              "code": "1134001",
              "display": "Muehrcke lines"
            },
            {
              "code": "1135000",
              "display": "Solar retinitis"
            },
            {
              "code": "1139006",
              "display": "Confrontation (visual) test"
            },
            {
              "code": "1140008",
              "display": "Thermal hypesthesia"
            },
            {
              "code": "1141007",
              "display": "Circumoral paresthesia"
            },
            {
              "code": "1145003",
              "display": "DSD - Developmental speech disorder"
            },
            {
              "code": "1150009",
              "display": "Congenital microcheilia"
            },
            {
              "code": "1151008",
              "display": "Constricted visual field"
            },
            {
              "code": "1152001",
              "display": "Skin reaction negative"
            },
            {
              "code": "1155004",
              "display": "Myocardial hypertrophy, determined by electrocardiogram"
            },
            {
              "code": "1156003",
              "display": "Cavitary prostatitis"
            },
            {
              "code": "1168007",
              "display": "Allotype"
            },
            {
              "code": "1184008",
              "display": "Glasgow coma scale, 10"
            },
            {
              "code": "1192004",
              "display": "Familial amyloid neuropathy, Finnish type"
            },
            {
              "code": "1194003",
              "display": "Disease condition determination, well controlled"
            },
            {
              "code": "1196001",
              "display": "Chronic bipolar II disorder, most recent episode major depressive"
            },
            {
              "code": "1197005",
              "display": "Carbuncle of heel"
            },
            {
              "code": "1201005",
              "display": "Benign essential hypertension"
            },
            {
              "code": "1203008",
              "display": "Deep third degree burn of forehead AND/OR cheek with loss of body part"
            },
            {
              "code": "1207009",
              "display": "Optic disc glaucomatous atrophy"
            },
            {
              "code": "1208004",
              "display": "Gastroptosis"
            },
            {
              "code": "1212005",
              "display": "Juvenile dermatomyositis"
            },
            {
              "code": "1214006",
              "display": "Infection by Strongyloides"
            },
            {
              "code": "1230003",
              "display": "No diagnosis on Axis 1"
            },
            {
              "code": "1232006",
              "display": "Congenital articular rigidity with myopathy"
            },
            {
              "code": "1239002",
              "display": "Congenital anteversion of femoral neck"
            },
            {
              "code": "1240000",
              "display": "Lying prone"
            },
            {
              "code": "1259003",
              "display": "Schistosis"
            },
            {
              "code": "1261007",
              "display": "Multiple fractures of ribs"
            },
            {
              "code": "1264004",
              "display": "Injury of descending left colon without open wound into abdominal cavity"
            },
            {
              "code": "1271009",
              "display": "Knuckle pads, leuconychia and deafness"
            },
            {
              "code": "1280009",
              "display": "Isologous chimera"
            },
            {
              "code": "1282001",
              "display": "Laryngeal perichondritis"
            },
            {
              "code": "1283006",
              "display": "Visual acuity less than .02 (1/60, count fingers 1 meter) or visual field less than 5 degrees, but better than 5."
            },
            {
              "code": "1284000",
              "display": "Abnormal jaw closure"
            },
            {
              "code": "1286003",
              "display": "Vitamin K deficiency coagulation disorder"
            },
            {
              "code": "1287007",
              "display": "Congenital absence of bile duct"
            },
            {
              "code": "1297003",
              "display": "Infection by Cladosporium carrionii"
            },
            {
              "code": "1308001",
              "display": "Complication of reimplant"
            },
            {
              "code": "1310004",
              "display": "Impaired glucose tolerance associated with genetic syndrome"
            },
            {
              "code": "1317001",
              "display": "Injury of ovary without open wound into abdominal cavity"
            },
            {
              "code": "1318006",
              "display": "Post-translational genetic protein processing"
            },
            {
              "code": "1323006",
              "display": "Kanamycin poisoning"
            },
            {
              "code": "1332008",
              "display": "Conjugated visual deviation"
            },
            {
              "code": "1335005",
              "display": "Peyronies disease"
            },
            {
              "code": "1343000",
              "display": "DTA - Deep transverse arrest"
            },
            {
              "code": "1345007",
              "display": "Hang nail"
            },
            {
              "code": "1351002",
              "display": "Iliac artery injury"
            },
            {
              "code": "1356007",
              "display": "Calculus of common duct with obstruction"
            },
            {
              "code": "1361009",
              "display": "Leucocoria"
            },
            {
              "code": "1363007",
              "display": "Fetal or neonatal effect of chronic maternal respiratory disease"
            },
            {
              "code": "1367008",
              "display": "Injury of superior mesenteric artery"
            },
            {
              "code": "1370007",
              "display": "Open fracture of metacarpal bone(s)"
            },
            {
              "code": "1372004",
              "display": "Unicornate uterus"
            },
            {
              "code": "1376001",
              "display": "Obsessive compulsive personality disorder"
            },
            {
              "code": "1378000",
              "display": "Supination-eversion injury of ankle"
            },
            {
              "code": "1380006",
              "display": "Agoraphobia without history of panic disorder with limited symptom attacks"
            },
            {
              "code": "1383008",
              "display": "Hallucinogen induced mood disorder"
            },
            {
              "code": "1384002",
              "display": "Diffuse cholesteatosis of middle ear"
            },
            {
              "code": "1386000",
              "display": "Intracranial hemorrhage"
            },
            {
              "code": "1387009",
              "display": "Solanum nigrum poisoning"
            },
            {
              "code": "1388004",
              "display": "Metabolic alkalosis"
            },
            {
              "code": "1393001",
              "display": "Lenz-Majewski dysplasia"
            },
            {
              "code": "1395008",
              "display": "Complication of ultrasound therapy"
            },
            {
              "code": "1402001",
              "display": "Frightened"
            },
            {
              "code": "1412008",
              "display": "Anterior subcapsular polar cataract"
            },
            {
              "code": "1415005",
              "display": "Inflammation of lymphatics"
            },
            {
              "code": "1418007",
              "display": "Hypoplastic chondrodystrophy"
            },
            {
              "code": "1419004",
              "display": "Injury of prostate without open wound into abdominal cavity"
            },
            {
              "code": "1426004",
              "display": "Necrotizing glomerulonephritis"
            },
            {
              "code": "1427008",
              "display": "Intraspinal abscess"
            },
            {
              "code": "1430001",
              "display": "Intracranial hemorrhage following injury without open intracranial wound AND with prolonged loss of consciousness (more than 24 hours) without return to pre-existing level"
            },
            {
              "code": "1447000",
              "display": "Icthyoparasitism"
            },
            {
              "code": "1469007",
              "display": "Miscarriage with urinary tract infection"
            },
            {
              "code": "1474004",
              "display": "Hypertensive heart AND renal disease complicating AND/OR reason for care during childbirth"
            },
            {
              "code": "1475003",
              "display": "Herpes labialis"
            },
            {
              "code": "1478001",
              "display": "Obliteration of lymphatic vessel"
            },
            {
              "code": "1479009",
              "display": "20q partial trisomy syndrome"
            },
            {
              "code": "1482004",
              "display": "Chalazion"
            },
            {
              "code": "1486001",
              "display": "Orbital congestion"
            },
            {
              "code": "1488000",
              "display": "PONV - Postoperative nausea and vomiting"
            },
            {
              "code": "1489008",
              "display": "External hordeolum"
            },
            {
              "code": "1492007",
              "display": "Congenital anomaly of large intestine"
            },
            {
              "code": "1493002",
              "display": "Acute endophthalmitis"
            },
            {
              "code": "1499003",
              "display": "Bipolar I disorder, single manic episode with postpartum onset"
            },
            {
              "code": "1512006",
              "display": "Congenital stricture of bile duct"
            },
            {
              "code": "1515008",
              "display": "Gorham disease"
            },
            {
              "code": "1518005",
              "display": "Splenitis"
            },
            {
              "code": "1519002",
              "display": "Congenital phlebectasia"
            },
            {
              "code": "1521007",
              "display": "Blister of buttock without infection"
            },
            {
              "code": "1523005",
              "display": "Clinical stage IV B"
            },
            {
              "code": "1525003",
              "display": "Blister of foot without infection"
            },
            {
              "code": "1531000",
              "display": "Nitrofuran derivative poisoning"
            },
            {
              "code": "1532007",
              "display": "Viral pharyngitis"
            },
            {
              "code": "1534008",
              "display": "Palsy of conjugate gaze"
            },
            {
              "code": "1538006",
              "display": "Central nervous system malformation in foetus affecting obstetrical care"
            },
            {
              "code": "1539003",
              "display": "Nodular tendinous disease of finger"
            },
            {
              "code": "1542009",
              "display": "Omphalocele with obstruction"
            },
            {
              "code": "1544005",
              "display": "Open dislocation of knee"
            },
            {
              "code": "1551001",
              "display": "Osteomyelitis of femur"
            },
            {
              "code": "1556006",
              "display": "Clark melanoma level 4"
            },
            {
              "code": "1563006",
              "display": "Protein S deficiency"
            },
            {
              "code": "1567007",
              "display": "Chronic gastric ulcer without hemorrhage, without perforation AND without obstruction"
            },
            {
              "code": "1588003",
              "display": "Heterosexual precocious puberty"
            },
            {
              "code": "1592005",
              "display": "Failed attempted termination of pregnancy with uremia"
            },
            {
              "code": "1593000",
              "display": "Infantile hemiplegia"
            },
            {
              "code": "1606009",
              "display": "Infection caused by Macracanthorhynchus hirudinaceus"
            },
            {
              "code": "1608005",
              "display": "Increased capillary permeability"
            },
            {
              "code": "1639007",
              "display": "Abnormality of organs AND/OR soft tissues of pelvis affecting pregnancy"
            },
            {
              "code": "1647007",
              "display": "Primaquine poisoning"
            },
            {
              "code": "1648002",
              "display": "Lymphocytic pseudotumor of lung"
            },
            {
              "code": "1654001",
              "display": "Steroid-induced glaucoma"
            },
            {
              "code": "1657008",
              "display": "Toxic effect of phosdrin"
            },
            {
              "code": "1658003",
              "display": "Closed fracture clavicle, lateral end"
            },
            {
              "code": "1663004",
              "display": "Tumor grade G2"
            },
            {
              "code": "1667003",
              "display": "Early fontanel closure"
            },
            {
              "code": "1670004",
              "display": "Cerebral hemiparesis"
            },
            {
              "code": "1671000",
              "display": "Sago spleen"
            },
            {
              "code": "1674008",
              "display": "Meesman's epithelial corneal dystrophy"
            },
            {
              "code": "1679003",
              "display": "Arthritis associated with another disorder"
            },
            {
              "code": "1682008",
              "display": "Transitory amino acid metabolic disorder"
            },
            {
              "code": "1685005",
              "display": "Rat-bite fever"
            },
            {
              "code": "1686006",
              "display": "Sedative, hypnotic AND/OR anxiolytic-induced anxiety disorder"
            },
            {
              "code": "1694004",
              "display": "Accessory lobe of lung"
            },
            {
              "code": "1698001",
              "display": "Ulcer of bile duct"
            },
            {
              "code": "1703007",
              "display": "Increased leg circumference"
            },
            {
              "code": "1705000",
              "display": "Closed fracture of base of neck of femur"
            },
            {
              "code": "1708003",
              "display": "Open dislocation of clavicle"
            },
            {
              "code": "1714005",
              "display": "Photokeratitis"
            },
            {
              "code": "1717003",
              "display": "Guttate hypomelanosis"
            },
            {
              "code": "1723008",
              "display": "Urethral stricture due to schistosomiasis"
            },
            {
              "code": "1724002",
              "display": "Infection caused by Crenosoma"
            },
            {
              "code": "1734006",
              "display": "Fracture of vertebral column with spinal cord injury"
            },
            {
              "code": "1735007",
              "display": "Thrill"
            },
            {
              "code": "1739001",
              "display": "Occipital fracture"
            },
            {
              "code": "1742007",
              "display": "Female hypererotism"
            },
            {
              "code": "1744008",
              "display": "Connation of teeth"
            },
            {
              "code": "1748006",
              "display": "Thrombophlebitis of deep femoral vein"
            },
            {
              "code": "1755008",
              "display": "Healed coronary"
            },
            {
              "code": "1761006",
              "display": "Biliary cirrhosis"
            },
            {
              "code": "1763009",
              "display": "Stromal keratitis"
            },
            {
              "code": "1767005",
              "display": "Fisher syndrome"
            },
            {
              "code": "1769008",
              "display": "Thoracodidymus"
            },
            {
              "code": "1771008",
              "display": "Insulin biosynthesis defect"
            },
            {
              "code": "1776003",
              "display": "RTA - Renal tubular acidosis"
            },
            {
              "code": "1777007",
              "display": "Increased molecular dissociation"
            },
            {
              "code": "1778002",
              "display": "Malocclusion due to abnormal swallowing"
            },
            {
              "code": "1779005",
              "display": "OFD II - Orofacial-digital syndrome II"
            },
            {
              "code": "1794009",
              "display": "Idiopathic corneal edema"
            },
            {
              "code": "1816003",
              "display": "Panic disorder with agoraphobia, severe agoraphobic avoidance AND mild panic attacks"
            },
            {
              "code": "1821000",
              "display": "Chemoreceptor apnea"
            },
            {
              "code": "1822007",
              "display": "Impaired glucose tolerance associated with pancreatic disease"
            },
            {
              "code": "1824008",
              "display": "Allergic gastritis"
            },
            {
              "code": "1826005",
              "display": "Granuloma of lip"
            },
            {
              "code": "1828006",
              "display": "Infestation caused by Gasterophilus hemorrhoidalis"
            },
            {
              "code": "1829003",
              "display": "Microcephalus"
            },
            {
              "code": "1833005",
              "display": "Phacoanaphylactic endophthalmitis"
            },
            {
              "code": "1835003",
              "display": "Necrosis of pancreas"
            },
            {
              "code": "1837006",
              "display": "Orciprenaline poisoning"
            },
            {
              "code": "1845001",
              "display": "Paraparesis"
            },
            {
              "code": "1847009",
              "display": "Endophthalmitis"
            },
            {
              "code": "1848004",
              "display": "Poisoning caused by gaseous anesthetic"
            },
            {
              "code": "1852004",
              "display": "Traumatic injury of sixth cranial nerve"
            },
            {
              "code": "1855002",
              "display": "Developmental academic disorder"
            },
            {
              "code": "1856001",
              "display": "Accessory nose"
            },
            {
              "code": "1857005",
              "display": "Congenital rubella syndrome"
            },
            {
              "code": "1858000",
              "display": "Infection caused by Stilesia globipunctata"
            },
            {
              "code": "1860003",
              "display": "Fluid volume disorder"
            },
            {
              "code": "1865008",
              "display": "Impaired intestinal protein absorption"
            },
            {
              "code": "1869002",
              "display": "Rupture of iris sphincter"
            },
            {
              "code": "1881003",
              "display": "Increased nutritional requirement"
            },
            {
              "code": "1892002",
              "display": "Star figure at the macula"
            },
            {
              "code": "1896004",
              "display": "Ectopic breast tissue"
            },
            {
              "code": "1897008",
              "display": "Amsinckia species poisoning"
            },
            {
              "code": "1899006",
              "display": "Autosomal hereditary disorder"
            },
            {
              "code": "1903004",
              "display": "Infestation caused by Psorergates ovis"
            },
            {
              "code": "1908008",
              "display": "von Willebrand disease, type IIC"
            },
            {
              "code": "1909000",
              "display": "Impairment level: better eye: severe impairment: lesser eye: near-total impairment"
            },
            {
              "code": "1922008",
              "display": "Congenital absence of urethra"
            },
            {
              "code": "1926006",
              "display": "Osteopetrosis"
            },
            {
              "code": "1938002",
              "display": "Emotional AND/OR mental disease in mother complicating pregnancy, childbirth AND/OR puerperium"
            },
            {
              "code": "1939005",
              "display": "Abnormal vascular flow"
            },
            {
              "code": "1943009",
              "display": "Left-right confusion"
            },
            {
              "code": "1953005",
              "display": "Congenital deficiency of pigment of skin"
            },
            {
              "code": "1954004",
              "display": "Dilated cardiomyopathy secondary to toxic reaction"
            },
            {
              "code": "1955003",
              "display": "Preauricular pit"
            },
            {
              "code": "1959009",
              "display": "Encephalartos species poisoning"
            },
            {
              "code": "1961000",
              "display": "Chronic polyarticular juvenile rheumatoid arthritis"
            },
            {
              "code": "1963002",
              "display": "PNH - Paroxysmal nocturnal hemoglobinuria"
            },
            {
              "code": "1965009",
              "display": "Normal skin pH"
            },
            {
              "code": "1967001",
              "display": "Congenital absence of forearm only"
            },
            {
              "code": "1973000",
              "display": "Sedative, hypnotic AND/OR anxiolytic-induced psychotic disorder with delusions"
            },
            {
              "code": "1977004",
              "display": "Oxymetholone poisoning"
            },
            {
              "code": "1979001",
              "display": "Focal choroiditis"
            },
            {
              "code": "1980003",
              "display": "Seromucinous otitis media"
            },
            {
              "code": "1981004",
              "display": "Urhidrosis"
            },
            {
              "code": "1988005",
              "display": "Late effect of injury to nerve roots, spinal plexus AND/OR other nerves of trunk"
            },
            {
              "code": "1989002",
              "display": "Burn of vagina AND/OR uterus"
            },
            {
              "code": "2004005",
              "display": "Normotensive"
            },
            {
              "code": "2012002",
              "display": "Fracture of lunate"
            },
            {
              "code": "2024009",
              "display": "Dilated cardiomyopathy secondary to metazoal myocarditis"
            },
            {
              "code": "2028007",
              "display": "Erythema induratum"
            },
            {
              "code": "2032001",
              "display": "Cerebral edema"
            },
            {
              "code": "2036003",
              "display": "Acquired factor VII deficiency disease"
            },
            {
              "code": "2040007",
              "display": "Neurogenic thoracic outlet syndrome"
            },
            {
              "code": "2041006",
              "display": "Eunuchoid gigantism"
            },
            {
              "code": "2043009",
              "display": "Alcoholic gastritis"
            },
            {
              "code": "2053005",
              "display": "Late effect of injury to blood vessels of thorax, abdomen AND/OR pelvis"
            },
            {
              "code": "2055003",
              "display": "Recurrent erosion syndrome"
            },
            {
              "code": "2058001",
              "display": "Bilateral loss of labyrinthine reactivity"
            },
            {
              "code": "2061000",
              "display": "Conductive hearing loss of combined sites"
            },
            {
              "code": "2065009",
              "display": "Autosomal dominant optic atrophy"
            },
            {
              "code": "2066005",
              "display": "Gastric ulcer with hemorrhage AND perforation but without obstruction"
            },
            {
              "code": "2070002",
              "display": "Burning sensation in eye"
            },
            {
              "code": "2073000",
              "display": "Delusions"
            },
            {
              "code": "2087000",
              "display": "Pulmonary nocardiosis"
            },
            {
              "code": "2089002",
              "display": "Pagets disease of bone"
            },
            {
              "code": "2091005",
              "display": "Pharyngeal diverticulitis"
            },
            {
              "code": "2094002",
              "display": "Carbon disulfide causing toxic effect"
            },
            {
              "code": "2102007",
              "display": "Deep corneal vascularization"
            },
            {
              "code": "2103002",
              "display": "Reflex sympathetic dystrophy of upper extremity"
            },
            {
              "code": "2107001",
              "display": "Anisomelia"
            },
            {
              "code": "2109003",
              "display": "Isolated somatotropin deficiency"
            },
            {
              "code": "2114004",
              "display": "Infection caused by Cysticercus pisiformis"
            },
            {
              "code": "2116002",
              "display": "Intramembranous bone formation"
            },
            {
              "code": "2120003",
              "display": "Weak cry"
            },
            {
              "code": "2121004",
              "display": "Ethopropazine poisoning"
            },
            {
              "code": "2128005",
              "display": "Disorder of adenoid"
            },
            {
              "code": "2129002",
              "display": "Edema of pharynx"
            },
            {
              "code": "2132004",
              "display": "Meconium in amniotic fluid noted before labor in liveborn infant"
            },
            {
              "code": "2134003",
              "display": "Diffuse pain"
            },
            {
              "code": "2136001",
              "display": "Open wound of jaw with complication"
            },
            {
              "code": "2138000",
              "display": "LSP - Left sacroposterior position"
            },
            {
              "code": "2145000",
              "display": "Anal intercourse"
            },
            {
              "code": "2149006",
              "display": "Decreased hormone production"
            },
            {
              "code": "2158004",
              "display": "Infection caused by Contracaecum"
            },
            {
              "code": "2167004",
              "display": "Retinal hemangioblastomatosis"
            },
            {
              "code": "2169001",
              "display": "Thoracic radiculitis"
            },
            {
              "code": "2170000",
              "display": "Gallop rhythm"
            },
            {
              "code": "2176006",
              "display": "Halogen acne"
            },
            {
              "code": "2177002",
              "display": "PHN - Post-herpetic neuralgia"
            },
            {
              "code": "2186007",
              "display": "Compensated metabolic alkalosis"
            },
            {
              "code": "2198002",
              "display": "Visceral epilepsy"
            },
            {
              "code": "2202000",
              "display": "Open posterior dislocation of distal end of femur"
            },
            {
              "code": "2204004",
              "display": "Acquired deformity of pinna"
            },
            {
              "code": "2213002",
              "display": "Congenital anomaly of vena cava"
            },
            {
              "code": "2216005",
              "display": "Nocturnal emission"
            },
            {
              "code": "2217001",
              "display": "Superficial injury of perineum without infection"
            },
            {
              "code": "2219003",
              "display": "Disability evaluation, disability 100%"
            },
            {
              "code": "2224000",
              "display": "Selenium poisoning"
            },
            {
              "code": "2228002",
              "display": "Scintillating scotoma"
            },
            {
              "code": "2229005",
              "display": "Chimera"
            },
            {
              "code": "2231001",
              "display": "Nerve plexus disorder"
            },
            {
              "code": "2237002",
              "display": "Painful breathing -pleurodynia"
            },
            {
              "code": "2239004",
              "display": "Previous pregnancies 6"
            },
            {
              "code": "2241003",
              "display": "X-linked absence of thyroxine-binding globulin"
            },
            {
              "code": "2243000",
              "display": "Hypercalcemia due to hyperthyroidism"
            },
            {
              "code": "2245007",
              "display": "Foreign body in nasopharynx"
            },
            {
              "code": "2251002",
              "display": "Primary hypotony of eye"
            },
            {
              "code": "2256007",
              "display": "Monovular twins"
            },
            {
              "code": "2261009",
              "display": "Obstetrical pulmonary fat embolism"
            },
            {
              "code": "2268003",
              "display": "Victim of homosexual aggression"
            },
            {
              "code": "2284002",
              "display": "Pulsating exophthalmos"
            },
            {
              "code": "2295008",
              "display": "Closed fracture of upper end of forearm"
            },
            {
              "code": "2296009",
              "display": "Iron dextran toxicity"
            },
            {
              "code": "2298005",
              "display": "Focal facial dermal dysplasia"
            },
            {
              "code": "2301009",
              "display": "Psychosomatic factor in physical condition, psychological component of unknown degree"
            },
            {
              "code": "2303007",
              "display": "Inguinal hernia with gangrene"
            },
            {
              "code": "2304001",
              "display": "Intervertebral discitis"
            },
            {
              "code": "2307008",
              "display": "Peripancreatic fat necrosis"
            },
            {
              "code": "2308003",
              "display": "Silent alleles"
            },
            {
              "code": "2312009",
              "display": "Reactive attachment disorder of infancy OR early childhood, inhibited type"
            },
            {
              "code": "2314005",
              "display": "Unprotected intercourse"
            },
            {
              "code": "2326000",
              "display": "Marriage annulment"
            },
            {
              "code": "2339001",
              "display": "Sexual overexposure"
            },
            {
              "code": "2341000",
              "display": "Infection caused by Moniliformis"
            },
            {
              "code": "2351004",
              "display": "Genetic transduction"
            },
            {
              "code": "2355008",
              "display": "Rud syndrome"
            },
            {
              "code": "2359002",
              "display": "Hyper-beta-alaninemia"
            },
            {
              "code": "2365002",
              "display": "Simple chronic pharyngitis"
            },
            {
              "code": "2366001",
              "display": "Late effect of dislocation"
            },
            {
              "code": "2367005",
              "display": "Acute hemorrhagic gastritis"
            },
            {
              "code": "2374000",
              "display": "Monofascicular block"
            },
            {
              "code": "2385003",
              "display": "Cellulitis of pectoral region"
            },
            {
              "code": "2388001",
              "display": "Normal variation in translucency"
            },
            {
              "code": "2390000",
              "display": "Acute gonococcal vulvovaginitis"
            },
            {
              "code": "2391001",
              "display": "Achondrogenesis"
            },
            {
              "code": "2396006",
              "display": "Malignant pyoderma"
            },
            {
              "code": "2398007",
              "display": "Quinidine toxicity by electrocardiogram"
            },
            {
              "code": "2403008",
              "display": "Dependence syndrome"
            },
            {
              "code": "2415007",
              "display": "Lumbosacral root lesion"
            },
            {
              "code": "2418009",
              "display": "Polyester fume causing toxic effect"
            },
            {
              "code": "2419001",
              "display": "Open wound of forehead with complication"
            },
            {
              "code": "2420007",
              "display": "Third degree burn of multiple sites of upper limb"
            },
            {
              "code": "2432006",
              "display": "Cerebrospinal fluid circulation disorder"
            },
            {
              "code": "2435008",
              "display": "Ascaridiasis"
            },
            {
              "code": "2437000",
              "display": "Placenta circumvallata"
            },
            {
              "code": "2438005",
              "display": "Iniencephaly"
            },
            {
              "code": "2439002",
              "display": "Purulent endocarditis"
            },
            {
              "code": "2443003",
              "display": "Hydrogen sulfide poisoning"
            },
            {
              "code": "2452007",
              "display": "Fetal rotation"
            },
            {
              "code": "2463005",
              "display": "Acquired heterochromia of iris"
            },
            {
              "code": "2469009",
              "display": "Onychomalacia"
            },
            {
              "code": "2470005",
              "display": "Brain damage"
            },
            {
              "code": "2471009",
              "display": "Intra-abdominal abscess postprocedure"
            },
            {
              "code": "2472002",
              "display": "Passes no urine"
            },
            {
              "code": "2473007",
              "display": "Intermittent vertical squint"
            },
            {
              "code": "2477008",
              "display": "Superficial phlebitis"
            },
            {
              "code": "2492009",
              "display": "Disorder of nutrition"
            },
            {
              "code": "2495006",
              "display": "Congenital cerebral arteriovenous aneurysm"
            },
            {
              "code": "2496007",
              "display": "Acalculia"
            },
            {
              "code": "2506003",
              "display": "Early onset dysthymia"
            },
            {
              "code": "2513003",
              "display": "Tinea capitis caused by Trichophyton"
            },
            {
              "code": "2518007",
              "display": "Cryptogenic sexual precocity"
            },
            {
              "code": "2521009",
              "display": "Bone conduction better than air"
            },
            {
              "code": "2523007",
              "display": "Salmonella pneumonia"
            },
            {
              "code": "2526004",
              "display": "Noninflammatory disorder of the female genital organs"
            },
            {
              "code": "2528003",
              "display": "Viremia"
            },
            {
              "code": "2532009",
              "display": "Choroidal rupture"
            },
            {
              "code": "2534005",
              "display": "Congenital absence of vena cava"
            },
            {
              "code": "2538008",
              "display": "Ketosis"
            },
            {
              "code": "2541004",
              "display": "Compulsive buying"
            },
            {
              "code": "2554006",
              "display": "Acute purulent pericarditis"
            },
            {
              "code": "2556008",
              "display": "Disease of supporting structures of teeth"
            },
            {
              "code": "2560006",
              "display": "Complex syndactyly of fingers"
            },
            {
              "code": "2562003",
              "display": "Athanasia trifurcata poisoning"
            },
            {
              "code": "2576002",
              "display": "Trachoma"
            },
            {
              "code": "2581006",
              "display": "Clasp knife rigidity"
            },
            {
              "code": "2582004",
              "display": "Deep third degree burn of multiple sites of lower limb"
            },
            {
              "code": "2583009",
              "display": "Filigreed network of venous valves"
            },
            {
              "code": "2584003",
              "display": "Cerebral degeneration in childhood"
            },
            {
              "code": "2585002",
              "display": "Pneumococcal pleurisy"
            },
            {
              "code": "2589008",
              "display": "Acute dacryoadenitis"
            },
            {
              "code": "2591000",
              "display": "Crush injury of shoulder region"
            },
            {
              "code": "2593002",
              "display": "Dubowitz syndrome"
            },
            {
              "code": "2602008",
              "display": "Hemarthrosis of shoulder"
            },
            {
              "code": "2606006",
              "display": "Boil of perineum"
            },
            {
              "code": "2615004",
              "display": "Graafian follicle cyst"
            },
            {
              "code": "2618002",
              "display": "Chronic recurrent major depressive disorder"
            },
            {
              "code": "2622007",
              "display": "Infected ulcer of skin"
            },
            {
              "code": "2624008",
              "display": "Prepubertal periodontitis"
            },
            {
              "code": "2625009",
              "display": "Senter syndrome"
            },
            {
              "code": "2630008",
              "display": "Open wound of finger without complication"
            },
            {
              "code": "2634004",
              "display": "Decreased blood erythrocyte volume"
            },
            {
              "code": "2638001",
              "display": "Hypercalcemia caused by a drug"
            },
            {
              "code": "2640006",
              "display": "Clinical stage 4"
            },
            {
              "code": "2651006",
              "display": "Closed traumatic dislocation of elbow joint"
            },
            {
              "code": "2655002",
              "display": "Invalidism"
            },
            {
              "code": "2657005",
              "display": "Overflow proteinuria"
            },
            {
              "code": "2663001",
              "display": "Palpatory proteinuria"
            },
            {
              "code": "2665008",
              "display": "Coordinate convulsion"
            },
            {
              "code": "2683000",
              "display": "Nonvenomous insect bite of axilla without infection"
            },
            {
              "code": "2689001",
              "display": "Dominant dystrophic epidermolysis bullosa with absence of skin"
            },
            {
              "code": "2694001",
              "display": "Myelophthisic anemia"
            },
            {
              "code": "2704003",
              "display": "Acute disease"
            },
            {
              "code": "2707005",
              "display": "Necrotizing enterocolitis"
            },
            {
              "code": "2713001",
              "display": "Closed pneumothorax"
            },
            {
              "code": "2724004",
              "display": "Auditory recruitment"
            },
            {
              "code": "2725003",
              "display": "Previous abnormality of glucose tolerance"
            },
            {
              "code": "2733002",
              "display": "Heel pain"
            },
            {
              "code": "2736005",
              "display": "Honeycomb atrophy of face"
            },
            {
              "code": "2740001",
              "display": "Gouty proteinuria"
            },
            {
              "code": "2749000",
              "display": "Congenital deformity of hip"
            },
            {
              "code": "2751001",
              "display": "Fibrocalculous pancreatic diabetes"
            },
            {
              "code": "2761008",
              "display": "Decreased stool caliber"
            },
            {
              "code": "2764000",
              "display": "Joint crackle"
            },
            {
              "code": "2770006",
              "display": "Fetal or neonatal effect of antibiotic transmitted via placenta and/or breast milk"
            },
            {
              "code": "2772003",
              "display": "Epidermolysis bullosa acquisita"
            },
            {
              "code": "2775001",
              "display": "Intra-articular loose body"
            },
            {
              "code": "2776000",
              "display": "Organic brain syndrome"
            },
            {
              "code": "2781009",
              "display": "Miscarriage complicated by delayed and/or excessive hemorrhage"
            },
            {
              "code": "2782002",
              "display": "Temporomandibular dysplasia"
            },
            {
              "code": "2783007",
              "display": "Gastrojejunal ulcer without hemorrhage AND without perforation"
            },
            {
              "code": "2786004",
              "display": "Epithelial ovarian tumor, International Federation of Gynecology and Obstetrics stage III"
            },
            {
              "code": "2790002",
              "display": "Impairment level: one eye: total impairment: other eye: not specified"
            },
            {
              "code": "2805007",
              "display": "Phosmet poisoning"
            },
            {
              "code": "2806008",
              "display": "Impaired psychomotor development"
            },
            {
              "code": "2807004",
              "display": "Chronic gastrojejunal ulcer with perforation"
            },
            {
              "code": "2808009",
              "display": "Infection caused by Prosthenorchis elegans"
            },
            {
              "code": "2815001",
              "display": "Sexual pyromania"
            },
            {
              "code": "2816000",
              "display": "Dilated cardiomyopathy secondary to myotonic dystrophy"
            },
            {
              "code": "2818004",
              "display": "Congenital vascular anomaly of eye"
            },
            {
              "code": "2819007",
              "display": "Magnesium sulfate poisoning"
            },
            {
              "code": "2825006",
              "display": "Abrasion and/or friction burn of gum without infection"
            },
            {
              "code": "2828008",
              "display": "Congenital stenosis of nares"
            },
            {
              "code": "2829000",
              "display": "Uhl disease"
            },
            {
              "code": "2831009",
              "display": "Pyloric antral vascular ectasia"
            },
            {
              "code": "2835000",
              "display": "Hemolytic anemia due to cardiac trauma"
            },
            {
              "code": "2836004",
              "display": "Butane causing toxic effect"
            },
            {
              "code": "2838003",
              "display": "Piblokto"
            },
            {
              "code": "2840008",
              "display": "Open fracture of vault of skull with cerebral laceration AND/OR contusion"
            },
            {
              "code": "2850009",
              "display": "Infection caused by Schistosoma incognitum"
            },
            {
              "code": "2853006",
              "display": "Macular keratitis"
            },
            {
              "code": "2856003",
              "display": "Vitamin A-responsive dermatosis"
            },
            {
              "code": "2858002",
              "display": "Postpartum sepsis"
            },
            {
              "code": "2884008",
              "display": "Spherophakia-brachymorphia syndrome"
            },
            {
              "code": "2893009",
              "display": "Anomaly of chromosome pair 10"
            },
            {
              "code": "2897005",
              "display": "Immune thrombocytopenia"
            },
            {
              "code": "2899008",
              "display": "Thought blocking"
            },
            {
              "code": "2900003",
              "display": "Fibromuscular dysplasia of renal artery"
            },
            {
              "code": "2901004",
              "display": "Altered blood passed per rectum"
            },
            {
              "code": "2902006",
              "display": "Decreased lymphocyte life span"
            },
            {
              "code": "2904007",
              "display": "Male infertility"
            },
            {
              "code": "2910007",
              "display": "Discharge from penis"
            },
            {
              "code": "2912004",
              "display": "Cystic-bullous disease of the lung"
            },
            {
              "code": "2917005",
              "display": "Transient hypothyroidism"
            },
            {
              "code": "2918000",
              "display": "Infection caused by Bacteroides"
            },
            {
              "code": "2919008",
              "display": "Nausea, vomiting and diarrhea"
            },
            {
              "code": "2929001",
              "display": "Arterial occlusion"
            },
            {
              "code": "2935001",
              "display": "Antiasthmatic poisoning"
            },
            {
              "code": "2940009",
              "display": "Intrabasal vesicular dermatitis"
            },
            {
              "code": "2946003",
              "display": "Osmotic diarrhea"
            },
            {
              "code": "2951009",
              "display": "Atopic cataract"
            },
            {
              "code": "2955000",
              "display": "Chronic ulcerative pulpitis"
            },
            {
              "code": "2965006",
              "display": "Nevoid congenital alopecia"
            },
            {
              "code": "2967003",
              "display": "Non-comitant strabismus"
            },
            {
              "code": "2972007",
              "display": "Occlusion of anterior spinal artery"
            },
            {
              "code": "2973002",
              "display": "Pelvic organ injury without open wound into abdominal cavity"
            },
            {
              "code": "2978006",
              "display": "Aneurysm of conjunctiva"
            },
            {
              "code": "2981001",
              "display": "Pulsatile mass of abdomen"
            },
            {
              "code": "2989004",
              "display": "Complication following molar AND/OR ectopic pregnancy"
            },
            {
              "code": "2990008",
              "display": "Lymphocytic leukemoid reaction"
            },
            {
              "code": "2992000",
              "display": "Pigmentary pallidal degeneration"
            },
            {
              "code": "2994004",
              "display": "Brain fag"
            },
            {
              "code": "2999009",
              "display": "Injury of ear region"
            },
            {
              "code": "3002002",
              "display": "Thyroid hemorrhage"
            },
            {
              "code": "3004001",
              "display": "Congenital dilatation of esophagus"
            },
            {
              "code": "3006004",
              "display": "Altered consciousness"
            },
            {
              "code": "3009006",
              "display": "Solanum malacoxylon poisoning"
            },
            {
              "code": "3013004",
              "display": "Open wound of ear drum without complication"
            },
            {
              "code": "3014005",
              "display": "Autoeczematization"
            },
            {
              "code": "3018008",
              "display": "Penetration of eyeball with magnetic foreign body"
            },
            {
              "code": "3019000",
              "display": "Closed anterior dislocation of elbow"
            },
            {
              "code": "3021005",
              "display": "Normal gastric acidity"
            },
            {
              "code": "3023008",
              "display": "Acute peptic ulcer without hemorrhage, without perforation AND without obstruction"
            },
            {
              "code": "3032005",
              "display": "Nonvenomous insect bite of cheek without infection"
            },
            {
              "code": "3033000",
              "display": "Bone AND/OR joint disorder of pelvis in mother complicating pregnancy, childbirth AND/OR puerperium"
            },
            {
              "code": "3038009",
              "display": "Acute lymphangitis of umbilicus"
            },
            {
              "code": "3044008",
              "display": "Vitreous prolapse"
            },
            {
              "code": "3053001",
              "display": "Poisoning caused by nitroglycerin"
            },
            {
              "code": "3059002",
              "display": "Acute lymphangitis of thigh"
            },
            {
              "code": "3067005",
              "display": "Weak C phenotype"
            },
            {
              "code": "3071008",
              "display": "Widow"
            },
            {
              "code": "3072001",
              "display": "Hormone-induced hypopituitarism"
            },
            {
              "code": "3073006",
              "display": "Ruvalcaba syndrome"
            },
            {
              "code": "3084004",
              "display": "Nonvenomous insect bite of gum without infection"
            },
            {
              "code": "3089009",
              "display": "Disability evaluation, impairment, class 7"
            },
            {
              "code": "3094009",
              "display": "Vomiting in infants AND/OR children"
            },
            {
              "code": "3095005",
              "display": "Induced malaria"
            },
            {
              "code": "3097002",
              "display": "Superficial injury of lip with infection"
            },
            {
              "code": "3098007",
              "display": "Ventricular septal rupture"
            },
            {
              "code": "3105002",
              "display": "Intron"
            },
            {
              "code": "3109008",
              "display": "Secondary dysthymia early onset"
            },
            {
              "code": "3110003",
              "display": "AOM - Acute otitis media"
            },
            {
              "code": "3119002",
              "display": "Brain stem laceration with open intracranial wound AND loss of consciousness"
            },
            {
              "code": "3129009",
              "display": "Infarction of ovary"
            },
            {
              "code": "3135009",
              "display": "OE - Otitis externa"
            },
            {
              "code": "3140001",
              "display": "Citrullinemia, subacute type"
            },
            {
              "code": "3144005",
              "display": "Staphylococcal pleurisy"
            },
            {
              "code": "3158007",
              "display": "Panic disorder with agoraphobia, agoraphobic avoidance in partial remission AND panic attacks in partial remission"
            },
            {
              "code": "3160009",
              "display": "Infertility of cervical origin"
            },
            {
              "code": "3163006",
              "display": "Acute adenoviral follicular conjunctivitis"
            },
            {
              "code": "3168002",
              "display": "Thrombophlebitis of intracranial venous sinus"
            },
            {
              "code": "3185000",
              "display": "Mood-congruent delusion"
            },
            {
              "code": "3199001",
              "display": "Sprain of shoulder joint"
            },
            {
              "code": "3200003",
              "display": "Sacrocoxalgia"
            },
            {
              "code": "3208005",
              "display": "Open wound of ossicles without complication"
            },
            {
              "code": "3214003",
              "display": "Invasive pulmonary aspergillosis"
            },
            {
              "code": "3217005",
              "display": "Open dislocation of sixth cervical vertebra"
            },
            {
              "code": "3218000",
              "display": "Mycotic disease"
            },
            {
              "code": "3219008",
              "display": "Disease type AND/OR category unknown"
            },
            {
              "code": "3228009",
              "display": "Closed fracture of the radial shaft"
            },
            {
              "code": "3229001",
              "display": "Tracheal ulcer"
            },
            {
              "code": "3230006",
              "display": "Illegal termination of pregnancy with afibrinogenemia"
            },
            {
              "code": "3238004",
              "display": "Pericarditis"
            },
            {
              "code": "3239007",
              "display": "Lymphocyte disorder"
            },
            {
              "code": "3253007",
              "display": "Dyschromia"
            },
            {
              "code": "3254001",
              "display": "Infection caused by Strongyloides westeri"
            },
            {
              "code": "3259006",
              "display": "Homeria species poisoning"
            },
            {
              "code": "3261002",
              "display": "Migratory osteolysis"
            },
            {
              "code": "3263004",
              "display": "Verumontanitis"
            },
            {
              "code": "3272007",
              "display": "Stomatocytosis"
            },
            {
              "code": "3274008",
              "display": "Flat chest"
            },
            {
              "code": "3275009",
              "display": "Behcet syndrome, vascular type"
            },
            {
              "code": "3276005",
              "display": "Toad poisoning"
            },
            {
              "code": "3277001",
              "display": "Terminal mood insomnia"
            },
            {
              "code": "3282008",
              "display": "Arc eye"
            },
            {
              "code": "3283003",
              "display": "Feeling of sand or foreign body in eye"
            },
            {
              "code": "3286006",
              "display": "Patient status determination, greatly improved"
            },
            {
              "code": "3289004",
              "display": "Anisometropia"
            },
            {
              "code": "3291007",
              "display": "Closed fracture of two ribs"
            },
            {
              "code": "3298001",
              "display": "Amnestic syndrome"
            },
            {
              "code": "3303004",
              "display": "Disease caused by Arenavirus"
            },
            {
              "code": "3304005",
              "display": "Bronchial compression"
            },
            {
              "code": "3305006",
              "display": "Disorder of lymphatic vessel"
            },
            {
              "code": "3308008",
              "display": "Atrophic-hyperplastic gastritis"
            },
            {
              "code": "3310005",
              "display": "Foreign body granuloma of skin"
            },
            {
              "code": "3321001",
              "display": "Renal abscess"
            },
            {
              "code": "3323003",
              "display": "Leukoplakia of penis"
            },
            {
              "code": "3327002",
              "display": "Acquired jerk nystagmus"
            },
            {
              "code": "3331008",
              "display": "Open fracture of neck of metacarpal bone"
            },
            {
              "code": "3344003",
              "display": "Toxic labyrinthitis"
            },
            {
              "code": "3345002",
              "display": "Idiopathic osteoporosis"
            },
            {
              "code": "3355003",
              "display": "Anti-common cold drug poisoning"
            },
            {
              "code": "3358001",
              "display": "Lichen ruber moniliformis"
            },
            {
              "code": "3368006",
              "display": "Dull chest pain"
            },
            {
              "code": "3376008",
              "display": "Pseudoptyalism"
            },
            {
              "code": "3381004",
              "display": "Open fracture of astragalus"
            },
            {
              "code": "3387000",
              "display": "Auditory discrimination aphasia"
            },
            {
              "code": "3391005",
              "display": "Negative for tumor cells"
            },
            {
              "code": "3393008",
              "display": "Phlebitis following infusion, perfusion AND/OR transfusion"
            },
            {
              "code": "3398004",
              "display": "Cadmium poisoning"
            },
            {
              "code": "3401001",
              "display": "Cercopithecus herpesvirus 1 disease"
            },
            {
              "code": "3415004",
              "display": "Cyanosis"
            },
            {
              "code": "3419005",
              "display": "Faucial diphtheria"
            },
            {
              "code": "3421000",
              "display": "Open blow-out fracture orbit"
            },
            {
              "code": "3424008",
              "display": "Heart rate fast"
            },
            {
              "code": "3426005",
              "display": "Retained magnetic intraocular foreign body"
            },
            {
              "code": "3427001",
              "display": "Nonglucosuric melituria"
            },
            {
              "code": "3434004",
              "display": "Myotonia"
            },
            {
              "code": "3439009",
              "display": "Severe combined immunodeficiency (SCID) due to absent peripheral T cell maturation"
            },
            {
              "code": "3441005",
              "display": "Disorder of sebaceous gland"
            },
            {
              "code": "3446000",
              "display": "Open fracture of T7-T12 level with spinal cord injury"
            },
            {
              "code": "3449007",
              "display": "Finger agnosia"
            },
            {
              "code": "3456001",
              "display": "Chronic progressive non-hereditary chorea"
            },
            {
              "code": "3458000",
              "display": "Myositis ossificans associated with dermato / polymyositis"
            },
            {
              "code": "3461004",
              "display": "Deep third degree burn of thumb"
            },
            {
              "code": "3464007",
              "display": "Infection caused by Oesophagostomum dentatum"
            },
            {
              "code": "3468005",
              "display": "Neonatal infective mastitis"
            },
            {
              "code": "3469002",
              "display": "Partial thickness burn of thumb"
            },
            {
              "code": "3472009",
              "display": "Spondylolisthesis, grade 4"
            },
            {
              "code": "3474005",
              "display": "Glycine max poisoning"
            },
            {
              "code": "3480002",
              "display": "Burn of wrist"
            },
            {
              "code": "3482005",
              "display": "Postoperative esophagitis"
            },
            {
              "code": "3483000",
              "display": "Chronic peptic ulcer with perforation"
            },
            {
              "code": "3487004",
              "display": "Pulmonary candidiasis"
            },
            {
              "code": "3500002",
              "display": "Open wound of ossicles with complication"
            },
            {
              "code": "3502005",
              "display": "Cervical lymphadenitis"
            },
            {
              "code": "3503000",
              "display": "Gender identity disorder of adolescence, previously asexual"
            },
            {
              "code": "3505007",
              "display": "Nonallopathic lesion of the arm"
            },
            {
              "code": "3506008",
              "display": "Stenosis of retinal artery"
            },
            {
              "code": "3507004",
              "display": "Abscess of thigh"
            },
            {
              "code": "3511005",
              "display": "Infectious thyroiditis"
            },
            {
              "code": "3514002",
              "display": "Peribronchial fibrosis of lung"
            },
            {
              "code": "3519007",
              "display": "Disorder of synovium"
            },
            {
              "code": "3528008",
              "display": "Restricted carbohydrate fat controlled diet"
            },
            {
              "code": "3529000",
              "display": "Infection caused by Sanguinicola"
            },
            {
              "code": "3530005",
              "display": "Bipolar 1 disorder, single manic episode, full remission"
            },
            {
              "code": "3531009",
              "display": "Intrapsychic conflict"
            },
            {
              "code": "3533007",
              "display": "Acute palmoplantar pustular psoriasis"
            },
            {
              "code": "3539006",
              "display": "Enteromenia"
            },
            {
              "code": "3542000",
              "display": "Laceration extending into parenchyma of spleen with open wound into abdominal cavity"
            },
            {
              "code": "3544004",
              "display": "Hair-splitting"
            },
            {
              "code": "3545003",
              "display": "Diastolic dysfunction"
            },
            {
              "code": "3548001",
              "display": "Brachial plexus disorder"
            },
            {
              "code": "3549009",
              "display": "Pancreatic acinar atrophy"
            },
            {
              "code": "3558002",
              "display": "Mesenteric infarction"
            },
            {
              "code": "3560000",
              "display": "Bilateral recurrent inguinal hernia"
            },
            {
              "code": "3570003",
              "display": "Increased blood erythrocyte volume"
            },
            {
              "code": "3571004",
              "display": "Megaloblastic anemia due to pancreatic insufficiency"
            },
            {
              "code": "3577000",
              "display": "Lattice retinal degeneration"
            },
            {
              "code": "3585009",
              "display": "Blinking"
            },
            {
              "code": "3586005",
              "display": "Psychogenic fugue"
            },
            {
              "code": "3589003",
              "display": "Syphilitic pericarditis"
            },
            {
              "code": "3590007",
              "display": "Enteroenteric fistula"
            },
            {
              "code": "3591006",
              "display": "Metabolic acidosis, normal anion gap, bicarbonate losses"
            },
            {
              "code": "3598000",
              "display": "Partial recent retinal detachment with single defect"
            },
            {
              "code": "3611003",
              "display": "Demeton poisoning"
            },
            {
              "code": "3633001",
              "display": "Abscess of hand"
            },
            {
              "code": "3634007",
              "display": "Legal termination of pregnancy complicated by metabolic disorder"
            },
            {
              "code": "3639002",
              "display": "Glossoptosis"
            },
            {
              "code": "3640000",
              "display": "Late effect of traumatic amputation"
            },
            {
              "code": "3641001",
              "display": "Infection caused by Coenurosis serialis"
            },
            {
              "code": "3642008",
              "display": "Steryl-sulfate sulfohydrolase deficiency"
            },
            {
              "code": "3644009",
              "display": "Macerated skin"
            },
            {
              "code": "3649004",
              "display": "Contusion, multiple sites of trunk"
            },
            {
              "code": "3650004",
              "display": "Congenital absence of liver,total"
            },
            {
              "code": "3652007",
              "display": "Overproduction of growth hormone"
            },
            {
              "code": "3657001",
              "display": "Osteospermum species poisoning"
            },
            {
              "code": "3660008",
              "display": "Lethal glossopharyngeal defect"
            },
            {
              "code": "3662000",
              "display": "Rolling hiatus hernia"
            },
            {
              "code": "3677008",
              "display": "Academic problem"
            },
            {
              "code": "3680009",
              "display": "Monocephalus tripus dibrachius"
            },
            {
              "code": "3681008",
              "display": "Thrombophlebitis of torcular Herophili"
            },
            {
              "code": "3696007",
              "display": "Functional dyspepsia"
            },
            {
              "code": "3699000",
              "display": "Transverse deficiency of arm"
            },
            {
              "code": "3703002",
              "display": "Ischiatic hernia with gangrene"
            },
            {
              "code": "3704008",
              "display": "Diffuse endocapillary proliferative glomerulonephritis"
            },
            {
              "code": "3705009",
              "display": "Congenital malformation of anterior chamber of eye"
            },
            {
              "code": "3712000",
              "display": "Degenerated eye"
            },
            {
              "code": "3716002",
              "display": "Thyroid goiter"
            },
            {
              "code": "3720003",
              "display": "Abnormal presence of hemoglobin"
            },
            {
              "code": "3723001",
              "display": "Joint inflammation"
            },
            {
              "code": "3733009",
              "display": "Congenital eventration of right crus of diaphragm"
            },
            {
              "code": "3736001",
              "display": "Open wound of thumbnail with tendon involvement"
            },
            {
              "code": "3738000",
              "display": "VH - Viral hepatitis"
            },
            {
              "code": "3744001",
              "display": "Hyperlipoproteinemia"
            },
            {
              "code": "3745000",
              "display": "Sleep rhythm problem"
            },
            {
              "code": "3747008",
              "display": "EC - Ejection click"
            },
            {
              "code": "3750006",
              "display": "Arteriospasm"
            },
            {
              "code": "3751005",
              "display": "Contusion of labium"
            },
            {
              "code": "3752003",
              "display": "Infection by Trichuris"
            },
            {
              "code": "3754002",
              "display": "Dysplasia of vagina"
            },
            {
              "code": "3755001",
              "display": "PRP - Pityriasis rubra pilaris"
            },
            {
              "code": "3756000",
              "display": "Static ataxia"
            },
            {
              "code": "3759007",
              "display": "Injury of heart with open wound into thorax"
            },
            {
              "code": "3760002",
              "display": "Familial multiple factor deficiency syndrome, type V"
            },
            {
              "code": "3762005",
              "display": "Bilateral recurrent femoral hernia with gangrene"
            },
            {
              "code": "3763000",
              "display": "Expected bereavement due to life event"
            },
            {
              "code": "3783004",
              "display": "Enamel pearls"
            },
            {
              "code": "3797007",
              "display": "Periodontal cyst"
            },
            {
              "code": "3798002",
              "display": "Premature birth of identical twins, both stillborn"
            },
            {
              "code": "3815005",
              "display": "Crohn disease of rectum"
            },
            {
              "code": "3820005",
              "display": "Inner ear conductive hearing loss"
            },
            {
              "code": "3827008",
              "display": "Aneurysm of artery of neck"
            },
            {
              "code": "3830001",
              "display": "Subcutaneous emphysema"
            },
            {
              "code": "3841004",
              "display": "Blister of cheek with infection"
            },
            {
              "code": "3845008",
              "display": "Duplication of intestine"
            },
            {
              "code": "3855007",
              "display": "Disorder of pancreas"
            },
            {
              "code": "3859001",
              "display": "Late effect of open wound of extremities without tendon injury"
            },
            {
              "code": "3873005",
              "display": "Failed attempted termination of pregnancy with acute necrosis of liver"
            },
            {
              "code": "3885002",
              "display": "ABO isoimmunization in pregnancy"
            },
            {
              "code": "3886001",
              "display": "Congenital fecaliths"
            },
            {
              "code": "3899003",
              "display": "Neutropenic typhlitis"
            },
            {
              "code": "3900008",
              "display": "Mixed sensory-motor polyneuropathy"
            },
            {
              "code": "3902000",
              "display": "Non dose-related drug-induced neutropenia"
            },
            {
              "code": "3903005",
              "display": "Closed traumatic pneumothorax"
            },
            {
              "code": "3908001",
              "display": "Infestation caused by Haematopinus"
            },
            {
              "code": "3909009",
              "display": "Coeur en sabot"
            },
            {
              "code": "3913002",
              "display": "Injury of gastrointestinal tract with open wound into abdominal cavity"
            },
            {
              "code": "3914008",
              "display": "Mental disorder in childhood"
            },
            {
              "code": "3928002",
              "display": "Zika virus disease"
            },
            {
              "code": "3939004",
              "display": "Bacterial colony density, transparent"
            },
            {
              "code": "3944006",
              "display": "X-linked placental steryl-sulfatase deficiency"
            },
            {
              "code": "3947004",
              "display": "High oxygen affinity hemoglobin polycythemia"
            },
            {
              "code": "3950001",
              "display": "Birth"
            },
            {
              "code": "3951002",
              "display": "Proctitis"
            },
            {
              "code": "3972004",
              "display": "Idiopathic insomnia"
            },
            {
              "code": "3975002",
              "display": "Deep third degree burn of lower limb"
            },
            {
              "code": "3978000",
              "display": "AIHA - Warm autoimmune hemolytic anemia"
            },
            {
              "code": "3987009",
              "display": "Congenital absence of trachea"
            },
            {
              "code": "3993001",
              "display": "Infection caused by Muellerius"
            },
            {
              "code": "3999002",
              "display": "Acute pyelitis without renal medullary necrosis"
            },
            {
              "code": "4003003",
              "display": "Alphavirus disease"
            },
            {
              "code": "4004009",
              "display": "Monster with cranial anomalies"
            },
            {
              "code": "4006006",
              "display": "Foetal tachycardia affecting management of mother"
            },
            {
              "code": "4009004",
              "display": "Lower urinary tract infection"
            },
            {
              "code": "4016003",
              "display": "Empyema of mastoid"
            },
            {
              "code": "4017007",
              "display": "Increased stratum corneum adhesiveness"
            },
            {
              "code": "4022007",
              "display": "Vulvitis circumscripta plasmacellularis"
            },
            {
              "code": "4026005",
              "display": "Interstitial mastitis associated with childbirth"
            },
            {
              "code": "4030008",
              "display": "Le Dantec virus disease"
            },
            {
              "code": "4038001",
              "display": "Myrotheciotoxicosis"
            },
            {
              "code": "4039009",
              "display": "Multiple vitamin deficiency disease"
            },
            {
              "code": "4040006",
              "display": "Hassall-Henle bodies"
            },
            {
              "code": "4041005",
              "display": "Congenital anomaly of macula"
            },
            {
              "code": "4046000",
              "display": "Degenerative spondylolisthesis"
            },
            {
              "code": "4062006",
              "display": "Lumbosacral plexus lesion"
            },
            {
              "code": "4063001",
              "display": "Achillodynia"
            },
            {
              "code": "4069002",
              "display": "Anoxic brain damage during AND/OR resulting from a procedure"
            },
            {
              "code": "4070001",
              "display": "Palinphrasia"
            },
            {
              "code": "4075006",
              "display": "Peganum harmala poisoning"
            },
            {
              "code": "4082005",
              "display": "Syphilitic myocarditis"
            },
            {
              "code": "4088009",
              "display": "Acquired hydrocephalus"
            },
            {
              "code": "4089001",
              "display": "Meningococcemia"
            },
            {
              "code": "4092002",
              "display": "Nonallopathic lesion of costovertebral region"
            },
            {
              "code": "4103001",
              "display": "Complex partial seizure"
            },
            {
              "code": "4106009",
              "display": "Rotator cuff rupture"
            },
            {
              "code": "4107000",
              "display": "Infertile male syndrome"
            },
            {
              "code": "4113009",
              "display": "Arrested hydrocephalus"
            },
            {
              "code": "4120002",
              "display": "Bronchiolitis"
            },
            {
              "code": "4124006",
              "display": "Insect bite, nonvenomous, of vagina, infected"
            },
            {
              "code": "4127004",
              "display": "Prostatic obstruction"
            },
            {
              "code": "4129001",
              "display": "Argyll-Robertson pupil"
            },
            {
              "code": "4135001",
              "display": "11p partial monosomy syndrome"
            },
            {
              "code": "4136000",
              "display": "Macrodactylia of toes"
            },
            {
              "code": "4142001",
              "display": "Muscular asthenopia"
            },
            {
              "code": "4152002",
              "display": "Acquired hypoprothrombinemia"
            },
            {
              "code": "4160001",
              "display": "Congenital anomaly of upper respiratory system"
            },
            {
              "code": "4168008",
              "display": "Tibial plateau chondromalacia"
            },
            {
              "code": "4170004",
              "display": "Ehlers-Danlos syndrome, procollagen proteinase resistant"
            },
            {
              "code": "4174008",
              "display": "Tripartite placenta"
            },
            {
              "code": "4175009",
              "display": "Infestation by Estrus"
            },
            {
              "code": "4178006",
              "display": "Partial recent retinal detachment with multiple defects"
            },
            {
              "code": "4181001",
              "display": "Normal peak expiratory flow rate"
            },
            {
              "code": "4183003",
              "display": "Charcot-Marie-Tooth disease, type IC"
            },
            {
              "code": "4184009",
              "display": "Congenital malformation of the endocrine glands"
            },
            {
              "code": "4191007",
              "display": "Scaphoid head"
            },
            {
              "code": "4195003",
              "display": "Duplication of anus"
            },
            {
              "code": "4197006",
              "display": "Disability evaluation, impairment, class 5"
            },
            {
              "code": "4199009",
              "display": "18p partial trisomy syndrome"
            },
            {
              "code": "4208000",
              "display": "Closed multiple fractures of both lower limbs"
            },
            {
              "code": "4210003",
              "display": "OH - Ocular hypertension"
            },
            {
              "code": "4223005",
              "display": "Parkinsonism caused by drug"
            },
            {
              "code": "4224004",
              "display": "Complication of infusion"
            },
            {
              "code": "4225003",
              "display": "Nasal tuberculosis"
            },
            {
              "code": "4229009",
              "display": "Phthisical eye"
            },
            {
              "code": "4232007",
              "display": "Chronic vulvitis"
            },
            {
              "code": "4237001",
              "display": "Suppurative pulpitis"
            },
            {
              "code": "4240001",
              "display": "Rupture of aorta"
            },
            {
              "code": "4241002",
              "display": "Listeria infection"
            },
            {
              "code": "4242009",
              "display": "18q partial monosomy syndrome"
            },
            {
              "code": "4244005",
              "display": "Urticaria neonatorum"
            },
            {
              "code": "4248008",
              "display": "Synovitis AND/OR tenosynovitis associated with another disease"
            },
            {
              "code": "4249000",
              "display": "Poor peripheral circulation"
            },
            {
              "code": "4251001",
              "display": "Internal eye sign"
            },
            {
              "code": "4260009",
              "display": "Sacral spinal cord injury without bone injury"
            },
            {
              "code": "4262001",
              "display": "Phlebitis of superior sagittal sinus"
            },
            {
              "code": "4264000",
              "display": "Chronic pericoronitis"
            },
            {
              "code": "4269005",
              "display": "Chronic gastrojejunal ulcer without hemorrhage AND without perforation"
            },
            {
              "code": "4273008",
              "display": "Closed posterior dislocation of elbow"
            },
            {
              "code": "4275001",
              "display": "Conjugate gaze spasm"
            },
            {
              "code": "4278004",
              "display": "Superficial foreign body of axilla without major open wound but with infection"
            },
            {
              "code": "4283007",
              "display": "Mirizzi syndrome"
            },
            {
              "code": "4287008",
              "display": "Chordee of penis"
            },
            {
              "code": "4294006",
              "display": "Isosexual precocious puberty"
            },
            {
              "code": "4300009",
              "display": "Deep third degree burn of forearm"
            },
            {
              "code": "4301008",
              "display": "Autoimmune state"
            },
            {
              "code": "4306003",
              "display": "Cluster B personality disorder"
            },
            {
              "code": "4307007",
              "display": "Pregestational diabetes mellitus AND/OR impaired glucose tolerance, modified White class F"
            },
            {
              "code": "4308002",
              "display": "RSIS - Repetitive strain injury syndrome"
            },
            {
              "code": "4310000",
              "display": "Third degree burn of wrist AND/OR hand"
            },
            {
              "code": "4313003",
              "display": "Acardiacus anceps"
            },
            {
              "code": "4316006",
              "display": "Myometritis"
            },
            {
              "code": "4320005",
              "display": "Factor V deficiency"
            },
            {
              "code": "4324001",
              "display": "Subacute cystitis"
            },
            {
              "code": "4325000",
              "display": "11q partial monosomy syndrome"
            },
            {
              "code": "4332009",
              "display": "Subarachnoid hemorrhage following injury without open intracranial wound AND with concussion"
            },
            {
              "code": "4338008",
              "display": "Arnold nerve reflex cough syndrome"
            },
            {
              "code": "4340003",
              "display": "Acrodermatitis chronica atrophicans"
            },
            {
              "code": "4349002",
              "display": "Open fracture of multiple sites of metacarpus"
            },
            {
              "code": "4354006",
              "display": "Open dislocation of scapula"
            },
            {
              "code": "4356008",
              "display": "Gingival soft tissue recession"
            },
            {
              "code": "4359001",
              "display": "Early congenital syphilis"
            },
            {
              "code": "4364002",
              "display": "Structure of associations"
            },
            {
              "code": "4367009",
              "display": "Hoover sign"
            },
            {
              "code": "4373005",
              "display": "Clubbing of nail"
            },
            {
              "code": "4374004",
              "display": "TV - Congenital tricuspid valve abnormality"
            },
            {
              "code": "4381006",
              "display": "Verbal paraphasia"
            },
            {
              "code": "4386001",
              "display": "Bronchospasm"
            },
            {
              "code": "4390004",
              "display": "Chronic lithium nephrotoxicity"
            },
            {
              "code": "4397001",
              "display": "Partial congenital duodenal obstruction"
            },
            {
              "code": "4399003",
              "display": "Acute hemorrhagic pancreatitis"
            },
            {
              "code": "4403007",
              "display": "Exclamation point hair"
            },
            {
              "code": "4406004",
              "display": "Congenital anomaly of male genital system"
            },
            {
              "code": "4409006",
              "display": "Combined methylmalonic acidemia and homocystinuria due to defects in adenosylcobalamin and methylcobalamin synthesis"
            },
            {
              "code": "4410001",
              "display": "Retroperitoneal hernia with obstruction"
            },
            {
              "code": "4412009",
              "display": "Digital nerve injury"
            },
            {
              "code": "4414005",
              "display": "Infection caused by Setaria"
            },
            {
              "code": "4416007",
              "display": "Heerfordt syndrome"
            },
            {
              "code": "4418008",
              "display": "Gangrenous ergotism"
            },
            {
              "code": "4426000",
              "display": "Ten previous induced terminations of pregnancy"
            },
            {
              "code": "4434006",
              "display": "BS - Bloom syndrome"
            },
            {
              "code": "4439001",
              "display": "Axenfeld-Schurenberg syndrome"
            },
            {
              "code": "4441000",
              "display": "Severe bipolar disorder with psychotic features"
            },
            {
              "code": "4445009",
              "display": "TB - Urogenital tuberculosis"
            },
            {
              "code": "4448006",
              "display": "Allergic headache"
            },
            {
              "code": "4451004",
              "display": "Illegal termination of pregnancy with renal tubular necrosis"
            },
            {
              "code": "4461006",
              "display": "Complication of administrative procedure"
            },
            {
              "code": "4463009",
              "display": "Indiana-Maryland type amyloid polyneuropathy"
            },
            {
              "code": "4464003",
              "display": "Rocio virus disease"
            },
            {
              "code": "4465002",
              "display": "Spherophakia"
            },
            {
              "code": "4468000",
              "display": "Oppenheim gait"
            },
            {
              "code": "4470009",
              "display": "Blanching of skin"
            },
            {
              "code": "4473006",
              "display": "Migraine with aura"
            },
            {
              "code": "4477007",
              "display": "Juvenile myopathy AND lactate acidosis"
            },
            {
              "code": "4478002",
              "display": "Multiple fractures of upper AND lower limbs"
            },
            {
              "code": "4481007",
              "display": "Abnormal gastric secretion regulation"
            },
            {
              "code": "4483005",
              "display": "Syphilitic punched out ulcer"
            },
            {
              "code": "104001",
              "display": "Excision of lesion of patella"
            },
            {
              "code": "115006",
              "display": "Fit removable orthodontic appliance"
            },
            {
              "code": "119000",
              "display": "Thoracoscopic partial lobectomy of lung"
            },
            {
              "code": "121005",
              "display": "Retrobulbar injection of therapeutic agent"
            },
            {
              "code": "128004",
              "display": "Hand microscope examination of skin"
            },
            {
              "code": "133000",
              "display": "Percutaneous implantation of neurostimulator electrodes into neuromuscular component"
            },
            {
              "code": "135007",
              "display": "Arthrotomy of wrist joint with exploration and biopsy"
            },
            {
              "code": "142007",
              "display": "Excision of tumor from shoulder area, deep, intramuscular"
            },
            {
              "code": "146005",
              "display": "Repair of nonunion of metatarsal with bone graft"
            },
            {
              "code": "153001",
              "display": "Cystourethroscopy with resection of ureterocele"
            },
            {
              "code": "160007",
              "display": "Removal of foreign body of tendon and/or tendon sheath"
            },
            {
              "code": "166001",
              "display": "Behavioral therapy"
            },
            {
              "code": "170009",
              "display": "Special potency disk identification, vancomycin test"
            },
            {
              "code": "174000",
              "display": "Harrison-Richardson operation on vagina"
            },
            {
              "code": "176003",
              "display": "Anastomosis of rectum"
            },
            {
              "code": "189009",
              "display": "Excision of lesion of artery"
            },
            {
              "code": "197002",
              "display": "Mold to yeast conversion test"
            },
            {
              "code": "230009",
              "display": "Miller operation, urethrovesical suspension"
            },
            {
              "code": "243009",
              "display": "Replacement of cerebral ventricular tube"
            },
            {
              "code": "245002",
              "display": "Division of nerve ganglion"
            },
            {
              "code": "262007",
              "display": "Percutaneous aspiration of renal pelvis"
            },
            {
              "code": "267001",
              "display": "Anal fistulectomy, multiple"
            },
            {
              "code": "285008",
              "display": "Incision and drainage of vulva"
            },
            {
              "code": "294002",
              "display": "Excisional biopsy of joint structure of spine"
            },
            {
              "code": "295001",
              "display": "Nonexcisional destruction of cyst of ciliary body"
            },
            {
              "code": "306005",
              "display": "US kidneys"
            },
            {
              "code": "316002",
              "display": "Partial dacryocystectomy"
            },
            {
              "code": "334003",
              "display": "Panorex examination of mandible"
            },
            {
              "code": "342002",
              "display": "Amobarbital interview"
            },
            {
              "code": "346004",
              "display": "Periodontal scaling and root planing, per quadrant"
            },
            {
              "code": "348003",
              "display": "Radionuclide dynamic function study"
            },
            {
              "code": "351005",
              "display": "Urinary undiversion of ureteral anastomosis"
            },
            {
              "code": "352003",
              "display": "Reagent RBC, preparation antibody sensitized pool"
            },
            {
              "code": "353008",
              "display": "IV/irrigation monitoring"
            },
            {
              "code": "374009",
              "display": "Costosternoplasty for pectus excavatum repair"
            },
            {
              "code": "388008",
              "display": "Blepharorrhaphy"
            },
            {
              "code": "389000",
              "display": "Tobramycin level"
            },
            {
              "code": "401004",
              "display": "Distal subtotal pancreatectomy"
            },
            {
              "code": "406009",
              "display": "Fulguration of stomach lesion"
            },
            {
              "code": "417005",
              "display": "Hospital re-admission"
            },
            {
              "code": "435001",
              "display": "Pulmonary inhalation study"
            },
            {
              "code": "445004",
              "display": "Repair of malunion of tibia"
            },
            {
              "code": "456004",
              "display": "Total abdominal colectomy with ileostomy"
            },
            {
              "code": "459006",
              "display": "Closed condylotomy of mandible"
            },
            {
              "code": "463004",
              "display": "Closed reduction of coxofemoral joint dislocation with splint"
            },
            {
              "code": "468008",
              "display": "Glutathione measurement"
            },
            {
              "code": "474008",
              "display": "Esophagoenteric anastomosis, intrathoracic"
            },
            {
              "code": "489004",
              "display": "Ferritin level"
            },
            {
              "code": "493005",
              "display": "Urobilinogen measurement, 48-hour, feces"
            },
            {
              "code": "494004",
              "display": "Excision of lesion of tonsil"
            },
            {
              "code": "497006",
              "display": "Replacement of cochlear prosthesis, multiple channels"
            },
            {
              "code": "503003",
              "display": "Corneal gluing"
            },
            {
              "code": "531007",
              "display": "Open pulmonary valve commissurotomy with inflow occlusion"
            },
            {
              "code": "533005",
              "display": "Repair of vesicocolic fistula"
            },
            {
              "code": "535003",
              "display": "Closure of ureterovesicovaginal fistula"
            },
            {
              "code": "540006",
              "display": "Antibody to single and double stranded DNA measurement"
            },
            {
              "code": "543008",
              "display": "Choledochostomy with transduodenal sphincteroplasty"
            },
            {
              "code": "545001",
              "display": "Operative procedure on lower leg"
            },
            {
              "code": "549007",
              "display": "Incision of intracranial vein"
            },
            {
              "code": "550007",
              "display": "Excision of lesion of adenoids"
            },
            {
              "code": "559008",
              "display": "Excision of varicose vein"
            },
            {
              "code": "570001",
              "display": "Vaccination for arthropod-borne viral encephalitis"
            },
            {
              "code": "574005",
              "display": "Benzodiazepine measurement"
            },
            {
              "code": "603006",
              "display": "Synchondrotomy"
            },
            {
              "code": "617002",
              "display": "Bone graft of mandible"
            },
            {
              "code": "618007",
              "display": "Frontal sinusectomy"
            },
            {
              "code": "625000",
              "display": "Removal of supernumerary digit"
            },
            {
              "code": "628003",
              "display": "Steinman test"
            },
            {
              "code": "629006",
              "display": "Lysis of adhesions of urethra"
            },
            {
              "code": "633004",
              "display": "Chart review by physician"
            },
            {
              "code": "637003",
              "display": "Lysis of adhesions of nose"
            },
            {
              "code": "642006",
              "display": "Cerebral thermography"
            },
            {
              "code": "645008",
              "display": "Diagnostic procedure on vitreous"
            },
            {
              "code": "647000",
              "display": "Excision of cervix by electroconization"
            },
            {
              "code": "657004",
              "display": "Operation on bursa"
            },
            {
              "code": "665001",
              "display": "Partial meniscectomy of temporomandibular joint"
            },
            {
              "code": "670008",
              "display": "Electrosurgical epilation of eyebrow"
            },
            {
              "code": "671007",
              "display": "Transplantation of testis"
            },
            {
              "code": "673005",
              "display": "Indirect examination of larynx"
            },
            {
              "code": "674004",
              "display": "Abduction test"
            },
            {
              "code": "676002",
              "display": "Peritoneal dialysis including cannulation"
            },
            {
              "code": "680007",
              "display": "Radiation physics consultation"
            },
            {
              "code": "687005",
              "display": "Albumin/Globulin ratio"
            },
            {
              "code": "695009",
              "display": "Destructive procedure of lesion on skin of trunk"
            },
            {
              "code": "697001",
              "display": "Hepatitis A virus antibody measurement"
            },
            {
              "code": "710006",
              "display": "Thromboendarterectomy with graft of mesenteric artery"
            },
            {
              "code": "712003",
              "display": "Closed chest suction"
            },
            {
              "code": "721002",
              "display": "Medical procedure on periurethral tissue"
            },
            {
              "code": "722009",
              "display": "Fine needle biopsy of thymus"
            },
            {
              "code": "726007",
              "display": "Pathology consultation, comprehensive, records and specimen with report"
            },
            {
              "code": "730005",
              "display": "Incision of subcutaneous tissue"
            },
            {
              "code": "741007",
              "display": "Operation on prostate"
            },
            {
              "code": "746002",
              "display": "Chiropractic adjustment of coccyx subluxation"
            },
            {
              "code": "753006",
              "display": "Manipulation of ankle AND foot"
            },
            {
              "code": "754000",
              "display": "Total urethrectomy"
            },
            {
              "code": "759005",
              "display": "Intracerebral electroencephalogram"
            },
            {
              "code": "762008",
              "display": "Computerized axial tomography of cervical spine with contrast"
            },
            {
              "code": "764009",
              "display": "Arthrodesis of interphalangeal joint of great toe"
            },
            {
              "code": "767002",
              "display": "White blood cell count - observation"
            },
            {
              "code": "789003",
              "display": "Cranial decompression, subtemporal, supratentorial"
            },
            {
              "code": "791006",
              "display": "Dressing and fixation procedure"
            },
            {
              "code": "807005",
              "display": "Excision of brain"
            },
            {
              "code": "814007",
              "display": "Electrophoresis measurement"
            },
            {
              "code": "817000",
              "display": "Excision of cyst of spleen"
            },
            {
              "code": "831000",
              "display": "Drawer test"
            },
            {
              "code": "851001",
              "display": "Root canal therapy, molar, excluding final restoration"
            },
            {
              "code": "853003",
              "display": "Fecal fat measurement, 72-hour collection"
            },
            {
              "code": "867007",
              "display": "Hypoglossofacial anastomosis"
            },
            {
              "code": "870006",
              "display": "Carbamazepine measurement"
            },
            {
              "code": "879007",
              "display": "Special blood coagulation test, explain by report"
            },
            {
              "code": "881009",
              "display": "Separation of ciliary body"
            },
            {
              "code": "893000",
              "display": "Tumor antigen measurement"
            },
            {
              "code": "897004",
              "display": "Radical maxillary antrotomy"
            },
            {
              "code": "910002",
              "display": "MHPG measurement, urine"
            },
            {
              "code": "911003",
              "display": "Removal of subarachnoid-ureteral shunt"
            },
            {
              "code": "913000",
              "display": "Chiropractic patient education"
            },
            {
              "code": "926001",
              "display": "Embolectomy with catheter of radial artery by arm incision"
            },
            {
              "code": "935008",
              "display": "Excision of bulbourethral gland"
            },
            {
              "code": "941001",
              "display": "Endoscopy of pituitary gland"
            },
            {
              "code": "945005",
              "display": "Excision of tibia and fibula for graft"
            },
            {
              "code": "948007",
              "display": "Phlebectomy of intracranial varicose vein"
            },
            {
              "code": "951000",
              "display": "Ultrasonic guidance for endomyocardial biopsy"
            },
            {
              "code": "956005",
              "display": "Anesthesia for procedure on thoracic esophagus"
            },
            {
              "code": "967006",
              "display": "Drug treatment education"
            },
            {
              "code": "969009",
              "display": "Incision and exploration of larynx"
            },
            {
              "code": "971009",
              "display": "Prosthetic construction and fitting"
            },
            {
              "code": "1001000",
              "display": "Cauterization of Bartholin's gland"
            },
            {
              "code": "1008006",
              "display": "Operation on nerve ganglion"
            },
            {
              "code": "1019009",
              "display": "Removal of corneal epithelium"
            },
            {
              "code": "1021004",
              "display": "Repair of scrotum"
            },
            {
              "code": "1029002",
              "display": "Fetoscopy"
            },
            {
              "code": "1032004",
              "display": "Enucleation of parotid gland cyst"
            },
            {
              "code": "1035002",
              "display": "Minimum bactericidal concentration test, microdilution method"
            },
            {
              "code": "1036001",
              "display": "Insertion of intravascular device in common iliac vein, complete"
            },
            {
              "code": "1041009",
              "display": "Debridement of open fracture of phalanges of foot"
            },
            {
              "code": "1042002",
              "display": "Paternity testing"
            },
            {
              "code": "1043007",
              "display": "Doppler color flow velocity mapping"
            },
            {
              "code": "1044001",
              "display": "Diagnostic ultrasound of abdomen and retroperitoneum"
            },
            {
              "code": "1048003",
              "display": "Capillary blood sampling"
            },
            {
              "code": "1054002",
              "display": "Sphincterotomy of papilla of Vater"
            },
            {
              "code": "1071001",
              "display": "Proximal splenorenal anastomosis"
            },
            {
              "code": "1084005",
              "display": "Excision of perinephric cyst"
            },
            {
              "code": "1093006",
              "display": "Excision of abdominal varicose vein"
            },
            {
              "code": "1103000",
              "display": "Transcrural mobilization of stapes"
            },
            {
              "code": "1104006",
              "display": "Triad knee repair"
            },
            {
              "code": "1115001",
              "display": "Decortication"
            },
            {
              "code": "1119007",
              "display": "Closed reduction of dislocation of foot and toe"
            },
            {
              "code": "1121002",
              "display": "Kinetic activities for range of motion"
            },
            {
              "code": "1127003",
              "display": "Interstitial radium application"
            },
            {
              "code": "1133007",
              "display": "Removal of intact mammary implant, bilateral"
            },
            {
              "code": "1163003",
              "display": "Ureteroenterostomy"
            },
            {
              "code": "1176009",
              "display": "Incision of inguinal region"
            },
            {
              "code": "1181000",
              "display": "Excision of tendon for graft"
            },
            {
              "code": "1186005",
              "display": "Anesthesia for procedure on bony pelvis"
            },
            {
              "code": "1198000",
              "display": "Excisional biopsy of bone of scapula"
            },
            {
              "code": "1209007",
              "display": "Arthroscopic repair lateral meniscus"
            },
            {
              "code": "1225002",
              "display": "Upper arm X-ray"
            },
            {
              "code": "1227005",
              "display": "Incision of subvalvular tissue for discrete subvalvular aortic stenosis"
            },
            {
              "code": "1235008",
              "display": "Muscle transfer"
            },
            {
              "code": "1237000",
              "display": "Application of cast, sugar tong"
            },
            {
              "code": "1238005",
              "display": "Epiphyseal arrest by stapling of distal radius"
            },
            {
              "code": "1251000",
              "display": "Incisional biopsy of testis"
            },
            {
              "code": "1253002",
              "display": "Refusion of spine"
            },
            {
              "code": "1258006",
              "display": "Excision of meniscus of wrist"
            },
            {
              "code": "1266002",
              "display": "Closure of tympanic membrane perforation"
            },
            {
              "code": "1267006",
              "display": "Electrocoagulation of lesion of vagina"
            },
            {
              "code": "1278003",
              "display": "Open reduction of closed shoulder dislocation with fracture of greater tuberosity"
            },
            {
              "code": "1279006",
              "display": "Repair of cardiac pacemaker pocket in skin AND/OR subcutaneous tissue"
            },
            {
              "code": "1292009",
              "display": "MRI of bladder"
            },
            {
              "code": "1299000",
              "display": "Excision of appendiceal stump"
            },
            {
              "code": "1315009",
              "display": "Reconstruction of eyebrow"
            },
            {
              "code": "1316005",
              "display": "Upper partial denture, cast metal base without resin saddles, including any conventional clasps, rests and teeth"
            },
            {
              "code": "1324000",
              "display": "Cerebrospinal fluid immunoglobulin G ratio and immunoglobulin G index"
            },
            {
              "code": "1327007",
              "display": "Procedure on Meckel diverticulum"
            },
            {
              "code": "1328002",
              "display": "Ilioiliac shunt"
            },
            {
              "code": "1329005",
              "display": "Division of congenital web of larynx"
            },
            {
              "code": "1337002",
              "display": "Colosigmoidostomy"
            },
            {
              "code": "1339004",
              "display": "Manual evacuation of feces"
            },
            {
              "code": "1347004",
              "display": "Medical procedure on palate"
            },
            {
              "code": "1352009",
              "display": "Anterior spinal rhizotomy"
            },
            {
              "code": "1358008",
              "display": "Anti-human globulin test, enzyme technique, titer"
            },
            {
              "code": "1366004",
              "display": "Breathing treatment"
            },
            {
              "code": "1385001",
              "display": "Echography, scan B-mode for foetal age determination"
            },
            {
              "code": "1390003",
              "display": "Laparoscopic sigmoid colectomy"
            },
            {
              "code": "1398005",
              "display": "Direct thrombectomy of iliac vein by leg incision"
            },
            {
              "code": "1399002",
              "display": "Incision and exploration of ureter"
            },
            {
              "code": "1407007",
              "display": "Application of long leg cast, brace type"
            },
            {
              "code": "1410000",
              "display": "Anesthesia for tympanotomy"
            },
            {
              "code": "1411001",
              "display": "Operation on papillary muscle of heart"
            },
            {
              "code": "1413003",
              "display": "Penetrating keratoplasty with homograft"
            },
            {
              "code": "1414009",
              "display": "Angiography of arteriovenous shunt"
            },
            {
              "code": "1417002",
              "display": "Operation on face"
            },
            {
              "code": "1431002",
              "display": "pexy"
            },
            {
              "code": "1440003",
              "display": "Repair with resection-recession"
            },
            {
              "code": "1449002",
              "display": "Removal of hair"
            },
            {
              "code": "1453000",
              "display": "Biofeedback, galvanic skin response"
            },
            {
              "code": "1455007",
              "display": "Cerclage"
            },
            {
              "code": "1457004",
              "display": "Truncal vagotomy with pyloroplasty and gastrostomy"
            },
            {
              "code": "1494008",
              "display": "Osmolarity measurement"
            },
            {
              "code": "1500007",
              "display": "Bilateral epididymovasostomy"
            },
            {
              "code": "1501006",
              "display": "Altemeier operation, perineal rectal pull-through"
            },
            {
              "code": "1505002",
              "display": "Hospital admission for isolation"
            },
            {
              "code": "1529009",
              "display": "Aspiration of soft tissue"
            },
            {
              "code": "1533002",
              "display": "Ureteroplication"
            },
            {
              "code": "1550000",
              "display": "Amikacin level"
            },
            {
              "code": "1555005",
              "display": "Brief group psychotherapy"
            },
            {
              "code": "1559004",
              "display": "Interleukin (IL)-2 assay"
            },
            {
              "code": "1576000",
              "display": "Repair of intestinouterine fistula"
            },
            {
              "code": "1577009",
              "display": "Implantation of cardiac single-chamber device replacement, rate-responsive"
            },
            {
              "code": "1578004",
              "display": "Reconstruction of ossicles with stapedectomy"
            },
            {
              "code": "1583007",
              "display": "Tractotomy of mesencephalon"
            },
            {
              "code": "1585000",
              "display": "Lengthening of gastrocnemius muscle"
            },
            {
              "code": "1596008",
              "display": "Anesthesia for total elbow replacement"
            },
            {
              "code": "1597004",
              "display": "Skeletal X-ray of ankle and foot"
            },
            {
              "code": "1602006",
              "display": "Social service interview with planning"
            },
            {
              "code": "1614003",
              "display": "Bilateral repair of inguinal hernia, direct"
            },
            {
              "code": "1615002",
              "display": "Reline upper partial denture, chairside"
            },
            {
              "code": "1616001",
              "display": "Galactosylceramide beta-galactosidase measurement, leukocytes"
            },
            {
              "code": "1636000",
              "display": "Injection of sclerosing agent in varicose vein"
            },
            {
              "code": "1638004",
              "display": "Cineplasty with cineplastic prosthesis of extremity"
            },
            {
              "code": "1640009",
              "display": "History and physical examination, insurance"
            },
            {
              "code": "1645004",
              "display": "Transduodenal sphincterotomy"
            },
            {
              "code": "1651009",
              "display": "Excision of tendon sheath"
            },
            {
              "code": "1653007",
              "display": "Internal fixation of bone without fracture reduction"
            },
            {
              "code": "1669000",
              "display": "Making occupied bed"
            },
            {
              "code": "1677001",
              "display": "Haagensen test"
            },
            {
              "code": "1678006",
              "display": "Endoscopic procedure of nerve"
            },
            {
              "code": "1680000",
              "display": "Secondary chemoprophylaxis"
            },
            {
              "code": "1683003",
              "display": "Direct closure of laceration of conjunctiva"
            },
            {
              "code": "1689004",
              "display": "Local excision of ovary"
            },
            {
              "code": "1691007",
              "display": "Drainage of abscess of tonsil"
            },
            {
              "code": "1699009",
              "display": "Special dosimetry"
            },
            {
              "code": "1702002",
              "display": "Labial veneer, resin laminate, laboratory"
            },
            {
              "code": "1704001",
              "display": "Correction of tibial pseudoarthrosis"
            },
            {
              "code": "1709006",
              "display": "Breast reconstruction, bilateral, with bilateral pedicle transverse rectus abdominis myocutaneous flaps"
            },
            {
              "code": "1712009",
              "display": "Immunoglobulin typing, immunoglobulin G"
            },
            {
              "code": "1713004",
              "display": "Hypothermia, total body, induction and maintenance"
            },
            {
              "code": "1730002",
              "display": "Suture of skin wound of hindfoot"
            },
            {
              "code": "1746005",
              "display": "Buckling of sclera using implant"
            },
            {
              "code": "1747001",
              "display": "Replacement of skeletal muscle stimulator"
            },
            {
              "code": "1753001",
              "display": "Resection of uveal tissue"
            },
            {
              "code": "1757000",
              "display": "Arthroscopy of wrist with partial synovectomy"
            },
            {
              "code": "1759002",
              "display": "Assessment of nutritional status"
            },
            {
              "code": "1770009",
              "display": "Mitral valvotomy"
            },
            {
              "code": "1774000",
              "display": "Nasopharyngeal rehabilitation"
            },
            {
              "code": "1775004",
              "display": "Submaxillary incision with drainage"
            },
            {
              "code": "1784004",
              "display": "Fecal stercobilin, qualitative"
            },
            {
              "code": "1787006",
              "display": "Ultrasonic guidance for pericardiocentesis"
            },
            {
              "code": "1788001",
              "display": "Blood unit collection for directed donation, donor"
            },
            {
              "code": "1801001",
              "display": "Endoscopic biopsy of duodenum"
            },
            {
              "code": "1805005",
              "display": "Take-down of stoma"
            },
            {
              "code": "1811008",
              "display": "Aspiration of bursa of hand"
            },
            {
              "code": "1813006",
              "display": "Cryotherapy of genital warts"
            },
            {
              "code": "1820004",
              "display": "Ethanol measurement, breath"
            },
            {
              "code": "1830008",
              "display": "Open reduction of open sacral fracture"
            },
            {
              "code": "1836002",
              "display": "Excision of diverticulum of ventricle of heart"
            },
            {
              "code": "1844002",
              "display": "Plication of ligament"
            },
            {
              "code": "1854003",
              "display": "Incision of nose"
            },
            {
              "code": "1859008",
              "display": "Hand tendon foreign body removed"
            },
            {
              "code": "1861004",
              "display": "Anesthesia for closed procedure on humerus and elbow"
            },
            {
              "code": "1862006",
              "display": "Thoracic phlebectomy"
            },
            {
              "code": "1866009",
              "display": "Bilateral total nephrectomy"
            },
            {
              "code": "1868005",
              "display": "FB - Removal of foreign body from brain"
            },
            {
              "code": "1870001",
              "display": "Insertion of halo device of skull with synchronous skeletal traction"
            },
            {
              "code": "1871002",
              "display": "Repair of aneurysm of coronary artery"
            },
            {
              "code": "1872009",
              "display": "Suture of male perineum"
            },
            {
              "code": "1876007",
              "display": "Recession of prognathic jaw"
            },
            {
              "code": "1879000",
              "display": "Fluorescent antigen measurement"
            },
            {
              "code": "1889001",
              "display": "Patient transfer, in-hospital, unit-to-unit"
            },
            {
              "code": "1906007",
              "display": "Insertion of prosthesis or prosthetic device of arm, bioelectric or cineplastic"
            },
            {
              "code": "1907003",
              "display": "Bifurcation of bone"
            },
            {
              "code": "1917008",
              "display": "Patient discharge, deceased, medicolegal case"
            },
            {
              "code": "1924009",
              "display": "Hepaticotomy with drainage"
            },
            {
              "code": "1950008",
              "display": "Drainage of nasal septal abscess"
            },
            {
              "code": "1958001",
              "display": "Grafting of bone of thumb with transfer of skin flap"
            },
            {
              "code": "1966005",
              "display": "Central block anesthesia"
            },
            {
              "code": "1983001",
              "display": "Total urethrectomy including cystostomy in female"
            },
            {
              "code": "1995001",
              "display": "Stripping of cerebral meninges"
            },
            {
              "code": "1999007",
              "display": "Psychologic test"
            },
            {
              "code": "2002009",
              "display": "Construction of subcutaneous tunnel without esophageal anastomosis"
            },
            {
              "code": "2021001",
              "display": "Internal fixation of radius and ulna without fracture reduction"
            },
            {
              "code": "2051007",
              "display": "Red cell iron utilization study"
            },
            {
              "code": "2054004",
              "display": "Barbiturates measurement, quantitative and qualitative"
            },
            {
              "code": "2067001",
              "display": "Implantation of electromagnetic hearing aid"
            },
            {
              "code": "2069003",
              "display": "Dental subperiosteal implant"
            },
            {
              "code": "2078009",
              "display": "Puncture of bursa of hand"
            },
            {
              "code": "2079001",
              "display": "Reimplantation of anomalous pulmonary artery"
            },
            {
              "code": "2080003",
              "display": "Angiectomy with anastomosis of lower limb artery"
            },
            {
              "code": "2098004",
              "display": "Open reduction of open mandibular fracture with external fixation"
            },
            {
              "code": "2115003",
              "display": "Dental prophylaxis, children"
            },
            {
              "code": "2119009",
              "display": "Repair of blood vessel"
            },
            {
              "code": "2127000",
              "display": "Reduction of closed sacral fracture"
            },
            {
              "code": "2137005",
              "display": "Excision of pericardial tumor"
            },
            {
              "code": "2153008",
              "display": "Cardiac catheterization education"
            },
            {
              "code": "2161003",
              "display": "Operation on vulva"
            },
            {
              "code": "2164006",
              "display": "Injection of aorta"
            },
            {
              "code": "2166008",
              "display": "Bicuspidization of aortic valve"
            },
            {
              "code": "2171001",
              "display": "Excision of tonsil tags"
            },
            {
              "code": "2178007",
              "display": "Ureterocentesis"
            },
            {
              "code": "2181002",
              "display": "Operation for bone injury of tarsals and metatarsals"
            },
            {
              "code": "2188008",
              "display": "Suture of tendon to skeletal attachment"
            },
            {
              "code": "2193006",
              "display": "Repair of ruptured aneurysm with graft of celiac artery"
            },
            {
              "code": "2196003",
              "display": "Gas liquid chromatography, electron capture type"
            },
            {
              "code": "2199005",
              "display": "Excision of lesion of cul-de-sac"
            },
            {
              "code": "2214008",
              "display": "Curette test of skin"
            },
            {
              "code": "2220009",
              "display": "Complement component assay"
            },
            {
              "code": "2225004",
              "display": "Sensititer system test"
            },
            {
              "code": "2234009",
              "display": "Proctosigmoidopexy"
            },
            {
              "code": "2238007",
              "display": "Stone operation, anoplasty"
            },
            {
              "code": "2242005",
              "display": "Reconstruction of eyelid"
            },
            {
              "code": "2244006",
              "display": "Arthroscopy of wrist with internal fixation for instability"
            },
            {
              "code": "2250001",
              "display": "Resection of ascending aorta with anastomosis"
            },
            {
              "code": "2252009",
              "display": "Hospital admission, urgent, 48 hours"
            },
            {
              "code": "2266004",
              "display": "Venography of adrenal, bilateral"
            },
            {
              "code": "2267008",
              "display": "Replacement of tracheostomy tube"
            },
            {
              "code": "2270007",
              "display": "Correction of cleft hand"
            },
            {
              "code": "2276001",
              "display": "Exploration of popliteal artery"
            },
            {
              "code": "2278000",
              "display": "Urinalysis, automated"
            },
            {
              "code": "2279008",
              "display": "Antibody detection, red blood cell, enzyme, 1 stage technique, including anti-human globulin"
            },
            {
              "code": "2290003",
              "display": "Microbial culture, anaerobic, initial isolation"
            },
            {
              "code": "2315006",
              "display": "Brain meninges operation"
            },
            {
              "code": "2318008",
              "display": "Anesthesia for cast procedure on forearm, wrist or hand"
            },
            {
              "code": "2321005",
              "display": "Delivery by Ritgen maneuver"
            },
            {
              "code": "2322003",
              "display": "Suture of recent wound of eyelid, direct closure, full-thickness"
            },
            {
              "code": "2337004",
              "display": "Adductor tenotomy"
            },
            {
              "code": "2344008",
              "display": "Complicated cystorrhaphy"
            },
            {
              "code": "2347001",
              "display": "Diagnostic model construction"
            },
            {
              "code": "2364003",
              "display": "Radical resection of tumor of soft tissue of wrist area"
            },
            {
              "code": "2371008",
              "display": "Tympanoplasty type II with graft against incus or malleus"
            },
            {
              "code": "2373006",
              "display": "Buffy coat smear evaluation"
            },
            {
              "code": "2382000",
              "display": "Application of breast pump"
            },
            {
              "code": "2386002",
              "display": "Closed reduction of dislocation of patella"
            },
            {
              "code": "2393003",
              "display": "Ligation of vein of lower limb"
            },
            {
              "code": "2406000",
              "display": "Chart periodontal pocket"
            },
            {
              "code": "2407009",
              "display": "Excision of mediastinal tumor"
            },
            {
              "code": "2408004",
              "display": "Hexosaminidase A and total hexosaminidase measurement, serum"
            },
            {
              "code": "2409007",
              "display": "Replantation of toe"
            },
            {
              "code": "2425002",
              "display": "Epstein-Barr virus serologic test"
            },
            {
              "code": "2442008",
              "display": "Incision of lacrimal canaliculus"
            },
            {
              "code": "2448007",
              "display": "Cell count of synovial fluid with differential count"
            },
            {
              "code": "2455009",
              "display": "Revision of lumbosubarachnoid shunt"
            },
            {
              "code": "2457001",
              "display": "Blind rehabilitation"
            },
            {
              "code": "2458006",
              "display": "Educational therapy"
            },
            {
              "code": "2459003",
              "display": "Destructive procedure of artery of upper extremity"
            },
            {
              "code": "2461007",
              "display": "Tennis elbow test"
            },
            {
              "code": "2474001",
              "display": "Repair of malunion of metatarsal bones"
            },
            {
              "code": "2475000",
              "display": "Twenty-four hour collection of urine"
            },
            {
              "code": "2480009",
              "display": "Debridement of skin, subcutaneous tissue, muscle and bone"
            },
            {
              "code": "2486003",
              "display": "Destructive procedure of breast"
            },
            {
              "code": "2488002",
              "display": "Provision of contact lens"
            },
            {
              "code": "2494005",
              "display": "Nurse to nurse communication"
            },
            {
              "code": "2498008",
              "display": "Rebase of upper partial denture"
            },
            {
              "code": "2507007",
              "display": "5' Nucleotidase measurement"
            },
            {
              "code": "2508002",
              "display": "Retrograde urography with kidney-ureter-bladder"
            },
            {
              "code": "2514009",
              "display": "Manual reduction of closed supracondylar fracture of humerus with traction"
            },
            {
              "code": "2517002",
              "display": "Stroke rehabilitation"
            },
            {
              "code": "2530001",
              "display": "Chiropractic visit"
            },
            {
              "code": "2531002",
              "display": "Mononuclear cell function assay"
            },
            {
              "code": "2535006",
              "display": "Removal of pulp - complete"
            },
            {
              "code": "2536007",
              "display": "Injection of medication in anterior chamber of eye"
            },
            {
              "code": "2547000",
              "display": "Excision of keloid"
            },
            {
              "code": "2552005",
              "display": "Incision of cerebral subarachnoid space"
            },
            {
              "code": "2564002",
              "display": "Creation of lumbar shunt including laminectomy"
            },
            {
              "code": "2566000",
              "display": "Osteoplasty of radius"
            },
            {
              "code": "2567009",
              "display": "Resection of rib by transaxillary approach"
            },
            {
              "code": "2580007",
              "display": "Transplant of hair follicles to scalp"
            },
            {
              "code": "2598006",
              "display": "Open heart surgery"
            },
            {
              "code": "2601001",
              "display": "Removal of bone flap of skull"
            },
            {
              "code": "2607002",
              "display": "Operation of supporting structures of uterus"
            },
            {
              "code": "2613006",
              "display": "Implantation of joint prosthesis of hand"
            },
            {
              "code": "2614000",
              "display": "Removal of ligature from fallopian tube"
            },
            {
              "code": "2616003",
              "display": "Repair of bifid digit of hand"
            },
            {
              "code": "2619005",
              "display": "Psychiatric interpretation to family or parents of patient"
            },
            {
              "code": "2629003",
              "display": "Intracranial/cerebral perfusion pressure monitoring"
            },
            {
              "code": "2632000",
              "display": "Incision and drainage of infected bursa of upper arm"
            },
            {
              "code": "2642003",
              "display": "Prefabricated post and core in addition to crown"
            },
            {
              "code": "2643008",
              "display": "Ligation of varicose vein of head and neck"
            },
            {
              "code": "2644002",
              "display": "Cauterization of liver"
            },
            {
              "code": "2645001",
              "display": "Intelligence test/WB1"
            },
            {
              "code": "2646000",
              "display": "Incision and exploration of vas deferens"
            },
            {
              "code": "2658000",
              "display": "Social service interview of patient"
            },
            {
              "code": "2659008",
              "display": "Suture of ligament of lower extremity"
            },
            {
              "code": "2668005",
              "display": "Recementation of space maintainer"
            },
            {
              "code": "2670001",
              "display": "Diagnostic procedure on cornea"
            },
            {
              "code": "2673004",
              "display": "Incision and drainage of masticator space by extraoral approach"
            },
            {
              "code": "2677003",
              "display": "Stripping"
            },
            {
              "code": "2690005",
              "display": "MRI of pelvis"
            },
            {
              "code": "2693007",
              "display": "Stool fat, quantitative measurement"
            },
            {
              "code": "2696004",
              "display": "Hepatic venography with hemodynamic evaluation"
            },
            {
              "code": "2697008",
              "display": "Stripping and ligation of great saphenous vein"
            },
            {
              "code": "2716009",
              "display": "Dermal-fat-fascia graft"
            },
            {
              "code": "2722000",
              "display": "Interleukin-3 assay"
            },
            {
              "code": "2731000",
              "display": "Serologic test for influenza virus A"
            },
            {
              "code": "2732007",
              "display": "Recession of tendon of hand"
            },
            {
              "code": "2737001",
              "display": "Exploratory craniotomy, infratentorial"
            },
            {
              "code": "2742009",
              "display": "Destruction of Bartholin's gland"
            },
            {
              "code": "2743004",
              "display": "Operative endoscopy of ileum"
            },
            {
              "code": "2745006",
              "display": "Epiplopexy"
            },
            {
              "code": "2752008",
              "display": "Incudopexy"
            },
            {
              "code": "2780005",
              "display": "Osteoplasty of facial bones"
            },
            {
              "code": "2794006",
              "display": "Cauterization of navel"
            },
            {
              "code": "2802005",
              "display": "Manual dilation and stretching"
            },
            {
              "code": "2811005",
              "display": "Cineradiography of pharynx"
            },
            {
              "code": "2813008",
              "display": "Nephroureterocystectomy"
            },
            {
              "code": "2837008",
              "display": "Transposition of ulnar nerve at elbow"
            },
            {
              "code": "2842000",
              "display": "Gas chromatography measurement"
            },
            {
              "code": "2843005",
              "display": "Revision of urinary conduit"
            },
            {
              "code": "2847006",
              "display": "Cervical myelography"
            },
            {
              "code": "2851008",
              "display": "Arthrotomy for synovectomy of sternoclavicular joint"
            },
            {
              "code": "2854000",
              "display": "Bursectomy of hand"
            },
            {
              "code": "2857007",
              "display": "Pinealectomy"
            },
            {
              "code": "2866006",
              "display": "Obliteration of lymphatic structure"
            },
            {
              "code": "2875008",
              "display": "Implantation of joint prosthesis of elbow"
            },
            {
              "code": "2876009",
              "display": "Hospital admission, type unclassified, explain by report"
            },
            {
              "code": "2885009",
              "display": "Intradermal allergen test"
            },
            {
              "code": "2891006",
              "display": "Arthroscopy of elbow with partial synovectomy"
            },
            {
              "code": "2898000",
              "display": "Deoxyribonucleic acid analysis, antenatal, blood"
            },
            {
              "code": "2903001",
              "display": "Diagnostic procedure on anterior chamber of eye"
            },
            {
              "code": "2908005",
              "display": "Cryotherapy to hemorrhoid"
            },
            {
              "code": "2914003",
              "display": "Anterior sclerotomy"
            },
            {
              "code": "2915002",
              "display": "Suture of capsule of ankle"
            },
            {
              "code": "2933008",
              "display": "Pneumogynecography"
            },
            {
              "code": "2945004",
              "display": "Suprapubic diverticulectomy of urinary bladder"
            },
            {
              "code": "2947007",
              "display": "Therapeutic compound measurement"
            },
            {
              "code": "2960001",
              "display": "Closure of fistula of uterine cervix"
            },
            {
              "code": "2968008",
              "display": "Craniectomy with treatment of penetrating wound of brain"
            },
            {
              "code": "2970004",
              "display": "Metacarpal lengthening and transfer of local flap"
            },
            {
              "code": "2971000",
              "display": "Closure of acquired urethrovaginal fistula"
            },
            {
              "code": "2977001",
              "display": "Thrombectomy of lower limb vein"
            },
            {
              "code": "3001009",
              "display": "Total lobectomy with bronchoplasty"
            },
            {
              "code": "3010001",
              "display": "Removal of silastic tubes from ear"
            },
            {
              "code": "3016007",
              "display": "Removal of Crutchfield tongs from skull"
            },
            {
              "code": "3025001",
              "display": "Calcitonin measurement"
            },
            {
              "code": "3026000",
              "display": "Tibiotalar arthrodesis"
            },
            {
              "code": "3029007",
              "display": "Peripheral nervous system disease rehabilitation"
            },
            {
              "code": "3041000",
              "display": "Repair of stomach"
            },
            {
              "code": "3047001",
              "display": "Kowa fundus photography"
            },
            {
              "code": "3060007",
              "display": "Forequarter amputation, right"
            },
            {
              "code": "3061006",
              "display": "Complete excision of nail AND nail matrix"
            },
            {
              "code": "3063009",
              "display": "Gastroscopy through artificial stoma"
            },
            {
              "code": "3075004",
              "display": "Nonoperative removal of prosthesis of bile duct"
            },
            {
              "code": "3078002",
              "display": "Embolectomy with catheter of renal artery by abdominal incision"
            },
            {
              "code": "3083005",
              "display": "Removal of device from thorax"
            },
            {
              "code": "3088001",
              "display": "Anesthesia for endoscopic procedure on upper extremity"
            },
            {
              "code": "3090000",
              "display": "Aneurysmectomy with graft replacement of lower limb artery"
            },
            {
              "code": "3112006",
              "display": "Restraint removal"
            },
            {
              "code": "3116009",
              "display": "Clotting screening"
            },
            {
              "code": "3130004",
              "display": "Monitoring of cardiac output by electrocardiogram"
            },
            {
              "code": "3133002",
              "display": "Patient discharge, deceased, autopsy"
            },
            {
              "code": "3137001",
              "display": "Replacement"
            },
            {
              "code": "3143004",
              "display": "Visual field examination and evaluation, intermediate"
            },
            {
              "code": "3162001",
              "display": "Gadolinium measurement"
            },
            {
              "code": "3164000",
              "display": "Open reduction of closed mandibular fracture with interdental fixation"
            },
            {
              "code": "3165004",
              "display": "Irrigation of muscle of hand"
            },
            {
              "code": "3166003",
              "display": "Closure of fistula of salivary gland"
            },
            {
              "code": "3177009",
              "display": "Internal obstetrical version"
            },
            {
              "code": "3183007",
              "display": "Closure of colostomy"
            },
            {
              "code": "3186004",
              "display": "Excision of Skene gland"
            },
            {
              "code": "3190002",
              "display": "Epilation by forceps"
            },
            {
              "code": "3204007",
              "display": "Destructive procedure of nerve"
            },
            {
              "code": "3241008",
              "display": "Correction of chordee with mobilization of urethra"
            },
            {
              "code": "3249005",
              "display": "Surgical construction of filtration bleb"
            },
            {
              "code": "3251009",
              "display": "Mayo operation, herniorrhaphy"
            },
            {
              "code": "3256004",
              "display": "Cervical lymphangiogram"
            },
            {
              "code": "3257008",
              "display": "Empty and measure peritoneal dialysis fluid"
            },
            {
              "code": "3258003",
              "display": "Cerebral arteriography"
            },
            {
              "code": "3268008",
              "display": "Transplantation of tissue of pelvic region"
            },
            {
              "code": "3270004",
              "display": "Implantation of neurostimulator in spine"
            },
            {
              "code": "3278006",
              "display": "Lysis of adhesions of bursa of hand"
            },
            {
              "code": "3287002",
              "display": "Cholecystogastrostomy"
            },
            {
              "code": "3320000",
              "display": "Abt - autologous blood transfusion"
            },
            {
              "code": "3324009",
              "display": "Laser beam photocoagulation"
            },
            {
              "code": "3326006",
              "display": "Excision of exostosis of head of fifth metatarsal"
            },
            {
              "code": "3328007",
              "display": "Incision of vein of head and neck"
            },
            {
              "code": "3333006",
              "display": "Application of short arm splint, forearm to hand, static"
            },
            {
              "code": "3338002",
              "display": "Open reduction of open radial shaft fracture"
            },
            {
              "code": "3352000",
              "display": "PTH - Parathyroid hormone level"
            },
            {
              "code": "3357006",
              "display": "Iron kinetics"
            },
            {
              "code": "3360004",
              "display": "Biliary anastomosis"
            },
            {
              "code": "3390006",
              "display": "Verification procedure"
            },
            {
              "code": "3399007",
              "display": "Reduction of torsion of omentum"
            },
            {
              "code": "3407002",
              "display": "Creation of lesion of spinal cord by percutaneous method"
            },
            {
              "code": "3413006",
              "display": "Blood cell morphology"
            },
            {
              "code": "3418002",
              "display": "Chondrectomy of spine"
            },
            {
              "code": "3432000",
              "display": "Preventive dental service"
            },
            {
              "code": "3443008",
              "display": "Pulp capping"
            },
            {
              "code": "3448004",
              "display": "Fixation of contralateral testis"
            },
            {
              "code": "3450007",
              "display": "Lymphocytes, T & B cell evaluation"
            },
            {
              "code": "3457005",
              "display": "Referral procedure"
            },
            {
              "code": "3479000",
              "display": "Removal of heart assist system with replacement"
            },
            {
              "code": "3498003",
              "display": "Total excision of pituitary gland by transsphenoidal approach"
            },
            {
              "code": "3499006",
              "display": "Aspiration of vitreous with replacement"
            },
            {
              "code": "3509001",
              "display": "Streptococcus vaccination"
            },
            {
              "code": "3512003",
              "display": "Angiography of arteries of extremity"
            },
            {
              "code": "3515001",
              "display": "Replacement of electronic heart device, pulse generator"
            },
            {
              "code": "3517009",
              "display": "Removal of foreign body of pelvis from subcutaneous tissue"
            },
            {
              "code": "3518004",
              "display": "Aversive psychotherapy"
            },
            {
              "code": "3527003",
              "display": "Antibody measurement"
            },
            {
              "code": "3546002",
              "display": "CVG - Coronary vein graft"
            },
            {
              "code": "3559005",
              "display": "Insertion of ureteral stent with ureterotomy"
            },
            {
              "code": "3562008",
              "display": "Rodney Smith operation, radical subtotal pancreatectomy"
            },
            {
              "code": "3564009",
              "display": "Removal of foreign body from fallopian tube"
            },
            {
              "code": "3575008",
              "display": "Repair of fascia with graft of fascia"
            },
            {
              "code": "3580004",
              "display": "Removal of calculus of pharynx"
            },
            {
              "code": "3605001",
              "display": "Reduction of ciliary body"
            },
            {
              "code": "3607009",
              "display": "Transplantation of mesenteric tissue"
            },
            {
              "code": "3620007",
              "display": "Red cell survival study with hepatic sequestration"
            },
            {
              "code": "3625002",
              "display": "Anesthesia for brachial arteriograms, retrograde"
            },
            {
              "code": "3651000",
              "display": "Morphometric analysis, nerve"
            },
            {
              "code": "3654008",
              "display": "Excision of lingula"
            },
            {
              "code": "3659003",
              "display": "Incision of inner ear"
            },
            {
              "code": "3664004",
              "display": "Closure of scleral fistula"
            },
            {
              "code": "3666002",
              "display": "Repair of peripheral nerve by suturing"
            },
            {
              "code": "3669009",
              "display": "Fitting of prosthesis or prosthetic device of upper arm"
            },
            {
              "code": "3673007",
              "display": "Leadbetter urethral reconstruction"
            },
            {
              "code": "3683006",
              "display": "Selenium measurement, urine"
            },
            {
              "code": "3686003",
              "display": "Zancolli operation for tendon transfer of biceps"
            },
            {
              "code": "3688002",
              "display": "Anesthesia for lens surgery"
            },
            {
              "code": "3690001",
              "display": "Shunt of left subclavian to descending aorta by Blalock-Park operation"
            },
            {
              "code": "3691002",
              "display": "Wedge osteotomy of tarsals and metatarsals"
            },
            {
              "code": "3697003",
              "display": "Tissue processing technique, routine, embed, cut and stain, per autopsy"
            },
            {
              "code": "3700004",
              "display": "Erysophake extraction of lens"
            },
            {
              "code": "3701000",
              "display": "Removal of foreign body of hip from subcutaneous tissue"
            },
            {
              "code": "3713005",
              "display": "Release for de Quervain tenosynovitis of hand"
            },
            {
              "code": "3717006",
              "display": "Dilute Russell viper venom time"
            },
            {
              "code": "3734003",
              "display": "SSG - Split skin graft"
            },
            {
              "code": "3735002",
              "display": "Coproporphyrin III measurement"
            },
            {
              "code": "3740005",
              "display": "Removal of foreign body of canthus by incision"
            },
            {
              "code": "3748003",
              "display": "Biopsy of perirenal tissue"
            },
            {
              "code": "3749006",
              "display": "Reduction of closed ischial fracture"
            },
            {
              "code": "3758004",
              "display": "Thrombectomy with catheter of subclavian artery by neck incision"
            },
            {
              "code": "3770000",
              "display": "Ward urine dip stick testing"
            },
            {
              "code": "3778007",
              "display": "Scrotum manipulation"
            },
            {
              "code": "3780001",
              "display": "Routine patient disposition, no follow-up planned"
            },
            {
              "code": "3784005",
              "display": "Delayed hypersensitivity skin test for streptokinase-streptodornase"
            },
            {
              "code": "3786007",
              "display": "Excision of lesion of pharynx"
            },
            {
              "code": "3787003",
              "display": "Ultrasonic guidance for needle biopsy"
            },
            {
              "code": "3794000",
              "display": "Pregnanetriol measurement"
            },
            {
              "code": "3796003",
              "display": "Excision of redundant mucosa from jejunostomy"
            },
            {
              "code": "3799005",
              "display": "Radiography of adenoids"
            },
            {
              "code": "3802001",
              "display": "Topical application of tooth medicament - desensitizing agent"
            },
            {
              "code": "3819004",
              "display": "Embolization of thoracic artery"
            },
            {
              "code": "3826004",
              "display": "Blepharotomy with drainage of abscess of eyelid"
            },
            {
              "code": "3828003",
              "display": "Open biopsy of vertebral body of thoracic region"
            },
            {
              "code": "3831002",
              "display": "Chiropractic application of ice"
            },
            {
              "code": "3843001",
              "display": "Removal of foreign body from fascia"
            },
            {
              "code": "3858009",
              "display": "Echography of thyroid, A-mode"
            },
            {
              "code": "3861005",
              "display": "Aneurysmectomy with anastomosis of lower limb artery"
            },
            {
              "code": "3862003",
              "display": "Total vital capacity measurement"
            },
            {
              "code": "3864002",
              "display": "Excisional biopsy of scrotum"
            },
            {
              "code": "3880007",
              "display": "Excision of lesion of fibula"
            },
            {
              "code": "3881006",
              "display": "Incision and drainage of submental space by extraoral approach"
            },
            {
              "code": "3887005",
              "display": "Wart ligation"
            },
            {
              "code": "3889008",
              "display": "Suture of lip"
            },
            {
              "code": "3891000",
              "display": "Comprehensive orthodontic treatment, permanent dentition, for class I malocclusion"
            },
            {
              "code": "3895009",
              "display": "Dressing"
            },
            {
              "code": "3907006",
              "display": "Incision and drainage of retroperitoneal abscess"
            },
            {
              "code": "3911000",
              "display": "Transplantation of muscle"
            },
            {
              "code": "3915009",
              "display": "Excision of artery of thorax and abdomen"
            },
            {
              "code": "3917001",
              "display": "Excisional biopsy of phalanges of foot"
            },
            {
              "code": "3918006",
              "display": "Plastic repair with lengthening"
            },
            {
              "code": "3926003",
              "display": "Lactate measurement"
            },
            {
              "code": "3929005",
              "display": "Patient transfer, in-hospital, bed-to-bed"
            },
            {
              "code": "3936006",
              "display": "Making Foster bed"
            },
            {
              "code": "3938007",
              "display": "Cerclage for retinal reattachment"
            },
            {
              "code": "3942005",
              "display": "Cystopexy"
            },
            {
              "code": "3955006",
              "display": "Antibody elution from red blood cells"
            },
            {
              "code": "3957003",
              "display": "Arteriectomy of thoracoabdominal aorta"
            },
            {
              "code": "3963007",
              "display": "Operation on submaxillary gland"
            },
            {
              "code": "3967008",
              "display": "Fluorescence polarization immunoassay"
            },
            {
              "code": "3968003",
              "display": "Excision of spinal facet joint"
            },
            {
              "code": "3969006",
              "display": "Removal of osteocartilagenous loose body from joint structures"
            },
            {
              "code": "3971006",
              "display": "Duchenne muscular dystrophy carrier detection"
            },
            {
              "code": "3980006",
              "display": "Partial excision of esophagus"
            },
            {
              "code": "3981005",
              "display": "Carrier detection, molecular genetics"
            },
            {
              "code": "3985001",
              "display": "Anesthesia for procedure on arteries of lower leg with bypass graft"
            },
            {
              "code": "3991004",
              "display": "MRI of pelvis, prostate and bladder"
            },
            {
              "code": "3998005",
              "display": "Bone imaging of limited area"
            },
            {
              "code": "4007002",
              "display": "Anti-human globulin test, indirect, titer, non-gamma"
            },
            {
              "code": "4008007",
              "display": "Phlebography of neck"
            },
            {
              "code": "4010009",
              "display": "Oophorectomy of remaining ovary with tube"
            },
            {
              "code": "4027001",
              "display": "Implantation of electronic stimulator into phrenic nerve"
            },
            {
              "code": "4034004",
              "display": "Closed reduction of facial fracture, except mandible"
            },
            {
              "code": "4035003",
              "display": "Restoration, resin, two surfaces, posterior, permanent"
            },
            {
              "code": "4036002",
              "display": "Arthroscopy of elbow with extensive debridement"
            },
            {
              "code": "4037006",
              "display": "Removal of vascular graft or prosthesis"
            },
            {
              "code": "4044002",
              "display": "Construction of permanent colostomy"
            },
            {
              "code": "4045001",
              "display": "Drainage of cerebral ventricle by incision"
            },
            {
              "code": "4052004",
              "display": "Percutaneous aspiration of spinal cord cyst"
            },
            {
              "code": "4064007",
              "display": "Specimen aliquoting"
            },
            {
              "code": "4068005",
              "display": "Removal of ventricular reservoir with synchronous replacement"
            },
            {
              "code": "4083000",
              "display": "Fitting of prosthesis or prosthetic device of lower arm"
            },
            {
              "code": "4084006",
              "display": "Repair of tendon of hand by graft or implant of muscle"
            },
            {
              "code": "4090005",
              "display": "Replacement of transvenous atrial and ventricular pacemaker electrode leads"
            },
            {
              "code": "4094001",
              "display": "Reduction of retroversion of uterus by suppository"
            },
            {
              "code": "4101004",
              "display": "Revision of spinal pleurothecal shunt"
            },
            {
              "code": "4102006",
              "display": "Root canal therapy, anterior, excluding final restoration"
            },
            {
              "code": "4114003",
              "display": "Parenteral chemotherapy for malignant neoplasm"
            },
            {
              "code": "4116001",
              "display": "Construction of window"
            },
            {
              "code": "4119008",
              "display": "Intracranial phlebectomy with anastomosis"
            },
            {
              "code": "4131005",
              "display": "Implantation into pelvic region"
            },
            {
              "code": "4134002",
              "display": "Operative block anesthesia"
            },
            {
              "code": "4139007",
              "display": "Posterior spinal cordotomy"
            },
            {
              "code": "4143006",
              "display": "Injection into anterior chamber of eye"
            },
            {
              "code": "4149005",
              "display": "Bone histomorphometry, aluminum stain"
            },
            {
              "code": "4154001",
              "display": "Incision and drainage of penis"
            },
            {
              "code": "4165006",
              "display": "Delayed hypersensitivity skin test for staphage lysate"
            },
            {
              "code": "4176005",
              "display": "Fothergill repair"
            },
            {
              "code": "4192000",
              "display": "Toxicology testing for organophosphate insecticide"
            },
            {
              "code": "4213001",
              "display": "Implantation of Ommaya reservoir"
            },
            {
              "code": "4214007",
              "display": "Intracardiac injection for cardiac resuscitation"
            },
            {
              "code": "4226002",
              "display": "Excision of lesion of thoracic vein"
            },
            {
              "code": "4252008",
              "display": "Aneurysmectomy with graft replacement by interposition"
            },
            {
              "code": "4263006",
              "display": "Biopsy of soft tissue of elbow area, superficial"
            },
            {
              "code": "4266003",
              "display": "Patient referral for drug addiction rehabilitation"
            },
            {
              "code": "4285000",
              "display": "Insertion of bone growth stimulator into femur"
            },
            {
              "code": "4293000",
              "display": "Reduction of intussusception by laparotomy"
            },
            {
              "code": "4304000",
              "display": "Excision of cusp of tricuspid valve"
            },
            {
              "code": "4319004",
              "display": "Rebase of complete lower denture"
            },
            {
              "code": "4321009",
              "display": "Bilateral leg arteriogram"
            },
            {
              "code": "4323007",
              "display": "Destruction of lesion of sclera"
            },
            {
              "code": "4331002",
              "display": "Anesthesia for hernia repair in lower abdomen"
            },
            {
              "code": "4333004",
              "display": "Incision and drainage of perisplenic space"
            },
            {
              "code": "4336007",
              "display": "Lloyd-Davies operation, abdominoperineal resection"
            },
            {
              "code": "4337003",
              "display": "Homogentisic acid measurement"
            },
            {
              "code": "4339000",
              "display": "Repair of nasolabial fistula"
            },
            {
              "code": "4341004",
              "display": "Complete submucous resection of turbinate"
            },
            {
              "code": "4344007",
              "display": "Cryopexy"
            },
            {
              "code": "4348005",
              "display": "Musculoplasty of hand"
            },
            {
              "code": "4350002",
              "display": "Removal of implant of cornea"
            },
            {
              "code": "4363008",
              "display": "Endoscopic brush biopsy of trachea"
            },
            {
              "code": "4365001",
              "display": "Surgical repair"
            },
            {
              "code": "4380007",
              "display": "Transposition of vulvar tissue"
            },
            {
              "code": "4387005",
              "display": "Valvuloplasty of pulmonary valve in total repair of tetralogy of Fallot"
            },
            {
              "code": "4388000",
              "display": "Repair of splenocolic fistula"
            },
            {
              "code": "4407008",
              "display": "Slitting of lacrimal canaliculus for passage of tube"
            },
            {
              "code": "4411002",
              "display": "Removal of device from female genital tract"
            },
            {
              "code": "4420006",
              "display": "Incision and drainage of parapharyngeal abscess by external approach"
            },
            {
              "code": "4424002",
              "display": "Making orthopedic bed"
            },
            {
              "code": "4436008",
              "display": "Methylatable chemotaxis protein (MCP) receptor measurement"
            },
            {
              "code": "4438009",
              "display": "Venography of vena cava"
            },
            {
              "code": "4443002",
              "display": "Decortication of ovary"
            },
            {
              "code": "4447001",
              "display": "Autopsy, gross and microscopic examination, stillborn or newborn without central nervous system"
            },
            {
              "code": "4449003",
              "display": "Manipulation of spinal meninges"
            },
            {
              "code": "4450003",
              "display": "Application of Kirschner wire"
            },
            {
              "code": "4455008",
              "display": "Open reduction of open elbow dislocation"
            },
            {
              "code": "4457000",
              "display": "Insertion of mold into vagina"
            },
            {
              "code": "4466001",
              "display": "Exploration of upper limb artery"
            },
            {
              "code": "4467005",
              "display": "Excision of tumor of ankle area, deep, intramuscular"
            },
            {
              "code": "4475004",
              "display": "Cyanide level"
            },
            {
              "code": "4487006",
              "display": "Norepinephrine measurement, supine"
            },
            {
              "code": "4489009",
              "display": "Neurolysis of trigeminal nerve"
            },
            {
              "code": "4496006",
              "display": "Mouthcare procedure"
            },
            {
              "code": "4503005",
              "display": "Removal of foreign body of sclera without use of magnet"
            },
            {
              "code": "4504004",
              "display": "Potter obstetrical version with extraction"
            },
            {
              "code": "4505003",
              "display": "Tenolysis of flexor tendon of forearm"
            },
            {
              "code": "4507006",
              "display": "Decompression fasciotomy of wrist, flexor and extensor compartment"
            },
            {
              "code": "4511000",
              "display": "Restoration, inlay, composite/resin, one surface, laboratory processed"
            },
            {
              "code": "4516005",
              "display": "Iridencleisis and iridotasis"
            },
            {
              "code": "4520009",
              "display": "Anastomosis of esophagus, antesternal or antethoracic, with insertion of prosthesis"
            },
            {
              "code": "4525004",
              "display": "Seen by casualty - service"
            },
            {
              "code": "4533003",
              "display": "Ligation of artery of lower limb"
            },
            {
              "code": "4535005",
              "display": "Incision of pelvirectal tissue"
            },
            {
              "code": "4539004",
              "display": "Excision of cyst of bronchus"
            },
            {
              "code": "4542005",
              "display": "Closed reduction of fracture of foot"
            },
            {
              "code": "4544006",
              "display": "Excision of subcutaneous tumor of extremities"
            },
            {
              "code": "4558008",
              "display": "Anterior resection of rectum"
            },
            {
              "code": "4563007",
              "display": "Hospital admission, transfer from other hospital or health care facility"
            },
            {
              "code": "4570007",
              "display": "Chemopallidectomy"
            },
            {
              "code": "4579008",
              "display": "Creation of ventriculoatrial shunt"
            },
            {
              "code": "4581005",
              "display": "Coreoplasty"
            },
            {
              "code": "4585001",
              "display": "Decompression of tendon of hand"
            },
            {
              "code": "4587009",
              "display": "Epiphysiodesis of distal radius"
            },
            {
              "code": "4589007",
              "display": "Care relating to reproduction and pregnancy"
            },
            {
              "code": "4593001",
              "display": "Cauterization of sclera with iridectomy"
            },
            {
              "code": "4594007",
              "display": "Coproporphyrin isomers, series I & III, urine"
            },
            {
              "code": "4613005",
              "display": "Radioimmunoassay"
            },
            {
              "code": "4625008",
              "display": "Apical pulse taking"
            },
            {
              "code": "4626009",
              "display": "Take-down of arterial anastomosis"
            },
            {
              "code": "4636001",
              "display": "Denker operation for radical maxillary antrotomy"
            },
            {
              "code": "4640005",
              "display": "Ligation of fallopian tubes by abdominal approach"
            },
            {
              "code": "4642002",
              "display": "Removal of inflatable penile prosthesis, with pump, reservoir and cylinders"
            },
            {
              "code": "4660002",
              "display": "Diagnostic procedure on phalanges of foot"
            },
            {
              "code": "4670000",
              "display": "Catheterization of bronchus"
            },
            {
              "code": "4671001",
              "display": "Excision of lesion from sphenoid sinus"
            },
            {
              "code": "4672008",
              "display": "Medical procedure on the nervous system"
            },
            {
              "code": "4691008",
              "display": "Identification of rotavirus antigen in feces"
            },
            {
              "code": "4692001",
              "display": "Transplantation of artery of upper extremity"
            },
            {
              "code": "4694000",
              "display": "Percutaneous biopsy of muscle"
            },
            {
              "code": "4699005",
              "display": "Alpha naphthyl butyrate stain method, blood or bone marrow"
            },
            {
              "code": "4701005",
              "display": "Colony forming unit-granulocyte-monocyte-erythroid-megakaryocyte assay"
            },
            {
              "code": "4707009",
              "display": "Partial excision of calcaneus"
            },
            {
              "code": "4712005",
              "display": "Removal of Gardner Wells tongs from skull"
            },
            {
              "code": "4713000",
              "display": "Endoscopy and photography"
            },
            {
              "code": "4719001",
              "display": "Psychologic cognitive testing and assessment"
            },
            {
              "code": "4727005",
              "display": "Lipoprotein electrophoresis"
            },
            {
              "code": "4734007",
              "display": "Irrigation of wound catheter of integument"
            },
            {
              "code": "4737000",
              "display": "Mycobacteria culture"
            },
            {
              "code": "4756005",
              "display": "Cryotherapy of subcutaneous tissue"
            },
            {
              "code": "4758006",
              "display": "Incudostapediopexy"
            },
            {
              "code": "4764004",
              "display": "Jet ventilation procedure"
            },
            {
              "code": "4765003",
              "display": "Insertion of ocular implant following or secondary to enucleation"
            },
            {
              "code": "4770005",
              "display": "Colporrhaphy for repair of urethrocele"
            },
            {
              "code": "4772002",
              "display": "Reduction of torsion of spermatic cord"
            },
            {
              "code": "4784000",
              "display": "Operation on sublingual gland"
            },
            {
              "code": "4804005",
              "display": "Microbial identification test"
            },
            {
              "code": "4811009",
              "display": "Reconstruction of diaphragm"
            },
            {
              "code": "4815000",
              "display": "Antibody identification, red blood cell antibody panel, enzyme, 2 stage technique including anti-human globulin"
            },
            {
              "code": "4820000",
              "display": "Incision of labial frenum"
            },
            {
              "code": "4827002",
              "display": "Shower hydrotherapy"
            },
            {
              "code": "4829004",
              "display": "Excision of small intestine for interposition"
            },
            {
              "code": "4847005",
              "display": "Anesthesia for cesarean section"
            },
            {
              "code": "4849008",
              "display": "Ovarian biopsy"
            },
            {
              "code": "4862007",
              "display": "Revision of anastomosis of large intestine"
            },
            {
              "code": "4877004",
              "display": "Extracapsular extraction of lens with iridectomy"
            },
            {
              "code": "4891005",
              "display": "Proctostomy"
            },
            {
              "code": "4895001",
              "display": "Construction of sigmoid bladder"
            },
            {
              "code": "4902005",
              "display": "Ethchlorvynol measurement"
            },
            {
              "code": "4903000",
              "display": "Serum protein electrophoresis"
            },
            {
              "code": "4904006",
              "display": "Dilation of anal sphincter under nonlocal anesthesia"
            },
            {
              "code": "4914002",
              "display": "Treatment planning for teletherapy"
            },
            {
              "code": "4929000",
              "display": "Local perfusion of kidney"
            },
            {
              "code": "4930005",
              "display": "Repair of thoracogastric fistula"
            },
            {
              "code": "4934001",
              "display": "Salpingography"
            },
            {
              "code": "4957007",
              "display": "Cervical spinal fusion for pseudoarthrosis"
            },
            {
              "code": "4966006",
              "display": "Extracorporeal perfusion"
            },
            {
              "code": "4970003",
              "display": "Venography"
            },
            {
              "code": "4974007",
              "display": "Liver operation"
            },
            {
              "code": "4976009",
              "display": "Anesthesia for endoscopic procedure on lower extremity"
            },
            {
              "code": "4987001",
              "display": "Osteoplasty of cranium with flap of bone"
            },
            {
              "code": "4992004",
              "display": "Cardiac catheterization, left heart, retrograde, percutaneous"
            },
            {
              "code": "4993009",
              "display": "Ischemic limb exercise with electromyography and lactic acid determination"
            },
            {
              "code": "5016005",
              "display": "Pontic, resin with high noble metal"
            },
            {
              "code": "5019003",
              "display": "Direct laryngoscopy with biopsy"
            },
            {
              "code": "5021008",
              "display": "Aldosterone measurement, standing, normal salt diet"
            },
            {
              "code": "5022001",
              "display": "Lysergic acid diethylamide measurement"
            },
            {
              "code": "5025004",
              "display": "Semen analysis, presence and motility of sperm"
            },
            {
              "code": "5032008",
              "display": "Labial veneer, porcelain laminate, laboratory"
            },
            {
              "code": "5034009",
              "display": "Graft to hair-bearing skin"
            },
            {
              "code": "5048009",
              "display": "External cephalic version with tocolysis"
            },
            {
              "code": "5055006",
              "display": "Uniscept system test"
            },
            {
              "code": "5057003",
              "display": "Radical orbitomaxillectomy"
            },
            {
              "code": "5065000",
              "display": "Reduction of closed traumatic hip dislocation with anesthesia"
            },
            {
              "code": "5091004",
              "display": "Peripheral vascular disease study"
            },
            {
              "code": "5105000",
              "display": "Endoscopy of renal pelvis"
            },
            {
              "code": "5110001",
              "display": "Ultrasound peripheral imaging, real time scan"
            },
            {
              "code": "5113004",
              "display": "FT4 - Free thyroxine level"
            },
            {
              "code": "5119000",
              "display": "Epiglottidectomy"
            },
            {
              "code": "5121005",
              "display": "Wedge osteotomy of pelvic bone"
            },
            {
              "code": "5123008",
              "display": "Anesthesia for procedure on pericardium with pump oxygenator"
            },
            {
              "code": "5130002",
              "display": "Needling of lens for cataract"
            },
            {
              "code": "5131003",
              "display": "Radiography of chest wall"
            },
            {
              "code": "5135007",
              "display": "Diagnostic procedure on scapula"
            },
            {
              "code": "5147001",
              "display": "Excision of lesion of ankle joint"
            },
            {
              "code": "5151004",
              "display": "Manual reduction of rectal hemorrhoids"
            },
            {
              "code": "5154007",
              "display": "Communication enhancement: speech deficit"
            },
            {
              "code": "5161006",
              "display": "Specialty clinic admission"
            },
            {
              "code": "5162004",
              "display": "Excision of pressure ulcer"
            },
            {
              "code": "5165002",
              "display": "Division of thoracic artery"
            },
            {
              "code": "5176003",
              "display": "Thromboendarterectomy with graft of renal artery"
            },
            {
              "code": "5182000",
              "display": "Total body perfusion"
            },
            {
              "code": "5184004",
              "display": "Osteotomy of shaft of femur with fixation"
            },
            {
              "code": "5186002",
              "display": "Arthrotomy for synovectomy of glenohumeral joint"
            },
            {
              "code": "5190000",
              "display": "Cell fusion"
            },
            {
              "code": "5191001",
              "display": "Surgical treatment of missed miscarriage of second trimester"
            },
            {
              "code": "5212002",
              "display": "Excision of lesion of lacrimal gland by frontal approach"
            },
            {
              "code": "5216004",
              "display": "Three dimensional ultrasound imaging of heart"
            },
            {
              "code": "5233006",
              "display": "Lateral fasciotomy"
            },
            {
              "code": "5243009",
              "display": "Suture of adenoid fossa"
            },
            {
              "code": "5245002",
              "display": "Transplantation of peripheral vein"
            },
            {
              "code": "5246001",
              "display": "Breakpoint cluster region analysis"
            },
            {
              "code": "5264008",
              "display": "Total bile acids measurement"
            },
            {
              "code": "5267001",
              "display": "Adrenal artery ligation"
            },
            {
              "code": "5270002",
              "display": "Bilateral destruction of fallopian tubes"
            },
            {
              "code": "5273000",
              "display": "Manual reduction of closed fracture of proximal end of ulna"
            },
            {
              "code": "5282006",
              "display": "Operation on oropharynx"
            },
            {
              "code": "5290006",
              "display": "Incision and drainage of Ludwig angina"
            },
            {
              "code": "5298004",
              "display": "Incision and drainage of deep hematoma of thigh region"
            },
            {
              "code": "5304008",
              "display": "DXT - Radiotherapy"
            },
            {
              "code": "5316002",
              "display": "Closed osteotomy of mandibular ramus"
            },
            {
              "code": "5317006",
              "display": "Radical amputation of penis with bilateral pelvic lymphadenectomy"
            },
            {
              "code": "5326009",
              "display": "Administration of dermatologic formulation"
            },
            {
              "code": "5328005",
              "display": "Shortening of Achilles tendon"
            },
            {
              "code": "5337005",
              "display": "Trocar biopsy"
            },
            {
              "code": "5338000",
              "display": "Nicotine measurement"
            },
            {
              "code": "5342002",
              "display": "Prophylactic treatment of tibia with methyl methacrylate"
            },
            {
              "code": "5348003",
              "display": "Repair of endocardial cushion defect"
            },
            {
              "code": "5357009",
              "display": "Leukocyte poor blood preparation"
            },
            {
              "code": "5373003",
              "display": "Stress breaker"
            },
            {
              "code": "5384005",
              "display": "Excision of part of frontal cortex"
            },
            {
              "code": "5391008",
              "display": "Artificial voice rehabilitation"
            },
            {
              "code": "5393006",
              "display": "Exploration of parathyroid with mediastinal exploration by sternal split approach"
            },
            {
              "code": "5402006",
              "display": "Manipulation of thoracic artery"
            },
            {
              "code": "5407000",
              "display": "Injection of fallopian tube"
            },
            {
              "code": "5415002",
              "display": "Destruction of lesion of liver"
            },
            {
              "code": "5419008",
              "display": "Lysis of adhesions of tendon of hand"
            },
            {
              "code": "5422005",
              "display": "Amylase measurement, peritoneal fluid"
            },
            {
              "code": "5429001",
              "display": "Diagnostic procedure on nipple"
            },
            {
              "code": "5431005",
              "display": "Percutaneous transluminal angioplasty"
            },
            {
              "code": "5433008",
              "display": "Skeletal X-ray of lower limb"
            },
            {
              "code": "5446003",
              "display": "Excision of cervical rib for outlet compression syndrome with sympathectomy"
            },
            {
              "code": "5447007",
              "display": "Transfusion"
            },
            {
              "code": "5452002",
              "display": "Core needle biopsy of thymus"
            },
            {
              "code": "5456004",
              "display": "Graft of lymphatic structure"
            },
            {
              "code": "5457008",
              "display": "Serologic test for Rickettsia conorii"
            },
            {
              "code": "5460001",
              "display": "Removal of prosthesis from fallopian tube"
            },
            {
              "code": "5479003",
              "display": "Select picture audiometry"
            },
            {
              "code": "5482008",
              "display": "Serologic test for Blastomyces"
            },
            {
              "code": "5486006",
              "display": "Delayed suture of tendon of hand"
            },
            {
              "code": "5489004",
              "display": "Diagnostic procedure on radius"
            },
            {
              "code": "5506006",
              "display": "Incision and exploration of abdominal wall"
            },
            {
              "code": "5517007",
              "display": "Restoration, inlay, porcelain/ceramic, per tooth, in addition to inlay"
            },
            {
              "code": "5521000",
              "display": "Open reduction of fracture of phalanges of foot"
            },
            {
              "code": "5536002",
              "display": "Arthrodesis of carpometacarpal joint of digits, other than thumb"
            },
            {
              "code": "5545001",
              "display": "Repair of carotid body"
            },
            {
              "code": "5551006",
              "display": "Direct laryngoscopy with arytenoidectomy with operating microscope"
            },
            {
              "code": "5556001",
              "display": "Manually assisted spontaneous delivery"
            },
            {
              "code": "5570001",
              "display": "Arthrotomy for infection with exploration and drainage of carpometacarpal joint"
            },
            {
              "code": "5571002",
              "display": "Excision of lesion of aorta with end-to-end anastomosis"
            },
            {
              "code": "5572009",
              "display": "Incision of kidney pelvis"
            },
            {
              "code": "5586008",
              "display": "Aminolevulinic acid dehydratase measurement"
            },
            {
              "code": "5608002",
              "display": "Excretion measurement"
            },
            {
              "code": "5616006",
              "display": "Osteoplasty of tibia"
            },
            {
              "code": "5621009",
              "display": "Excision of malignant lesion of skin of extremities"
            },
            {
              "code": "5632009",
              "display": "Open biopsy of bronchus"
            },
            {
              "code": "5636007",
              "display": "Fistulectomy of bone"
            },
            {
              "code": "5638008",
              "display": "Carbohydrate measurement"
            },
            {
              "code": "5648005",
              "display": "Surgical repair and revision of shunt"
            },
            {
              "code": "5651003",
              "display": "Arylsulfatase A measurement"
            },
            {
              "code": "5663008",
              "display": "Phlebectomy of varicose vein of head and neck"
            },
            {
              "code": "5669007",
              "display": "Portable electroencephalogram awake and asleep with stimulation"
            },
            {
              "code": "5671007",
              "display": "Magnet extraction of foreign body from ciliary body"
            },
            {
              "code": "5687005",
              "display": "Removal of foreign body from ovary"
            },
            {
              "code": "5690004",
              "display": "Incision of seminal vesicle"
            },
            {
              "code": "5694008",
              "display": "Crisis intervention with follow-up"
            },
            {
              "code": "5721002",
              "display": "Repair of eyebrow"
            },
            {
              "code": "5722009",
              "display": "Surgical reanastomosis of colon"
            },
            {
              "code": "5726007",
              "display": "Removal of epicardial electrodes"
            },
            {
              "code": "5728008",
              "display": "Anoscopy for removal of foreign body"
            },
            {
              "code": "5731009",
              "display": "Hemosiderin, quantitative measurement"
            },
            {
              "code": "5733007",
              "display": "Fluorescent identification of anti-nuclear antibody"
            },
            {
              "code": "5738003",
              "display": "Biopsy of cul-de-sac"
            },
            {
              "code": "5745003",
              "display": "Excision ampulla of Vater with reimplantation of common duct"
            },
            {
              "code": "5760000",
              "display": "Osteoplasty of radius and ulna, shortening"
            },
            {
              "code": "5771004",
              "display": "Blepharotomy"
            },
            {
              "code": "5777000",
              "display": "Flexorplasty of elbow"
            },
            {
              "code": "5781000",
              "display": "Operation on nasal septum"
            },
            {
              "code": "5785009",
              "display": "Forensic autopsy"
            },
            {
              "code": "5787001",
              "display": "Elevation of bone fragments of orbit of skull with debridement"
            },
            {
              "code": "5789003",
              "display": "Lysis of adhesions of intestines"
            },
            {
              "code": "5796001",
              "display": "Excision of external thrombotic hemorrhoid"
            },
            {
              "code": "5806001",
              "display": "Revision of tracheostomy scar"
            },
            {
              "code": "5807005",
              "display": "Fenestration of inner ear, initial"
            },
            {
              "code": "5809008",
              "display": "Selective vagotomy with pyloroplasty and gastrostomy"
            },
            {
              "code": "5812006",
              "display": "Laboratory reporting, fax"
            },
            {
              "code": "5818005",
              "display": "Flocculation test"
            },
            {
              "code": "5821007",
              "display": "Ligation, division and complete stripping of long and short saphenous veins"
            },
            {
              "code": "5823005",
              "display": "Diagnostic radiography, left"
            },
            {
              "code": "5832007",
              "display": "Partial ostectomy of thorax, ribs or sternum"
            },
            {
              "code": "5845006",
              "display": "Emulsification procedure"
            },
            {
              "code": "5846007",
              "display": "Diagnostic radiography of toes"
            },
            {
              "code": "5857002",
              "display": "Complement mediated cytotoxicity assay"
            },
            {
              "code": "5865004",
              "display": "Open reduction of dislocation of toe"
            },
            {
              "code": "5870006",
              "display": "Tertiary closure of abdominal wall"
            },
            {
              "code": "5880005",
              "display": "Clinical examination"
            },
            {
              "code": "5892005",
              "display": "Mastoid antrotomy"
            },
            {
              "code": "5894006",
              "display": "Methyl red test"
            },
            {
              "code": "5897004",
              "display": "Removal of Scribner shunt"
            },
            {
              "code": "5902003",
              "display": "History and physical examination, complete"
            },
            {
              "code": "5925002",
              "display": "Incision and drainage of hematoma of wrist"
            },
            {
              "code": "5930003",
              "display": "Cardiac monitor removal"
            },
            {
              "code": "5947002",
              "display": "Consultation for hearing and/or speech problem"
            },
            {
              "code": "5961007",
              "display": "Division of blood vessels of cornea"
            },
            {
              "code": "5966002",
              "display": "Removal of foreign body from elbow area, deep"
            },
            {
              "code": "5971009",
              "display": "Incision and drainage of axilla"
            },
            {
              "code": "5983006",
              "display": "Repair of spermatic cord"
            },
            {
              "code": "5986003",
              "display": "Non-sensitized spontaneous sheep erythrocyte binding, E-rosette"
            },
            {
              "code": "5992009",
              "display": "Midtarsal arthrodesis, multiple"
            },
            {
              "code": "5995006",
              "display": "Gas liquid chromatography, flame photometric type"
            },
            {
              "code": "5997003",
              "display": "Drainage of cerebral subarachnoid space by aspiration"
            },
            {
              "code": "5998008",
              "display": "Radical dissection of groin"
            },
            {
              "code": "6005008",
              "display": "Transplantation of vitreous by anterior approach"
            },
            {
              "code": "6007000",
              "display": "Magnetic resonance imaging of chest"
            },
            {
              "code": "6019008",
              "display": "Endoscopy of large intestine"
            },
            {
              "code": "6025007",
              "display": "Laparoscopic appendectomy"
            },
            {
              "code": "6026008",
              "display": "Removal of coronary artery obstruction by percutaneous transluminal balloon with thrombolytic agent"
            },
            {
              "code": "6029001",
              "display": "Augmentation of outflow tract of pulmonary valve"
            },
            {
              "code": "6035001",
              "display": "Chart abstracting"
            },
            {
              "code": "6063004",
              "display": "Kanamycin measurement"
            },
            {
              "code": "6069000",
              "display": "Panniculotomy"
            },
            {
              "code": "6082008",
              "display": "Perforation of footplate"
            },
            {
              "code": "6092000",
              "display": "Aspiration of nasal sinus by puncture"
            },
            {
              "code": "6100001",
              "display": "Fenestration of stapes footplate with vein graft"
            },
            {
              "code": "6108008",
              "display": "Subdural tap through fontanel, infant, initial"
            },
            {
              "code": "6119006",
              "display": "Local destruction of lesion of bony palate"
            },
            {
              "code": "6125005",
              "display": "Change of gastrostomy tube"
            },
            {
              "code": "6126006",
              "display": "Fitzgerald factor assay"
            },
            {
              "code": "6127002",
              "display": "Diagnostic radiography of abdomen, oblique standard"
            },
            {
              "code": "6130009",
              "display": "Surgical exposure of impacted or unerupted tooth to aid eruption"
            },
            {
              "code": "6133006",
              "display": "Lymphokine assay"
            },
            {
              "code": "6143009",
              "display": "Diabetic education"
            },
            {
              "code": "6146001",
              "display": "Repair of heart septum with prosthesis"
            },
            {
              "code": "6148000",
              "display": "Chondrectomy of semilunar cartilage of knee"
            },
            {
              "code": "6157006",
              "display": "Endoscopic retrograde cholangiopancreatography with biopsy"
            },
            {
              "code": "6159009",
              "display": "Galactose measurement"
            },
            {
              "code": "6161000",
              "display": "Excision of lesion of capsule of toes"
            },
            {
              "code": "6164008",
              "display": "Osteoclasis of clavicle"
            },
            {
              "code": "6166005",
              "display": "Nephropyeloureterostomy"
            },
            {
              "code": "6177004",
              "display": "Southern blot assay"
            },
            {
              "code": "6187000",
              "display": "Repair of aneurysm with graft of common femoral artery"
            },
            {
              "code": "6188005",
              "display": "Arthrotomy of knee"
            },
            {
              "code": "6189002",
              "display": "Excision of aberrant tissue of breast"
            },
            {
              "code": "6190006",
              "display": "Colopexy"
            },
            {
              "code": "6195001",
              "display": "Transurethral drainage of prostatic abscess"
            },
            {
              "code": "6198004",
              "display": "Repair of fracture with Sofield type procedure"
            },
            {
              "code": "6200005",
              "display": "Excision of lesion of female perineum"
            },
            {
              "code": "6205000",
              "display": "Fluorescent antigen, titer"
            },
            {
              "code": "6213004",
              "display": "Prescribing corneoscleral contact lens"
            },
            {
              "code": "6221005",
              "display": "Suture of colon"
            },
            {
              "code": "6225001",
              "display": "Antibody detection, RBC, enzyme, 2 stage technique, including anti-human globulin"
            },
            {
              "code": "6226000",
              "display": "Visual rehabilitation, eye motion defect"
            },
            {
              "code": "6227009",
              "display": "Relationship psychotherapy"
            },
            {
              "code": "6231003",
              "display": "Graft of palate"
            },
            {
              "code": "6238009",
              "display": "Diagnostic radiography of sacroiliac joints"
            },
            {
              "code": "6240004",
              "display": "Operative procedure on knee"
            },
            {
              "code": "6255008",
              "display": "Resection of abdominal artery with replacement"
            },
            {
              "code": "6271008",
              "display": "Echography, immersion B-scan"
            },
            {
              "code": "6274000",
              "display": "Excision of aural glomus tumor, extended, extratemporal"
            },
            {
              "code": "6286002",
              "display": "Destructive procedure on ovaries and fallopian tubes"
            },
            {
              "code": "6289009",
              "display": "White blood cell histogram evaluation"
            },
            {
              "code": "6295005",
              "display": "Sequestrectomy of pelvic bone"
            },
            {
              "code": "6307005",
              "display": "Keratophakia"
            },
            {
              "code": "6309008",
              "display": "Fecal fat differential, quantitative"
            },
            {
              "code": "6319002",
              "display": "Beta lactamase, chromogenic cephalosporin susceptibility test"
            },
            {
              "code": "6337001",
              "display": "Ligation of aortic arch"
            },
            {
              "code": "6339003",
              "display": "Conditioning play audiometry"
            },
            {
              "code": "6343004",
              "display": "Forensic bite mark comparison technique"
            },
            {
              "code": "6353003",
              "display": "Mitsuda reaction to lepromin"
            },
            {
              "code": "6354009",
              "display": "Sedimentation rate, Westergren"
            },
            {
              "code": "6355005",
              "display": "Removal of internal fixation device of radius"
            },
            {
              "code": "6358007",
              "display": "Capsulorrhaphy of joint"
            },
            {
              "code": "6361008",
              "display": "Anesthesia for popliteal thromboendarterectomy"
            },
            {
              "code": "6363006",
              "display": "Dilation of lacrimal punctum with irrigation"
            },
            {
              "code": "6370006",
              "display": "Chemosurgery of stomach lesion"
            },
            {
              "code": "6384001",
              "display": "Removal of device from digestive system"
            },
            {
              "code": "6385000",
              "display": "Exploration of disc space"
            },
            {
              "code": "6388003",
              "display": "TdT stain"
            },
            {
              "code": "6396008",
              "display": "Galactokinase measurement"
            },
            {
              "code": "6397004",
              "display": "Muscular strength development exercise"
            },
            {
              "code": "6399001",
              "display": "Division of arteriovenous fistula with ligation"
            },
            {
              "code": "6402000",
              "display": "Excision of common bile duct"
            },
            {
              "code": "6403005",
              "display": "Lengthening of muscle of hand"
            },
            {
              "code": "6419003",
              "display": "Excision of tumor from elbow area, deep, subfascial"
            },
            {
              "code": "6429005",
              "display": "Heteroautogenous transplantation"
            },
            {
              "code": "6433003",
              "display": "Closed heart valvotomy of mitral valve"
            },
            {
              "code": "6434009",
              "display": "Seminal fluid detection"
            },
            {
              "code": "6438007",
              "display": "Exploration of ciliary body"
            },
            {
              "code": "6439004",
              "display": "Destruction of lesion of peripheral nerve"
            },
            {
              "code": "6443000",
              "display": "Pontic, porcelain fused to predominantly base metal"
            },
            {
              "code": "6444006",
              "display": "Enlargement of eye socket"
            },
            {
              "code": "6465000",
              "display": "Arthrotomy of glenohumeral joint for infection with drainage"
            },
            {
              "code": "6466004",
              "display": "Administration of Rh immune globulin"
            },
            {
              "code": "6470007",
              "display": "Laparoamnioscopy"
            },
            {
              "code": "6473009",
              "display": "Suture of old obstetrical laceration of uterus"
            },
            {
              "code": "6480006",
              "display": "Urinary bladder residual urine study"
            },
            {
              "code": "6486000",
              "display": "Curettage of sclera"
            },
            {
              "code": "6487009",
              "display": "Hand tendon pulley reconstruction with tendon prosthesis"
            },
            {
              "code": "6491004",
              "display": "Protein S, free assay"
            },
            {
              "code": "6499002",
              "display": "Tsuge operation on finger for macrodactyly repair"
            },
            {
              "code": "6502003",
              "display": "Complete lower denture"
            },
            {
              "code": "6506000",
              "display": "Placing a patient on a bedpan"
            },
            {
              "code": "6519001",
              "display": "Operation on multiple extraocular muscles with temporary detachment from globe"
            },
            {
              "code": "6521006",
              "display": "Polytomography"
            },
            {
              "code": "6527005",
              "display": "Uchida fimbriectomy with tubal ligation by endoscopy"
            },
            {
              "code": "6535008",
              "display": "Excision of cyst of hand"
            },
            {
              "code": "6536009",
              "display": "Implantation of tricuspid valve with tissue graft"
            },
            {
              "code": "6543003",
              "display": "Complicated catheterization of bladder"
            },
            {
              "code": "6547002",
              "display": "Repair with closure of non-surgical wound"
            },
            {
              "code": "6555009",
              "display": "Insertion of infusion pump beneath skin"
            },
            {
              "code": "6556005",
              "display": "Reticulin antibody measurement"
            },
            {
              "code": "6562000",
              "display": "Destruction of lesion of tongue"
            },
            {
              "code": "6563005",
              "display": "Transposition of muscle of hand"
            },
            {
              "code": "6567006",
              "display": "Pulmonary valve commissurotomy by transvenous balloon method"
            },
            {
              "code": "6568001",
              "display": "Diagnostic procedure on eyelid"
            },
            {
              "code": "6585004",
              "display": "Closed reduction of fracture of tarsal or metatarsal"
            },
            {
              "code": "6589005",
              "display": "Antibody titration, high protein"
            },
            {
              "code": "6601003",
              "display": "Removal of foreign body from skin of axilla"
            },
            {
              "code": "6614002",
              "display": "Antibody to single stranded DNA measurement"
            },
            {
              "code": "6615001",
              "display": "Electroretinography with medical evaluation"
            },
            {
              "code": "6622009",
              "display": "Add clasp to existing partial denture"
            },
            {
              "code": "6634001",
              "display": "Destruction of hemorrhoids, internal"
            },
            {
              "code": "6639006",
              "display": "Replacement of obstructed valve in shunt system"
            },
            {
              "code": "6650009",
              "display": "Radionuclide lacrimal flow study"
            },
            {
              "code": "6656003",
              "display": "Acoustic stimulation test"
            },
            {
              "code": "6657007",
              "display": "Maintenance drug therapy for mental disorder"
            },
            {
              "code": "6658002",
              "display": "Removal of foreign body from alveolus"
            },
            {
              "code": "6661001",
              "display": "King-Steelquist hindquarter operation"
            },
            {
              "code": "6665005",
              "display": "Restoration, crown, porcelain fused to noble metal"
            },
            {
              "code": "6668007",
              "display": "Fibrinogen assay, quantitative"
            },
            {
              "code": "6670003",
              "display": "Closure of external fistula of trachea"
            }
          ]
        }
      ]
    }
  }