describe 'DataCriteriaHelpers', ->

  describe 'AllergyIntolerance attributes', ->
    it 'should support AllergyIntolerance.clinicalStatus', ->
      DataCriteriaAsserts.assertCodeableConcept('AllergyIntolerance', 'clinicalStatus', 'clinicalStatus')

    it 'should support AllergyIntolerance.verificationStatus', ->
      DataCriteriaAsserts.assertCodeableConcept('AllergyIntolerance', 'verificationStatus', 'verificationStatus')

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

      dateTime = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-05T08:00:00.000+00:00')
      fhirResource = new cqm.models.AllergyIntolerance()
      # set DateTime
      attr.setValue(fhirResource, dateTime)

      value = attr.getValue(fhirResource)
      # Verify after setting values
      expect(value.value).toEqual '2020-10-05T08:00:00.000+00:00'

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

