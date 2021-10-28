describe 'DataCriteriaHelpers', ->

  describe 'Immunization Attributes', ->
    it 'should support Immunization.status', ->
      DataCriteriaAsserts.assertCode('Immunization', 'status', cqm.models.ImmunizationStatus)

    it 'should support Immunization.occurrence as datatime', ->
      DataCriteriaAsserts.assertDateTime('Immunization', 'occurrence')

    it 'should choice types of Immunization.occurrence', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Immunization']
      attr = attrs.find (attr) -> attr.path is 'occurrence'
      expect(attr.path).toEqual 'occurrence'
      expect(attr.types.length).toBe 1
      expect(attr.types).toEqual ['DateTime']

    it 'should support Immunization.statusReason', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['Immunization']
      attr = attrs.find (attr) -> attr.path is 'statusReason'
      expect(attr.path).toEqual 'statusReason'
      expect(attr.types).toEqual [ 'CodeableConcept' ]

      DataCriteriaAsserts.assertCodeableConcept('Immunization', 'statusReason')
