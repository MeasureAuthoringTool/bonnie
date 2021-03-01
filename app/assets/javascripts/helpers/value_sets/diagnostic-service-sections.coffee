# Description https://www.hl7.org/fhir/valueset-diagnostic-service-sections.html
# This value set is used in the following places:
# This value set is used in the following places:
# Resource: DiagnosticReport.category
# Profile: LipidProfile: DiagnosticReport.category
# Profile: DiagnosticReport-Genetics: DiagnosticReport.category
# Profile: HLAResult: DiagnosticReport.category
@DiagnosticServiceSectionCodesValueSet = class DiagnosticServiceSectionCodesValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "diagnostic-service-sections",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>Diagnostic Service Section Codes</h2><div><p>This value set includes all the codes in HL7 V2 table 0074.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"v2/0074/index.html\"><code>http://terminology.hl7.org/CodeSystem/v2-0074</code></a></li></ul></div>"
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
    "url" : "http://hl7.org/fhir/ValueSet/diagnostic-service-sections",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.234"
    }],
    "version" : "4.0.1",
    "name" : "DiagnosticServiceSectionCodes",
    "title" : "Diagnostic Service Section Codes",
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
    "description" : "This value set includes all the codes in HL7 V2 table 0074.",
    "compose" : {
      "include" : [{
        "system" : "http://terminology.hl7.org/CodeSystem/v2-0074",
        "concept": [
          {
            "code": "AU",
            "display": "Audiology"
          },
          {
            "code": "BG",
            "display": "Blood Gases"
          },
          {
            "code": "BLB",
            "display": "Blood Bank"
          },
          {
            "code": "CG",
            "display": "Cytogenetics"
          },
          {
            "code": "CH",
            "display": "Chemistry"
          },
          {
            "code": "CP",
            "display": "Cytopathology"
          },
          {
            "code": "CT",
            "display": "CAT Scan"
          },
          {
            "code": "CTH",
            "display": "Cardiac Catheterization"
          },
          {
            "code": "CUS",
            "display": "Cardiac Ultrasound"
          },
          {
            "code": "EC",
            "display": "Electrocardiac (e.g., EKG,  EEC, Holter)"
          },
          {
            "code": "EN",
            "display": "Electroneuro (EEG, EMG,EP,PSG)"
          },
          {
            "code": "GE",
            "display": "Genetics"
          },
          {
            "code": "HM",
            "display": "Hematology"
          },
          {
            "code": "ICU",
            "display": "Bedside ICU Monitoring"
          },
          {
            "code": "IMM",
            "display": "Immunology"
          },
          {
            "code": "LAB",
            "display": "Laboratory"
          },
          {
            "code": "MB",
            "display": "Microbiology"
          },
          {
            "code": "MCB",
            "display": "Mycobacteriology"
          },
          {
            "code": "MYC",
            "display": "Mycology"
          },
          {
            "code": "NMR",
            "display": "Nuclear Magnetic Resonance"
          },
          {
            "code": "NMS",
            "display": "Nuclear Medicine Scan"
          },
          {
            "code": "NRS",
            "display": "Nursing Service Measures"
          },
          {
            "code": "OSL",
            "display": "Outside Lab"
          },
          {
            "code": "OT",
            "display": "Occupational Therapy"
          },
          {
            "code": "OTH",
            "display": "Other"
          },
          {
            "code": "OUS",
            "display": "OB Ultrasound"
          },
          {
            "code": "PF",
            "display": "Pulmonary Function"
          },
          {
            "code": "PHR",
            "display": "Pharmacy"
          },
          {
            "code": "PHY",
            "display": "Physician (Hx. Dx, admission note, etc.)"
          },
          {
            "code": "PT",
            "display": "Physical Therapy"
          },
          {
            "code": "RAD",
            "display": "Radiology"
          },
          {
            "code": "RC",
            "display": "Respiratory Care (therapy)"
          },
          {
            "code": "RT",
            "display": "Radiation Therapy"
          },
          {
            "code": "RUS",
            "display": "Radiology Ultrasound"
          },
          {
            "code": "RX",
            "display": "Radiograph"
          },
          {
            "code": "SP",
            "display": "Surgical Pathology"
          },
          {
            "code": "SR",
            "display": "Serology"
          },
          {
            "code": "TX",
            "display": "Toxicology"
          },
          {
            "code": "VR",
            "display": "Virology"
          },
          {
            "code": "VUS",
            "display": "Vascular Ultrasound"
          },
          {
            "code": "XRC",
            "display": "Cineradiograph"
          }
        ]
      }]
    }
  }