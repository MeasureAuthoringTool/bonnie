describe 'DataCriteriaHelpers', ->

  it 'has data_element_categories and primary_date_attributes', ->
    expect(Object.keys(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES).length).toEqual 32
    expect(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES['Encounter']).toEqual { period: 'Period' }
    expect(Object.keys(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES).length).toEqual 39
    expect(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES['Encounter']).toEqual 'management'

  describe 'data type converters', ->
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

  describe 'Primary code path', ->
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

  ############################################
  # Testing data element attribute accessors:

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

      onset = conditionAttrs[2]
      expect(onset.path).toEqual 'onset'
      expect(onset.title).toEqual 'onset'
      expect(onset.types).toEqual ['DateTime', 'Age', 'Period', 'Range']

      abatement = conditionAttrs[3]
      expect(abatement.path).toEqual 'abatement'
      expect(abatement.title).toEqual 'abatement'
      expect(abatement.types).toEqual ['DateTime', 'Age', 'Period', 'Range']

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
      # set coding to verificationStatus
      verificationStatus.setValue(conditionResource, coding)

      selectedCoding = verificationStatus.getValue(conditionResource)
      # Verify after setting values
      expect(selectedCoding.code.value).toEqual 'differential'
      expect(selectedCoding.display.value).toEqual 'Differential'
      expect(selectedCoding.system.value).toEqual 'condition-ver-status'

    it 'should set and get values for abatement if Choice type is DateTime', ->
      conditionAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      abatement = conditionAttrs[3]
      expect(abatement.path).toEqual 'abatement'
      # Create DateTime & condition fhir resource
      dateTime = new cqm.models.CQL.DateTime(2020, 10, 5, 8, 0, 0, 0, 0)
      conditionResource = new cqm.models.Condition()
      # set abatement DateTime
      abatement.setValue(conditionResource, dateTime)

      abatementValue = abatement.getValue(conditionResource)
      # Verify after setting values
      expect(abatementValue.value).toEqual dateTime.toString()

    it 'should set and get values for abatement if Choice type is Age', ->
      conditionAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      abatement = conditionAttrs[3]
      expect(abatement.path).toEqual 'abatement'
      # Create condition fhir resource and abatement Age
      conditionResource = new cqm.models.Condition()
      age = new cqm.models.Age()
      age.unit = cqm.models.PrimitiveString.parsePrimitive('days')
      age.value = cqm.models.PrimitiveDecimal.parsePrimitive(12)
      # set abatement Age
      abatement.setValue(conditionResource, age)
      abatementValue = abatement.getValue(conditionResource)
      # Verify after setting values
      expect(abatementValue.unit.value).toEqual age.unit.value
      expect(abatementValue.value.value).toEqual age.value.value

    it 'should set and get values for abatement if Choice type is Period', ->
      conditionAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      abatement = conditionAttrs[3]
      expect(abatement.path).toEqual 'abatement'
      # Create condition fhir resource abatement Period
      conditionResource = new cqm.models.Condition()
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      # set abatement Period
      abatement.setValue(conditionResource, period)

      abatementValue = abatement.getValue(conditionResource)
      # Verify after setting values
      expect(abatementValue.start.value).toEqual period.start.value
      expect(abatementValue.end.value).toEqual period.end.value

  describe 'Encounter attributes', ->
    it 'should support Encounter.length', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'length'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'length'
      expect(attr.title).toBe 'length'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Duration'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Duration()
      valueToSet.unit = cqm.models.PrimitiveString.parsePrimitive('ml')
      valueToSet.value = cqm.models.PrimitiveDecimal.parsePrimitive(100)
      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.unit.value).toBe 'ml'
      expect(value.value.value).toBe 100

    it 'should support Encounter.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'status'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'status'
      expect(attr.title).toBe 'status'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'

    it 'should support Encounter.location.period', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'location.period'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'location.period'
      expect(attr.title).toBe 'location.period'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Period'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Period()
      valueToSet.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      valueToSet.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.start.value).toBe '2020-09-02T13:54:57'
      expect(value.end.value).toBe '2020-10-02T13:54:57'

    it 'should support Encounter.hospitalization.dischargeDisposition', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'hospitalization.dischargeDisposition'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'hospitalization.dischargeDisposition'
      expect(attr.title).toBe 'hospitalization.dischargeDisposition'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'CodeableConcept'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')
      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

  describe 'Procedure attributes', ->
    it 'should support procedure status and performed attributes', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      status = procedureAttrs[0]
      expect(status.path).toEqual 'status'
      expect(status.title).toEqual 'status'
      expect(status.types).toEqual ['Code']
      performed = procedureAttrs[1]
      expect(performed.path).toEqual 'performed'
      expect(performed.title).toEqual 'performed'
      expect(performed.types).toEqual ['DateTime', 'Period']

    it 'should set and get values for procedure status', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      procedureStatus = procedureAttrs[0]
      expect(procedureStatus.path).toEqual 'status'
      procedureResource = new cqm.models.Procedure()
      # when no code is set
      expect(procedureStatus.getValue(procedureResource)).toBeUndefined

      # set the code
      procedureStatus.setValue(procedureResource, 'test code')
      selectedCode = procedureStatus.getValue(procedureResource)
      # Verify after setting code
      expect(selectedCode).toEqual 'test code'

    it 'should get value sets for procedure status', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      procedureStatus = procedureAttrs[0]
      expect(procedureStatus.path).toEqual 'status'
      statusVs = procedureStatus.valueSets()
      expect(statusVs.length).toEqual 1
      expect(statusVs[0].name).toEqual 'EventStatus'
      expect(statusVs[0].compose.include.length).toEqual 1
      expect(statusVs[0].compose.include[0].concept.length).toEqual 8

    it 'should set and get values for performed if Choice type is DateTime', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      performed = procedureAttrs[1]
      expect(performed.path).toEqual 'performed'
      # Create procedure fhir resource & DateTime to set
      procedureResource = new cqm.models.Procedure()
      dateTime = new cqm.models.CQL.DateTime(2020, 10, 5, 8, 0, 0, 0, 0)
      expect(performed.getValue(procedureResource)).toBeUndefined

      # set performed DateTime to Procedure
      performed.setValue(procedureResource, dateTime)
      performedValue = performed.getValue(procedureResource)
      # Verify after setting values
      expect(performedValue.value).toEqual dateTime.toString()

    it 'should set and get values for performed if Choice type is Period', ->
      procedureAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      performed = procedureAttrs[1]
      expect(performed.path).toEqual 'performed'
      # Create procedure fhir resource & period to set
      procedureResource = new cqm.models.Procedure()
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      # set performed period to Procedure
      performed.setValue(procedureResource, period)

      performedValue = performed.getValue(procedureResource)
      # Verify after setting values
      expect(performedValue.start.value).toEqual period.start.value
      expect(performedValue.end.value).toEqual period.end.value

    it 'should support Procedure.category', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'category'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'category'
      expect(attr.title).toBe 'category'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'CodeableConcept'

      fhirResource = new cqm.models.Procedure()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

    it 'should support Procedure.statusReason', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'statusReason'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'statusReason'
      expect(attr.title).toBe 'statusReason'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'CodeableConcept'

      fhirResource = new cqm.models.Procedure()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

    it 'should support Procedure.usedCode', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Procedure']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'usedCode'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'usedCode'
      expect(attr.title).toBe 'usedCode'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'CodeableConcept'

      fhirResource = new cqm.models.Procedure()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

  describe 'Medication Request attributes', ->
    it 'should support MedicationRequest.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationRequest']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'status'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'status'
      expect(attr.title).toBe 'status'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'

      fhirResource = new cqm.models.MedicationRequest()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)
      expect(cqm.models.MedicationRequestStatus.isMedicationRequestStatus(fhirResource.status)).toBe true

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'

    it 'should support MedicationRequest.intent', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationRequest']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'intent'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'intent'
      expect(attr.title).toBe 'intent'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'

      fhirResource = new cqm.models.MedicationRequest()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)
      expect(cqm.models.MedicationRequestIntent.isMedicationRequestIntent(fhirResource.intent)).toBe true

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'

  describe 'Medication Statement attributes', ->
    it 'should support MedicationStatement.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationStatement']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'status'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'status'
      expect(attr.title).toBe 'status'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'

      fhirResource = new cqm.models.MedicationStatement()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)
      expect(cqm.models.MedicationStatementStatus.isMedicationStatementStatus(fhirResource.status)).toBe true

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'

  describe 'AllergyIntolerance attributes', ->
    it 'should support AllergyIntolerance.clinicalStatus', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['AllergyIntolerance']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'clinicalStatus'
      expect(attr.path).toBe 'clinicalStatus'
      expect(attr.title).toBe 'clinicalStatus'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'CodeableConcept'

      fhirResource = new cqm.models.AllergyIntolerance()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

    it 'should support AllergyIntolerance.verificationStatus', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['AllergyIntolerance']
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is 'verificationStatus'
      expect(attr.path).toBe 'verificationStatus'
      expect(attr.title).toBe 'verificationStatus'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'CodeableConcept'

      fhirResource = new cqm.models.AllergyIntolerance()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

    it 'should support onset', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['AllergyIntolerance']
      attr = attrs.find (attr) => attr.path is 'onset'
      expect(attr.path).toEqual 'onset'
      expect(attr.title).toEqual 'onset'
      expect(attr.types).toEqual ['DateTime', 'Age', 'Period', 'Range']

      fhirResource = new cqm.models.AllergyIntolerance()
      expect(attr.getValue(fhirResource)).toBeUndefined

    it 'should set and get values for abatement if Choice type is DateTime', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['AllergyIntolerance']
      attr = attrs.find (attr) => attr.path is 'onset'
      expect(attr.path).toEqual 'onset'
      # Create DateTime & hir resource
      dateTime = new cqm.models.CQL.DateTime(2020, 10, 5, 8, 0, 0, 0, 0)
      fhirResource = new cqm.models.AllergyIntolerance()
      # set DateTime
      attr.setValue(fhirResource, dateTime)

      value = attr.getValue(fhirResource)
      # Verify after setting values
      expect(value.value).toEqual dateTime.toString()

    it 'should set and get values for onset if Choice type is Age', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['AllergyIntolerance']
      attr = attrs.find (attr) => attr.path is 'onset'
      expect(attr.path).toEqual 'onset'
      # Create condition fhir resource and Age
      fhirResource = new cqm.models.AllergyIntolerance()
      age = new cqm.models.Age()
      age.unit = cqm.models.PrimitiveString.parsePrimitive('days')
      age.value = cqm.models.PrimitiveDecimal.parsePrimitive(12)
      # set Age
      attr.setValue(fhirResource, age)
      value = attr.getValue(fhirResource)
      # Verify after setting values
      expect(value.unit.value).toEqual age.unit.value
      expect(value.value.value).toEqual age.value.value

    it 'should set and get values for onset if Choice type is Period', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['AllergyIntolerance']
      attr = attrs.find (attr) => attr.path is 'onset'
      expect(attr.path).toEqual 'onset'
      # Create condition fhir resource and Period
      fhirResource = new cqm.models.AllergyIntolerance()
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      # set Period
      attr.setValue(fhirResource, period)

      value = attr.getValue(fhirResource)
      # Verify after setting values
      expect(value.start.value).toEqual period.start.value
      expect(value.end.value).toEqual period.end.value
