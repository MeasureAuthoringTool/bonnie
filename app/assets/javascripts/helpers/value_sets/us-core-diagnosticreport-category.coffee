# Description http://hl7.org/fhir/us/core/ValueSet/us-core-diagnosticreport-category
# The US Core Diagnostic Report Category Value Set is a 'starter set' of categories supported for fetching and Diagnostic Reports and notes.
# This value set is used in the following places:
# This value set is used in the following places:
# Resource: DiagnosticReport.category
# Profile: StructureDefinition-us-core-diagnosticreport-note: DiagnosticReport.category
@USCoreDiagnosticReportCategoryValueSet = class USCoreDiagnosticReportCategoryValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "id": "us-core-diagnosticreport-category",
    "text": {
      "status": "generated",
      "div": "<div xmlns=\"http://www.w3.org/1999/xhtml\"><ul><li>Include these codes as defined in <a href=\"http://loinc.org\"><code>http://loinc.org</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td></tr><tr><td><a href=\"http://details.loinc.org/LOINC/LP29684-5.html\">LP29684-5</a></td><td>Radiology</td><td/></tr><tr><td><a href=\"http://details.loinc.org/LOINC/LP29708-2.html\">LP29708-2</a></td><td>Cardiology</td><td/></tr><tr><td><a href=\"http://details.loinc.org/LOINC/LP7839-6.html\">LP7839-6</a></td><td>Pathology</td><td/></tr></table></li></ul></div>"
    },
    "url": "http://hl7.org/fhir/us/core/ValueSet/us-core-diagnosticreport-category",
    "version": "3.1.1",
    "name": "USCoreDiagnosticReportCategory",
    "title": "US Core DiagnosticReport Category",
    "status": "active",
    "date": "2019-05-21",
    "description": "The US Core Diagnostic Report Category Value Set is a 'starter set' of categories supported for fetching and Diagnostic Reports and notes.",
    "jurisdiction": [
      {
        "coding": [
          {
            "system": "urn:iso:std:iso:3166",
            "code": "US",
            "display": "United States of America"
          }
        ]
      }
    ],
    "copyright": "This material contains content from [LOINC](http://loinc.org). LOINC is copyright © 1995-2020, Regenstrief Institute, Inc. and the Logical Observation Identifiers Names and Codes (LOINC) Committee and is available at no cost under the license at http://loinc.org/license. LOINC® is a registered United States trademark of Regenstrief Institute, Inc",
    "compose": {
      "include": [
        {
          "system": "http://loinc.org",
          "concept": [
            {
              "code": "LP29684-5",
              "display": "Radiology"
            },
            {
              "code": "LP29708-2",
              "display": "Cardiology"
            },
            {
              "code": "LP7839-6",
              "display": "Pathology"
            }
          ]
        }
      ]
    }
  }