@DataCriteriaHelpers = class DataCriteriaHelpers

  @PRIMARY_TIMING_ATTRIBUTES:
    AdverseEvent: { date: 'dateTime', detected: 'dateTime', recordedDate: 'dateTime' },
    AllergyIntolerance: { recordedDate: 'dateTime', lastOccurrence: 'dateTime' },
    Condition: { recordedDate: 'dateTime' },
    FamilyMemberHistory: { date: 'dateTime' },
    Coverage: { period: 'Period' },
    DiagnosticReport: { issued: 'instant' },
    ImagingStudy: { started: 'DateTime' },
    Observation: { issued: 'instant' },
    Specimen: { receivedTime: 'dateTime' },
    CarePlan: { period: 'Period', created: 'DateTime' },
    CareTeam: { period: 'Period' },
    Goal: { statusDate: 'date' },
    NutritionOrder: { dateTime: 'dateTime' },
    ServiceRequest: { authoredOn: 'dateTime' },
    Claim: { billablePeriod: 'Period', created: 'dateTime' },
    Communication: { sent: 'dateTime', received: 'dateTime' },
    CommunicationRequest: { authoredOn: 'dateTime' },
    DeviceRequest: { authoredOn: 'dateTime' },
    DeviceUseStatement: { recordedOn: 'dateTime' },
    Device: { manufactureDate: 'dateTime', expirationDate: 'dateTime' },
    Encounter: { period: 'Period' },
    Flag: { period: 'Period' },
    Immunization: { recorded: 'dateTime', expirationDate: 'date' },
    ImmunizationEvaluation: { date: 'dateTime' },
    ImmunizationRecommendation: { date: 'dateTime' },
    MedicationDispense: { whenPrepared: 'dateTime', whenHandedOver: 'dateTime' },
    MedicationRequest: { authoredOn: 'dateTime' },
    MedicationStatement: { dateAsserted: 'dateTime' },
    Practitioner: { birthDate: 'date' },
    PractitionerRole: { period: 'Period' },
    RelatedPerson: { period: 'Period', birthDate: 'date' },
    Task: { executionPeriod: 'Period', authoredOn: 'dateTime', lastModified: 'dateTime' }

  @DATA_ELEMENT_CATEGORIES:
    AdverseEvent:       'clinical summary'
    AllergyIntolerance: 'clinical summary'
    Condition:          'clinical summary'
    FamilyMemberHistory:'clinical summary'
    Procedure:          'clinical summary'

    Coverage: 'financial support'

    BodyStructure:    'diagnostics'
    DiagnosticReport: 'diagnostics'
    ImagingStudy:     'diagnostics'
    Observation:      'diagnostics'
    Specimen:         'diagnostics'

    CarePlan:       'care provision'
    CareTeam:       'care provision'
    Goal:           'care provision'
    NutritionOrder: 'care provision'
    ServiceRequest: 'care provision'

    Claim: 'billing'

    Communication:        'request response'
    CommunicationRequest: 'request response'
    DeviceRequest:        'request response'
    DeviceUseStatement:   'request response'

    Location: 'providers entities'

    Device:    'material entities'
    Substance: 'material entities'

    Encounter: 'management'
    Flag:      'management'

    Immunization:               'medications'
    ImmunizationEvaluation:     'medications'
    ImmunizationRecommendation: 'medications'
    Medication:                  'medications'
    MedicationAdministration:    'medications'
    MedicationDispense:         'medications'
    MedicationRequest:          'medications'
    MedicationStatement:        'medications'

    Patient:          'individuals'
    Practitioner:     'individuals'
    PractitionerRole: 'individuals'
    RelatedPerson:    'individuals'

    Task: 'workflow'

  @createIntervalFromPeriod: (period) ->
    return null if period == undefined ||
      (period?.start == undefined && period?.end == undefined )

    startDate = @getCQLDateTimeFromString(period?.start?.value) if period?.start?.value?
    endDate = @getCQLDateTimeFromString(period?.end?.value) if period?.end?.value?
    new cqm.models.CQL.Interval(startDate, endDate)

  @getCQLDateTimeFromString: (dateStr) ->
    return null if dateStr == undefined
    cqm.models.CQL.DateTime.fromJSDate(new Date(dateStr), 0)

  @getCQLDateFromString: (dateStr) ->
    return null if dateStr == undefined
    cqm.models.CQL.Date.fromJSDate(new Date(dateStr))

  @createPeriodFromInterval: (interval) ->
    period = new cqm.models.Period()
    period.start = period.end = null
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive interval.low.toString() if interval && interval.low?
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive interval.high.toString() if interval && interval.high?
    return period

  @getPrimitiveDateTimeForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveDateTime.parsePrimitive dateTime?.toString()

  @getPrimitiveInstantForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveInstant.parsePrimitive dateTime?.toString()

  @getPrimitiveDateForCqlDate: (date) ->
    cqm.models.PrimitiveDate.parsePrimitive date?.toString()

  @getPrimaryCodePath: (dataElement) ->
    return cqm.models[dataElement.fhir_resource?.constructor?.name]?.primaryCodePath

  @getPrimaryCodes: (dataElement) ->
    return dataElement?.fhir_resource?.primaryCode?.coding || []

  @setPrimaryCodes: (dataElement, codes) ->
    codeableConcept = new cqm.models.CodeableConcept()
    codeableConcept.coding = codes
    dataElement?.fhir_resource?.primaryCode = codeableConcept

  @getPrimaryCodePath: (dataElement) ->
    resourceType = dataElement.fhir_resource?.resourceType
    primaryCodePath = @DATA_ELEMENT_PRIMARY_CODE_PATH[resourceType]
    return primaryCodePath


  @getAttributes: (dataElement) ->
    resourceType = dataElement.fhir_resource?.resourceType
    attributes = @DATA_ELEMENT_ATTRIBUTES[resourceType]
    return attributes || []

  @getAttribute: (dataElement, path) ->
    resourceType = dataElement.fhir_resource?.resourceType
    return @DATA_ELEMENT_ATTRIBUTES[resourceType]?.find( (attr) => attr.path is path )

# Editor types:
#    'Interval<DateTime>'
#    'Interval<Quantity>'
#    'DateTime'
#    'Time'
#    'Quantity'
#    'Code'
#    'String'
#    'Integer'
#    'Decimal'
#    'Ratio'
#    'Any'
#    'Identifier'
#    else null

# Data element attributes per resource type
  @DATA_ELEMENT_ATTRIBUTES:
      AdverseEvent:                 []
      AllergyIntolerance:           []
      Condition:                    []
      FamilyMemberHistory:          []
      Procedure:                    []
      Coverage:                     []
      BodyStructure:                []
      DiagnosticReport:             []
      ImagingStudy:                 []
      Observation:                  []
      Specimen:                     []
      CarePlan:                     []
      CareTeam:                     []
      Goal:                         []
      NutritionOrder:               []
      ServiceRequest:               []
      Claim:                        []
      Communication:                []
      CommunicationRequest:         []
      DeviceRequest:                []
      DeviceUseStatement:           []
      Location:                     []
      Device:                       []
      Substance:                    []
      Encounter:                    [
        {
          path: 'length'
          title: 'Length'
          getValue: (fhirResource) =>
            fhirResource?.length
          setValue: (fhirResource, value) =>
            fhirResource?.length = value
          types: ['Duration']
        },
    #        { path: 'status' },
    #        { path: 'location.period' },
    #        { path: 'hospitalization.dischargeDisposition' },
    #        { path: 'type' }
      ]
      Flag:                         []
      Immunization:                 []
      ImmunizationEvaluation:       []
      ImmunizationRecommendation:   []
      Medication:                   []
      MedicationAdministration:     []
      MedicationDispense:           []
      MedicationRequest:            []
      MedicationStatement:          []
      Patient:                      []
      Practitioner:                 []
      PractitionerRole:             []
      RelatedPerson:                []
      Task:                         []

