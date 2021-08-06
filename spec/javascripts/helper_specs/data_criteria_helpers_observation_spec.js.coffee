describe 'DataCriteriaHelpers', ->

  describe 'Observation attributes', ->
    beforeEach ->
      @observationAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Observation']

    it 'should support Observation.status', ->
      DataCriteriaAsserts.assertCode('Observation', 'status', cqm.models.ObservationStatus)

    it 'should support Observation.category', ->
      DataCriteriaAsserts.assertCodeableConcept('Observation', 'category')

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
      DataCriteriaAsserts.assertBoolean('Observation', 'value')

      # set DateTime value
      DataCriteriaAsserts.assertDateTime('Observation', 'value')

      # set CodeableConcept value
      DataCriteriaAsserts.assertCodeableConcept('Observation', 'value')

    it 'should support Observation.component', ->
      fhirResource = new cqm.models.Observation()
      attrDef = @observationAttrs.find (attr) -> attr.path is 'component'
      expect(attrDef.path).toEqual 'component'
      expect(attrDef.isArray).toEqual true
      expect(attrDef.types.length).toBe 1
      expect(attrDef.types[0]).toBe 'ObservationComponent'

      # String
      componentToSet = new cqm.models.ObservationComponent()
      componentToSet.value = cqm.models.PrimitiveString.parsePrimitive('CA978112CA1BBDCAFAC231B39A23DC4DA786EFF8147C4E72B9807785AFEE48BB')
      attrDef.setValue(fhirResource, [componentToSet])
      attrValue = attrDef.getValue(fhirResource.clone())
      expect(attrValue[0].value.value).toEqual 'CA978112CA1BBDCAFAC231B39A23DC4DA786EFF8147C4E72B9807785AFEE48BB'

      #set Boolean value
      componentToSet = new cqm.models.ObservationComponent()
      componentToSet.value = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      attrDef.setValue(fhirResource, [componentToSet])
      attrValue = attrDef.getValue(fhirResource.clone())
      expect(attrValue[0].value.value).toEqual true

      # set DateTime value
      componentToSet = new cqm.models.ObservationComponent()
      componentToSet.value = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
      attrDef.setValue(fhirResource, [componentToSet])
      attrValue = attrDef.getValue(fhirResource)
      expect(attrValue[0].value.value).toEqual '2012-02-02T08:45:00.000+00:00'

      # set CodeableConcept value
      componentToSet = new cqm.models.ObservationComponent()
      componentToSet.value = DataTypeHelpers.createCodeableConcept('123456', 'SNOMEDCT')
      attrDef.setValue(fhirResource, [componentToSet])
      attrValue = attrDef.getValue(fhirResource.clone())
      expect(attrValue[0].value.coding[0].system.value).toEqual 'SNOMEDCT'
      expect(attrValue[0].value.coding[0].code.value).toEqual '123456'

      # set SampledData value
      componentToSet = new cqm.models.ObservationComponent()
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

      componentToSet.value = valueSampledData
      attrDef.setValue(fhirResource, [componentToSet])
      attrValue = attrDef.getValue(fhirResource.clone())
      expect(attrValue[0].value.origin).toEqual valueSampledData.origin
      expect(attrValue[0].value.period).toEqual valueSampledData.period
      expect(attrValue[0].value.dimensions).toEqual valueSampledData.dimensions
      expect(attrValue[0].value.lowerLimit).toEqual valueSampledData.lowerLimit
      expect(attrValue[0].value.upperLimit).toEqual valueSampledData.upperLimit
      expect(attrValue[0].value.data).toEqual valueSampledData.data

      # Observation.component.code
      componentToSet = new cqm.models.ObservationComponent()
      componentToSet.code = DataTypeHelpers.createCodeableConcept('123456', 'SNOMEDCT')
      attrDef.setValue(fhirResource, [componentToSet])
      attrValue = attrDef.getValue(fhirResource.clone())
      expect(attrValue[0].code.coding[0].system.value).toEqual 'SNOMEDCT'
      expect(attrValue[0].code.coding[0].code.value).toEqual '123456'

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


