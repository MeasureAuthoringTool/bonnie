describe 'DataCriteriaHelpers', ->

  describe 'Medication Dispense attributes', ->

    it 'doesnt support MedicationDispense primary code path', ->
      dataElement = new cqm.models.DataElement()
      dataElement.fhir_resource = new cqm.models['MedicationDispense']()
      expect(DataCriteriaHelpers.isPrimaryCodePathSupported(dataElement)).toBe(false)

    it 'should support MedicationAdministration.medication', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) => attr.path is 'medication'
      expect(attr.path).toEqual 'medication'
      expect(attr.title).toEqual 'medication'
      expect(attr.types).toEqual [ 'CodeableConcept', 'Reference' ]

      fhirResource = new cqm.models['MedicationDispense']()
      #   CodeableConcept
      coding = new cqm.models.Coding()
      coding.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      coding.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')
      attr.setValue(fhirResource, coding)
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

      #   Reference
      ref = cqm.models.Reference.parse({"reference": "random-reference"})
      attr.setValue(fhirResource, ref)
      value = attr.getValue(fhirResource.clone())

      expect(value.reference.value).toEqual 'random-reference'