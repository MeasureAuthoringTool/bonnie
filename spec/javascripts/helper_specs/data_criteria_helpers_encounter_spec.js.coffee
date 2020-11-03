describe 'DataCriteriaHelpers', ->

  describe 'Encounter attributes', ->
    it 'should support Encounter.class', ->
      DataCriteriaAsserts.assertCoding('Encounter', 'class', 'class')

    it 'should support Encounter.diagnosis.condition', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'diagnosis.condition'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'diagnosis.condition'
      expect(attr.title).toBe 'diagnosis.condition'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Reference'
      expect(attr.referenceTypes.length).toBe 2
      expect(attr.referenceTypes[0]).toBe 'Condition'
      expect(attr.referenceTypes[1]).toBe 'Procedure'

      fhirResource = new cqm.models.Encounter()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Reference()
      valueToSet.reference = cqm.models.PrimitiveString.parsePrimitive('Condition/12345')
      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.reference.value).toBe 'Condition/12345'

    it 'should support Encounter.length', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Encounter']
      expect(attrs).toBeDefined
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
      DataCriteriaAsserts.assertCodeableConcept('Encounter', 'hospitalization.dischargeDisposition', 'hospitalization.dischargeDisposition')

    it 'should support Encounter.hospitalization.admitSource', ->
      DataCriteriaAsserts.assertCodeableConcept('Encounter', 'hospitalization.admitSource', 'hospitalization.admitSource')