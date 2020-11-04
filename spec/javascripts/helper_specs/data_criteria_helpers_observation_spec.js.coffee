describe 'DataCriteriaHelpers', ->

  describe 'Observation attributes', ->
    beforeEach ->
      @observationAttrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Observation']


    it 'should support Observation.status', ->
      DataCriteriaAsserts.assertCode('Observation', 'status', 'status', (fhirResource) -> cqm.models.ObservationStatus.isObservationStatus(fhirResource.status))

    it 'should support Observation.category', ->
      DataCriteriaAsserts.assertCodeableConcept('Observation', 'category', 'category')

    it 'should support Observation.component.code', ->
      DataCriteriaAsserts.assertCodeableConcept('Observation', 'component.code', 'component.code')

    it 'should support Observation.value', ->
      value = @observationAttrs.find (attr) => attr.path is 'value'
      expect(value.path).toEqual 'value'
      expect(value.title).toEqual 'value'
      expect(value.types).toEqual ['Boolean', 'CodeableConcept', 'DateTime', 'Integer', 'Period',
        'Quantity', 'Range', 'Ratio', 'SampleData', 'String', 'Time']

      # set Boolean value
      valueBoolean = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      fhirResource = new cqm.models.Observation()
      value.setValue(fhirResource, valueBoolean)
      expect(fhirResource.value.value).toEqual valueBoolean.value
      attrValue = value.getValue(fhirResource)
      expect(attrValue.value).toEqual valueBoolean.value

      # set DateTime value
      valueDateTime = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
      value.setValue(fhirResource, valueDateTime)
      expect(fhirResource.value.value).toEqual valueDateTime.toString()

      # set CodeableConcept value
      coding = cqm.models.Coding.parse({system: 'SNOMEDCT', code:'123456', version: 'version'})
      value.setValue(fhirResource, coding)
      attrValue = value.getValue(fhirResource)
      expect(attrValue.system.value).toEqual coding.system.value
      expect(attrValue.code.value).toEqual coding.code.value
      expect(attrValue.version.value).toEqual coding.version.value

    it 'should support Observation.component.value', ->
      attribute = @observationAttrs.find (attr) => attr.path is 'component.value'
      expect(attribute.path).toEqual 'component.value'
      expect(attribute.title).toEqual 'component.value'
      expect(attribute.types).toEqual ['Quantity', 'CodeableConcept', 'String', 'Boolean', 'Integer',
        'Range', 'Ratio', 'SampledData','Time', 'DateTime', 'Period']

      #set Boolean value
      valueBoolean = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      fhirResource = new cqm.models.Observation()
      attribute.setValue(fhirResource, valueBoolean)
      attrValue = attribute.getValue(fhirResource)
      expect(attrValue.value).toEqual valueBoolean.value

      # set DateTime value
      valueDateTime = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
      attribute.setValue(fhirResource, valueDateTime)
      attrValue = attribute.getValue(fhirResource)
      expect(attrValue.value).toEqual valueDateTime.toString()

      # set CodeableConcept value
      coding = cqm.models.Coding.parse({system: 'SNOMEDCT', code:'123456', version: 'version'})
      attribute.setValue(fhirResource, coding)
      attrValue = attribute.getValue(fhirResource)
      expect(attrValue.system.value).toEqual coding.system.value
      expect(attrValue.code.value).toEqual coding.code.value
      expect(attrValue.version.value).toEqual coding.version.value

