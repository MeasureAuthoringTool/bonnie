describe 'DataCriteriaHelpers', ->

  describe 'Observation attributes', ->
    beforeEach ->
      @observationAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Observation']


    it 'should support Observation.status', ->
      DataCriteriaAsserts.assertCode('Observation', 'status', cqm.models.ObservationStatus)

    it 'should support Observation.category', ->
      DataCriteriaAsserts.assertCodeableConcept('Observation', 'category')

    it 'should support Observation.component.code', ->
      DataCriteriaAsserts.assertCodeableConcept('Observation', 'component.code')

    it 'should support Observation.effective', ->
      attr = @observationAttrs.find (attr) -> attr.path is 'effective'
      expect(attr.path).toEqual 'effective'
      expect(attr.types).toEqual ['DateTime', 'Period', 'Timing', 'Instant']

      # set DateTime/Timing
      valueDateTime = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
      fhirResource = new cqm.models.Observation()
      attr.setValue(fhirResource, valueDateTime)
      expect(fhirResource.effective.value).toEqual '2012-02-02T08:45:00.000+00:00'

    it 'should support Observation.value', ->
      value = @observationAttrs.find (attr) -> attr.path is 'value'
      expect(value.path).toEqual 'value'
      expect(value.types).toEqual ['Boolean', 'CodeableConcept', 'DateTime', 'Integer', 'Period',
        'Quantity', 'Range', 'Ratio', 'SampledData', 'String', 'Time']

      # set Boolean value
      valueBoolean = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      fhirResource = new cqm.models.Observation()
      value.setValue(fhirResource, valueBoolean)
      expect(fhirResource.value.value).toEqual valueBoolean.value
      attrValue = value.getValue(fhirResource)
      expect(attrValue.value).toEqual valueBoolean.value

      # set DateTime value
      valueDateTime = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
      value.setValue(fhirResource, valueDateTime)
      expect(fhirResource.value.value).toEqual '2012-02-02T08:45:00.000+00:00'

      # set CodeableConcept value
      coding = cqm.models.Coding.parse({system: 'SNOMEDCT', code:'123456', version: 'version'})
      value.setValue(fhirResource, coding)
      attrValue = value.getValue(fhirResource)
      expect(attrValue.system.value).toEqual coding.system.value
      expect(attrValue.code.value).toEqual coding.code.value
      expect(attrValue.version.value).toEqual coding.version.value

    it 'should support Observation.component.value', ->
      attribute = @observationAttrs.find (attr) -> attr.path is 'component.value'
      expect(attribute.path).toEqual 'component.value'
      expect(attribute.types).toEqual ['Quantity', 'CodeableConcept', 'String', 'Boolean', 'Integer',
        'Range', 'Ratio', 'SampledData','Time', 'DateTime', 'Period']

      #set Boolean value
      valueBoolean = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      fhirResource = new cqm.models.Observation()
      attribute.setValue(fhirResource, valueBoolean)
      attrValue = attribute.getValue(fhirResource)
      expect(attrValue.value).toEqual valueBoolean.value

      # set DateTime value
      valueDateTime = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
      attribute.setValue(fhirResource, valueDateTime)
      attrValue = attribute.getValue(fhirResource)
      expect(attrValue.value).toEqual '2012-02-02T08:45:00.000+00:00'

      # set CodeableConcept value
      coding = cqm.models.Coding.parse({system: 'SNOMEDCT', code:'123456', version: 'version'})
      attribute.setValue(fhirResource, coding)
      attrValue = attribute.getValue(fhirResource)
      expect(attrValue.system.value).toEqual coding.system.value
      expect(attrValue.code.value).toEqual coding.code.value
      expect(attrValue.version.value).toEqual coding.version.value

      # set SampledData value
      valueSampledData = new cqm.models.SampledData()
      valueSampledData.origin = new cqm.models.SimpleQuantity()
      valueSampledData.origin.value = cqm.models.PrimitiveDecimal.parsePrimitive(2)

      valueSampledData.period = new cqm.models.PrimitiveDecimal()
      valueSampledData.period.value = cqm.models.PrimitiveDecimal.parsePrimitive(3.0)

      valueSampledData.dimensions = new cqm.models.PrimitivePositiveInt()
      valueSampledData.dimensions.value = cqm.models.PrimitivePositiveInt.parsePrimitive(4)

      valueSampledData.lowerLimit = new cqm.models.PrimitiveDecimal()
      valueSampledData.lowerLimit.value = cqm.models.PrimitiveDecimal.parsePrimitive(3.0)

      valueSampledData.upperLimit = new cqm.models.PrimitiveDecimal()
      valueSampledData.upperLimit = cqm.models.PrimitiveDecimal.parsePrimitive(4.0)

      valueSampledData.data = new cqm.models.PrimitiveString()
      valueSampledData.data = cqm.models.PrimitiveString.parsePrimitive("E")

      attribute.setValue(fhirResource, valueSampledData)
      attrValue = attribute.getValue(fhirResource)
      expect(attrValue.origin).toEqual valueSampledData.origin
      expect(attrValue.period).toEqual valueSampledData.period
      expect(attrValue.dimensions).toEqual valueSampledData.dimensions
      expect(attrValue.lowerLimit).toEqual valueSampledData.lowerLimit
      expect(attrValue.upperLimit).toEqual valueSampledData.upperLimit
      expect(attrValue.data).toEqual valueSampledData.data

    it 'should support Observation.encounter', ->
      encounterAttr = @observationAttrs.find (attr) -> attr.path is 'encounter'
      expect(encounterAttr).toBeDefined
      expect(encounterAttr.path).toBe 'encounter'
      expect(encounterAttr.types.length).toBe 1
      expect(encounterAttr.types[0]).toBe 'Reference'
      expect(encounterAttr.referenceTypes.length).toBe 1
      expect(encounterAttr.referenceTypes[0]).toBe 'Encounter'

      observation = new cqm.models.Observation()
      expect(encounterAttr.getValue(observation)).toBeUndefined

      valueToSet = new cqm.models.Reference()
      valueToSet.reference = cqm.models.PrimitiveString.parsePrimitive('Encounter/XYZ-12345')
      encounterAttr.setValue(observation, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = encounterAttr.getValue(observation.clone())
      expect(value).toBeDefined
      expect(value.reference.value).toBe 'Encounter/XYZ-12345'


