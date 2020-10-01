describe 'DataCriteriaHelpers', ->
  it 'has data_element_categories and primary_date_attributes', ->
    expect(Object.keys(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES).length).toEqual 32
    expect(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES['Encounter']).toEqual { period: 'Period' }
    expect(Object.keys(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES).length).toEqual 39
    expect(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES['Encounter']).toEqual 'management'

  it 'creates interval from period', ->
    period = new cqm.models.Period()
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-05T09:00:00.000+00:00')

    interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
    expect(interval.low.toString()).toEqual period.start.value
    expect(interval.high.toString()).toEqual period.end.value

  it 'creates interval from period when start and end is not available', ->
    period = new cqm.models.Period()
    interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
    expect(interval).toEqual null

  it 'creates interval from period when start is available but end is not available', ->
    period = new cqm.models.Period()
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
    period.end = undefined
    interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
    expect(interval.low.toString()).toEqual period.start.value
    expect(interval.high).toEqual undefined

  it 'creates interval from period when start is not available but end is available', ->
    period = new cqm.models.Period()
    period.start = undefined
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
    interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
    expect(interval.low).toEqual period.start
    expect(interval.high.toString()).toEqual period.end.value

  it 'creates period from interval', ->
    start = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
    end = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
    interval = new cqm.models.CQL.Interval(start, end)
    period = DataCriteriaHelpers.createPeriodFromInterval(interval)
    expect(period.start.value).toEqual interval.low.toString()
    expect(period.end.value).toEqual interval.high.toString()

  it 'creates period from interval when low is undefined', ->
    end = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
    interval = new cqm.models.CQL.Interval(undefined , end)
    period = DataCriteriaHelpers.createPeriodFromInterval(interval)
    expect(period.start).toEqual null
    expect(period.end.value).toEqual interval.high.toString()

  it 'creates period from interval when high is undefined', ->
    start = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
    interval = new cqm.models.CQL.Interval(start , undefined )
    period = DataCriteriaHelpers.createPeriodFromInterval(interval)
    expect(period.start.value).toEqual interval.low.toString()
    expect(period.end).toEqual null

  it 'creates period from datetime string', ->
    date = new cqm.models.CQL.DateTime(2020, 9, 21, 8, 0, 0, 0, 0)
    period = DataCriteriaHelpers.getPeriodForStringDateTime(date.toString())
    expect(period.start.value).toEqual date.toString()
    expect(period.end.value).toEqual date.add(15, cqm.models.CQL.DateTime.Unit.MINUTE).toString()

  it 'creates period from date string', ->
    date = new cqm.models.CQL.Date(2020, 9, 21)
    period = DataCriteriaHelpers.getPeriodForStringDate(date.toString())
    expect(period.start.value).toEqual '2020-09-21T08:00:00.000+00:00'
    expect(period.end.value).toEqual '2020-09-21T08:15:00.000+00:00'

  it 'creates CQL date from date string', ->
    dateString = '2012-02-02T08:45:00.000+00:00'
    cqlDate = DataCriteriaHelpers.getCQLDateFromString(dateString)
    expect(cqlDate.toString()).toEqual '2012-02-02'

  it 'creates PrimitiveDateTime from CQL DateTime', ->
    dateTime = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
    primitiveDateTime = DataCriteriaHelpers.getPrimitiveDateTimeForCqlDateTime(dateTime)
    expect(primitiveDateTime instanceof cqm.models.PrimitiveDateTime).toEqual true
    expect(primitiveDateTime.value).toEqual dateTime.toString()

  it 'creates PrimitiveInstant from CQL DateTime', ->
    dateTime = new cqm.models.CQL.DateTime(2020, 2, 2, 8, 45, 0, 0, 0)
    primitiveInstant = DataCriteriaHelpers.getPrimitiveInstantForCqlDateTime(dateTime)
    expect(primitiveInstant instanceof cqm.models.PrimitiveInstant).toEqual true
    expect(primitiveInstant.value).toEqual dateTime.toString()

  it 'creates PrimitiveDate from CQL Date', ->
    date = new cqm.models.CQL.Date(2020, 4, 5)
    primitiveDate = DataCriteriaHelpers.getPrimitiveDateForCqlDate(date)
    expect(primitiveDate instanceof cqm.models.PrimitiveDate).toEqual true
    expect(primitiveDate.value).toEqual date.toString()

  it 'creates PrimitiveDateTime from DateTime string', ->
    dateTime = new cqm.models.CQL.DateTime(2020, 2, 2, 8, 45, 0, 0, 0)
    primitiveDateTime = DataCriteriaHelpers.getPrimitiveDateTimeForStringDateTime(dateTime.toString())
    expect(primitiveDateTime instanceof cqm.models.PrimitiveDateTime).toEqual true
    expect(primitiveDateTime.value).toEqual dateTime.toString()

  it 'creates PrimitiveDateTime from Date string', ->
    date = new cqm.models.CQL.Date(2020, 9, 23)
    primitiveDateTime = DataCriteriaHelpers.getPrimitiveDateTimeForStringDate(date.toString())
    expect(primitiveDateTime instanceof cqm.models.PrimitiveDateTime).toEqual true
    expect(primitiveDateTime.value).toEqual '2020-09-23T08:00:00.000+00:00'

  it 'creates PrimitiveDate from DateTime string', ->
    dateTime = new cqm.models.CQL.DateTime(2020, 9, 23, 8, 45, 0, 0, 0)
    primitiveDate = DataCriteriaHelpers.getPrimitiveDateForStringDateTime(dateTime.toString())
    expect(primitiveDate instanceof cqm.models.PrimitiveDate).toEqual true
    expect(primitiveDate.value).toEqual '2020-09-23'

  DATA_ELEMENT_PRIMARY_CODE_PATH = [
    "AdverseEvent",
    "AllergyIntolerance",
    "Condition",
    "FamilyMemberHistory",
    "Procedure",
    "Coverage",
    "BodyStructure",
    "DiagnosticReport",
    "ImagingStudy",
    "Observation",
    "Specimen",
    "CarePlan",
    "CareTeam",
    "Goal",
    "NutritionOrder",
    "ServiceRequest",
    "Claim",
    "Communication",
    "CommunicationRequest",
    "DeviceRequest",
    "DeviceUseStatement",
    "Location",
    "Device",
    "Substance",
    "Encounter",
    "Flag",
    "Immunization",
    "ImmunizationEvaluation",
    "ImmunizationRecommendation",
    "Medication",
    "MedicationAdministration",
    "MedicationDispense",
    "MedicationRequest",
    "MedicationStatement",
    "Patient",
    "Practitioner",
    "PractitionerRole",
    "RelatedPerson",
    "Task",
  ]

  it 'returns undefined (unsupported) for an empty DataElement getPrimaryCodePath', ->
    expect(DataCriteriaHelpers.getPrimaryCodePath(new cqm.models.DataElement())).toBeUndefined

  it 'returns null for a DataElement unknown resource', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Resource()
    de.fhir_resource.resourceType = 'unsupported'
    expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toBe(null)

  it 'returns meta for getPrimaryCodePath', ->
    for res in DATA_ELEMENT_PRIMARY_CODE_PATH
      de = new cqm.models.DataElement()
      de.fhir_resource = new cqm.models[res]()
      expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toBeDefined()

  it 'set/get primary codes works for Encounter', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Encounter()
    expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toEqual 'type'
    expect(DataCriteriaHelpers.getPrimaryCodes(de)).toEqual []
    coding = new cqm.models.Coding()
    coding.system = cqm.models.PrimitiveUri.parsePrimitive('system')
    coding.code = cqm.models.PrimitiveCode.parsePrimitive('code')
    coding.version = cqm.models.PrimitiveString.parsePrimitive('version')
    DataCriteriaHelpers.setPrimaryCodes(de, [coding])
    expect(DataCriteriaHelpers.getPrimaryCodes(de).length).toEqual 1
    expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].code.value).toEqual 'code'
    expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].system.value).toEqual 'system'
    expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].version.value).toEqual 'version'

  it 'set/get primary codes works for Condition', ->
    de = new cqm.models.DataElement()
    de.fhir_resource = new cqm.models.Condition()
    expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toEqual 'code'
    expect(DataCriteriaHelpers.getPrimaryCodes(de)).toEqual []
    coding = new cqm.models.Coding()
    coding.system = cqm.models.PrimitiveUri.parsePrimitive('system')
    coding.code = cqm.models.PrimitiveCode.parsePrimitive('code')
    coding.version = cqm.models.PrimitiveString.parsePrimitive('version')
    DataCriteriaHelpers.setPrimaryCodes(de, [coding])
    expect(DataCriteriaHelpers.getPrimaryCodes(de).length).toEqual 1
    expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].code.value).toEqual 'code'
    expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].system.value).toEqual 'system'
    expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].version.value).toEqual 'version'

  describe 'Condition attributes', ->
    it 'should support clinicalStatus and verificationStatus attributes', ->
      conditionAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      clinicalStatus = conditionAttrs[0]
      expect(clinicalStatus.path).toEqual 'clinicalStatus'
      expect(clinicalStatus.title).toEqual 'clinicalStatus'
      expect(clinicalStatus.types).toEqual ['CodeableConcept']

      verificationStatus = conditionAttrs[1]
      expect(verificationStatus.path).toEqual 'verificationStatus'
      expect(verificationStatus.title).toEqual 'verificationStatus'
      expect(verificationStatus.types).toEqual ['CodeableConcept']

    it 'should set and get values for clinicalStatus', ->
      conditionAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      clinicalStatus = conditionAttrs[0]
      expect(clinicalStatus.path).toEqual 'clinicalStatus'
      # Create condition fhir resource and coding
      conditionResource = new cqm.models.Condition()
      coding = new cqm.models.Coding()
      coding.system = cqm.models.PrimitiveUri.parsePrimitive('condition-clinical')
      coding.version = cqm.models.PrimitiveString.parsePrimitive('4.0.1')
      coding.code = cqm.models.PrimitiveCode.parsePrimitive('recurrence')
      coding.display = cqm.models.PrimitiveString.parsePrimitive('Recurrence')
      coding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      # set coding to clinicalStatus
      clinicalStatus.setValue(conditionResource, coding)

      selectedCoding = clinicalStatus.getValue(conditionResource)
      # Verify after setting values
      expect(selectedCoding.code.value).toEqual 'recurrence'
      expect(selectedCoding.display.value).toEqual 'Recurrence'
      expect(selectedCoding.system.value).toEqual 'condition-clinical'

    it 'should get valueSets for clinicalStatus', ->
      condition = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      clinicalStatus = condition[0]
      expect(clinicalStatus.path).toEqual 'clinicalStatus'

      valueSets = clinicalStatus.valueSets()
      expect(valueSets[0].id).toEqual '2.16.840.1.113883.4.642.3.164'
      expect(valueSets[0].name).toEqual 'ConditionClinicalStatusCodes'

    it 'should set and get values for verificationStatus', ->
      conditionAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      verificationStatus = conditionAttrs[1]
      expect(verificationStatus.path).toEqual 'verificationStatus'
      # Create condition fhir resource and coding
      conditionResource = new cqm.models.Condition()
      coding = new cqm.models.Coding()
      coding.system = cqm.models.PrimitiveUri.parsePrimitive('condition-ver-status')
      coding.version = cqm.models.PrimitiveString.parsePrimitive('4.0.1')
      coding.code = cqm.models.PrimitiveCode.parsePrimitive('differential')
      coding.display = cqm.models.PrimitiveString.parsePrimitive('Differential')
      coding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      # set coding to clinicalStatus
      verificationStatus.setValue(conditionResource, coding)

      selectedCoding = verificationStatus.getValue(conditionResource)
      # Verify after setting values
      expect(selectedCoding.code.value).toEqual 'differential'
      expect(selectedCoding.display.value).toEqual 'Differential'
      expect(selectedCoding.system.value).toEqual 'condition-ver-status'
