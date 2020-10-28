#  Description https://hl7.org/fhir/R4/valueset-device-kind.html
# Used in:
# Resource: ChargeItem.product[x] (Reference(Device|Medication|Substance)|CodeableConcept / Example)
# Resource: DeviceRequest.code[x] (Reference(Device)|CodeableConcept / Example)
# Resource: Procedure.usedCode (CodeableConcept / Example)
# Resource: DeviceDefinition.type (CodeableConcept / Example)
# Extension: https://hl7.org/fhir/StructureDefinition/observation-deviceCode: deviceCode (CodeableConcept / Example)
@DeviceKindValueSet = class DeviceKindValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "device-kind",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>FHIR Device Types</h2><div><p>Codes used to identify medical devices. Includes concepts from SNOMED CT (http://www.snomed.org/) where concept is-a 49062001 (Device)  and is provided as a suggestive example.</p>\n</div><p><b>Copyright Statement:</b></p><div><p>This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include codes from <a href=\"http://www.snomed.org/\"><code>http://snomed.info/sct</code></a> where concept  is-a  49062001 (Device)</li></ul></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "oo"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "draft"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 1
      }],
    "url" : "http://hl7.org/fhir/ValueSet/device-kind",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.208"
    }],
    "version" : "4.0.1",
    "name" : "FHIRDeviceTypes",
    "title" : "FHIR Device Types",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 Orders and Observations Workgroup",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      }]
    }],
    "description" : "Codes used to identify medical devices. Includes concepts from SNOMED CT (http://www.snomed.org/) where concept is-a 49062001 (Device)  and is provided as a suggestive example.",
    "copyright" : "This resource includes content from SNOMED Clinical Terms® (SNOMED CT®) which is copyright of the International Health Terminology Standards Development Organisation (IHTSDO). Implementers of these specifications must have the appropriate SNOMED CT Affiliate license - for more information contact http://www.snomed.org/snomed-ct/get-snomed-ct or info@snomed.org",
    "compose" : {
      "include" : [
        {
          "system" : "http://snomed.info/sct",
          "concept": [
            {
              "code": "49062001",
              "display": "Device (physical object)"
            },
            {
              "code": "156009",
              "display": "Spine board"
            },
            {
              "code": "271003",
              "display": "Bone plate"
            },
            {
              "code": "287000",
              "display": "Air receiver"
            },
            {
              "code": "291005",
              "display": "Atomizer"
            },
            {
              "code": "678001",
              "display": "Epilator"
            },
            {
              "code": "739006",
              "display": "Bicycle ergometer"
            },
            {
              "code": "793009",
              "display": "Mechanical power press"
            },
            {
              "code": "882002",
              "display": "Diagnostic implant"
            },
            {
              "code": "972002",
              "display": "Air filter, device"
            },
            {
              "code": "989005",
              "display": "Linen cloth"
            },
            {
              "code": "994005",
              "display": "Brush, device"
            },
            {
              "code": "1211003",
              "display": "Treadmill, device"
            },
            {
              "code": "1333003",
              "display": "Emesis basin, device"
            },
            {
              "code": "1422002",
              "display": "Plastic mold, device"
            },
            {
              "code": "1579007",
              "display": "Surgical drill, device"
            },
            {
              "code": "1766001",
              "display": "Toboggan, device"
            },
            {
              "code": "1941006",
              "display": "Silk cloth"
            },
            {
              "code": "1962007",
              "display": "Dike, device"
            },
            {
              "code": "2248009",
              "display": "Tracheal tube cuff"
            },
            {
              "code": "2282003",
              "display": "Breast implant"
            },
            {
              "code": "2287009",
              "display": "Nail file, device"
            },
            {
              "code": "2468001",
              "display": "Breath analyzer, device"
            },
            {
              "code": "2478003",
              "display": "Ocular prosthesis"
            },
            {
              "code": "2491002",
              "display": "Intra-aortic balloon catheter, device"
            },
            {
              "code": "3201004",
              "display": "Tent, device"
            },
            {
              "code": "3319006",
              "display": "Artificial liver, device"
            },
            {
              "code": "4408003",
              "display": "Endoscopic camera, device"
            },
            {
              "code": "4632004",
              "display": "Hair cloth"
            },
            {
              "code": "4816004",
              "display": "Metal device"
            },
            {
              "code": "5041003",
              "display": "Adhesive strip, device"
            },
            {
              "code": "5042005",
              "display": "Patient scale, device"
            },
            {
              "code": "5159002",
              "display": "Physiologic monitoring system, device"
            },
            {
              "code": "5679009",
              "display": "Bed sheet"
            },
            {
              "code": "6012004",
              "display": "Hearing aid"
            },
            {
              "code": "6097006",
              "display": "T-tube"
            },
            {
              "code": "6822006",
              "display": "Microwave oven"
            },
            {
              "code": "6919005",
              "display": "Protective clothing material"
            },
            {
              "code": "6972009",
              "display": "Lithotripter"
            },
            {
              "code": "7007007",
              "display": "Radiographic-fluoroscopic unit"
            },
            {
              "code": "7402007",
              "display": "Probe"
            },
            {
              "code": "7406005",
              "display": "Crib"
            },
            {
              "code": "7704007",
              "display": "Stabilizing appliance"
            },
            {
              "code": "7733008",
              "display": "Hydrocephalic shunt catheter"
            },
            {
              "code": "7968002",
              "display": "Three-wheeled all-terrain vehicle"
            },
            {
              "code": "7971005",
              "display": "Fogarty catheter"
            },
            {
              "code": "8060009",
              "display": "Denture"
            },
            {
              "code": "8118007",
              "display": "Crane"
            },
            {
              "code": "8170008",
              "display": "Adhesive"
            },
            {
              "code": "8384009",
              "display": "Band saw"
            },
            {
              "code": "8407004",
              "display": "Bile collection bag"
            },
            {
              "code": "8434001",
              "display": "Gaol"
            },
            {
              "code": "8451008",
              "display": "Intramedullary nail"
            },
            {
              "code": "8615009",
              "display": "Blood electrolyte analyzer"
            },
            {
              "code": "8643000",
              "display": "Mortising machine"
            },
            {
              "code": "8682003",
              "display": "Protective shield"
            },
            {
              "code": "9017009",
              "display": "Ventricular intracranial catheter"
            },
            {
              "code": "9096001",
              "display": "Support"
            },
            {
              "code": "9129003",
              "display": "Feeding catheter"
            },
            {
              "code": "9419002",
              "display": "Bobsled"
            },
            {
              "code": "9458007",
              "display": "Elastic bandage"
            },
            {
              "code": "9611009",
              "display": "Dermatotome"
            },
            {
              "code": "9883003",
              "display": "Cargo handling gear"
            },
            {
              "code": "10244001",
              "display": "Needle guide"
            },
            {
              "code": "10371004",
              "display": "Electrostimulating analgesia unit"
            },
            {
              "code": "10507000",
              "display": "Toeboard"
            },
            {
              "code": "10826000",
              "display": "Industrial saw"
            },
            {
              "code": "10850003",
              "display": "Radiographic-therapeutic unit"
            },
            {
              "code": "10906003",
              "display": "Vein stripper"
            },
            {
              "code": "11141007",
              "display": "Bone growth stimulator"
            },
            {
              "code": "11158002",
              "display": "Electromyographic monitor and recorder"
            },
            {
              "code": "11358008",
              "display": "Prosthetic valve"
            },
            {
              "code": "11987000",
              "display": "Clinical chemistry analyzer"
            },
            {
              "code": "12150006",
              "display": "Cannula"
            },
            {
              "code": "12183004",
              "display": "Upper limb prosthesis"
            },
            {
              "code": "12198002",
              "display": "Ice skate"
            },
            {
              "code": "12953007",
              "display": "File"
            },
            {
              "code": "13118005",
              "display": "Wool cloth"
            },
            {
              "code": "13219008",
              "display": "Gastroscope"
            },
            {
              "code": "13288007",
              "display": "Monitors"
            },
            {
              "code": "13459008",
              "display": "Temporary artificial heart prosthesis"
            },
            {
              "code": "13764006",
              "display": "Uterine sound"
            },
            {
              "code": "13855007",
              "display": "Pillow"
            },
            {
              "code": "13905003",
              "display": "Tennis ball"
            },
            {
              "code": "14106009",
              "display": "Cardiac pacemaker implant"
            },
            {
              "code": "14108005",
              "display": "Cage"
            },
            {
              "code": "14116001",
              "display": "Analgesia unit"
            },
            {
              "code": "14208000",
              "display": "Oil well"
            },
            {
              "code": "14288003",
              "display": "Nasal septum button"
            },
            {
              "code": "14339000",
              "display": "Button"
            },
            {
              "code": "14364002",
              "display": "Camera"
            },
            {
              "code": "14423008",
              "display": "Adhesive bandage"
            },
            {
              "code": "14519003",
              "display": "Aspirator"
            },
            {
              "code": "14548009",
              "display": "Harrington rod"
            },
            {
              "code": "14762000",
              "display": "Alloy steel chain sling"
            },
            {
              "code": "14789005",
              "display": "Prosthetic implant"
            },
            {
              "code": "15000008",
              "display": "Air-conditioner"
            },
            {
              "code": "15340005",
              "display": "Wood's light"
            },
            {
              "code": "15447007",
              "display": "Arthroplasty prosthesis"
            },
            {
              "code": "15644007",
              "display": "Anesthesia unit"
            },
            {
              "code": "15869005",
              "display": "Dosimeter, device"
            },
            {
              "code": "15873008",
              "display": "Boiler, device"
            },
            {
              "code": "15922004",
              "display": "Gown, device"
            },
            {
              "code": "16056004",
              "display": "Boots"
            },
            {
              "code": "16349000",
              "display": "Orthopedic equipment"
            },
            {
              "code": "16417001",
              "display": "Commercial breathing supply hoses diving operation, device"
            },
            {
              "code": "16470007",
              "display": "Electrode, device"
            },
            {
              "code": "16497000",
              "display": "Electric clipper, device"
            },
            {
              "code": "16524003",
              "display": "Cotton cloth"
            },
            {
              "code": "16540000",
              "display": "Umbrella catheter, device"
            },
            {
              "code": "16650009",
              "display": "Splint, device"
            },
            {
              "code": "17102003",
              "display": "NG - Nasogastric tube"
            },
            {
              "code": "17107009",
              "display": "Prosthetic mitral valve"
            },
            {
              "code": "17207004",
              "display": "Mattress, device"
            },
            {
              "code": "17306006",
              "display": "Hernia belt, device"
            },
            {
              "code": "17404008",
              "display": "Cardiac compression board, device"
            },
            {
              "code": "17472008",
              "display": "Knife, device"
            },
            {
              "code": "18151003",
              "display": "Punch, device"
            },
            {
              "code": "18153000",
              "display": "Fluorescence immunoassay analyzer, device"
            },
            {
              "code": "18411005",
              "display": "Chisel, device"
            },
            {
              "code": "18666004",
              "display": "Finespun glass"
            },
            {
              "code": "19257004",
              "display": "Defibrillator, device"
            },
            {
              "code": "19328000",
              "display": "Blanket, device"
            },
            {
              "code": "19443004",
              "display": "Radioactive implant, device"
            },
            {
              "code": "19627002",
              "display": "Leather"
            },
            {
              "code": "19762002",
              "display": "Leather belt"
            },
            {
              "code": "19817005",
              "display": "Fan blade, device"
            },
            {
              "code": "19892000",
              "display": "Scale, device"
            },
            {
              "code": "19923001",
              "display": "Catheter, device"
            },
            {
              "code": "20195009",
              "display": "Leg prosthesis, device"
            },
            {
              "code": "20235003",
              "display": "Toothbrush, device"
            },
            {
              "code": "20273004",
              "display": "Industrial machine, device"
            },
            {
              "code": "20359006",
              "display": "Contraceptive diaphragm, device"
            },
            {
              "code": "20406008",
              "display": "Back rests, device"
            },
            {
              "code": "20428008",
              "display": "Oxygen tent, device"
            },
            {
              "code": "20513005",
              "display": "Power tool, device"
            },
            {
              "code": "20568009",
              "display": "Urinary catheter, device"
            },
            {
              "code": "20613002",
              "display": "Cystoscope, device"
            },
            {
              "code": "20861007",
              "display": "Plug pack, device"
            },
            {
              "code": "20867006",
              "display": "Experimental implant, device"
            },
            {
              "code": "20873007",
              "display": "Plastic cloth-like material"
            },
            {
              "code": "20997002",
              "display": "Hand tool, device"
            },
            {
              "code": "21079000",
              "display": "Carbon monoxide analyzer, device"
            },
            {
              "code": "21546008",
              "display": "Icebox"
            },
            {
              "code": "21870002",
              "display": "Transluminal extraction catheter, device"
            },
            {
              "code": "21944004",
              "display": "Abdominal binder, device"
            },
            {
              "code": "22251003",
              "display": "Timer, device"
            },
            {
              "code": "22283009",
              "display": "Artificial membrane, device"
            },
            {
              "code": "22566001",
              "display": "Cytology brush, device"
            },
            {
              "code": "22662007",
              "display": "Retaining harness, device"
            },
            {
              "code": "22679001",
              "display": "Handcuffs, device"
            },
            {
              "code": "22744006",
              "display": "Artificial hair wig, device"
            },
            {
              "code": "22852002",
              "display": "Therapeutic implant, device"
            },
            {
              "code": "23228005",
              "display": "Arthroscope, device"
            },
            {
              "code": "23366006",
              "display": "Motorized wheelchair device"
            },
            {
              "code": "23699001",
              "display": "Baseball, device"
            },
            {
              "code": "23785007",
              "display": "Arthroscopic irrigation/distension pump, device"
            },
            {
              "code": "23973005",
              "display": "Indwelling urinary catheter, device"
            },
            {
              "code": "24073000",
              "display": "Mechanical cardiac valve prosthesis"
            },
            {
              "code": "24110008",
              "display": "Anoscope, device"
            },
            {
              "code": "24174009",
              "display": "Bronchoscope, device"
            },
            {
              "code": "24230000",
              "display": "Vibrator, device"
            },
            {
              "code": "24290003",
              "display": "Cardiac valve bioprosthesis"
            },
            {
              "code": "24402003",
              "display": "Stepladder, device"
            },
            {
              "code": "24470005",
              "display": "Wrench, device"
            },
            {
              "code": "24513003",
              "display": "Plastic boots"
            },
            {
              "code": "24697008",
              "display": "Ostomy belt, device"
            },
            {
              "code": "24767007",
              "display": "Eustachian tube prosthesis, device"
            },
            {
              "code": "25005004",
              "display": "Snare, device"
            },
            {
              "code": "25062003",
              "display": "Feeding tube, device"
            },
            {
              "code": "25152007",
              "display": "Squeeze cage, device"
            },
            {
              "code": "25510005",
              "display": "Heart valve prosthesis"
            },
            {
              "code": "25632005",
              "display": "Hockey puck, device"
            },
            {
              "code": "25680008",
              "display": "Scaffold, device"
            },
            {
              "code": "25742001",
              "display": "Orthodontic appliance, device"
            },
            {
              "code": "25937001",
              "display": "Neurostimulation device"
            },
            {
              "code": "26128008",
              "display": "Bougie, device"
            },
            {
              "code": "26239002",
              "display": "Soccer ball, device"
            },
            {
              "code": "26334009",
              "display": "Dockboard, device"
            },
            {
              "code": "26397000",
              "display": "Reservoir bag"
            },
            {
              "code": "26412008",
              "display": "ET - Endotracheal tube"
            },
            {
              "code": "26579007",
              "display": "Holter valve, device"
            },
            {
              "code": "26719000",
              "display": "Celestin tube, device"
            },
            {
              "code": "26882005",
              "display": "Rongeur, device"
            },
            {
              "code": "27042007",
              "display": "Needle adapter, device"
            },
            {
              "code": "27065002",
              "display": "Suture"
            },
            {
              "code": "27091001",
              "display": "Dumbwaiter, device"
            },
            {
              "code": "27126002",
              "display": "Power belt, device"
            },
            {
              "code": "27229001",
              "display": "Spray booth, device"
            },
            {
              "code": "27606000",
              "display": "Dental prosthesis, device"
            },
            {
              "code": "27785006",
              "display": "Athletic supporter, device"
            },
            {
              "code": "27812008",
              "display": "Electric heating pad, device"
            },
            {
              "code": "27976001",
              "display": "Woodworking machinery, device"
            },
            {
              "code": "27991004",
              "display": "Thermometer, device"
            },
            {
              "code": "28026003",
              "display": "Hairbrush, device"
            },
            {
              "code": "29292008",
              "display": "Fur garment"
            },
            {
              "code": "29319002",
              "display": "Forceps, device"
            },
            {
              "code": "29396008",
              "display": "Resuscitator, device"
            },
            {
              "code": "30012001",
              "display": "Elevator, device"
            },
            {
              "code": "30070001",
              "display": "Multistage suspension scaffolding, device"
            },
            {
              "code": "30115002",
              "display": "Shield, device"
            },
            {
              "code": "30176005",
              "display": "Baseball bat, device"
            },
            {
              "code": "30234008",
              "display": "Medical laboratory analyzer, device"
            },
            {
              "code": "30610008",
              "display": "Epidural catheter, device"
            },
            {
              "code": "30661003",
              "display": "Cosmetic prosthesis, device"
            },
            {
              "code": "30929000",
              "display": "Ligator, device"
            },
            {
              "code": "30968007",
              "display": "Drainage bag, device"
            },
            {
              "code": "31030004",
              "display": "Peritoneal catheter, device"
            },
            {
              "code": "31031000",
              "display": "Internal fixator"
            },
            {
              "code": "31174004",
              "display": "Lumbosacral belt, device"
            },
            {
              "code": "31791005",
              "display": "Traction belt, device"
            },
            {
              "code": "31878003",
              "display": "Surgical scissors, device"
            },
            {
              "code": "32033000",
              "display": "Arterial pressure monitor, device"
            },
            {
              "code": "32356002",
              "display": "Machine guarding, device"
            },
            {
              "code": "32504006",
              "display": "Screwdriver, device"
            },
            {
              "code": "32634007",
              "display": "Fixed ladder, device"
            },
            {
              "code": "32667006",
              "display": "Oral airway"
            },
            {
              "code": "32711007",
              "display": "Ostomy collection bag, device"
            },
            {
              "code": "32712000",
              "display": "Drain, device"
            },
            {
              "code": "32871007",
              "display": "Tweezer, device"
            },
            {
              "code": "33194000",
              "display": "Welding equipment, device"
            },
            {
              "code": "33352006",
              "display": "Ax, device"
            },
            {
              "code": "33388001",
              "display": "Carbon dioxide analyzer, device"
            },
            {
              "code": "33482001",
              "display": "Rubber boots"
            },
            {
              "code": "33686008",
              "display": "Stylet, device"
            },
            {
              "code": "33690005",
              "display": "Sharp instrument, device"
            },
            {
              "code": "33802005",
              "display": "Enema bag, device"
            },
            {
              "code": "33894003",
              "display": "Experimental device"
            },
            {
              "code": "33918000",
              "display": "Rubberized cloth"
            },
            {
              "code": "34164001",
              "display": "POP - Plaster of Paris cast"
            },
            {
              "code": "34188004",
              "display": "Straightjacket, device"
            },
            {
              "code": "34234003",
              "display": "Plastic tube, device"
            },
            {
              "code": "34263000",
              "display": "Medical balloon, device"
            },
            {
              "code": "34362008",
              "display": "Vascular device"
            },
            {
              "code": "34759008",
              "display": "Urethral catheter, device"
            },
            {
              "code": "35398009",
              "display": "Ostomy appliance, device"
            },
            {
              "code": "35593004",
              "display": "Wire ligature, device"
            },
            {
              "code": "35870000",
              "display": "Cerebrospinal catheter, device"
            },
            {
              "code": "36365007",
              "display": "Ice-pick, device"
            },
            {
              "code": "36370000",
              "display": "Aspirator trap bottle, device"
            },
            {
              "code": "36645008",
              "display": "Stimulator, device"
            },
            {
              "code": "36761001",
              "display": "Natural hair wig, device"
            },
            {
              "code": "36965003",
              "display": "Hemodialysis machine, device"
            },
            {
              "code": "36977008",
              "display": "Peripheral nerve stimulator"
            },
            {
              "code": "37189001",
              "display": "Magnetic detector, device"
            },
            {
              "code": "37270008",
              "display": "Endoscope, device"
            },
            {
              "code": "37284003",
              "display": "Bag, device"
            },
            {
              "code": "37311003",
              "display": "Stone retrieval basket, device"
            },
            {
              "code": "37347002",
              "display": "Dildo, device"
            },
            {
              "code": "37360008",
              "display": "Patient isolator, device"
            },
            {
              "code": "37503007",
              "display": "Protective blind, device"
            },
            {
              "code": "37759000",
              "display": "Surgical instrument, device"
            },
            {
              "code": "37874008",
              "display": "Continuing positive airway pressure unit, device"
            },
            {
              "code": "37953008",
              "display": "Bedside rails, device"
            },
            {
              "code": "38126007",
              "display": "Protective lenses"
            },
            {
              "code": "38141007",
              "display": "Tourniquet, device"
            },
            {
              "code": "38277008",
              "display": "Protective device"
            },
            {
              "code": "38806006",
              "display": "Hockey stick, device"
            },
            {
              "code": "38862006",
              "display": "Sheet metal bending equipment"
            },
            {
              "code": "38871002",
              "display": "Metallic cloth"
            },
            {
              "code": "39590006",
              "display": "Air compressor, device"
            },
            {
              "code": "39690000",
              "display": "Sphygmomanometer, device"
            },
            {
              "code": "39768008",
              "display": "Rasp, device"
            },
            {
              "code": "39790008",
              "display": "Non-electric heating pad, device"
            },
            {
              "code": "39802000",
              "display": "Tongue blade, device"
            },
            {
              "code": "39821008",
              "display": "Positron emission tomography unit, device"
            },
            {
              "code": "39849001",
              "display": "Nasal oxygen cannula"
            },
            {
              "code": "39869006",
              "display": "Alarm, device"
            },
            {
              "code": "40388003",
              "display": "Biomedical implant"
            },
            {
              "code": "40519001",
              "display": "Binder, device"
            },
            {
              "code": "41157002",
              "display": "Orthopedic immobilizer"
            },
            {
              "code": "41323003",
              "display": "Urinary collection bag, device"
            },
            {
              "code": "41525006",
              "display": "Artificial structure, device"
            },
            {
              "code": "41684000",
              "display": "Industrial tool, device"
            },
            {
              "code": "42152006",
              "display": "Metal tube, device"
            },
            {
              "code": "42305009",
              "display": "Ambulation device"
            },
            {
              "code": "42380001",
              "display": "Ear plug, device"
            },
            {
              "code": "42451009",
              "display": "Blood warmer, device"
            },
            {
              "code": "42716000",
              "display": "Wool"
            },
            {
              "code": "42882002",
              "display": "Hypodermic spray, device"
            },
            {
              "code": "43001000",
              "display": "Phlebotomy kit, device"
            },
            {
              "code": "43192004",
              "display": "Bone pencil, device"
            },
            {
              "code": "43252007",
              "display": "Cochlear implant"
            },
            {
              "code": "43725001",
              "display": "Airway equipment"
            },
            {
              "code": "43734006",
              "display": "Blood administration set, device"
            },
            {
              "code": "43770009",
              "display": "Doppler device"
            },
            {
              "code": "43983001",
              "display": "Shoes"
            },
            {
              "code": "44056008",
              "display": "Caliper, device"
            },
            {
              "code": "44396004",
              "display": "Magnet, device"
            },
            {
              "code": "44492001",
              "display": "Industrial robot, device"
            },
            {
              "code": "44668000",
              "display": "Pump, device"
            },
            {
              "code": "44738004",
              "display": "Laryngoscope, device"
            },
            {
              "code": "44806002",
              "display": "Esophageal bougie, device"
            },
            {
              "code": "44845007",
              "display": "Golf ball, device"
            },
            {
              "code": "44907005",
              "display": "Four-wheeled all-terrain vehicle, device"
            },
            {
              "code": "44959004",
              "display": "Angioplasty balloon catheter, device"
            },
            {
              "code": "45633005",
              "display": "Peritoneal dialyzer, device"
            },
            {
              "code": "45901004",
              "display": "Penrose drain, device"
            },
            {
              "code": "46181005",
              "display": "Automatic fire extinguisher system, device"
            },
            {
              "code": "46265007",
              "display": "Artificial lashes, device"
            },
            {
              "code": "46299005",
              "display": "Sanitary belt, device"
            },
            {
              "code": "46364009",
              "display": "Clamp, device"
            },
            {
              "code": "46440007",
              "display": "Basketball, device"
            },
            {
              "code": "46625003",
              "display": "Suppository"
            },
            {
              "code": "46666003",
              "display": "Chain, device"
            },
            {
              "code": "46949002",
              "display": "Deck machinery, device"
            },
            {
              "code": "47162009",
              "display": "Mirror, device"
            },
            {
              "code": "47326004",
              "display": "Electrical utilization equipment, device"
            },
            {
              "code": "47424002",
              "display": "Apgar scoring timer, device"
            },
            {
              "code": "47528002",
              "display": "Ureteric catheter"
            },
            {
              "code": "47731004",
              "display": "Birthing chair, device"
            },
            {
              "code": "47734007",
              "display": "Chromic catgut suture"
            },
            {
              "code": "47776004",
              "display": "Mittens"
            },
            {
              "code": "47942000",
              "display": "Proctoscope, device"
            },
            {
              "code": "48066006",
              "display": "Circular portable saw, device"
            },
            {
              "code": "48096001",
              "display": "Bathtub rails, device"
            },
            {
              "code": "48240003",
              "display": "Training equipment, device"
            },
            {
              "code": "48246009",
              "display": "Studgun, device"
            },
            {
              "code": "48295009",
              "display": "Vascular filter, device"
            },
            {
              "code": "48473008",
              "display": "Protective body armor, device"
            },
            {
              "code": "48822005",
              "display": "Bilirubin light, device"
            },
            {
              "code": "48990009",
              "display": "Strap, device"
            },
            {
              "code": "49448001",
              "display": "Razor, device"
            },
            {
              "code": "49890001",
              "display": "Hospital cart, device"
            },
            {
              "code": "50121007",
              "display": "Glasses"
            },
            {
              "code": "50457005",
              "display": "Workover rig service to oil well, device"
            },
            {
              "code": "50483000",
              "display": "Oil rig"
            },
            {
              "code": "50851003",
              "display": "Penile tumescence monitor, device"
            },
            {
              "code": "51016001",
              "display": "Hammer, device"
            },
            {
              "code": "51086006",
              "display": "Shower curtain, device"
            },
            {
              "code": "51324004",
              "display": "Stripper, device"
            },
            {
              "code": "51685009",
              "display": "Roller skate, device"
            },
            {
              "code": "51791000",
              "display": "Measuring tape, device"
            },
            {
              "code": "51832004",
              "display": "Valved tube, device"
            },
            {
              "code": "51883004",
              "display": "Sling, device"
            },
            {
              "code": "52124006",
              "display": "Central line"
            },
            {
              "code": "52161002",
              "display": "Molten lava"
            },
            {
              "code": "52291003",
              "display": "Gloves"
            },
            {
              "code": "52520009",
              "display": "Ladder, device"
            },
            {
              "code": "52537002",
              "display": "Aspirator collection canister, device"
            },
            {
              "code": "52624007",
              "display": "Radiofrequency generator, device"
            },
            {
              "code": "52773007",
              "display": "Ski, device"
            },
            {
              "code": "52809000",
              "display": "Nasopharyngeal catheter, device"
            },
            {
              "code": "52893008",
              "display": "Blood gas/pH analyzer, device"
            },
            {
              "code": "53167006",
              "display": "Platform suspended boom, device"
            },
            {
              "code": "53177008",
              "display": "Nasal balloon, device"
            },
            {
              "code": "53217009",
              "display": "Artificial lung, device"
            },
            {
              "code": "53350007",
              "display": "Prosthesis, device"
            },
            {
              "code": "53535004",
              "display": "Retractor, device"
            },
            {
              "code": "53639001",
              "display": "Stethoscope, device"
            },
            {
              "code": "53671008",
              "display": "Gastric balloon, device"
            },
            {
              "code": "53996008",
              "display": "Penile prosthesis, device"
            },
            {
              "code": "54234007",
              "display": "Cryogenic analgesia unit, device"
            },
            {
              "code": "54638004",
              "display": "Towel, device"
            },
            {
              "code": "54953005",
              "display": "Computerized axial tomography scanner, device"
            },
            {
              "code": "55091003",
              "display": "Blood coagulation analyzer, device"
            },
            {
              "code": "55206006",
              "display": "Suture button, device"
            },
            {
              "code": "55216003",
              "display": "Amnioscope, device"
            },
            {
              "code": "55337009",
              "display": "Auscultoscope, device"
            },
            {
              "code": "55567004",
              "display": "Bassinet, device"
            },
            {
              "code": "55658008",
              "display": "Hot object"
            },
            {
              "code": "55986002",
              "display": "Tong, device"
            },
            {
              "code": "56144002",
              "display": "Back braces, device"
            },
            {
              "code": "56353002",
              "display": "Staple, device"
            },
            {
              "code": "56547001",
              "display": "Trephine, device"
            },
            {
              "code": "56896002",
              "display": "Pacemaker catheter, device"
            },
            {
              "code": "56961003",
              "display": "Cardiac transvenous pacemaker, device"
            },
            {
              "code": "57118008",
              "display": "Perfusion pump, device"
            },
            {
              "code": "57134006",
              "display": "Clinical instrument"
            },
            {
              "code": "57368009",
              "display": "Contact lens"
            },
            {
              "code": "57395004",
              "display": "Physical restraint equipment, device"
            },
            {
              "code": "57730005",
              "display": "Abrasive grinding, device"
            },
            {
              "code": "58153004",
              "display": "Android, device"
            },
            {
              "code": "58253008",
              "display": "Suction catheter, device"
            },
            {
              "code": "58514003",
              "display": "Infant scale, device"
            },
            {
              "code": "58878002",
              "display": "Protective vest, device"
            },
            {
              "code": "58938008",
              "display": "WC - Wheelchair"
            },
            {
              "code": "59102007",
              "display": "Ice bag, device"
            },
            {
              "code": "59127000",
              "display": "Apnea alarm, device"
            },
            {
              "code": "59153008",
              "display": "Barge, device"
            },
            {
              "code": "59160002",
              "display": "Chipguard, device"
            },
            {
              "code": "59181002",
              "display": "Oxygen analyzer, device"
            },
            {
              "code": "59432006",
              "display": "Ligature, device"
            },
            {
              "code": "59746007",
              "display": "Needle holder, device"
            },
            {
              "code": "59772003",
              "display": "Culdoscope, device"
            },
            {
              "code": "59782002",
              "display": "Speculum, device"
            },
            {
              "code": "59833007",
              "display": "Collapsible balloon, device"
            },
            {
              "code": "60054005",
              "display": "SB - Seat belt"
            },
            {
              "code": "60110001",
              "display": "Wig, device"
            },
            {
              "code": "60150003",
              "display": "Skipole, device"
            },
            {
              "code": "60161006",
              "display": "Acupuncture needle, device"
            },
            {
              "code": "60185003",
              "display": "Carbon dioxide absorber, device"
            },
            {
              "code": "60311007",
              "display": "Leather boots"
            },
            {
              "code": "60773001",
              "display": "Injector"
            },
            {
              "code": "60806001",
              "display": "Whirlpool bath"
            },
            {
              "code": "60957001",
              "display": "Otoscope"
            },
            {
              "code": "61330002",
              "display": "Nasopharyngeal airway device"
            },
            {
              "code": "61512008",
              "display": "Tennis racket"
            },
            {
              "code": "61835000",
              "display": "Dilator"
            },
            {
              "code": "61968008",
              "display": "Syringe"
            },
            {
              "code": "61979003",
              "display": "Antiembolic device"
            },
            {
              "code": "62336005",
              "display": "Electric cable"
            },
            {
              "code": "62495008",
              "display": "Gamma counter"
            },
            {
              "code": "62614002",
              "display": "Overhead and gantry crane"
            },
            {
              "code": "62980002",
              "display": "Tubular bandage"
            },
            {
              "code": "63112008",
              "display": "Bone wire"
            },
            {
              "code": "63173005",
              "display": "Hat band"
            },
            {
              "code": "63289001",
              "display": "Metal nail"
            },
            {
              "code": "63336000",
              "display": "Bone plug"
            },
            {
              "code": "63548003",
              "display": "Derrick"
            },
            {
              "code": "63562005",
              "display": "Cervical collar"
            },
            {
              "code": "63619003",
              "display": "Fiberoptic cable"
            },
            {
              "code": "63653004",
              "display": "Medical device"
            },
            {
              "code": "63797009",
              "display": "Traction unit"
            },
            {
              "code": "63839002",
              "display": "Electroejaculator"
            },
            {
              "code": "63995005",
              "display": "Bandage"
            },
            {
              "code": "64174005",
              "display": "Snowmobile"
            },
            {
              "code": "64255007",
              "display": "Esophageal balloon"
            },
            {
              "code": "64565002",
              "display": "Air tool"
            },
            {
              "code": "64571008",
              "display": "Hair clipper"
            },
            {
              "code": "64883003",
              "display": "Inhalation analgesia unit"
            },
            {
              "code": "64973003",
              "display": "Scissors"
            },
            {
              "code": "64989000",
              "display": "Escalator"
            },
            {
              "code": "65053001",
              "display": "Electrical battery"
            },
            {
              "code": "65105002",
              "display": "Surgical drapes"
            },
            {
              "code": "65268008",
              "display": "Chart recorder"
            },
            {
              "code": "65473004",
              "display": "Microscope"
            },
            {
              "code": "65577000",
              "display": "X-ray shield"
            },
            {
              "code": "65818007",
              "display": "Stent"
            },
            {
              "code": "66222000",
              "display": "Hospital robot"
            },
            {
              "code": "66415006",
              "display": "Audiometric testing equipment"
            },
            {
              "code": "66435007",
              "display": "Electric bed"
            },
            {
              "code": "66494009",
              "display": "Face cloth"
            },
            {
              "code": "67270000",
              "display": "Hip prosthesis"
            },
            {
              "code": "67387001",
              "display": "Coronary perfusion catheter"
            },
            {
              "code": "67670006",
              "display": "Radiographic-tomographic unit"
            },
            {
              "code": "67777003",
              "display": "Moving walk"
            },
            {
              "code": "67829007",
              "display": "Esophagoscope"
            },
            {
              "code": "67920005",
              "display": "Aerial lift"
            },
            {
              "code": "67966000",
              "display": "Enema tube"
            },
            {
              "code": "68080007",
              "display": "Radiographic unit"
            },
            {
              "code": "68181008",
              "display": "Vibrating electric heating pad"
            },
            {
              "code": "68183006",
              "display": "Bone screw"
            },
            {
              "code": "68276009",
              "display": "Bottle"
            },
            {
              "code": "68325009",
              "display": "Sound"
            },
            {
              "code": "68597009",
              "display": "Support belt"
            },
            {
              "code": "68685003",
              "display": "Household robot"
            },
            {
              "code": "68842005",
              "display": "Gastroduodenoscope"
            },
            {
              "code": "69670004",
              "display": "Patient utensil kit"
            },
            {
              "code": "69805005",
              "display": "Insulin pump"
            },
            {
              "code": "69922008",
              "display": "Tracheostomy button"
            },
            {
              "code": "70080007",
              "display": "Bayonet"
            },
            {
              "code": "70300000",
              "display": "Skull tongs"
            },
            {
              "code": "70303003",
              "display": "Freezer"
            },
            {
              "code": "70453008",
              "display": "Sled"
            },
            {
              "code": "70665002",
              "display": "Blood pressure cuff"
            },
            {
              "code": "70793005",
              "display": "Recreation equipment"
            },
            {
              "code": "70872004",
              "display": "Wash basin"
            },
            {
              "code": "71384000",
              "display": "Warmer"
            },
            {
              "code": "71483007",
              "display": "Diving stage"
            },
            {
              "code": "71545009",
              "display": "Humidifier"
            },
            {
              "code": "71601002",
              "display": "Proctosigmoidoscope"
            },
            {
              "code": "71667001",
              "display": "Bone wax"
            },
            {
              "code": "71948003",
              "display": "Autoclave"
            },
            {
              "code": "72070000",
              "display": "Ring"
            },
            {
              "code": "72188006",
              "display": "Tissue expander"
            },
            {
              "code": "72302000",
              "display": "Lead cable"
            },
            {
              "code": "72506001",
              "display": "Implantable defibrillator"
            },
            {
              "code": "72742007",
              "display": "Aspirator collection bottle"
            },
            {
              "code": "73027007",
              "display": "Infant incubator"
            },
            {
              "code": "73534004",
              "display": "Artificial skin"
            },
            {
              "code": "73562006",
              "display": "Transilluminator"
            },
            {
              "code": "73571002",
              "display": "Intravenous analgesia unit"
            },
            {
              "code": "73618007",
              "display": "Power saw"
            },
            {
              "code": "73878004",
              "display": "Hand saw"
            },
            {
              "code": "73985004",
              "display": "Face protection in construction industry"
            },
            {
              "code": "74094004",
              "display": "Belt"
            },
            {
              "code": "74108008",
              "display": "Recorder"
            },
            {
              "code": "74300007",
              "display": "Sanitary pad"
            },
            {
              "code": "74444006",
              "display": "AL - Artificial limb"
            },
            {
              "code": "74566002",
              "display": "Crutch"
            },
            {
              "code": "74884005",
              "display": "Boatswain's chair"
            },
            {
              "code": "75075000",
              "display": "Shoring and bracing (masonry and woodwork)"
            },
            {
              "code": "75187009",
              "display": "Local anesthesia kit"
            },
            {
              "code": "75192006",
              "display": "Arterial cannula"
            },
            {
              "code": "75751006",
              "display": "Manual respirator"
            },
            {
              "code": "75780002",
              "display": "Artificial kidney"
            },
            {
              "code": "75963008",
              "display": "Skateboard"
            },
            {
              "code": "76091005",
              "display": "Stainless steel wire suture"
            },
            {
              "code": "76123001",
              "display": "Glass tube"
            },
            {
              "code": "76428000",
              "display": "Elbow joint prosthesis"
            },
            {
              "code": "76433001",
              "display": "Apron"
            },
            {
              "code": "76664007",
              "display": "Artificial pancreas"
            },
            {
              "code": "76705002",
              "display": "Applicator stick"
            },
            {
              "code": "76825006",
              "display": "Abrasive wheel machinery"
            },
            {
              "code": "76937009",
              "display": "Guillotine"
            },
            {
              "code": "77444004",
              "display": "Pins"
            },
            {
              "code": "77541009",
              "display": "Band"
            },
            {
              "code": "77720000",
              "display": "Clips"
            },
            {
              "code": "77755003",
              "display": "Chemical fiber cloth"
            },
            {
              "code": "77777004",
              "display": "Bone staple"
            },
            {
              "code": "78279003",
              "display": "Nail clipper"
            },
            {
              "code": "78498003",
              "display": "Testicular prosthesis"
            },
            {
              "code": "78641001",
              "display": "Nylon suture"
            },
            {
              "code": "78886001",
              "display": "Electronic monitor"
            },
            {
              "code": "79051006",
              "display": "Greenfield filter"
            },
            {
              "code": "79068005",
              "display": "Needle"
            },
            {
              "code": "79218005",
              "display": "Vehicle-mounted work platform"
            },
            {
              "code": "79287008",
              "display": "Tampon"
            },
            {
              "code": "79401009",
              "display": "Chute"
            },
            {
              "code": "79438009",
              "display": "Foot protection"
            },
            {
              "code": "79481007",
              "display": "Swing or sliding cut-off saw"
            },
            {
              "code": "79593001",
              "display": "Transvenous electrode"
            },
            {
              "code": "79618001",
              "display": "Storage tank"
            },
            {
              "code": "79811009",
              "display": "Electric blanket"
            },
            {
              "code": "79834000",
              "display": "Hickman line"
            },
            {
              "code": "79952001",
              "display": "Swan-Ganz catheter, device"
            },
            {
              "code": "80278003",
              "display": "Pediatric bed"
            },
            {
              "code": "80404000",
              "display": "Chain fall"
            },
            {
              "code": "80617005",
              "display": "Analysers"
            },
            {
              "code": "80664005",
              "display": "Motor home"
            },
            {
              "code": "80853009",
              "display": "Tendon hammer"
            },
            {
              "code": "80950008",
              "display": "Oven"
            },
            {
              "code": "81293006",
              "display": "Textile material"
            },
            {
              "code": "81317009",
              "display": "Socket wrench"
            },
            {
              "code": "81320001",
              "display": "Enzyme immunoassay analyzer"
            },
            {
              "code": "81826000",
              "display": "All-terrain vehicle"
            },
            {
              "code": "81892008",
              "display": "Radial saw"
            },
            {
              "code": "82379000",
              "display": "Hemostat"
            },
            {
              "code": "82449006",
              "display": "Peripheral intravenous catheter"
            },
            {
              "code": "82657000",
              "display": "Bony tissue forceps"
            },
            {
              "code": "82830000",
              "display": "Robotic arm"
            },
            {
              "code": "82879008",
              "display": "Safety belt"
            },
            {
              "code": "83059008",
              "display": "Tube"
            },
            {
              "code": "83315005",
              "display": "Audio analgesia unit"
            },
            {
              "code": "83320005",
              "display": "Dip tank"
            },
            {
              "code": "83369007",
              "display": "Plastic shoes"
            },
            {
              "code": "83517001",
              "display": "Robot"
            },
            {
              "code": "83903000",
              "display": "Man lift"
            },
            {
              "code": "84023008",
              "display": "Ski tow"
            },
            {
              "code": "84330009",
              "display": "Pliers"
            },
            {
              "code": "84444002",
              "display": "Chain saw"
            },
            {
              "code": "84546002",
              "display": "Barricade"
            },
            {
              "code": "84599008",
              "display": "Detonating cord"
            },
            {
              "code": "84610002",
              "display": "Implantable dental prosthesis"
            },
            {
              "code": "84683006",
              "display": "Aortic valve prosthesis"
            },
            {
              "code": "84756000",
              "display": "Adhesive tape"
            },
            {
              "code": "85106006",
              "display": "Boring machine"
            },
            {
              "code": "85329008",
              "display": "Abortion pump"
            },
            {
              "code": "85455005",
              "display": "Cart"
            },
            {
              "code": "85684007",
              "display": "Engraving press"
            },
            {
              "code": "86056006",
              "display": "Golf club"
            },
            {
              "code": "86174004",
              "display": "Laparoscope"
            },
            {
              "code": "86184003",
              "display": "Electrocardiographic monitor and recorder"
            },
            {
              "code": "86407004",
              "display": "Table"
            },
            {
              "code": "86453006",
              "display": "Defibrillator paddle"
            },
            {
              "code": "86572008",
              "display": "Arteriovenous shunt catheter"
            },
            {
              "code": "86768006",
              "display": "Balloon pump"
            },
            {
              "code": "86816008",
              "display": "Diving ladder"
            },
            {
              "code": "86967005",
              "display": "Tool"
            },
            {
              "code": "87088005",
              "display": "Soldering iron"
            },
            {
              "code": "87140005",
              "display": "Clothing material"
            },
            {
              "code": "87405001",
              "display": "Cane"
            },
            {
              "code": "87710003",
              "display": "Physical restraint structure"
            },
            {
              "code": "87717000",
              "display": "Tester"
            },
            {
              "code": "87851008",
              "display": "Blood cell counter and analyzer"
            },
            {
              "code": "88063004",
              "display": "Footwear"
            },
            {
              "code": "88168006",
              "display": "Maximum security cell"
            },
            {
              "code": "88208003",
              "display": "Intravenous anesthesia administration set"
            },
            {
              "code": "88765001",
              "display": "Artificial tissue"
            },
            {
              "code": "88959008",
              "display": "Hypodermic needle"
            },
            {
              "code": "89149003",
              "display": "Stretcher"
            },
            {
              "code": "89236003",
              "display": "Leather shoes"
            },
            {
              "code": "89509004",
              "display": "Blood culture analyzer"
            },
            {
              "code": "90003000",
              "display": "Magnetic resonance imaging unit"
            },
            {
              "code": "90035000",
              "display": "Alcohol sponge"
            },
            {
              "code": "90082007",
              "display": "Cast cutter"
            },
            {
              "code": "90134004",
              "display": "Metal periosteal implant"
            },
            {
              "code": "90412006",
              "display": "Colonoscope"
            },
            {
              "code": "90504001",
              "display": "Auricular prosthesis"
            },
            {
              "code": "90913005",
              "display": "Rubber shoes"
            },
            {
              "code": "90948003",
              "display": "Abrasive blast by cleaning nozzles"
            },
            {
              "code": "91294003",
              "display": "Thomas collar"
            },
            {
              "code": "91318002",
              "display": "Hyperbaric chamber"
            },
            {
              "code": "91535004",
              "display": "Basin"
            },
            {
              "code": "91537007",
              "display": "Hospital bed"
            },
            {
              "code": "102303004",
              "display": "Vascular prosthesis"
            },
            {
              "code": "102304005",
              "display": "Measuring ruler"
            },
            {
              "code": "102305006",
              "display": "Intramedullary reamer"
            },
            {
              "code": "102306007",
              "display": "Reamer"
            },
            {
              "code": "102307003",
              "display": "Surgical knife"
            },
            {
              "code": "102308008",
              "display": "Scalpel"
            },
            {
              "code": "102309000",
              "display": "Surgical saw"
            },
            {
              "code": "102310005",
              "display": "Gigli's wire saw"
            },
            {
              "code": "102311009",
              "display": "Starck dilator"
            },
            {
              "code": "102312002",
              "display": "Atherectomy device"
            },
            {
              "code": "102313007",
              "display": "Rotational atherectomy device"
            },
            {
              "code": "102314001",
              "display": "Embolization coil"
            },
            {
              "code": "102315000",
              "display": "Embolization ball"
            },
            {
              "code": "102316004",
              "display": "Embolization particulate"
            },
            {
              "code": "102317008",
              "display": "Guiding catheter"
            },
            {
              "code": "102318003",
              "display": "Implantable venous catheter"
            },
            {
              "code": "102319006",
              "display": "Percutaneous transluminal angioplasty balloon"
            },
            {
              "code": "102320000",
              "display": "Detachable balloon"
            },
            {
              "code": "102321001",
              "display": "Operating microscope"
            },
            {
              "code": "102322008",
              "display": "External prosthesis for sonographic procedure"
            },
            {
              "code": "102323003",
              "display": "Water bag prosthesis for imaging procedure"
            },
            {
              "code": "102324009",
              "display": "Saline bag prosthesis for imaging procedure"
            },
            {
              "code": "102325005",
              "display": "Gel prosthesis for imaging procedure"
            },
            {
              "code": "102326006",
              "display": "Dagger"
            },
            {
              "code": "102327002",
              "display": "Dirk"
            },
            {
              "code": "102328007",
              "display": "Sword"
            },
            {
              "code": "102384007",
              "display": "Motor vehicle airbag"
            },
            {
              "code": "102385008",
              "display": "Front airbag"
            },
            {
              "code": "102386009",
              "display": "Front driver airbag"
            },
            {
              "code": "102387000",
              "display": "Front passenger airbag"
            },
            {
              "code": "102388005",
              "display": "Side airbag"
            },
            {
              "code": "102402008",
              "display": "Snowboard"
            },
            {
              "code": "102403003",
              "display": "Water ski"
            },
            {
              "code": "105784003",
              "display": "Life support equipment"
            },
            {
              "code": "105785002",
              "display": "Adhesive, bandage AND/OR suture"
            },
            {
              "code": "105787005",
              "display": "Belt AND/OR binder"
            },
            {
              "code": "105788000",
              "display": "Probe, sound, bougie AND/OR airway"
            },
            {
              "code": "105789008",
              "display": "Cannula, tube AND/OR catheter"
            },
            {
              "code": "105790004",
              "display": "Bag, balloon AND/OR bottle"
            },
            {
              "code": "105791000",
              "display": "Pump, injector AND/OR aspirator"
            },
            {
              "code": "105792007",
              "display": "Analgesia AND/OR anesthesia unit"
            },
            {
              "code": "105793002",
              "display": "Monitor, alarm AND/OR stimulator"
            },
            {
              "code": "105794008",
              "display": "Scope AND/OR camera"
            },
            {
              "code": "105809003",
              "display": "Physical restraint equipment AND/OR structure"
            },
            {
              "code": "108874005",
              "display": "Silicone plug"
            },
            {
              "code": "109184000",
              "display": "Pregnancy testing kit"
            },
            {
              "code": "109226007",
              "display": "Dental pin"
            },
            {
              "code": "109227003",
              "display": "Hand joint prosthesis"
            },
            {
              "code": "109228008",
              "display": "Knee joint prosthesis"
            },
            {
              "code": "111041008",
              "display": "Artificial nails"
            },
            {
              "code": "111042001",
              "display": "Artificial organ"
            },
            {
              "code": "111043006",
              "display": "Medical tuning fork"
            },
            {
              "code": "111044000",
              "display": "Bone tap"
            },
            {
              "code": "111045004",
              "display": "Exerciser"
            },
            {
              "code": "111047007",
              "display": "Urethral bougie"
            },
            {
              "code": "111048002",
              "display": "Rhinoscope"
            },
            {
              "code": "111052002",
              "display": "Protective breast plate"
            },
            {
              "code": "111060001",
              "display": "Industrial sewing machine"
            },
            {
              "code": "111062009",
              "display": "Food waste disposal equipment"
            },
            {
              "code": "115961006",
              "display": "Soft Cast"
            },
            {
              "code": "115962004",
              "display": "Fiberglass cast"
            },
            {
              "code": "116146000",
              "display": "Blood product unit"
            },
            {
              "code": "116204000",
              "display": "Catheter tip"
            },
            {
              "code": "116205004",
              "display": "Blood bag"
            },
            {
              "code": "116206003",
              "display": "Plasma bag"
            },
            {
              "code": "116250002",
              "display": "Filter"
            },
            {
              "code": "116251003",
              "display": "Wick"
            },
            {
              "code": "118294000",
              "display": "Solid-state laser"
            },
            {
              "code": "118295004",
              "display": "Gas laser"
            },
            {
              "code": "118296003",
              "display": "Chemical laser"
            },
            {
              "code": "118297007",
              "display": "Excimer laser"
            },
            {
              "code": "118298002",
              "display": "Dye laser"
            },
            {
              "code": "118299005",
              "display": "Diode laser"
            },
            {
              "code": "118301003",
              "display": "Nd:YVO>4< laser"
            },
            {
              "code": "118302005",
              "display": "Nd:YLF laser"
            },
            {
              "code": "118303000",
              "display": "Nd:Glass laser"
            },
            {
              "code": "118304006",
              "display": "Chromium sapphire laser device"
            },
            {
              "code": "118305007",
              "display": "Er:Glass laser"
            },
            {
              "code": "118306008",
              "display": "Erbium-YAG laser"
            },
            {
              "code": "118307004",
              "display": "Ho:YLF laser"
            },
            {
              "code": "118308009",
              "display": "Holmium-YAG laser"
            },
            {
              "code": "118309001",
              "display": "Ti:sapphire laser device"
            },
            {
              "code": "118310006",
              "display": "Alexandrite laser"
            },
            {
              "code": "118311005",
              "display": "Argon laser"
            },
            {
              "code": "118312003",
              "display": "CO2 laser"
            },
            {
              "code": "118313008",
              "display": "He laser"
            },
            {
              "code": "118314002",
              "display": "Helium cadmium laser"
            },
            {
              "code": "118315001",
              "display": "HeNe laser"
            },
            {
              "code": "118316000",
              "display": "Krypton laser"
            },
            {
              "code": "118317009",
              "display": "Neon gas laser"
            },
            {
              "code": "118318004",
              "display": "Nitrogen gas laser"
            },
            {
              "code": "118319007",
              "display": "Xenon gas laser"
            },
            {
              "code": "118320001",
              "display": "Copper vapor laser"
            },
            {
              "code": "118321002",
              "display": "Gold vapor laser"
            },
            {
              "code": "118322009",
              "display": "DF laser"
            },
            {
              "code": "118323004",
              "display": "DF-CO>2< laser device"
            },
            {
              "code": "118324005",
              "display": "HF laser"
            },
            {
              "code": "118325006",
              "display": "ArF laser"
            },
            {
              "code": "118326007",
              "display": "KrF laser"
            },
            {
              "code": "118327003",
              "display": "KrCl laser"
            },
            {
              "code": "118328008",
              "display": "XeCl laser"
            },
            {
              "code": "118329000",
              "display": "XeFl laser"
            },
            {
              "code": "118330005",
              "display": "Free electron laser"
            },
            {
              "code": "118331009",
              "display": "Tunable dye laser"
            },
            {
              "code": "118332002",
              "display": "Tunable dye argon laser"
            },
            {
              "code": "118333007",
              "display": "Gallium arsenide laser"
            },
            {
              "code": "118334001",
              "display": "Gallium aluminum arsenide laser"
            },
            {
              "code": "118335000",
              "display": "Lead-salt laser"
            },
            {
              "code": "118336004",
              "display": "Rhodamine 6G dye laser"
            },
            {
              "code": "118337008",
              "display": "Coumarin C30 dye laser"
            },
            {
              "code": "118338003",
              "display": "Coumarin 102 dye laser"
            },
            {
              "code": "118342000",
              "display": "Diode pumped laser"
            },
            {
              "code": "118343005",
              "display": "Flashlamp pumped laser device"
            },
            {
              "code": "118346002",
              "display": "Pulsed dye laser"
            },
            {
              "code": "118347006",
              "display": "QS laser"
            },
            {
              "code": "118348001",
              "display": "Flashlamp pulsed dye laser"
            },
            {
              "code": "118349009",
              "display": "CW CO>2< laser"
            },
            {
              "code": "118350009",
              "display": "High energy pulsed CO>2< laser"
            },
            {
              "code": "118351008",
              "display": "Frequency doubled Nd:YAG laser"
            },
            {
              "code": "118354000",
              "display": "Continuous wave laser"
            },
            {
              "code": "118355004",
              "display": "Pulsed laser"
            },
            {
              "code": "118356003",
              "display": "Metal vapor laser"
            },
            {
              "code": "118357007",
              "display": "KTP laser"
            },
            {
              "code": "118371004",
              "display": "Ion laser"
            },
            {
              "code": "118372006",
              "display": "Plastic implant"
            },
            {
              "code": "118373001",
              "display": "Silastic implant"
            },
            {
              "code": "118374007",
              "display": "Silicone implant"
            },
            {
              "code": "118375008",
              "display": "Cardiac septum prosthesis"
            },
            {
              "code": "118376009",
              "display": "Thermocouple"
            },
            {
              "code": "118377000",
              "display": "Biopsy needle"
            },
            {
              "code": "118378005",
              "display": "Pacemaker pulse generator"
            },
            {
              "code": "118379002",
              "display": "Automatic implantable cardioverter sensing electrodes"
            },
            {
              "code": "118380004",
              "display": "Implantable defibrillator leads"
            },
            {
              "code": "118381000",
              "display": "Implantable cardioverter leads"
            },
            {
              "code": "118382007",
              "display": "Neuropacemaker device"
            },
            {
              "code": "118383002",
              "display": "External fixation device"
            },
            {
              "code": "118384008",
              "display": "Long arm splint"
            },
            {
              "code": "118385009",
              "display": "Short arm splint"
            },
            {
              "code": "118386005",
              "display": "Figure of eight plaster cast"
            },
            {
              "code": "118387001",
              "display": "Halo jacket"
            },
            {
              "code": "118388006",
              "display": "Body cast, shoulder to hips"
            },
            {
              "code": "118389003",
              "display": "Body cast, shoulder to hips including head, Minerva type"
            },
            {
              "code": "118390007",
              "display": "Body cast, shoulder to hips including one thigh"
            },
            {
              "code": "118391006",
              "display": "Body cast, shoulder to hips including both thighs"
            },
            {
              "code": "118392004",
              "display": "Shoulder cast"
            },
            {
              "code": "118393009",
              "display": "Long arm cylinder"
            },
            {
              "code": "118394003",
              "display": "Forearm cylinder"
            },
            {
              "code": "118396001",
              "display": "Cylinder cast, thigh to ankle"
            },
            {
              "code": "118397005",
              "display": "Long leg cast"
            },
            {
              "code": "118398000",
              "display": "Long leg cast, walker or ambulatory type"
            },
            {
              "code": "118399008",
              "display": "Long leg cast, brace type"
            },
            {
              "code": "118400001",
              "display": "Short leg cast below knee to toes"
            },
            {
              "code": "118401002",
              "display": "Short leg cast below knee to toes, walking or ambulatory type"
            },
            {
              "code": "118402009",
              "display": "Clubfoot cast"
            },
            {
              "code": "118403004",
              "display": "Clubfoot cast, short leg"
            },
            {
              "code": "118404005",
              "display": "Clubfoot cast, long leg"
            },
            {
              "code": "118405006",
              "display": "Spica cast"
            },
            {
              "code": "118406007",
              "display": "Hip spica cast, both legs"
            },
            {
              "code": "118407003",
              "display": "Hip spica cast, one leg"
            },
            {
              "code": "118408008",
              "display": "Hip spica cast, one and one-half spica"
            },
            {
              "code": "118409000",
              "display": "Patellar tendon bearing cast"
            },
            {
              "code": "118410005",
              "display": "Boot cast"
            },
            {
              "code": "118411009",
              "display": "Sugar tong cast"
            },
            {
              "code": "118412002",
              "display": "Gauntlet cast"
            },
            {
              "code": "118413007",
              "display": "Complete cast"
            },
            {
              "code": "118414001",
              "display": "Pressure dressing"
            },
            {
              "code": "118415000",
              "display": "Packing material"
            },
            {
              "code": "118416004",
              "display": "Wound packing material"
            },
            {
              "code": "118418003",
              "display": "Trocar"
            },
            {
              "code": "118419006",
              "display": "Umbrella device"
            },
            {
              "code": "118420000",
              "display": "Atrial septal umbrella"
            },
            {
              "code": "118421001",
              "display": "King-Mills umbrella device"
            },
            {
              "code": "118422008",
              "display": "Mobitz-Uddin umbrella device"
            },
            {
              "code": "118423003",
              "display": "Rashkind umbrella device"
            },
            {
              "code": "118424009",
              "display": "Reservoir device"
            },
            {
              "code": "118425005",
              "display": "Ventricular reservoir"
            },
            {
              "code": "118426006",
              "display": "Ommaya reservoir"
            },
            {
              "code": "118427002",
              "display": "Rickham reservoir"
            },
            {
              "code": "118428007",
              "display": "Flexible fiberoptic endoscope"
            },
            {
              "code": "118429004",
              "display": "Flexible fiberoptic laryngoscope with strobe"
            },
            {
              "code": "118643004",
              "display": "Cast"
            },
            {
              "code": "122456005",
              "display": "Laser"
            },
            {
              "code": "123636009",
              "display": "SS - Silk suture"
            },
            {
              "code": "126064005",
              "display": "Gastrostomy tube, device"
            },
            {
              "code": "126065006",
              "display": "Jejunostomy tube, device"
            },
            {
              "code": "128981007",
              "display": "Baffle"
            },
            {
              "code": "129113006",
              "display": "Intra-aortic balloon pump"
            },
            {
              "code": "129121000",
              "display": "Tracheostomy tube"
            },
            {
              "code": "129247000",
              "display": "Fine biopsy needle"
            },
            {
              "code": "129248005",
              "display": "Core biopsy needle"
            },
            {
              "code": "129460009",
              "display": "Compression paddle"
            },
            {
              "code": "129462001",
              "display": "Catheter guide wire"
            },
            {
              "code": "129463006",
              "display": "J wire"
            },
            {
              "code": "129464000",
              "display": "Medical administrative equipment"
            },
            {
              "code": "129465004",
              "display": "Medical record"
            },
            {
              "code": "129466003",
              "display": "Patient chart"
            },
            {
              "code": "129467007",
              "display": "Identification plate"
            },
            {
              "code": "134823007",
              "display": "Sterile absorbent dressing pad"
            },
            {
              "code": "134963007",
              "display": "Wound drainage pouch dressing"
            },
            {
              "code": "170615005",
              "display": "Home nebulizer"
            },
            {
              "code": "182562006",
              "display": "Plaster jacket"
            },
            {
              "code": "182563001",
              "display": "Shoulder spica"
            },
            {
              "code": "182564007",
              "display": "Humeral U-slab"
            },
            {
              "code": "182565008",
              "display": "Long arm slab"
            },
            {
              "code": "182566009",
              "display": "Humeral hanging slab"
            },
            {
              "code": "182567000",
              "display": "Forearm slab"
            },
            {
              "code": "182568005",
              "display": "Scaphoid cast"
            },
            {
              "code": "182569002",
              "display": "Bennett cast"
            },
            {
              "code": "182570001",
              "display": "Hip spica"
            },
            {
              "code": "182571002",
              "display": "Long leg spica"
            },
            {
              "code": "182572009",
              "display": "Below knee non-weight-bearing cast"
            },
            {
              "code": "182573004",
              "display": "Below knee weight-bearing cast"
            },
            {
              "code": "182574005",
              "display": "Plaster stripper"
            },
            {
              "code": "182576007",
              "display": "Humeral brace"
            },
            {
              "code": "182577003",
              "display": "Functional elbow brace"
            },
            {
              "code": "182578008",
              "display": "Forearm brace"
            },
            {
              "code": "182579000",
              "display": "Hip brace"
            },
            {
              "code": "182580002",
              "display": "Femoral brace"
            },
            {
              "code": "182581003",
              "display": "Tibial brace"
            },
            {
              "code": "182587004",
              "display": "Body support"
            },
            {
              "code": "182588009",
              "display": "Spinal frame"
            },
            {
              "code": "182589001",
              "display": "Corset support"
            },
            {
              "code": "182590005",
              "display": "Cardiac bed"
            },
            {
              "code": "182591009",
              "display": "Water bed"
            },
            {
              "code": "182592002",
              "display": "High air loss bed"
            },
            {
              "code": "182839003",
              "display": "Automated drug microinjector"
            },
            {
              "code": "183116000",
              "display": "Dental aid"
            },
            {
              "code": "183125006",
              "display": "Ear fitting hearing aid"
            },
            {
              "code": "183135000",
              "display": "Mobility aid"
            },
            {
              "code": "183141007",
              "display": "Inshoe orthosis"
            },
            {
              "code": "183143005",
              "display": "Surgical stockings"
            },
            {
              "code": "183144004",
              "display": "Antiembolic stockings"
            },
            {
              "code": "183146002",
              "display": "ZF - Zimmer frame"
            },
            {
              "code": "183147006",
              "display": "Tripod"
            },
            {
              "code": "183148001",
              "display": "RGO - Reciprocating gait orthosis"
            },
            {
              "code": "183149009",
              "display": "Hip guidance orthosis"
            },
            {
              "code": "183150009",
              "display": "Standing frame"
            },
            {
              "code": "183152001",
              "display": "Hip abduction orthosis"
            },
            {
              "code": "183153006",
              "display": "Hip-knee-ankle-foot orthosis"
            },
            {
              "code": "183154000",
              "display": "Knee-ankle-foot orthosis"
            },
            {
              "code": "183155004",
              "display": "Flexible knee support"
            },
            {
              "code": "183156003",
              "display": "Collateral ligament brace"
            },
            {
              "code": "183157007",
              "display": "Anterior cruciate ligament brace"
            },
            {
              "code": "183158002",
              "display": "Posterior cruciate ligament brace"
            },
            {
              "code": "183159005",
              "display": "Ground reaction orthosis"
            },
            {
              "code": "183160000",
              "display": "Rigid ankle-foot orthosis"
            },
            {
              "code": "183161001",
              "display": "Flexible ankle-foot orthosis"
            },
            {
              "code": "183162008",
              "display": "Double below-knee iron"
            },
            {
              "code": "183164009",
              "display": "Inside iron"
            },
            {
              "code": "183165005",
              "display": "Outside iron"
            },
            {
              "code": "183166006",
              "display": "Inside T-strap"
            },
            {
              "code": "183170003",
              "display": "Hindquarter prosthesis"
            },
            {
              "code": "183171004",
              "display": "Hip disarticulation prosthesis"
            },
            {
              "code": "183172006",
              "display": "Above knee prosthesis"
            },
            {
              "code": "183173001",
              "display": "Through knee prosthesis"
            },
            {
              "code": "183174007",
              "display": "Below knee prosthesis"
            },
            {
              "code": "183175008",
              "display": "Syme's prosthesis"
            },
            {
              "code": "183176009",
              "display": "Midfoot amputation prosthesis"
            },
            {
              "code": "183177000",
              "display": "Shoe filler"
            },
            {
              "code": "183183002",
              "display": "Milwaukee brace"
            },
            {
              "code": "183184008",
              "display": "Boston brace"
            },
            {
              "code": "183185009",
              "display": "Jewett brace"
            },
            {
              "code": "183187001",
              "display": "Halo device"
            },
            {
              "code": "183188006",
              "display": "Four poster brace"
            },
            {
              "code": "183189003",
              "display": "Rigid collar"
            },
            {
              "code": "183190007",
              "display": "Flexible collar"
            },
            {
              "code": "183192004",
              "display": "Shoulder abduction brace"
            },
            {
              "code": "183193009",
              "display": "Elbow brace"
            },
            {
              "code": "183194003",
              "display": "Passive wrist extension splint"
            },
            {
              "code": "183195002",
              "display": "Active wrist extension splint"
            },
            {
              "code": "183196001",
              "display": "Passive finger extension splint"
            },
            {
              "code": "183197005",
              "display": "Active finger extension splint"
            },
            {
              "code": "183198000",
              "display": "Kleinert traction"
            },
            {
              "code": "183199008",
              "display": "Passive thumb splint"
            },
            {
              "code": "183200006",
              "display": "Active thumb splint"
            },
            {
              "code": "183202003",
              "display": "Shin splint"
            },
            {
              "code": "183204002",
              "display": "Excretory control aid"
            },
            {
              "code": "183235008",
              "display": "Facial non-surgical prosthesis"
            },
            {
              "code": "183236009",
              "display": "Breast non-surgical prosthesis"
            },
            {
              "code": "183240000",
              "display": "Patient-propelled wheelchair"
            },
            {
              "code": "183241001",
              "display": "Pedal powered wheelchair"
            },
            {
              "code": "183248007",
              "display": "Attendant powered wheelchair"
            },
            {
              "code": "183249004",
              "display": "Wheelchair seating"
            },
            {
              "code": "183250004",
              "display": "Molded wheelchair seat"
            },
            {
              "code": "183251000",
              "display": "Matrix seat"
            },
            {
              "code": "201706006",
              "display": "Intracranial pressure transducer"
            },
            {
              "code": "223394001",
              "display": "Equipment for positioning"
            },
            {
              "code": "224684009",
              "display": "Top security prison"
            },
            {
              "code": "224685005",
              "display": "Category B prison"
            },
            {
              "code": "224686006",
              "display": "Low security prison"
            },
            {
              "code": "224823002",
              "display": "Street lighting"
            },
            {
              "code": "224824008",
              "display": "Sign posting"
            },
            {
              "code": "224825009",
              "display": "Street name sign"
            },
            {
              "code": "224826005",
              "display": "Building name sign"
            },
            {
              "code": "224827001",
              "display": "Pedestrian direction sign"
            },
            {
              "code": "224828006",
              "display": "Traffic sign"
            },
            {
              "code": "224898003",
              "display": "Orthotic device"
            },
            {
              "code": "224899006",
              "display": "Walking aid"
            },
            {
              "code": "224900001",
              "display": "Communication aid"
            },
            {
              "code": "228167008",
              "display": "Corset"
            },
            {
              "code": "228235002",
              "display": "Slippers"
            },
            {
              "code": "228236001",
              "display": "Mules"
            },
            {
              "code": "228237005",
              "display": "Slippersox"
            },
            {
              "code": "228239008",
              "display": "Trainers"
            },
            {
              "code": "228240005",
              "display": "Plimsolls"
            },
            {
              "code": "228241009",
              "display": "Sandals"
            },
            {
              "code": "228242002",
              "display": "Gum boots"
            },
            {
              "code": "228243007",
              "display": "Chappel"
            },
            {
              "code": "228259007",
              "display": "Fastening"
            },
            {
              "code": "228260002",
              "display": "Velcro"
            },
            {
              "code": "228261003",
              "display": "Buckle"
            },
            {
              "code": "228262005",
              "display": "Zipper"
            },
            {
              "code": "228264006",
              "display": "Small button"
            },
            {
              "code": "228265007",
              "display": "Medium button"
            },
            {
              "code": "228266008",
              "display": "Large button"
            },
            {
              "code": "228267004",
              "display": "Press stud"
            },
            {
              "code": "228268009",
              "display": "Hook and eye"
            },
            {
              "code": "228270000",
              "display": "Laces"
            },
            {
              "code": "228271001",
              "display": "Shoe laces"
            },
            {
              "code": "228731007",
              "display": "Radiotherapy equipment and appliances"
            },
            {
              "code": "228732000",
              "display": "Beam direction shell"
            },
            {
              "code": "228733005",
              "display": "Head and neck beam direction shell"
            },
            {
              "code": "228734004",
              "display": "Body beam direction shell"
            },
            {
              "code": "228735003",
              "display": "Beam modifier"
            },
            {
              "code": "228736002",
              "display": "Surface bolus"
            },
            {
              "code": "228737006",
              "display": "Surface compensator"
            },
            {
              "code": "228738001",
              "display": "Cutout"
            },
            {
              "code": "228739009",
              "display": "Shielding block"
            },
            {
              "code": "228740006",
              "display": "Lung block"
            },
            {
              "code": "228741005",
              "display": "Humerus block"
            },
            {
              "code": "228742003",
              "display": "Scrotal block"
            },
            {
              "code": "228743008",
              "display": "Kidney block"
            },
            {
              "code": "228744002",
              "display": "Eye block"
            },
            {
              "code": "228745001",
              "display": "Bite block"
            },
            {
              "code": "228746000",
              "display": "Wedge filter"
            },
            {
              "code": "228747009",
              "display": "Kilovoltage grid"
            },
            {
              "code": "228748004",
              "display": "Brachytherapy implant"
            },
            {
              "code": "228749007",
              "display": "Single plane implant"
            },
            {
              "code": "228750007",
              "display": "Two plane implant"
            },
            {
              "code": "228751006",
              "display": "Semicircular implant"
            },
            {
              "code": "228752004",
              "display": "Regular volume implant"
            },
            {
              "code": "228753009",
              "display": "Irregular volume implant"
            },
            {
              "code": "228754003",
              "display": "Brachytherapy surface mold"
            },
            {
              "code": "228755002",
              "display": "Two plane mold"
            },
            {
              "code": "228756001",
              "display": "Single plane mold"
            },
            {
              "code": "228757005",
              "display": "Cylinder mold"
            },
            {
              "code": "228759008",
              "display": "Adhesive felt mold"
            },
            {
              "code": "228760003",
              "display": "Elastoplast mold"
            },
            {
              "code": "228761004",
              "display": "Collimator"
            },
            {
              "code": "228762006",
              "display": "Multileaf collimator"
            },
            {
              "code": "228763001",
              "display": "Asymmetric jaws collimator"
            },
            {
              "code": "228765008",
              "display": "Standard collimator"
            },
            {
              "code": "228766009",
              "display": "Form of brachytherapy source"
            },
            {
              "code": "228767000",
              "display": "Wire source"
            },
            {
              "code": "228768005",
              "display": "Seeds source"
            },
            {
              "code": "228770001",
              "display": "Hairpins source"
            },
            {
              "code": "228771002",
              "display": "Needles source"
            },
            {
              "code": "228772009",
              "display": "Pellets source"
            },
            {
              "code": "228773004",
              "display": "Capsules source"
            },
            {
              "code": "228774005",
              "display": "Chains source"
            },
            {
              "code": "228775006",
              "display": "Tubes source"
            },
            {
              "code": "228776007",
              "display": "Rods source"
            },
            {
              "code": "228777003",
              "display": "Grains source"
            },
            {
              "code": "228778008",
              "display": "Plaque source"
            },
            {
              "code": "228869008",
              "display": "Manual wheelchair"
            },
            {
              "code": "229772003",
              "display": "Bed"
            },
            {
              "code": "229839006",
              "display": "Functional foot orthosis"
            },
            {
              "code": "229840008",
              "display": "Non-functional foot orthosis"
            },
            {
              "code": "229841007",
              "display": "Detachable pad for the foot"
            },
            {
              "code": "229842000",
              "display": "Detachable toe prop"
            },
            {
              "code": "229843005",
              "display": "Detachable horseshoe pad"
            },
            {
              "code": "243135003",
              "display": "Spacer"
            },
            {
              "code": "243719003",
              "display": "Near low vision aid - integral eyeglass magnifier"
            },
            {
              "code": "243720009",
              "display": "Near low vision aid - clip-on eyeglass magnifier"
            },
            {
              "code": "243722001",
              "display": "Near low vision aid - integral eyeglass telescope"
            },
            {
              "code": "243723006",
              "display": "Near low vision aid - clip-on eyeglass telescope"
            },
            {
              "code": "255296002",
              "display": "Wedge"
            },
            {
              "code": "255712000",
              "display": "Television"
            },
            {
              "code": "255716002",
              "display": "Latex rubber gloves"
            },
            {
              "code": "256245006",
              "display": "Textiles"
            },
            {
              "code": "256246007",
              "display": "Cotton - textile"
            },
            {
              "code": "256247003",
              "display": "Flax"
            },
            {
              "code": "256562002",
              "display": "Cotton wool"
            },
            {
              "code": "256563007",
              "display": "Cotton wool roll"
            },
            {
              "code": "256564001",
              "display": "Cotton wool pledget"
            },
            {
              "code": "256589007",
              "display": "Dental rubber dam"
            },
            {
              "code": "256590003",
              "display": "Endodontic sponge"
            },
            {
              "code": "256593001",
              "display": "Orthodontic elastic"
            },
            {
              "code": "256641009",
              "display": "Ribbon gauze"
            },
            {
              "code": "256642002",
              "display": "Wet ribbon gauze"
            },
            {
              "code": "256643007",
              "display": "Dry ribbon gauze"
            },
            {
              "code": "257192006",
              "display": "Aid to vision"
            },
            {
              "code": "257193001",
              "display": "Telescopic eyeglasses"
            },
            {
              "code": "257194007",
              "display": "Video"
            },
            {
              "code": "257211007",
              "display": "Cylinder cutter"
            },
            {
              "code": "257212000",
              "display": "Rotary cutter"
            },
            {
              "code": "257213005",
              "display": "Rotary cutter with steel blades"
            },
            {
              "code": "257214004",
              "display": "Rotary cutter with plastic blades"
            },
            {
              "code": "257215003",
              "display": "Nail instrument"
            },
            {
              "code": "257216002",
              "display": "Flexible endoscope"
            },
            {
              "code": "257217006",
              "display": "Rigid endoscope"
            },
            {
              "code": "257218001",
              "display": "Flexible cystoscope"
            },
            {
              "code": "257219009",
              "display": "Rigid cystoscope"
            },
            {
              "code": "257220003",
              "display": "Hysteroscope"
            },
            {
              "code": "257221004",
              "display": "Flexible hysteroscope"
            },
            {
              "code": "257222006",
              "display": "Rigid hysteroscope"
            },
            {
              "code": "257223001",
              "display": "Contact hysteroscope"
            },
            {
              "code": "257224007",
              "display": "Panoramic hysteroscope"
            },
            {
              "code": "257225008",
              "display": "Flexible bronchoscope"
            },
            {
              "code": "257226009",
              "display": "Rigid bronchoscope"
            },
            {
              "code": "257227000",
              "display": "Standard laryngoscope"
            },
            {
              "code": "257228005",
              "display": "Fiberlight anesthetic laryngoscope"
            },
            {
              "code": "257229002",
              "display": "Pharyngeal mirror"
            },
            {
              "code": "257230007",
              "display": "Obstetric forceps"
            },
            {
              "code": "257231006",
              "display": "Barnes forceps"
            }
          ]
        }
      ]
    }
  }