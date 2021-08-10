describe 'DataCriteriaHelpers', ->

  describe 'Condition attributes', ->
    it 'should support clinicalStatus and verificationStatus attributes', ->
      conditionAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Condition']
      clinicalStatus = conditionAttrs[0]
      expect(clinicalStatus.path).toEqual 'clinicalStatus'
      expect(clinicalStatus.types).toEqual ['CodeableConcept']

      verificationStatus = conditionAttrs[1]
      expect(verificationStatus.path).toEqual 'verificationStatus'
      expect(verificationStatus.types).toEqual ['CodeableConcept']

      onset = conditionAttrs[2]
      expect(onset.path).toEqual 'onset'
      expect(onset.types).toEqual ['DateTime', 'Age', 'Period', 'Range']

      abatement = conditionAttrs[3]
      expect(abatement.path).toEqual 'abatement'
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
      dateTime = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-05T08:00:00.000+00:00')
      conditionResource = new cqm.models.Condition()
      # set abatement DateTime
      abatement.setValue(conditionResource, dateTime)

      abatementValue = abatement.getValue(conditionResource)
      # Verify after setting values
      expect(abatementValue.value).toEqual '2020-10-05T08:00:00.000+00:00'

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

    it 'should support Condition.bodySite', ->
      DataCriteriaAsserts.assertCodeableConcept('Condition', 'bodySite')

    it 'should support Condition.category', ->
      DataCriteriaAsserts.assertCodeableConcept('Condition', 'category')

    it 'should support Condition.severity', ->
      DataCriteriaAsserts.assertCodeableConcept('Condition', 'severity')

    it 'should support Condition.recorder', ->
      DataCriteriaAsserts.assertReference('Condition', 'recorder')

    it 'should support Condition.asserter', ->
      DataCriteriaAsserts.assertReference('Condition', 'asserter')
