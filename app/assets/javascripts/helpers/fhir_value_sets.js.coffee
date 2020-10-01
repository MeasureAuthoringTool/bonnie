@FhirValueSets = class FhirValueSets

  @VALUE_SETS = [
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "ConditionClinicalStatusCodes",
      "title": "ConditionClinicalStatusCodes",
      "compose": {
        "include": [
          {
            "system": "condition-clinical",
            "version": "4.0.1",
            "concept": [
              {
                "code": "active",
                "display": "Active"
              },
              {
                "code": "recurrence",
                "display": "Recurrence"
              },
              {
                "code": "relapse",
                "display": "Relapse"
              },
              {
                "code": "inactive",
                "display": "Inactive"
              },
              {
                "code": "remission",
                "display": "Remission"
              },
              {
                "code": "resolved",
                "display": "Resolved"
              }
            ]
          }
        ]
      },
      "url": "http://terminology.hl7.org/CodeSystem/condition-clinical"
      "id": "2.16.840.1.113883.4.642.3.164"
    },
    {
      "resourceType": "ValueSet",
      "version": "4.0.1",
      "name": "ConditionVerificationStatus",
      "title": "ConditionVerificationStatus",
      "compose": {
        "include": [
          {
            "system": "condition-ver-status",
            "version": "4.0.1",
            "concept": [
              {
                "code": "unconfirmed",
                "display": "Unconfirmed"
              },
              {
                "code": "provisional",
                "display": "Provisional"
              },
              {
                "code": "differential",
                "display": "Differential"
              },
              {
                "code": "confirmed",
                "display": "Confirmed"
              },
              {
                "code": "refuted",
                "display": "Refuted"
              },
              {
                "code": "entered-in-error",
                "display": "Entered in Error"
              }
            ]
          }
        ]
      },
      "url": "http://terminology.hl7.org/CodeSystem/condition-ver-status"
      "id": "2.16.840.1.113883.4.642.3.166"
    }
  ]

  @getValueSetByOid: (oid) ->
    @VALUE_SETS.filter (vs) -> vs.id == oid
