@TastStatusValueSet = class TastStatusValueSet
  @JSON = {
    "resourceType": "ValueSet",
    "version": "4.0.1",
    "name": "TaskStatus",
    "title": "TaskStatus",
    "compose": {
      "include": [
        {
          "system": "http://hl7.org/fhir/task-status",
          "version": "4.0.1",
          "concept": [
            {
              "code": "draft",
              "display": "Draft"
            },
            {
              "code": "requested",
              "display": "Requested"
            },
            {
              "code": "received",
              "display": "Received"
            },
            {
              "code": "accepted",
              "display": "Accepted"
            },
            {
              "code": "rejected",
              "display": "Rejected"
            },
            {
              "code": "ready",
              "display": "Ready"
            },
            {
              "code": "cancelled",
              "display": "Cancelled"
            },
            {
              "code": "in-progress",
              "display": "In Progress"
            },
            {
              "code": "on-hold",
              "display": "On Hold"
            },
            {
              "code": "failed",
              "display": "Failed"
            },
            {
              "code": "completed",
              "display": "Completed"
            },
            {
              "code": "entered-in-error",
              "display": "Entered in Error"
            }
          ]
        }
      ]
    },
    "url": "http://hl7.org/fhir/ValueSet/task-status"
    "id": "2.16.840.1.113883.4.642.3.790"
  }
