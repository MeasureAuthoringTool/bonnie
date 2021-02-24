# Description: http://hl7.org/fhir/valueset-medication-as-needed-reason.html
@MedicationAsNeededReasonCodes = class MedicationAsNeededReasonCodes
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "medication-as-needed-reason",
    "url" : "http://hl7.org/fhir/ValueSet/medication-as-needed-reason",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.96"
    }],
    "version" : "4.0.1",
    "name" : "SNOMEDCTMedicationAsNeededReasonCodes",
    "title" : "SNOMED CT Medication As Needed Reason Codes",
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
    "description" : "This value set includes all clinical findings from SNOMED CT - provided as an exemplar value set.",
    "copyright" : "This value set includes content from SNOMED CT, which is copyright 2002+ International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement.",
    "compose" : {
      "include" : [
        {
          "system" : "http://snomed.info/sct",
          "concept" : [
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
            }
          ]
        }
      ]
    }
  }
