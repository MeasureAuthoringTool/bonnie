# http://hl7.org/fhir/valueset-approach-site-codes.html
@AdministrationSiteCodesValueSet = class AdministrationSiteCodesValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "approach-site-codes",
    "url" : "http://hl7.org/fhir/ValueSet/approach-site-codes",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.346"
    }],
    "version" : "4.0.1",
    "name" : "SNOMEDCTAnatomicalStructureForAdministrationSiteCodes",
    "title" : "SNOMED CT Anatomical Structure for Administration Site Codes",
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
    "description" : "This value set includes Anatomical Structure codes from SNOMED CT - provided as an exemplar.",
    "copyright" : "This value set includes content from SNOMED CT, which is copyright Â© 2002 International Health Terminology Standards Development Organisation (IHTSDO), and distributed by agreement between IHTSDO and HL7. Implementer use of SNOMED CT is not covered by this agreement.",
    "compose" : {
      "include" : [
        {
          "system" : "http://snomed.info/sct",
          "concept" : [
            {
              "code": "106004",
              "display": "Posterior carpal region"
            },
            {
              "code": "107008",
              "display": "Fetal part of placenta"
            },
            {
              "code": "108003",
              "display": "Condylar emissary vein"
            },
            {
              "code": "110001",
              "display": "Visceral layer of Bowman's capsule"
            },
            {
              "code": "111002",
              "display": "Parathyroid gland"
            },
            {
              "code": "116007",
              "display": "Subcutaneous tissue of medial surface of index finger"
            },
            {
              "code": "124002",
              "display": "Coronoid process of mandible"
            },
            {
              "code": "149003",
              "display": "Central pair of microtubules, cilium or flagellum, not bacterial"
            },
            {
              "code": "155008",
              "display": "Deep circumflex artery of ilium"
            },
            {
              "code": "167005",
              "display": "Supraclavicular part of brachial plexus"
            },
            {
              "code": "202009",
              "display": "Anterior division of renal artery"
            },
            {
              "code": "205006",
              "display": "Left commissure of aortic valve"
            },
            {
              "code": "206007",
              "display": "Gluteus maximus muscle"
            },
            {
              "code": "221001",
              "display": "Articular surface, phalanges, of fourth metacarpal bone"
            },
            {
              "code": "227002",
              "display": "Canal of Hering"
            },
            {
              "code": "233006",
              "display": "Hepatocolic ligament"
            },
            {
              "code": "235004",
              "display": "Superior labial artery"
            },
            {
              "code": "246001",
              "display": "Lateral vestibular nucleus"
            },
            {
              "code": "247005",
              "display": "Mesotympanum"
            },
            {
              "code": "251007",
              "display": "Pectoral region"
            },
            {
              "code": "256002",
              "display": "Kupffer cell"
            },
            {
              "code": "263002",
              "display": "Thoracic nerve"
            },
            {
              "code": "266005",
              "display": "Right lower lobe of lung"
            },
            {
              "code": "272005",
              "display": "Superior articular process of lumbar vertebra"
            },
            {
              "code": "273000",
              "display": "Lateral myocardium"
            },
            {
              "code": "283001",
              "display": "Central axillary lymph node"
            },
            {
              "code": "284007",
              "display": "Flexor tendon and tendon sheath of fourth toe"
            },
            {
              "code": "289002",
              "display": "Metacarpophalangeal joint of index finger"
            },
            {
              "code": "301000",
              "display": "Fifth metatarsal bone"
            },
            {
              "code": "311007",
              "display": "Plantar surface of great toe"
            },
            {
              "code": "315003",
              "display": "Skin of umbilicus"
            },
            {
              "code": "318001",
              "display": "Cardiac impression of liver"
            },
            {
              "code": "344001",
              "display": "Ankle"
            },
            {
              "code": "345000",
              "display": "Penetrating atrioventricular bundle"
            },
            {
              "code": "356000",
              "display": "Reticular corium"
            },
            {
              "code": "393006",
              "display": "Wall of urinary bladder"
            },
            {
              "code": "402006",
              "display": "Dental branches of inferior alveolar artery"
            },
            {
              "code": "405008",
              "display": "Posterior temporal diploic vein"
            },
            {
              "code": "414003",
              "display": "Gastric fundus"
            },
            {
              "code": "422005",
              "display": "Inferior surface of tongue"
            },
            {
              "code": "446003",
              "display": "Trochanteric bursa"
            },
            {
              "code": "457008",
              "display": "Collateral ligament"
            },
            {
              "code": "461002",
              "display": "Lateral corticospinal tract"
            },
            {
              "code": "464005",
              "display": "Basophilic normoblast"
            },
            {
              "code": "465006",
              "display": "Ascending frontal gyrus"
            },
            {
              "code": "471000",
              "display": "Flexor hallucis longus in leg"
            },
            {
              "code": "480000",
              "display": "Cardiopulmonary circulatory system"
            },
            {
              "code": "485005",
              "display": "TC - Transverse colon"
            },
            {
              "code": "528006",
              "display": "Costal surface of lung"
            },
            {
              "code": "552004",
              "display": "Vagus nerve parasympathetic fibers to cardiac plexus"
            },
            {
              "code": "565008",
              "display": "Intervertebral disc space of fifth lumbar vertebra"
            },
            {
              "code": "582005",
              "display": "Head of phalanx of great toe"
            },
            {
              "code": "587004",
              "display": "Capsule of proximal interphalangeal joint of third toe"
            },
            {
              "code": "589001",
              "display": "Interventricular septum"
            },
            {
              "code": "595000",
              "display": "Palpebral fissure"
            },
            {
              "code": "608002",
              "display": "Subcutaneous tissue of philtrum"
            },
            {
              "code": "621009",
              "display": "Multivesicular body, internal vesicles"
            },
            {
              "code": "635006",
              "display": "Tuberosity of distal phalanx of little toe"
            },
            {
              "code": "650002",
              "display": "Superior articular process of seventh thoracic vertebra"
            },
            {
              "code": "660006",
              "display": "Tracheal mucous membrane"
            },
            {
              "code": "661005",
              "display": "Jaw region"
            },
            {
              "code": "667009",
              "display": "Embryological structure"
            },
            {
              "code": "688000",
              "display": "Fetal hyaloid artery"
            },
            {
              "code": "691000",
              "display": "Small intestine submucosa"
            },
            {
              "code": "692007",
              "display": "Body of ischium"
            },
            {
              "code": "723004",
              "display": "Dense intermediate filament bundles"
            },
            {
              "code": "774007",
              "display": "Head and neck"
            },
            {
              "code": "790007",
              "display": "Visceral surface of liver"
            },
            {
              "code": "798000",
              "display": "Deep temporal veins"
            },
            {
              "code": "808000",
              "display": "Posterior intercostal artery"
            },
            {
              "code": "809008",
              "display": "Fetal chondrocranium"
            },
            {
              "code": "823005",
              "display": "Posterior cervical spinal cord nerve root"
            },
            {
              "code": "830004",
              "display": "Spinous process of fifth thoracic vertebra"
            },
            {
              "code": "836005",
              "display": "Oral region of face"
            },
            {
              "code": "885000",
              "display": "Lamina muscularis of colonic mucous membrane"
            },
            {
              "code": "895007",
              "display": "Anterior cruciate ligament of knee joint"
            },
            {
              "code": "917004",
              "display": "Superior laryngeal aperture"
            },
            {
              "code": "921006",
              "display": "Thyrohyoid branch of ansa cervicalis"
            },
            {
              "code": "947002",
              "display": "Crus of diaphragm"
            },
            {
              "code": "955009",
              "display": "Bronchus"
            },
            {
              "code": "976004",
              "display": "Ovarian vein"
            },
            {
              "code": "996007",
              "display": "Meningeal branch of occipital artery"
            },
            {
              "code": "1005009",
              "display": "Entire diaphragmatic lymph node"
            },
            {
              "code": "1012000",
              "display": "Structure of fibrous portion of pericardium"
            },
            {
              "code": "1015003",
              "display": "Structure of peritonsillar tissue"
            },
            {
              "code": "1028005",
              "display": "Sebaceous gland structure"
            },
            {
              "code": "1030007",
              "display": "Structure of vesicular bursa of sternohyoid muscle"
            },
            {
              "code": "1063000",
              "display": "Frontozygomatic suture of skull"
            },
            {
              "code": "1075005",
              "display": "Promonocyte"
            },
            {
              "code": "1076006",
              "display": "Subcutaneous prepatellar bursa"
            },
            {
              "code": "1086007",
              "display": "Female"
            },
            {
              "code": "1087003",
              "display": "Sternothyroid muscle"
            },
            {
              "code": "1092001",
              "display": "Superior occipital gyrus"
            },
            {
              "code": "1099005",
              "display": "Thymic cortex"
            },
            {
              "code": "1101003",
              "display": "Cranial cavity"
            },
            {
              "code": "1106008",
              "display": "Major calyx"
            },
            {
              "code": "1110006",
              "display": "Tarsal gland"
            },
            {
              "code": "1122009",
              "display": "Inferior longitudinal muscle of tongue"
            },
            {
              "code": "1136004",
              "display": "Aortopulmonary septum"
            },
            {
              "code": "1159005",
              "display": "Frenulum linguae"
            },
            {
              "code": "1172006",
              "display": "Odontoid process of axis"
            },
            {
              "code": "1173001",
              "display": "Mandibular nerve"
            },
            {
              "code": "1174007",
              "display": "Chromosomes, group E"
            },
            {
              "code": "1193009",
              "display": "Teres major muscle"
            },
            {
              "code": "1216008",
              "display": "Synostosis"
            },
            {
              "code": "1231004",
              "display": "Central nervous system meninges"
            },
            {
              "code": "1236009",
              "display": "Duodenal serosa"
            },
            {
              "code": "1243003",
              "display": "Inferior articular process of sixth cervical vertebra"
            },
            {
              "code": "1246006",
              "display": "Dorsal digital nerves of radial nerve"
            },
            {
              "code": "1263005",
              "display": "Distinctive arrangement of microtubules"
            },
            {
              "code": "1277008",
              "display": "Vertebral nerve"
            },
            {
              "code": "1307006",
              "display": "Glottis"
            },
            {
              "code": "1311000",
              "display": "Telogen hair"
            },
            {
              "code": "1350001",
              "display": "Deep flexor tendon of index finger"
            },
            {
              "code": "1353004",
              "display": "Gastric serosa"
            },
            {
              "code": "1403006",
              "display": "Vastus lateralis muscle"
            },
            {
              "code": "1425000",
              "display": "Posterior limb of stapes"
            },
            {
              "code": "1439000",
              "display": "Paravesicular lymph node"
            },
            {
              "code": "1441004",
              "display": "Laryngeal saccule"
            },
            {
              "code": "1456008",
              "display": "Yellow fibrocartilage"
            },
            {
              "code": "1467009",
              "display": "Parietal branch of superficial temporal artery"
            },
            {
              "code": "1484003",
              "display": "Structure of metatarsal region of foot"
            },
            {
              "code": "1490004",
              "display": "Soft tissues of trunk"
            },
            {
              "code": "1502004",
              "display": "Anterior cecal artery"
            },
            {
              "code": "1511004",
              "display": "Ejaculatory duct"
            },
            {
              "code": "1516009",
              "display": "Frontomental diameter of head"
            },
            {
              "code": "1527006",
              "display": "Lamina of fourth thoracic vertebra"
            },
            {
              "code": "1537001",
              "display": "Intervertebral disc of eleventh thoracic vertebra"
            },
            {
              "code": "1541002",
              "display": "Coccygeal plexus"
            },
            {
              "code": "1562001",
              "display": "Nucleus pulposus of intervertebral disc of third lumbar vertebra"
            },
            {
              "code": "1569005",
              "display": "Nail of third toe"
            },
            {
              "code": "1580005",
              "display": "Nucleus ventralis lateralis"
            },
            {
              "code": "1581009",
              "display": "Ileal artery"
            },
            {
              "code": "1584001",
              "display": "Symphysis"
            },
            {
              "code": "1600003",
              "display": "Splenius capitis muscle"
            },
            {
              "code": "1605008",
              "display": "Histioblast"
            },
            {
              "code": "1610007",
              "display": "Otoconia"
            },
            {
              "code": "1611006",
              "display": "Paramammary lymph node"
            },
            {
              "code": "1617005",
              "display": "Intrinsic larynx"
            },
            {
              "code": "1620002",
              "display": "Metaphase nucleus"
            },
            {
              "code": "1626008",
              "display": "Third thoracic vertebra"
            },
            {
              "code": "1627004",
              "display": "Medial collateral ligament of knee joint"
            },
            {
              "code": "1630006",
              "display": "Supraorbital vein"
            },
            {
              "code": "1631005",
              "display": "Foregut"
            },
            {
              "code": "1650005",
              "display": "Hilum of left lung"
            },
            {
              "code": "1655000",
              "display": "Transverse peduncular tract nucleus"
            },
            {
              "code": "1659006",
              "display": "Nucleus medialis dorsalis"
            },
            {
              "code": "1684009",
              "display": "Ligamentum teres of liver"
            },
            {
              "code": "1706004",
              "display": "Thymic lobule"
            },
            {
              "code": "1707008",
              "display": "Ventral nuclear group of thalamus"
            },
            {
              "code": "1711002",
              "display": "Periorbital region"
            },
            {
              "code": "1716007",
              "display": "Cupula ampullaris"
            },
            {
              "code": "1721005",
              "display": "Right tonsil"
            },
            {
              "code": "1729007",
              "display": "Central tegmental tract"
            },
            {
              "code": "1732005",
              "display": "TD - Thoracic duct"
            },
            {
              "code": "1765002",
              "display": "Structure of lymphatic vessel of thorax"
            },
            {
              "code": "1780008",
              "display": "Premelanosome"
            },
            {
              "code": "1781007",
              "display": "Sacroiliac region"
            },
            {
              "code": "1797002",
              "display": "Naris"
            },
            {
              "code": "1818002",
              "display": "Greater circulus arteriosus of iris"
            },
            {
              "code": "1825009",
              "display": "Root of nose"
            },
            {
              "code": "1832000",
              "display": "Scleral conjunctiva"
            },
            {
              "code": "1840006",
              "display": "Arrector pili muscle"
            },
            {
              "code": "1849007",
              "display": "Pharyngeal recess"
            },
            {
              "code": "1853009",
              "display": "Structure of suprahyoid muscle"
            },
            {
              "code": "1874005",
              "display": "Promontory lymph node"
            },
            {
              "code": "1893007",
              "display": "Joint of upper extremity"
            },
            {
              "code": "1895000",
              "display": "Musculophrenic vein"
            },
            {
              "code": "1902009",
              "display": "Skin of external ear"
            },
            {
              "code": "1910005",
              "display": "Ear"
            },
            {
              "code": "1918003",
              "display": "Suprarenal aorta"
            },
            {
              "code": "1927002",
              "display": "Left elbow"
            },
            {
              "code": "1992003",
              "display": "Porus acusticus internus"
            },
            {
              "code": "1997009",
              "display": "Cingulum dentis"
            },
            {
              "code": "2010005",
              "display": "Clavicular facet of scapula"
            },
            {
              "code": "2020000",
              "display": "Superior thoracic artery"
            },
            {
              "code": "2031008",
              "display": "Structure of anterior median fissure of spinal cord"
            },
            {
              "code": "2033006",
              "display": "Right fallopian tube"
            },
            {
              "code": "2044003",
              "display": "Vaginal nerves"
            },
            {
              "code": "2048000",
              "display": "Lingual tonsil"
            },
            {
              "code": "2049008",
              "display": "Chorionic villi"
            },
            {
              "code": "2059009",
              "display": "Skin of ear lobule"
            },
            {
              "code": "2071003",
              "display": "Reticular formation of spinal cord"
            },
            {
              "code": "2076008",
              "display": "Head of phalanx of hand"
            },
            {
              "code": "2083001",
              "display": "Nucleus ambiguus"
            },
            {
              "code": "2095001",
              "display": "Accessory sinus"
            },
            {
              "code": "2123001",
              "display": "Mammilloinfundibular nucleus"
            },
            {
              "code": "2150006",
              "display": "Urinary tract transitional epithelial cell"
            },
            {
              "code": "2156000",
              "display": "Glial cell"
            },
            {
              "code": "2160002",
              "display": "Ligamentum arteriosum"
            },
            {
              "code": "2175005",
              "display": "Pharyngeal cavity"
            },
            {
              "code": "2182009",
              "display": "Endometrial zona basalis"
            },
            {
              "code": "2192001",
              "display": "Clavicular part of pectoralis major muscle"
            },
            {
              "code": "2205003",
              "display": "Lamina of fifth thoracic vertebra"
            },
            {
              "code": "2209009",
              "display": "Cerebral basal surface"
            },
            {
              "code": "2236006",
              "display": "Lesser osseous pelvis"
            },
            {
              "code": "2246008",
              "display": "Type I hair cell"
            },
            {
              "code": "2255006",
              "display": "Subserosa"
            },
            {
              "code": "2285001",
              "display": "Structure of torcular Herophili"
            },
            {
              "code": "2292006",
              "display": "Structure of nasopharyngeal gland"
            },
            {
              "code": "2302002",
              "display": "Vein of the knee"
            },
            {
              "code": "2305000",
              "display": "Structure of spinous process of cervical vertebra"
            },
            {
              "code": "2306004",
              "display": "Structure of base of third metacarpal bone"
            },
            {
              "code": "2327009",
              "display": "Salivary seromucous gland"
            },
            {
              "code": "2330002",
              "display": "Structure of segmental bronchial branches"
            },
            {
              "code": "2332005",
              "display": "Metencephalon of foetus"
            },
            {
              "code": "2334006",
              "display": "Renal calyx"
            },
            {
              "code": "2349003",
              "display": "Structure of nasal suture of skull"
            },
            {
              "code": "2372001",
              "display": "Structure of medial surface of toe"
            },
            {
              "code": "2383005",
              "display": "Structure of papillary muscles of right ventricle"
            },
            {
              "code": "2389009",
              "display": "Structure of superior margin of adrenal gland"
            },
            {
              "code": "2395005",
              "display": "Structure of transverse facial artery"
            },
            {
              "code": "2397002",
              "display": "Structure of first metatarsal facet of medial cuneiform bone"
            },
            {
              "code": "2400006",
              "display": "Universal designation 21"
            },
            {
              "code": "2402003",
              "display": "Structure of dorsum of foot"
            },
            {
              "code": "2421006",
              "display": "Structure of submaxillary ganglion"
            },
            {
              "code": "2433001",
              "display": "Structure of digital tendon and tendon sheath of foot"
            },
            {
              "code": "2436009",
              "display": "Tunica intima of vein"
            },
            {
              "code": "2453002",
              "display": "Subcutaneous tissue structure of posterior surface of forearm"
            },
            {
              "code": "2454008",
              "display": "Structure of articular surface, third metacarpal, of second metacarpal bone"
            },
            {
              "code": "2484000",
              "display": "Skin structure of frenulum of clitoris"
            },
            {
              "code": "2489005",
              "display": "Structure of medial check ligament of eye"
            },
            {
              "code": "2499000",
              "display": "Entire cisterna pontis"
            },
            {
              "code": "2502001",
              "display": "Membrane of lysosome"
            },
            {
              "code": "2504000",
              "display": "Structure of pancreatic plexus"
            },
            {
              "code": "2510000",
              "display": "Femoral triangle structure"
            },
            {
              "code": "2539000",
              "display": "Structure of superior rectal artery"
            },
            {
              "code": "2543001",
              "display": "Structure of cuboid articular facet of fourth metatarsal bone"
            },
            {
              "code": "2550002",
              "display": "Bone structure of phalanx of thumb"
            },
            {
              "code": "2577006",
              "display": "Structure of gracilis muscle"
            },
            {
              "code": "2579009",
              "display": "Plasmablast"
            },
            {
              "code": "2592007",
              "display": "All extremities"
            },
            {
              "code": "2600000",
              "display": "Structure of flexor pollicis longus muscle tendon"
            },
            {
              "code": "2620004",
              "display": "Intervertebral disc structure of third thoracic vertebra"
            },
            {
              "code": "2639009",
              "display": "Neuroendocrine tissue"
            },
            {
              "code": "2653009",
              "display": "Structure of posterior thalamic radiation of internal capsule"
            },
            {
              "code": "2666009",
              "display": "Structure of semispinalis capitis muscle"
            },
            {
              "code": "2672009",
              "display": "Structure of anterior cutaneous branch of lumbosacral plexus"
            },
            {
              "code": "2675006",
              "display": "Structure of anterior ethmoidal artery"
            },
            {
              "code": "2681003",
              "display": "Structure of dorsal nerve of penis"
            },
            {
              "code": "2682005",
              "display": "Bladder mucosa"
            },
            {
              "code": "2686008",
              "display": "Structure of medial olfactory gyrus"
            },
            {
              "code": "2687004",
              "display": "Structure of Bowman space"
            },
            {
              "code": "2695000",
              "display": "Left maxillary sinus structure"
            },
            {
              "code": "2703009",
              "display": "Entire calcarine artery"
            },
            {
              "code": "2712006",
              "display": "Structure of capsule of ankle joint"
            },
            {
              "code": "2718005",
              "display": "Structure of apical foramen of tooth"
            },
            {
              "code": "2726002",
              "display": "Structure of fold for stapes"
            },
            {
              "code": "2730004",
              "display": "Entire vitelline vein of placenta"
            },
            {
              "code": "2739003",
              "display": "Endometrial structure"
            },
            {
              "code": "2741002",
              "display": "Structure of medial occipitotemporal gyrus"
            },
            {
              "code": "2746007",
              "display": "Circular layer of gastric muscularis"
            },
            {
              "code": "2748008",
              "display": "Spinal cord structure"
            },
            {
              "code": "2759004",
              "display": "Eccrine gland structure"
            },
            {
              "code": "2771005",
              "display": "Lamina propria of ureter"
            },
            {
              "code": "2789006",
              "display": "Apocrine gland structure"
            },
            {
              "code": "2792005",
              "display": "Structure of pars tensa of tympanic membrane"
            },
            {
              "code": "2803000",
              "display": "Structure of tendon sheath of popliteus muscle"
            },
            {
              "code": "2810006",
              "display": "Structure of cremasteric fascia"
            },
            {
              "code": "2812003",
              "display": "Structure of head of femur"
            },
            {
              "code": "2824005",
              "display": "Structure of spinous process of fourth thoracic vertebra"
            },
            {
              "code": "2826007",
              "display": "Structure of lamina of fourth lumbar vertebra"
            },
            {
              "code": "2830005",
              "display": "Structure of dorsal digital nerves of lateral hallux and medial second toe"
            },
            {
              "code": "2839006",
              "display": "Structure of perivesicular tissues of seminal vesicles"
            },
            {
              "code": "2841007",
              "display": "Renal artery structure"
            },
            {
              "code": "2845003",
              "display": "Structure of respiratory epithelium"
            },
            {
              "code": "2848001",
              "display": "Structure of superficial epigastric artery"
            },
            {
              "code": "2855004",
              "display": "Structure of accessory cephalic vein"
            },
            {
              "code": "2861001",
              "display": "Entire gland (organ)"
            },
            {
              "code": "2894003",
              "display": "Structure of posterior epiglottis"
            },
            {
              "code": "2905008",
              "display": "Structure of anterior ligament of uterus"
            },
            {
              "code": "2909002",
              "display": "Structure of posterior portion of diaphragmatic aspect of liver"
            },
            {
              "code": "2920002",
              "display": "Structure of facial nerve motor branch"
            },
            {
              "code": "2922005",
              "display": "Structure of posterior papillary muscle of left ventricle"
            },
            {
              "code": "2923000",
              "display": "Subcutaneous tissue structure of supraorbital area"
            },
            {
              "code": "2954001",
              "display": "Supernumerary deciduous tooth"
            },
            {
              "code": "2969000",
              "display": "Anatomical space structure"
            },
            {
              "code": "2979003",
              "display": "Bone structure of medial cuneiform"
            },
            {
              "code": "2986006",
              "display": "Structure of talar facet of navicular bone of foot"
            },
            {
              "code": "2998001",
              "display": "Entire right margin of uterus"
            },
            {
              "code": "3003007",
              "display": "Internal capsule anterior limb structure"
            },
            {
              "code": "3008003",
              "display": "White fibrocartilage"
            },
            {
              "code": "3028004",
              "display": "Transitional epithelial cell"
            },
            {
              "code": "3039001",
              "display": "Subcutaneous tissue structure of thigh"
            },
            {
              "code": "3042007",
              "display": "Structure of glomerular urinary pole"
            },
            {
              "code": "3054007",
              "display": "Structure of articular surface, metacarpal, of phalanx of thumb"
            },
            {
              "code": "3055008",
              "display": "Structure of bone marrow of vertebral body"
            },
            {
              "code": "3056009",
              "display": "Structure of anteroventral nucleus of thalamus"
            },
            {
              "code": "3057000",
              "display": "Nerve structure"
            },
            {
              "code": "3058005",
              "display": "PNS - Peripheral nervous system"
            },
            {
              "code": "3062004",
              "display": "Spinal arachnoid"
            },
            {
              "code": "3068000",
              "display": "Structure of seminal vesicle lumen"
            },
            {
              "code": "3081007",
              "display": "Mitochondrion in division"
            },
            {
              "code": "3093003",
              "display": "Structure of tendinous arch of pelvic fascia"
            },
            {
              "code": "3100007",
              "display": "Clinical crown of tooth"
            },
            {
              "code": "3113001",
              "display": "Structure of suprachoroidal space"
            },
            {
              "code": "3117000",
              "display": "Structure of dorsal surface of index finger"
            },
            {
              "code": "3118005",
              "display": "Structure of trabecula carnea of left ventricle"
            },
            {
              "code": "3120008",
              "display": "Pleural membrane structure"
            },
            {
              "code": "3134008",
              "display": "Structure of head of fourth metatarsal bone"
            },
            {
              "code": "3138006",
              "display": "Bone tissue"
            },
            {
              "code": "3153003",
              "display": "Structure of tractus olivocochlearis"
            },
            {
              "code": "3156006",
              "display": "Structure of obturator artery"
            },
            {
              "code": "3159004",
              "display": "Structure of costocervical trunk"
            },
            {
              "code": "3169005",
              "display": "Spinal nerve structure"
            },
            {
              "code": "3178004",
              "display": "Structure of raphe of soft palate"
            },
            {
              "code": "3194006",
              "display": "Endocardium of right atrium"
            },
            {
              "code": "3198009",
              "display": "Monostomatic sublingual gland"
            },
            {
              "code": "3215002",
              "display": "Subcutaneous tissue structure of nuchal region"
            },
            {
              "code": "3222005",
              "display": "All large arteries"
            },
            {
              "code": "3227004",
              "display": "Left coronary artery main stem"
            },
            {
              "code": "3236000",
              "display": "Structure of posterior segment of right upper lobe of lung"
            },
            {
              "code": "3243006",
              "display": "Structure of parametrial lymph node"
            },
            {
              "code": "3255000",
              "display": "Papillary area"
            },
            {
              "code": "3262009",
              "display": "Structure of root canal of tooth"
            },
            {
              "code": "3279003",
              "display": "Structure of pedicle of third cervical vertebra"
            },
            {
              "code": "3295003",
              "display": "Structure of ventral anterior nucleus of thalamus"
            },
            {
              "code": "3301002",
              "display": "Tectopontine fibers"
            },
            {
              "code": "3302009",
              "display": "Splenic branch of splenic artery"
            },
            {
              "code": "3315000",
              "display": "Structure of vestibulospinal tract"
            },
            {
              "code": "3332001",
              "display": "Occipitofrontal diameter of head"
            },
            {
              "code": "3336003",
              "display": "Haversian canal"
            },
            {
              "code": "3341006",
              "display": "Right lung structure"
            },
            {
              "code": "3350008",
              "display": "Entire right commissure of pulmonic valve"
            },
            {
              "code": "3362007",
              "display": "Intertragal incisure structure"
            },
            {
              "code": "3366005",
              "display": "Structure of anterior papillary muscle of left ventricle"
            },
            {
              "code": "3370002",
              "display": "Structure of supporting tissue of rectum"
            },
            {
              "code": "3374006",
              "display": "Secondary spermatocyte"
            },
            {
              "code": "3377004",
              "display": "Structure of agger nasi"
            },
            {
              "code": "3382006",
              "display": "Structure of rima oris"
            },
            {
              "code": "3383001",
              "display": "Nonsegmented basophil"
            },
            {
              "code": "3394002",
              "display": "Suboccipitobregmatic diameter of head"
            },
            {
              "code": "3395001",
              "display": "Structure of superior palpebral arch"
            },
            {
              "code": "3396000",
              "display": "Structure of mesogastrium"
            },
            {
              "code": "3400000",
              "display": "Cell of bone"
            },
            {
              "code": "3409004",
              "display": "Structure of lateral margin of forearm"
            },
            {
              "code": "3417007",
              "display": "Structure of rotator muscle"
            },
            {
              "code": "3438001",
              "display": "Deep lymphatic of upper extremity"
            },
            {
              "code": "3444002",
              "display": "Thalamostriate vein"
            },
            {
              "code": "3447009",
              "display": "Penetrated oocyte"
            },
            {
              "code": "3460003",
              "display": "Structure of anterodorsal nucleus of thalamus"
            },
            {
              "code": "3462006",
              "display": "Structure of commissure of tricuspid valve"
            },
            {
              "code": "3471002",
              "display": "Posterior midline of trunk"
            },
            {
              "code": "3478008",
              "display": "Structure of vastus medialis muscle"
            },
            {
              "code": "3481003",
              "display": "Structure of embryonic testis"
            },
            {
              "code": "3488009",
              "display": "Annulate lamella, cisternal lumen"
            },
            {
              "code": "3490005",
              "display": "Subcutaneous tissue structure of suboccipital region"
            },
            {
              "code": "3524005",
              "display": "Structure of lateral wall of mastoid antrum"
            },
            {
              "code": "3538003",
              "display": "Structure of capsule of proximal tibiofibular joint"
            },
            {
              "code": "3541007",
              "display": "Structure of dorsal metatarsal artery"
            },
            {
              "code": "3553006",
              "display": "Structure of thyroid capsule"
            },
            {
              "code": "3556003",
              "display": "Structure of dorsal nucleus of trapezoid body"
            },
            {
              "code": "3563003",
              "display": "Muscularis of ureter"
            },
            {
              "code": "3572006",
              "display": "Vertebral body"
            },
            {
              "code": "3578005",
              "display": "Structure of body of gallbladder"
            },
            {
              "code": "3582007",
              "display": "Structure of gastrophrenic ligament"
            },
            {
              "code": "3584008",
              "display": "T10 dorsal arch"
            },
            {
              "code": "3594003",
              "display": "Structure of straight part of longus colli muscle"
            },
            {
              "code": "3608004",
              "display": "Ischiococcygeus muscle"
            },
            {
              "code": "3609007",
              "display": "Structure of occipital branch of posterior auricular artery"
            },
            {
              "code": "3646006",
              "display": "Lamellipodium"
            },
            {
              "code": "3663005",
              "display": "Structure of tympanic ostium of Eustachian tube"
            },
            {
              "code": "3665003",
              "display": "Pelvic wall structure"
            },
            {
              "code": "3670005",
              "display": "Entire subpyloric lymph node"
            },
            {
              "code": "3711007",
              "display": "Great vessel"
            },
            {
              "code": "3743007",
              "display": "Structure of lateral thoracic artery"
            },
            {
              "code": "3761003",
              "display": "Structure of nucleus pulposus of intervertebral disc of first thoracic vertebra"
            },
            {
              "code": "3766008",
              "display": "Subcutaneous tissue structure of lower extremity"
            },
            {
              "code": "3785006",
              "display": "Entire dorsal metacarpal ligament"
            },
            {
              "code": "3788008",
              "display": "Structure of apical segment of right lower lobe of lung"
            },
            {
              "code": "3789000",
              "display": "Enteroendocrine cell"
            },
            {
              "code": "3810000",
              "display": "Septal cartilage structure"
            },
            {
              "code": "3838008",
              "display": "Structure of apex of coccyx"
            },
            {
              "code": "3860006",
              "display": "Structure of transplanted liver"
            },
            {
              "code": "3865001",
              "display": "Structure of interscapular region of back"
            },
            {
              "code": "3867009",
              "display": "Structure of dorsal surface of great toe"
            },
            {
              "code": "3876002",
              "display": "Subcutaneous tissue structure of femoral region"
            },
            {
              "code": "3877006",
              "display": "Structure of common carotid plexus"
            },
            {
              "code": "3910004",
              "display": "Subcutaneous tissue structure of lateral surface of fourth toe"
            },
            {
              "code": "3916005",
              "display": "Structure of occipital lymph node"
            },
            {
              "code": "3924000",
              "display": "Structure of pericardiophrenic artery"
            },
            {
              "code": "3931001",
              "display": "OW - Oval window"
            },
            {
              "code": "3935005",
              "display": "Head of tenth rib structure"
            },
            {
              "code": "3937002",
              "display": "Structure of entorhinal cortex"
            },
            {
              "code": "3954005",
              "display": "Lacrimal sac structure"
            },
            {
              "code": "3956007",
              "display": "Structure of fifth metatarsal articular facet of fourth metatarsal bone"
            },
            {
              "code": "3959000",
              "display": "Structure of rectus capitis muscle"
            },
            {
              "code": "3960005",
              "display": "Olfactory tract structure"
            },
            {
              "code": "3964001",
              "display": "Structure of gyrus of brain"
            },
            {
              "code": "3966004",
              "display": "Entire parietal branch of anterior cerebral artery"
            },
            {
              "code": "3977005",
              "display": "Subcutaneous tissue structure of concha"
            },
            {
              "code": "3984002",
              "display": "Deep vein of clitoris"
            },
            {
              "code": "3989007",
              "display": "Structure of medial globus pallidus"
            },
            {
              "code": "4015004",
              "display": "Chromosomes, group A"
            },
            {
              "code": "4019005",
              "display": "Posterior commissure of labium majorum"
            },
            {
              "code": "4029003",
              "display": "Eosinophilic progranulocyte"
            },
            {
              "code": "4061004",
              "display": "Lateral orbital wall"
            },
            {
              "code": "4066009",
              "display": "Structure of capsule of proximal interphalangeal joint of index finger"
            },
            {
              "code": "4072009",
              "display": "Structure of fourth coccygeal vertebra"
            },
            {
              "code": "4081003",
              "display": "Entire dorsal lingual vein"
            },
            {
              "code": "4093007",
              "display": "Structure of vagus nerve bronchial branch"
            },
            {
              "code": "4111006",
              "display": "Macula of the saccule"
            },
            {
              "code": "4117005",
              "display": "Lumbosacral spinal cord central canal structure"
            },
            {
              "code": "4121003",
              "display": "Structure of superior frontal sulcus"
            },
            {
              "code": "4146003",
              "display": "Structure of artery of extremity"
            },
            {
              "code": "4148002",
              "display": "Structure of palmar surface of little finger"
            },
            {
              "code": "4150005",
              "display": "Celiac nervous plexus structure"
            },
            {
              "code": "4158003",
              "display": "Abdominal aortic plexus structure"
            },
            {
              "code": "4159006",
              "display": "Hyparterial bronchus"
            },
            {
              "code": "4180000",
              "display": "Both lower extremities"
            },
            {
              "code": "4193005",
              "display": "Entire extensor tendon and tendon sheath of fifth toe"
            },
            {
              "code": "4205002",
              "display": "Türk cell"
            },
            {
              "code": "4212006",
              "display": "Epithelial cells"
            },
            {
              "code": "4215008",
              "display": "Head of second rib structure"
            },
            {
              "code": "4247003",
              "display": "Bone structure of first metacarpal"
            },
            {
              "code": "4258007",
              "display": "Posterior tibial vein"
            },
            {
              "code": "4268002",
              "display": "Lateral spinorubral tract"
            },
            {
              "code": "4276000",
              "display": "Structure of inferior articular process of seventh cervical vertebra"
            },
            {
              "code": "4281009",
              "display": "Structure of middle portion of ileum"
            },
            {
              "code": "4295007",
              "display": "Structure of paracortical area of lymph node"
            },
            {
              "code": "4303006",
              "display": "Cartilage canal"
            },
            {
              "code": "4312008",
              "display": "Anterior midline of abdomen"
            },
            {
              "code": "4317002",
              "display": "Structure of spinalis muscle"
            },
            {
              "code": "4328003",
              "display": "Protoplasmic astrocyte"
            },
            {
              "code": "4335006",
              "display": "Upper jaw region"
            },
            {
              "code": "4352005",
              "display": "Structure of subchorionic space"
            },
            {
              "code": "4358009",
              "display": "Structure of lateral surface of little finger"
            },
            {
              "code": "4360006",
              "display": "Stratum spinosum structure"
            },
            {
              "code": "4369007",
              "display": "Small intestine mucous membrane structure"
            },
            {
              "code": "4371007",
              "display": "Structure of fourth metatarsal facet of lateral cuneiform bone"
            },
            {
              "code": "4375003",
              "display": "Structure of incisure of cartilaginous portion of auditory canal"
            },
            {
              "code": "4377006",
              "display": "Structure of parafascicular nucleus of thalamus"
            },
            {
              "code": "4394008",
              "display": "Scala vestibuli structure"
            },
            {
              "code": "4402002",
              "display": "Structure of anterior articular surface for talus"
            },
            {
              "code": "4419000",
              "display": "Tracheal submucosa"
            },
            {
              "code": "4421005",
              "display": "Cellular structures"
            },
            {
              "code": "4430002",
              "display": "Structure of clivus ossis sphenoidalis"
            },
            {
              "code": "4432005",
              "display": "Structure of ductus arteriosus"
            },
            {
              "code": "4442007",
              "display": "Dental arch structure"
            },
            {
              "code": "4486002",
              "display": "Structure of accessory sinus gland"
            },
            {
              "code": "4524000",
              "display": "Structure of subclavian plexus"
            },
            {
              "code": "4527007",
              "display": "Joint structure of lower extremity"
            },
            {
              "code": "4537002",
              "display": "Structure of internal medullary lamina of thalamus"
            },
            {
              "code": "4548009",
              "display": "Lamellated granule, as in surfactant-secreting cell"
            },
            {
              "code": "4549001",
              "display": "Entire vagus nerve parasympathetic fibers to liver, gallbladder, bile ducts and pancreas"
            },
            {
              "code": "4566004",
              "display": "Structure of tentorium cerebelli"
            },
            {
              "code": "4573009",
              "display": "Desmosome"
            },
            {
              "code": "4578000",
              "display": "Skin structure of posterior surface of thigh"
            },
            {
              "code": "4583008",
              "display": "Structure of splenius muscle of trunk"
            },
            {
              "code": "4588004",
              "display": "Structure of middle trunk of brachial plexus"
            },
            {
              "code": "4596009",
              "display": "Larynx structure"
            },
            {
              "code": "4603002",
              "display": "Structure of base of phalanx of foot"
            },
            {
              "code": "4606005",
              "display": "Tubercle of eighth rib structure"
            },
            {
              "code": "4621004",
              "display": "Structure of lesser tuberosity of humerus"
            },
            {
              "code": "4624007",
              "display": "Structure of lymphatic cord"
            },
            {
              "code": "4647008",
              "display": "Lipid droplet, homogeneous"
            },
            {
              "code": "4651005",
              "display": "Structure of tunica albuginea of corpus spongiosum"
            },
            {
              "code": "4658004",
              "display": "Skin structure of nuchal region"
            },
            {
              "code": "4677002",
              "display": "Basal lamina, inclusion in subepithelial location"
            },
            {
              "code": "4703008",
              "display": "Cardinal vein structure"
            },
            {
              "code": "4717004",
              "display": "Neutrophilic myelocyte"
            },
            {
              "code": "4718009",
              "display": "Entire venous plexus of the foramen ovale basis cranii"
            },
            {
              "code": "4743003",
              "display": "Structure of ventral sacrococcygeal ligament"
            },
            {
              "code": "4755009",
              "display": "Structure of medial surface of great toe"
            },
            {
              "code": "4759003",
              "display": "Structure of gemellus muscle"
            },
            {
              "code": "4766002",
              "display": "Structure of supracardinal vein"
            },
            {
              "code": "4768001",
              "display": "Structure of perineal nerve"
            },
            {
              "code": "4774001",
              "display": "Structure of phrenic nerve pericardial branch"
            },
            {
              "code": "4775000",
              "display": "Structure of ventral posterior inferior nucleus"
            },
            {
              "code": "4799000",
              "display": "Deiter cell"
            },
            {
              "code": "4810005",
              "display": "Structure of uterine venous plexus"
            },
            {
              "code": "4812002",
              "display": "Anterior tibial compartment structure"
            },
            {
              "code": "4828007",
              "display": "Femoral canal structure"
            },
            {
              "code": "4840007",
              "display": "Subcutaneous tissue structure of ring finger"
            },
            {
              "code": "4843009",
              "display": "Ampulla of semicircular duct"
            },
            {
              "code": "4861000",
              "display": "Structure of tuberculum impar"
            },
            {
              "code": "4866005",
              "display": "Constrictor muscle of pharynx structure"
            },
            {
              "code": "4870002",
              "display": "Structure of dorsal tegmental nuclei of midbrain"
            },
            {
              "code": "4871003",
              "display": "Lamina of modiolus of cochlea"
            },
            {
              "code": "4881004",
              "display": "Entire sublingual vein"
            },
            {
              "code": "4888005",
              "display": "Entire interlobular vein of kidney"
            },
            {
              "code": "4897009",
              "display": "Cell membrane, prokaryotic"
            },
            {
              "code": "4905007",
              "display": "Structure of uterovaginal plexus"
            },
            {
              "code": "4906008",
              "display": "Mastoid antrum structure"
            },
            {
              "code": "4924005",
              "display": "Cerebellar gracile lobule"
            },
            {
              "code": "4942000",
              "display": "Lower limb lymph node structure"
            },
            {
              "code": "4954000",
              "display": "Structure of radial notch of ulna"
            },
            {
              "code": "4956003",
              "display": "Subcutaneous tissue structure of back"
            },
            {
              "code": "4958002",
              "display": "Amygdaloid structure"
            },
            {
              "code": "5001007",
              "display": "Structure of superior temporal sulcus"
            },
            {
              "code": "5023006",
              "display": "Structure of yellow bone marrow"
            },
            {
              "code": "5026003",
              "display": "Structure of posterior surface of prostate"
            },
            {
              "code": "5046008",
              "display": "Structure of superficial dorsal veins of clitoris"
            },
            {
              "code": "5068003",
              "display": "Structure of obturator internus muscle ischial bursa"
            },
            {
              "code": "5069006",
              "display": "Structure of rugal column"
            },
            {
              "code": "5076001",
              "display": "Structure of infrasternal angle"
            },
            {
              "code": "5115006",
              "display": "Structure of posterior auricular vein"
            },
            {
              "code": "5122003",
              "display": "Entire angle of first rib"
            },
            {
              "code": "5128004",
              "display": "Lens zonules"
            },
            {
              "code": "5140004",
              "display": "Permanent upper right 6 tooth"
            },
            {
              "code": "5192008",
              "display": "Structure of intervertebral foramen of twelfth thoracic vertebra"
            },
            {
              "code": "5194009",
              "display": "Structure of epithelium of lens"
            },
            {
              "code": "5195005",
              "display": "Structure of right external carotid artery"
            },
            {
              "code": "5204005",
              "display": "Superior ileocecal recess"
            },
            {
              "code": "5213007",
              "display": "Frontal vein"
            },
            {
              "code": "5225005",
              "display": "Structure of uterine ostium of fallopian tube"
            },
            {
              "code": "5228007",
              "display": "Right cerebral hemisphere structure"
            },
            {
              "code": "5229004",
              "display": "Structure of mucosa of gallbladder"
            },
            {
              "code": "5261000",
              "display": "Structure of thoracic intervertebral disc"
            },
            {
              "code": "5272005",
              "display": "Skin structure of lateral portion of neck"
            },
            {
              "code": "5279001",
              "display": "Structure of foramen singulare"
            },
            {
              "code": "5296000",
              "display": "Structure of anterior mediastinal lymph node"
            },
            {
              "code": "5324007",
              "display": "Structure of superior pole of kidney"
            },
            {
              "code": "5329002",
              "display": "Bone structure of C4"
            },
            {
              "code": "5336001",
              "display": "Structure of inferior frontal gyrus"
            },
            {
              "code": "5347008",
              "display": "Synaptic specialization, cytoplasmic"
            },
            {
              "code": "5362005",
              "display": "Structure of median arcuate ligament of diaphragm"
            },
            {
              "code": "5366008",
              "display": "Hippocampal structure"
            },
            {
              "code": "5379004",
              "display": "Small intestine muscularis propria"
            },
            {
              "code": "5382009",
              "display": "Superior fascia of perineum"
            },
            {
              "code": "5394000",
              "display": "Uterine paracervical lymph node"
            },
            {
              "code": "5398002",
              "display": "Normal fat pad"
            },
            {
              "code": "5403001",
              "display": "Articular process of third lumbar vertebra"
            },
            {
              "code": "5421003",
              "display": "Sex chromosome Y"
            },
            {
              "code": "5427004",
              "display": "Apocrine intraepidermal duct"
            },
            {
              "code": "5458003",
              "display": "Deep artery of clitoris"
            },
            {
              "code": "5459006",
              "display": "Cardiac incisure of stomach"
            },
            {
              "code": "5491007",
              "display": "Lacrimal part of orbicularis oculi muscle"
            },
            {
              "code": "5493005",
              "display": "Metacarpophalangeal joint of little finger"
            },
            {
              "code": "5498001",
              "display": "Superior aberrant ductule of epididymis"
            },
            {
              "code": "5501001",
              "display": "Hyaloid artery"
            },
            {
              "code": "5520004",
              "display": "Subcutaneous tissue of chin"
            },
            {
              "code": "5538001",
              "display": "Tegmental portion of pons"
            },
            {
              "code": "5542003",
              "display": "Crista marginalis of tooth"
            },
            {
              "code": "5544002",
              "display": "Longitudinal layer of duodenal muscularis propria"
            },
            {
              "code": "5560003",
              "display": "Alveolar ridge mucous membrane"
            },
            {
              "code": "5564007",
              "display": "Singlet"
            },
            {
              "code": "5574005",
              "display": "Seventh costal cartilage"
            },
            {
              "code": "5580002",
              "display": "Tendon of supraspinatus muscle"
            },
            {
              "code": "5597008",
              "display": "Retina of right eye"
            },
            {
              "code": "5611001",
              "display": "Anulus fibrosus of intervertebral disc of fifth cervical vertebra"
            },
            {
              "code": "5625000",
              "display": "Navicular facet of intermediate cuneiform bone"
            },
            {
              "code": "5627008",
              "display": "Right visceral pleura"
            },
            {
              "code": "5633004",
              "display": "Muscular portion of interventricular septum"
            },
            {
              "code": "5643001",
              "display": "Canal of stomach"
            },
            {
              "code": "5644007",
              "display": "Fractured membrane P face"
            },
            {
              "code": "5653000",
              "display": "Inner surface of seventh rib"
            },
            {
              "code": "5665001",
              "display": "Retina"
            },
            {
              "code": "5668004",
              "display": "Lower digestive tract"
            },
            {
              "code": "5677006",
              "display": "Lenticular fasciculus"
            },
            {
              "code": "5682004",
              "display": "Subcutaneous tissue of upper extremity"
            },
            {
              "code": "5696005",
              "display": "Articular part of tubercle of ninth rib"
            },
            {
              "code": "5697001",
              "display": "Skin of lateral surface of finger"
            },
            {
              "code": "5709001",
              "display": "Multifidus muscles"
            },
            {
              "code": "5713008",
              "display": "Submandibular triangle"
            },
            {
              "code": "5717009",
              "display": "Temporal fossa"
            },
            {
              "code": "5718004",
              "display": "Tendon and tendon sheath of leg and ankle"
            },
            {
              "code": "5727003",
              "display": "Anterior cervical lymph node"
            },
            {
              "code": "5742000",
              "display": "Skin of forearm"
            },
            {
              "code": "5751008",
              "display": "Subcutaneous tissue of anterior portion of neck"
            },
            {
              "code": "5769004",
              "display": "Endocervical epithelium"
            },
            {
              "code": "5780004",
              "display": "Paradidymis"
            },
            {
              "code": "5798000",
              "display": "Diaphragm"
            },
            {
              "code": "5802004",
              "display": "Medium sized neuron"
            },
            {
              "code": "5814007",
              "display": "Angle of seventh rib"
            },
            {
              "code": "5815008",
              "display": "Superior rectus muscle"
            },
            {
              "code": "5816009",
              "display": "Duodenal fold"
            },
            {
              "code": "5825003",
              "display": "Substantia propria of sclera"
            },
            {
              "code": "5828001",
              "display": "Posterior cord of brachial plexus"
            },
            {
              "code": "5847003",
              "display": "Superior articular process of seventh cervical vertebra"
            },
            {
              "code": "5854009",
              "display": "Orbital plate of ethmoid bone"
            },
            {
              "code": "5868002",
              "display": "Serosa of urinary bladder"
            },
            {
              "code": "5872003",
              "display": "Subcutaneous tissue of lateral border of sole of foot"
            },
            {
              "code": "5881009",
              "display": "Tuberosity of distal phalanx of hand"
            },
            {
              "code": "5882002",
              "display": "Endothelial sieve plate"
            },
            {
              "code": "5889006",
              "display": "Articular surface, third metacarpal, of fourth metacarpal bone"
            },
            {
              "code": "5890002",
              "display": "Posterior cells of ethmoid sinus"
            },
            {
              "code": "5893000",
              "display": "Superior recess of tympanic membrane"
            },
            {
              "code": "5898009",
              "display": "Myotome"
            },
            {
              "code": "5923009",
              "display": "Articular process of twelfth thoracic vertebra"
            },
            {
              "code": "5926001",
              "display": "Bronchial lumen"
            },
            {
              "code": "5928000",
              "display": "Great cardiac vein"
            },
            {
              "code": "5942008",
              "display": "Tensor tympani muscle"
            },
            {
              "code": "5943003",
              "display": "Vestibular vein"
            },
            {
              "code": "5944009",
              "display": "Posterior palatine arch"
            },
            {
              "code": "5948007",
              "display": "Capsule of distal interphalangeal joint of third toe"
            },
            {
              "code": "5951000",
              "display": "Left wrist"
            },
            {
              "code": "5953002",
              "display": "Eighth rib"
            },
            {
              "code": "5976004",
              "display": "Subcutaneous tissue of eyelid"
            },
            {
              "code": "5979006",
              "display": "Episcleral artery"
            },
            {
              "code": "5996007",
              "display": "Chromosomes, group D"
            },
            {
              "code": "6001004",
              "display": "Quadratus lumborum muscle"
            },
            {
              "code": "6004007",
              "display": "Intervertebral disc of second thoracic vertebra"
            },
            {
              "code": "6006009",
              "display": "Circular layer of duodenal muscularis propria"
            },
            {
              "code": "6009002",
              "display": "Mesentery of ascending colon"
            },
            {
              "code": "6013009",
              "display": "Reticuloendothelial system"
            },
            {
              "code": "6014003",
              "display": "Penicilliary arteries"
            },
            {
              "code": "6023000",
              "display": "Heterolysosome"
            },
            {
              "code": "6032003",
              "display": "Columnar epithelial cell"
            },
            {
              "code": "6046003",
              "display": "Outer surface of third rib"
            },
            {
              "code": "6050005",
              "display": "Lacrimal vein"
            },
            {
              "code": "6059006",
              "display": "Metacarpophalangeal joint of middle finger"
            },
            {
              "code": "6062009",
              "display": "Deciduous mandibular right canine tooth"
            },
            {
              "code": "6073002",
              "display": "Ligament of left superior vena cava"
            },
            {
              "code": "6074008",
              "display": "Capsule of temporomandibular joint"
            },
            {
              "code": "6076005",
              "display": "Gastrointestinal subserosa"
            },
            {
              "code": "6104005",
              "display": "Subclavian nerve"
            },
            {
              "code": "6105006",
              "display": "Body of fifth thoracic vertebra"
            },
            {
              "code": "6110005",
              "display": "Facial nerve parasympathetic fibers"
            },
            {
              "code": "6194002",
              "display": "Nail of fourth toe"
            },
            {
              "code": "6216007",
              "display": "Postcapillary venule"
            },
            {
              "code": "6217003",
              "display": "Piriform recess"
            },
            {
              "code": "6229007",
              "display": "Os lacrimale"
            },
            {
              "code": "6253001",
              "display": "Sulcus terminalis cordis"
            },
            {
              "code": "6268000",
              "display": "Accessory phrenic nerves"
            },
            {
              "code": "6269008",
              "display": "Subcutaneous tissue of scalp"
            },
            {
              "code": "6279005",
              "display": "Skin of dorsal surface of finger"
            },
            {
              "code": "6317000",
              "display": "Posterior basal branch of left pulmonary artery"
            },
            {
              "code": "6325003",
              "display": "Aryepiglottic muscle"
            },
            {
              "code": "6326002",
              "display": "Fetal atloid articulation"
            },
            {
              "code": "6335009",
              "display": "Lymphoid follicle of stomach"
            },
            {
              "code": "6359004",
              "display": "Hair medulla"
            },
            {
              "code": "6371005",
              "display": "Lymphatics of thyroid gland"
            },
            {
              "code": "6375001",
              "display": "Cavernous portion of urethra"
            },
            {
              "code": "6392005",
              "display": "Coccygeal nerve"
            },
            {
              "code": "6404004",
              "display": "Ligamentum nuchae"
            },
            {
              "code": "6413002",
              "display": "Presymphysial lymph node"
            },
            {
              "code": "6417001",
              "display": "Medial malleolus"
            },
            {
              "code": "6423006",
              "display": "Supraspinatus muscle"
            },
            {
              "code": "6424000",
              "display": "Structure of radiating portion of cortical lobule of kidney"
            },
            {
              "code": "6445007",
              "display": "Mast cell"
            },
            {
              "code": "6448009",
              "display": "Posterior vagal trunk"
            },
            {
              "code": "6450001",
              "display": "Cytotrophoblast"
            },
            {
              "code": "6472004",
              "display": "Medial aspect of ovary"
            },
            {
              "code": "6504002",
              "display": "Glans clitoridis"
            },
            {
              "code": "6511003",
              "display": "Distal portion of circumflex branch of left coronary artery"
            },
            {
              "code": "6530003",
              "display": "Cardiac valve leaflet"
            },
            {
              "code": "6533001",
              "display": "Colonic haustra"
            },
            {
              "code": "6538005",
              "display": "Thyrocervical trunk"
            },
            {
              "code": "6541001",
              "display": "Anterior commissure of mitral valve"
            },
            {
              "code": "6544009",
              "display": "Gastrohepatic ligament"
            },
            {
              "code": "6550004",
              "display": "Angular incisure of stomach"
            },
            {
              "code": "6551000",
              "display": "Pollicis artery"
            },
            {
              "code": "6553002",
              "display": "Inferior nasal turbinate"
            },
            {
              "code": "6564004",
              "display": "Medial border of sole"
            },
            {
              "code": "6566002",
              "display": "Cerebellar hemisphere"
            },
            {
              "code": "6572002",
              "display": "Base of phalanx of middle finger"
            },
            {
              "code": "6598008",
              "display": "Lingual nerve"
            },
            {
              "code": "6606008",
              "display": "Structure of dorsal intercuneiform ligaments"
            },
            {
              "code": "6608009",
              "display": "Sphenoparietal sinus"
            },
            {
              "code": "6620001",
              "display": "Cuticle of nail"
            },
            {
              "code": "6623004",
              "display": "Sternal muscle"
            },
            {
              "code": "6633007",
              "display": "Right posterior cerebral artery"
            },
            {
              "code": "6643005",
              "display": "Right anterior cerebral artery"
            },
            {
              "code": "6646002",
              "display": "Anterior fossa of cranial cavity"
            },
            {
              "code": "6649009",
              "display": "Uterine subserosa"
            },
            {
              "code": "6651008",
              "display": "Central lobule of cerebellum"
            },
            {
              "code": "6684008",
              "display": "Articular facet of head of fibula"
            },
            {
              "code": "6685009",
              "display": "Right ankle"
            },
            {
              "code": "6711001",
              "display": "Arch of second lumbar vertebra"
            },
            {
              "code": "6720005",
              "display": "Femoral nerve lateral muscular branches"
            },
            {
              "code": "6731002",
              "display": "Pleural recess"
            },
            {
              "code": "6739000",
              "display": "Chorda tympani"
            },
            {
              "code": "6742006",
              "display": "Callosomarginal branch of anterior cerebral artery"
            },
            {
              "code": "6750002",
              "display": "Mitochondrial inclusion"
            },
            {
              "code": "6757004",
              "display": "Right knee"
            },
            {
              "code": "6787005",
              "display": "Tendon and tendon sheath of hand"
            },
            {
              "code": "6789008",
              "display": "Spermatozoa"
            },
            {
              "code": "6799003",
              "display": "Macula of utricle"
            },
            {
              "code": "6805009",
              "display": "Interstitial tissue of spleen"
            },
            {
              "code": "6820003",
              "display": "Obturator nerve anterior branch"
            },
            {
              "code": "6828005",
              "display": "Ligament of lumbosacral joint"
            },
            {
              "code": "6829002",
              "display": "Pars ciliaris of retina"
            },
            {
              "code": "6834003",
              "display": "Axial skeleton"
            },
            {
              "code": "6841009",
              "display": "Corticomedullary junction of kidney"
            },
            {
              "code": "6844001",
              "display": "Spore crystal"
            },
            {
              "code": "6850006",
              "display": "Secondary foot process"
            },
            {
              "code": "6864006",
              "display": "Leaf of epiglottis"
            },
            {
              "code": "6866008",
              "display": "Habenular commissure"
            },
            {
              "code": "6871001",
              "display": "Visceral pericardium"
            },
            {
              "code": "6894000",
              "display": "Medial surface of arm"
            },
            {
              "code": "6902008",
              "display": "Popliteal region"
            },
            {
              "code": "6905005",
              "display": "Subcutaneous tissue of medial surface of third toe"
            },
            {
              "code": "6912001",
              "display": "Lower alveolar ridge mucosa"
            },
            {
              "code": "6914000",
              "display": "Perivascular space"
            },
            {
              "code": "6921000",
              "display": "Right upper extremity"
            },
            {
              "code": "6930008",
              "display": "Jugular arch"
            },
            {
              "code": "6944002",
              "display": "Anterior labial veins"
            },
            {
              "code": "6969002",
              "display": "Lymphocytic tissue"
            },
            {
              "code": "6975006",
              "display": "Anterior myocardium"
            },
            {
              "code": "6981003",
              "display": "Posterior hypothalamic nucleus"
            },
            {
              "code": "6987004",
              "display": "Collateral sulcus"
            },
            {
              "code": "6989001",
              "display": "Thoracolumbar region of back"
            },
            {
              "code": "6991009",
              "display": "Subcutaneous tissue of jaw"
            },
            {
              "code": "7035006",
              "display": "Bile duct mucous membrane"
            },
            {
              "code": "7050002",
              "display": "Subcutaneous tissue of external genitalia"
            },
            {
              "code": "7067009",
              "display": "Right colic artery"
            },
            {
              "code": "7076002",
              "display": "Interstitial tissue of myocardium"
            },
            {
              "code": "7083009",
              "display": "Middle phalanx of index finger"
            },
            {
              "code": "7090004",
              "display": "Supraaortic branches"
            },
            {
              "code": "7091000",
              "display": "Ventral posterolateral nucleus of thalamus"
            },
            {
              "code": "7099003",
              "display": "Attachment plaque of desmosome or hemidesmosome"
            },
            {
              "code": "7117004",
              "display": "Fetal implantation site"
            },
            {
              "code": "7121006",
              "display": "Maxillary right second molar tooth"
            },
            {
              "code": "7148007",
              "display": "Anulus fibrosus of intervertebral disc of thoracic vertebra"
            },
            {
              "code": "7149004",
              "display": "False rib"
            },
            {
              "code": "7154008",
              "display": "Trigeminal ganglion sensory root"
            },
            {
              "code": "7160008",
              "display": "Base of metacarpal bone"
            },
            {
              "code": "7167006",
              "display": "Paraduodenal recess"
            },
            {
              "code": "7173007",
              "display": "Cauda equina"
            },
            {
              "code": "7188002",
              "display": "Gustatory pore"
            },
            {
              "code": "7192009",
              "display": "Isthmus tympani posticus"
            },
            {
              "code": "7227003",
              "display": "Hypoglossal nerve intrinsic tongue muscle branch"
            },
            {
              "code": "7234001",
              "display": "Inferior choroid vein"
            },
            {
              "code": "7242000",
              "display": "Appendiceal muscularis propria"
            },
            {
              "code": "7275008",
              "display": "Lymphatics of appendix and large intestine"
            },
            {
              "code": "7295002",
              "display": "Muscle of perineum"
            },
            {
              "code": "7296001",
              "display": "Deep inguinal ring"
            },
            {
              "code": "7311008",
              "display": "Anterior surface of arm"
            },
            {
              "code": "7344002",
              "display": "Lingual gyrus"
            },
            {
              "code": "7345001",
              "display": "Ciliary processes"
            },
            {
              "code": "7347009",
              "display": "Infratendinous olecranon bursa"
            },
            {
              "code": "7362006",
              "display": "Lymphatic of head"
            },
            {
              "code": "7376007",
              "display": "Left margin of uterus"
            },
            {
              "code": "7378008",
              "display": "Paraventricular nucleus of thalamus"
            },
            {
              "code": "7384006",
              "display": "Plantar calcaneocuboidal ligament"
            },
            {
              "code": "7404008",
              "display": "Anterior semicircular duct"
            },
            {
              "code": "7435002",
              "display": "Ovarian ligament"
            },
            {
              "code": "7471001",
              "display": "Lateral surface of sublingual gland"
            },
            {
              "code": "7477002",
              "display": "Lipid, crystalline"
            },
            {
              "code": "7480001",
              "display": "Iliotibial tract"
            },
            {
              "code": "7494000",
              "display": "Cerebellar lenticular nucleus"
            },
            {
              "code": "7498002",
              "display": "Plantar tarsal ligaments"
            },
            {
              "code": "7507003",
              "display": "Anterior ligament of head of fibula"
            },
            {
              "code": "7524009",
              "display": "Vasa vasorum"
            },
            {
              "code": "7532001",
              "display": "Vagus nerve parasympathetic fibers"
            },
            {
              "code": "7554004",
              "display": "Deep head of flexor pollicis brevis muscle"
            },
            {
              "code": "7566005",
              "display": "Mitotic cell in anaphase"
            },
            {
              "code": "7569003",
              "display": "Finger"
            },
            {
              "code": "7591005",
              "display": "Intervertebral disc space of eleventh thoracic vertebra"
            },
            {
              "code": "7597009",
              "display": "Subcutaneous tissue of vertex"
            },
            {
              "code": "7605000",
              "display": "Connexon"
            },
            {
              "code": "7610001",
              "display": "Tenth thoracic vertebra"
            },
            {
              "code": "7629007",
              "display": "Thalamoolivary tract"
            },
            {
              "code": "7651004",
              "display": "Intervenous tubercle of right atrium"
            },
            {
              "code": "7652006",
              "display": "Frenulum labii"
            },
            {
              "code": "7657000",
              "display": "Femoral artery"
            },
            {
              "code": "7658005",
              "display": "Subtendinous bursa of triceps brachii muscle"
            },
            {
              "code": "7697002",
              "display": "Pontine portion of medial longitudinal fasciculus"
            },
            {
              "code": "7712004",
              "display": "Subdural space of spinal region"
            },
            {
              "code": "7726008",
              "display": "Skin of medial surface of fifth toe"
            },
            {
              "code": "7736000",
              "display": "Posterior choroidal artery"
            },
            {
              "code": "7742001",
              "display": "Palatine duct"
            },
            {
              "code": "7748002",
              "display": "Skin appendage"
            },
            {
              "code": "7755000",
              "display": "Mesovarian margin of ovary"
            },
            {
              "code": "7756004",
              "display": "Lamina of third thoracic vertebra"
            },
            {
              "code": "7764005",
              "display": "Striate artery"
            },
            {
              "code": "7769000",
              "display": "Right foot"
            },
            {
              "code": "7783003",
              "display": "Sympathetic trunk spinal nerve branch"
            },
            {
              "code": "7820009",
              "display": "Lateral posterior nucleus of thalamus"
            },
            {
              "code": "7829005",
              "display": "Anterior surface of manubrium"
            },
            {
              "code": "7832008",
              "display": "Abdominal aorta"
            },
            {
              "code": "7835005",
              "display": "Posterior margin of nasal septum"
            },
            {
              "code": "7840002",
              "display": "Subcutaneous tissue of submental area"
            },
            {
              "code": "7841003",
              "display": "Macrocytic normochromic erythrocyte"
            },
            {
              "code": "7844006",
              "display": "Sternoclavicular joint"
            },
            {
              "code": "7851002",
              "display": "Intracranial subdural space"
            },
            {
              "code": "7854005",
              "display": "Mandibular canal"
            },
            {
              "code": "7872004",
              "display": "Myocardium of ventricle"
            },
            {
              "code": "7874003",
              "display": "Scapular region of back"
            },
            {
              "code": "7880006",
              "display": "Rhopheocytotic vesicle"
            },
            {
              "code": "7884002",
              "display": "Corneal corpuscle"
            },
            {
              "code": "7885001",
              "display": "Rotator cuff including muscles and tendons"
            },
            {
              "code": "7892006",
              "display": "Submucosa of anal canal"
            },
            {
              "code": "7896009",
              "display": "Occipital angle of parietal bone"
            },
            {
              "code": "7911004",
              "display": "Olivocerebellar fibers"
            },
            {
              "code": "7925003",
              "display": "Proximal phalanx of third toe"
            },
            {
              "code": "7936005",
              "display": "Ligament of diaphragm"
            },
            {
              "code": "7944005",
              "display": "Helper cell"
            },
            {
              "code": "7954009",
              "display": "Lamina propria of ethmoid sinus"
            },
            {
              "code": "7967007",
              "display": "First left aortic arch"
            },
            {
              "code": "7986004",
              "display": "Abdominopelvic portion of sympathetic nervous system"
            },
            {
              "code": "7991003",
              "display": "Skin of glans penis"
            },
            {
              "code": "7999001",
              "display": "Articulations of auditory ossicles"
            },
            {
              "code": "8001006",
              "display": "Mucous membrane of tongue"
            },
            {
              "code": "8012006",
              "display": "Anterior communicating artery"
            },
            {
              "code": "8017000",
              "display": "Inflow tract of right ventricle"
            },
            {
              "code": "8024004",
              "display": "Limitans nucleus"
            },
            {
              "code": "8039003",
              "display": "Subcutaneous acromial bursa"
            },
            {
              "code": "8040001",
              "display": "Superficial flexor tendon of little finger"
            },
            {
              "code": "8045006",
              "display": "Membrane-coating granule, amorphous"
            },
            {
              "code": "8057002",
              "display": "Lateral nuclei of globus pallidus"
            },
            {
              "code": "8059004",
              "display": "Pancreatic veins"
            },
            {
              "code": "8067007",
              "display": "Superficial circumflex iliac vein"
            },
            {
              "code": "8068002",
              "display": "Stratum lemnisci of corpora quadrigemina"
            },
            {
              "code": "8079007",
              "display": "Radial nerve"
            },
            {
              "code": "8091003",
              "display": "Intervertebral disc space of twelfth thoracic vertebra"
            },
            {
              "code": "8100009",
              "display": "Infundibulum of Fallopian tube"
            },
            {
              "code": "8111001",
              "display": "Intranuclear crystal"
            },
            {
              "code": "8112008",
              "display": "Hindgut"
            },
            {
              "code": "8119004",
              "display": "Delphian lymph node"
            },
            {
              "code": "8128003",
              "display": "Supraaortic valve area"
            },
            {
              "code": "8133004",
              "display": "Superior anastomotic vein"
            },
            {
              "code": "8157004",
              "display": "Vein of head"
            },
            {
              "code": "8158009",
              "display": "Interlobar duct of pancreas"
            },
            {
              "code": "8159001",
              "display": "Superior colliculus of corpora quadrigemina"
            },
            {
              "code": "8160006",
              "display": "Lateral striate arteries"
            },
            {
              "code": "8161005",
              "display": "Infraorbital nerve"
            },
            {
              "code": "8165001",
              "display": "Superior articular process of fifth thoracic vertebra"
            },
            {
              "code": "8205005",
              "display": "Wrist"
            },
            {
              "code": "8225009",
              "display": "Accessory atrioventricular bundle"
            },
            {
              "code": "8242003",
              "display": "Apical branch of right pulmonary artery"
            },
            {
              "code": "8251006",
              "display": "Osseous portion of Eustachian tube"
            },
            {
              "code": "8264007",
              "display": "Tunica interna of eyeball"
            },
            {
              "code": "8265008",
              "display": "Articular surface, metacarpal, of phalanx of hand"
            },
            {
              "code": "8266009",
              "display": "Small intestine serosa"
            },
            {
              "code": "8279000",
              "display": "Pelvic viscus"
            },
            {
              "code": "8289001",
              "display": "Below knee region"
            },
            {
              "code": "8292002",
              "display": "Interlobular arteries of liver"
            },
            {
              "code": "8314003",
              "display": "Mastoid fontanel of skull"
            },
            {
              "code": "8334002",
              "display": "Lumbar lymph node"
            },
            {
              "code": "8356004",
              "display": "Colic lymph node"
            },
            {
              "code": "8361002",
              "display": "Tunica intima"
            },
            {
              "code": "8369000",
              "display": "Sphincter pupillae muscle"
            },
            {
              "code": "8373002",
              "display": "Jugum of sphenoid bone"
            },
            {
              "code": "8387002",
              "display": "Lamina of eighth thoracic vertebra"
            },
            {
              "code": "8389004",
              "display": "Birth canal"
            },
            {
              "code": "8412003",
              "display": "Iliac fossa"
            },
            {
              "code": "8415001",
              "display": "Renal surface of adrenal gland"
            },
            {
              "code": "8454000",
              "display": "Joint of lumbar vertebra"
            },
            {
              "code": "8464009",
              "display": "Ligament of sacroiliac joint and pubic symphysis"
            },
            {
              "code": "8482007",
              "display": "Sinoatrial node branch of right coronary artery"
            },
            {
              "code": "8483002",
              "display": "Mesial surface of tooth"
            },
            {
              "code": "8496001",
              "display": "Obliquus capitis muscle"
            },
            {
              "code": "8523001",
              "display": "Inferior articular process of twelfth thoracic vertebra"
            },
            {
              "code": "8546004",
              "display": "Posterior intercavernous sinus"
            },
            {
              "code": "8556000",
              "display": "Lipid droplet"
            },
            {
              "code": "8559007",
              "display": "Juxtaintestinal lymph node"
            },
            {
              "code": "8560002",
              "display": "Interclavicular ligament"
            },
            {
              "code": "8568009",
              "display": "Abdominal lymph nodes"
            },
            {
              "code": "8580001",
              "display": "Both feet"
            },
            {
              "code": "8595004",
              "display": "Meissner's plexus"
            },
            {
              "code": "8598002",
              "display": "Acoustic nerve"
            },
            {
              "code": "8600008",
              "display": "Cricoid cartilage"
            },
            {
              "code": "8603005",
              "display": "Adductor hallucis muscle"
            },
            {
              "code": "8604004",
              "display": "Medulla oblongata fasciculus cuneatus"
            },
            {
              "code": "8608001",
              "display": "Right margin of heart"
            },
            {
              "code": "8617001",
              "display": "Zygomatic region of face"
            },
            {
              "code": "8623006",
              "display": "Transplanted ureter"
            },
            {
              "code": "8629005",
              "display": "Superior right pulmonary vein"
            },
            {
              "code": "8640002",
              "display": "Choroidal branches of posterior spinal artery"
            },
            {
              "code": "8668003",
              "display": "Glycogen vacuole"
            },
            {
              "code": "8671006",
              "display": "All toes"
            },
            {
              "code": "8677005",
              "display": "Body of right atrium"
            },
            {
              "code": "8688004",
              "display": "Lateral olfactory gyrus"
            },
            {
              "code": "8695008",
              "display": "Intervertebral foramen of second lumbar vertebra"
            },
            {
              "code": "8710005",
              "display": "Minor sublingual ducts"
            },
            {
              "code": "8711009",
              "display": "Periodontal tissues"
            },
            {
              "code": "8714001",
              "display": "Subcutaneous tissue of interdigital space of hand"
            },
            {
              "code": "8752000",
              "display": "Cavernous portion of internal carotid artery"
            },
            {
              "code": "8770002",
              "display": "Nail of second toe"
            },
            {
              "code": "8775007",
              "display": "Tendinous arch"
            },
            {
              "code": "8784007",
              "display": "Intranuclear body, granular with filamentous capsule"
            },
            {
              "code": "8810002",
              "display": "Corticomedullary junction of adrenal gland"
            },
            {
              "code": "8814006",
              "display": "Iliac tuberosity"
            },
            {
              "code": "8815007",
              "display": "Thenar and hypothenar spaces"
            },
            {
              "code": "8820007",
              "display": "Pedicle of eleventh thoracic vertebra"
            },
            {
              "code": "8821006",
              "display": "Peroneal artery"
            },
            {
              "code": "8827005",
              "display": "Shaft of phalanx of middle finger"
            },
            {
              "code": "8839002",
              "display": "Agranular endoplasmic reticulum, connection with other organelle"
            },
            {
              "code": "8845005",
              "display": "Subtendinous prepatellar bursa"
            },
            {
              "code": "8850004",
              "display": "Proper fasciculus"
            },
            {
              "code": "8854008",
              "display": "Crista galli"
            },
            {
              "code": "8862000",
              "display": "Palmar surface of middle finger"
            },
            {
              "code": "8873007",
              "display": "Mandibular right second premolar tooth"
            },
            {
              "code": "8887007",
              "display": "Brachiocephalic vein"
            },
            {
              "code": "8892009",
              "display": "Diaphragmatic surface of lung"
            },
            {
              "code": "8894005",
              "display": "Gastric cardiac gland"
            },
            {
              "code": "8897003",
              "display": "Lateral glossoepiglottic fold"
            },
            {
              "code": "8907008",
              "display": "Left ulnar artery"
            },
            {
              "code": "8910001",
              "display": "Inferior transverse scapular ligament"
            },
            {
              "code": "8911002",
              "display": "Endocardium of right ventricle"
            },
            {
              "code": "8928004",
              "display": "Inguinal lymph node"
            },
            {
              "code": "8931003",
              "display": "Coracoid process of scapula"
            },
            {
              "code": "8935007",
              "display": "Cerebral meninges"
            },
            {
              "code": "8942007",
              "display": "Trapezoid ligament"
            },
            {
              "code": "8965002",
              "display": "Stratum zonale of corpora quadrigemina"
            },
            {
              "code": "8966001",
              "display": "Left eye"
            },
            {
              "code": "8983005",
              "display": "Joint structure of vertebral column"
            },
            {
              "code": "8988001",
              "display": "Marginal part of orbicularis oris muscle"
            },
            {
              "code": "8993003",
              "display": "Hepatic vein"
            },
            {
              "code": "9000002",
              "display": "Cerebellar peduncle"
            },
            {
              "code": "9003000",
              "display": "Left parietal lobe"
            },
            {
              "code": "9018004",
              "display": "Middle colic vein"
            },
            {
              "code": "9040008",
              "display": "Ascending colon"
            },
            {
              "code": "9055004",
              "display": "Both forearms"
            },
            {
              "code": "9073001",
              "display": "White matter of insula"
            },
            {
              "code": "9081000",
              "display": "Splenic sinusoids"
            },
            {
              "code": "9086005",
              "display": "Superior laryngeal vein"
            },
            {
              "code": "9089003",
              "display": "Arch of foot"
            },
            {
              "code": "9108007",
              "display": "Vein of the scala tympani"
            },
            {
              "code": "9127001",
              "display": "Transverse folds of palate"
            },
            {
              "code": "9156001",
              "display": "Embryo stage 1"
            },
            {
              "code": "9181003",
              "display": "Accessory carpal bone"
            },
            {
              "code": "9185007",
              "display": "Capsule of metatarsophalangeal joint of fifth toe"
            },
            {
              "code": "9186008",
              "display": "Filaments of contractile apparatus"
            },
            {
              "code": "9188009",
              "display": "Intervertebral disc of eighth thoracic vertebra"
            },
            {
              "code": "9208002",
              "display": "Centriole"
            },
            {
              "code": "9212008",
              "display": "Shaft of fifth metatarsal bone"
            },
            {
              "code": "9229006",
              "display": "Rotatores lumborum muscles"
            },
            {
              "code": "9231002",
              "display": "External pudendal veins"
            },
            {
              "code": "9240003",
              "display": "Niemann-Pick cell"
            },
            {
              "code": "9242006",
              "display": "Posterior segment of right lobe of liver"
            },
            {
              "code": "9258009",
              "display": "Gravid uterus"
            },
            {
              "code": "9261005",
              "display": "Tendon and tendon sheath of second toe"
            },
            {
              "code": "9262003",
              "display": "Fascia of pelvis"
            },
            {
              "code": "9284003",
              "display": "Corpus cavernosum of penis"
            },
            {
              "code": "9290004",
              "display": "Posterior intraoccipital synchondrosis"
            },
            {
              "code": "9305001",
              "display": "Labial veins"
            },
            {
              "code": "9317004",
              "display": "Merkel's tactile disc"
            },
            {
              "code": "9320007",
              "display": "Subtendinous iliac bursa"
            },
            {
              "code": "9321006",
              "display": "Tail of epididymis"
            },
            {
              "code": "9325002",
              "display": "Interdental papilla of gingiva"
            },
            {
              "code": "9332006",
              "display": "Lateral ligament of temporomandibular joint"
            },
            {
              "code": "9348007",
              "display": "Skin of medial surface of middle finger"
            },
            {
              "code": "9379006",
              "display": "Permanent teeth"
            },
            {
              "code": "9380009",
              "display": "Pecten ani"
            },
            {
              "code": "9384000",
              "display": "Lumbar vein"
            },
            {
              "code": "9390001",
              "display": "Lymphatics of stomach"
            },
            {
              "code": "9432007",
              "display": "Plantar surface of fourth toe"
            },
            {
              "code": "9438006",
              "display": "Structure of deep cervical lymphatic vessel"
            },
            {
              "code": "9454009",
              "display": "Subclavian vein"
            },
            {
              "code": "9455005",
              "display": "Medial cartilaginous lamina of Eustachian tube"
            },
            {
              "code": "9475001",
              "display": "Amacrine cells of retina"
            },
            {
              "code": "9481009",
              "display": "Afferent glomerular arteriole"
            },
            {
              "code": "9490002",
              "display": "Pulmonary ligament"
            },
            {
              "code": "9498009",
              "display": "Head of metacarpal bone"
            },
            {
              "code": "9502002",
              "display": "Coronal depression of tooth"
            },
            {
              "code": "9512009",
              "display": "Calcaneocuboidal ligament"
            },
            {
              "code": "9535007",
              "display": "Pyramid of medulla oblongata"
            },
            {
              "code": "9558005",
              "display": "Facet for fifth costal cartilage of sternum"
            },
            {
              "code": "9566001",
              "display": "Duodenal lumen"
            },
            {
              "code": "9568000",
              "display": "Subcutaneous tissue of areola"
            },
            {
              "code": "9596006",
              "display": "Deep branch of ulnar nerve"
            },
            {
              "code": "9609000",
              "display": "Posterior process of nasal septal cartilage"
            },
            {
              "code": "9625005",
              "display": "Lanugo hair"
            },
            {
              "code": "9642004",
              "display": "Left superior vena cava"
            },
            {
              "code": "9646001",
              "display": "Superior transverse scapular ligament"
            },
            {
              "code": "9654004",
              "display": "Gastric mucous gland"
            },
            {
              "code": "9659009",
              "display": "Infraclavicular lymph nodes"
            },
            {
              "code": "9662007",
              "display": "Subcutaneous tissue of lower margin of nasal septum"
            },
            {
              "code": "9668006",
              "display": "Ciliary muscle"
            },
            {
              "code": "9677004",
              "display": "Head of second metatarsal bone"
            },
            {
              "code": "9683001",
              "display": "Melanocyte"
            },
            {
              "code": "9684007",
              "display": "Posterior scrotal branches of internal pudendal artery"
            },
            {
              "code": "9708001",
              "display": "Iliac fascia"
            },
            {
              "code": "9732008",
              "display": "Medial supraclavicular nerves"
            },
            {
              "code": "9736006",
              "display": "Right wrist"
            },
            {
              "code": "9743000",
              "display": "Tendon of index finger"
            },
            {
              "code": "9758008",
              "display": "Submucosa of tonsil"
            },
            {
              "code": "9770007",
              "display": "Genital tubercle"
            },
            {
              "code": "9775002",
              "display": "Left carotid sinus"
            },
            {
              "code": "9779008",
              "display": "Distinctive shape of mitochondrial cristae"
            },
            {
              "code": "9783008",
              "display": "Superficial lymphatics of thorax"
            },
            {
              "code": "9791004",
              "display": "Deep venous system of lower extremity"
            },
            {
              "code": "9796009",
              "display": "Skeletal muscle fiber, type IIb"
            },
            {
              "code": "9813009",
              "display": "Fascia of upper extremity"
            },
            {
              "code": "9825007",
              "display": "Proximal phalanx of little toe"
            },
            {
              "code": "9837009",
              "display": "Perforating branches of internal thoracic artery"
            },
            {
              "code": "9840009",
              "display": "Biparietal diameter of head"
            },
            {
              "code": "9841008",
              "display": "Interspinalis thoracis muscles"
            },
            {
              "code": "9846003",
              "display": "Right kidney"
            },
            {
              "code": "9847007",
              "display": "Hilum of adrenal gland"
            },
            {
              "code": "9849005",
              "display": "Fornix of lacrimal sac"
            },
            {
              "code": "9870004",
              "display": "Carunculae hymenales"
            },
            {
              "code": "9875009",
              "display": "Thymus"
            },
            {
              "code": "9878006",
              "display": "Appendicular vein"
            },
            {
              "code": "9880000",
              "display": "Thyroid tubercle"
            },
            {
              "code": "9881001",
              "display": "Peripheral nerve myelinated nerve fiber"
            },
            {
              "code": "9891007",
              "display": "Transverse arytenoid muscle"
            },
            {
              "code": "9898001",
              "display": "Paracentral lobule"
            },
            {
              "code": "9951005",
              "display": "Posterior ethmoidal nerve"
            },
            {
              "code": "9968009",
              "display": "Primary foot process"
            },
            {
              "code": "9970000",
              "display": "Ileocecal ostium"
            },
            {
              "code": "9976006",
              "display": "Rhomboideus cervicis muscle"
            },
            {
              "code": "9994000",
              "display": "Superior articular process of sixth thoracic vertebra"
            },
            {
              "code": "9999005",
              "display": "Duodenal ampulla"
            },
            {
              "code": "10013000",
              "display": "Lateral meniscus of knee joint"
            },
            {
              "code": "10024003",
              "display": "Base of lung"
            },
            {
              "code": "10025002",
              "display": "Base of phalanx of index finger"
            },
            {
              "code": "10026001",
              "display": "Ventral spinocerebellar tract of pons"
            },
            {
              "code": "10036009",
              "display": "Nucleus pulposus of intervertebral disc of eighth thoracic vertebra"
            },
            {
              "code": "10042008",
              "display": "Intervertebral foramen of fifth thoracic vertebra"
            },
            {
              "code": "10047002",
              "display": "Transplanted lung"
            },
            {
              "code": "10052007",
              "display": "Male"
            },
            {
              "code": "10056005",
              "display": "Ophthalmic nerve"
            },
            {
              "code": "10062000",
              "display": "Levator labii superioris muscle"
            },
            {
              "code": "10119003",
              "display": "Deep volar arch of radial artery"
            },
            {
              "code": "10124000",
              "display": "Deep dorsal sacrococcygeal ligament"
            },
            {
              "code": "10134009",
              "display": "Medial surface of third toe"
            }
          ]
        }
      ]
    }
  }
