# Description http://hl7.org/fhir/ValueSet/days-of-week
# CodeSystem: This value set is the designated 'entire code system' value set for DaysOfWeek
# Resource: PractitionerRole.availableTime.daysOfWeek (code / Required)
# Resource: HealthcareService.availableTime.daysOfWeek (code / Required)
# Resource: Location.hoursOfOperation.daysOfWeek (code / Required)
# Resource: Timing.repeat.dayOfWeek (code / Required)
@DaysOfWeekValueSet = class DaysOfWeekValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "days-of-week",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>DaysOfWeek</h2><div><p>The days of the week.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-days-of-week.html\"><code>http://hl7.org/fhir/days-of-week</code></a></li></ul></div>"
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
    "url" : "http://hl7.org/fhir/ValueSet/days-of-week",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.512"
    }],
    "version" : "4.0.1",
    "name" : "DaysOfWeek",
    "title" : "DaysOfWeek",
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
    "description" : "The days of the week.",
    "immutable" : true,
    "compose": {
      "include": [
        {
          "system": "http://hl7.org/fhir/days-of-week",
          "concept": [
            {
              "code": "mon",
              "display": "Monday"
            },
            {
              "code": "tue",
              "display": "Tuesday"
            },
            {
              "code": "wed",
              "display": "Wednesday"
            },
            {
              "code": "thu",
              "display": "Thursday"
            },
            {
              "code": "fri",
              "display": "Friday"
            },
            {
              "code": "sat",
              "display": "Saturday"
            },
            {
              "code": "sun",
              "display": "Sunday"
            }
          ]
        }
      ]
    }
  }