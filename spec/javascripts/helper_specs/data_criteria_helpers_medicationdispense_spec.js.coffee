describe 'DataCriteriaHelpers', ->

  describe 'Medication Dispense attributes', ->

    it 'doesnt support MedicationDispense primary code path', ->
      dataElement = new cqm.models.DataElement()
      dataElement.fhir_resource = new cqm.models['MedicationDispense']()
      expect(DataCriteriaHelpers.isPrimaryCodePathSupported(dataElement)).toBe(false)

    it 'should support MedicationDispense.medication', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) -> attr.path is 'medication'
      expect(attr.path).toEqual 'medication'
      expect(attr.title).toEqual 'medication'
      expect(attr.types).toEqual [ 'CodeableConcept', 'Reference' ]

      fhirResource = new cqm.models['MedicationDispense']()
      # CodeableConcept
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

    it 'should support MedicationDispense.dosageInstruction', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) -> attr.path is 'dosageInstruction'
      expect(attr.path).toEqual 'dosageInstruction'
      expect(attr.title).toEqual 'dosageInstruction'
      expect(attr.types).toEqual [ 'Dosage' ]

      fhirResource = new cqm.models['MedicationDispense']()
      # CodeableConcept
      dosage = new cqm.models.Dosage()
      dosage.sequence = cqm.models.PrimitiveInteger.parsePrimitive(1)
      dosage.text = cqm.models.PrimitiveString.parsePrimitive('some text')

      coding = new cqm.models.Coding()
      coding.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      coding.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')
      codeableConcept = new cqm.models.CodeableConcept()
      codeableConcept.coding = coding
      dosage.additionalInstruction = [ codeableConcept ]

      attr.setValue(fhirResource, dosage)
      value = attr.getValue(fhirResource)
      expect(value).toBeDefined()
      expect(value.sequence.value).toBe 1
      expect(value.text.value).toBe 'some text'
      expect(value.additionalInstruction[0].coding.code.value).toBe 'code1'
      expect(value.additionalInstruction[0].coding.system.value).toBe 'system1'
      # null value test
      attr.setValue(fhirResource, null)
      value = attr.getValue(fhirResource)
      expect(value).toBeUndefined()
