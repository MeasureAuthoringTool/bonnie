# Description http://hl7.org/fhir/ValueSet/units-of-time
# This value set is used in the following places:
# Resource: Timing.repeat.durationUnit (code / Required)
# Resource: Timing.repeat.periodUnit (code / Required)
@UnitsOfTimeValueSet = class UnitsOfTimeValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "units-of-time",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "extensions",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>UnitsOfTime</h2><div><p>A unit of time (units from UCUM).</p>\n</div><p><b>Copyright Statement:</b></p><div><p>These codes are excerpted from UCUM (THE UNIFIED CODE FOR UNITS OF MEASURE). UCUM is Copyright © 1989-2013 Regenstrief Institute, Inc. and The UCUM Organization, Indianapolis, IN. All rights reserved. See http://unitsofmeasure.org/trac//wiki/TermsOfUse for details.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include these codes as defined in <a href=\"http://unitsofmeasure.org\"><code>http://unitsofmeasure.org</code></a><table class=\"none\"><tr><td style=\"white-space:nowrap\"><b>Code</b></td><td><b>Display</b></td><td><b>Definition</b></td></tr><tr><td>s</td><td>second</td><td>second</td></tr><tr><td>min</td><td>minute</td><td>minute</td></tr><tr><td>h</td><td>hour</td><td>hour</td></tr><tr><td>d</td><td>day</td><td>day</td></tr><tr><td>wk</td><td>week</td><td>week</td></tr><tr><td>mo</td><td>month</td><td>month</td></tr><tr><td>a</td><td>year</td><td>year</td></tr></table></li></ul><p><b>Additional Language Displays</b></p><table class=\"codes\"><tr><td><b>Code</b></td><td><b>中文 (Chinese, zh)</b></td></tr><tr><td>s</td><td>秒</td></tr><tr><td>min</td><td>分钟</td></tr><tr><td>h</td><td>小时</td></tr><tr><td>d</td><td>天</td></tr><tr><td>wk</td><td>星期</td></tr><tr><td>mo</td><td>月</td></tr><tr><td>a</td><td>年</td></tr></table></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "fhir"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "normative"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-normative-version",
        "valueCode" : "4.0.0"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 5
      }],
    "url" : "http://hl7.org/fhir/ValueSet/units-of-time",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.77"
    }],
    "version" : "4.0.1",
    "name" : "UnitsOfTime",
    "title" : "UnitsOfTime",
    "status" : "active",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      },
        {
          "system" : "email",
          "value" : "fhir@lists.hl7.org"
        }]
    }],
    "description" : "A unit of time (units from UCUM).",
    "copyright" : "These codes are excerpted from UCUM (THE UNIFIED CODE FOR UNITS OF MEASURE). UCUM is Copyright © 1989-2013 Regenstrief Institute, Inc. and The UCUM Organization, Indianapolis, IN. All rights reserved. See http://unitsofmeasure.org/trac//wiki/TermsOfUse for details.",
    "compose": {
      "include": [
        {
          "system": "http://unitsofmeasure.org",
          "concept": [
            {
              "code": "s",
              "display": "second"
            },
            {
              "code": "min",
              "display": "minute"
            },
            {
              "code": "h",
              "display": "hour"
            },
            {
              "code": "d",
              "display": "day"
            },
            {
              "code": "wk",
              "display": "week"
            },
            {
              "code": "mo",
              "display": "month"
            },
            {
              "code": "a",
              "display": "year"
            }
          ]
        }
      ]
    }
  }