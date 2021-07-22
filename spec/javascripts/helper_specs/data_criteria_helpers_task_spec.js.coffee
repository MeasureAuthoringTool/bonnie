describe 'DataCriteriaHelpers', ->

  describe 'Task', ->

    it 'supports Task primary code path', ->
      dataElement = new cqm.models.DataElement()
      dataElement.fhir_resource = new cqm.models['Task']()
      expect(DataCriteriaHelpers.isPrimaryCodePathSupported(dataElement)).toBe(true)

    it 'should support Task.basedOn', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Task']
      attr = attrs.find (attr) -> attr.path is 'basedOn'
      expect(attr.path).toEqual 'basedOn'
      expect(attr.title).toEqual 'basedOn'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Reference'
      expect(attr.referenceTypes.length).toBe Object.keys(DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES).length
      expect(attr.referenceTypes).toEqual Object.keys(DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES)

      fhirResource = new cqm.models['Task']()
      #   Reference
      ref = cqm.models.Reference.parse({"reference": "random-reference"})
      attr.setValue(fhirResource, ref)
      value = attr.getValue(fhirResource.clone())

      expect(value.reference.value).toEqual 'random-reference'
