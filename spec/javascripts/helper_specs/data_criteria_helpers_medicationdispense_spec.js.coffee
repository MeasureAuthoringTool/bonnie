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
      expect(attr.types).toEqual [ 'CodeableConcept', 'Reference' ]

      fhirResource = new cqm.models['MedicationDispense']()
      # CodeableConcept
      codeableConcept = DataTypeHelpers.createCodeableConcept('code1', 'system1')
      attr.setValue(fhirResource, codeableConcept)
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.coding[0].code.value).toBe 'code1'
      expect(value.coding[0].system.value).toBe 'system1'

      #   Reference
      ref = cqm.models.Reference.parse({"reference": "random-reference"})
      attr.setValue(fhirResource, ref)
      value = attr.getValue(fhirResource.clone())

      expect(value.reference.value).toEqual 'random-reference'

    it 'should support MedicationDispense.dosageInstruction', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) -> attr.path is 'dosageInstruction'
      expect(attr.path).toEqual 'dosageInstruction'
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

    it 'should support MedicationDispense.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) -> attr.path is 'status'
      expect(attr.path).toEqual 'status'
      expect(attr.types).toEqual [ 'Code' ]

      fhirResource = new cqm.models['MedicationDispense']()

      status = cqm.models.MedicationDispenseStatus.parsePrimitive('a status  # 1')

      attr.setValue(fhirResource, status)

      value = attr.getValue(fhirResource)
      expect(value).toBeDefined()
      expect(value.value).toBe 'a status  # 1'

    it 'should support MedicationDispense.statusReason', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) -> attr.path is 'statusReason'
      expect(attr.path).toEqual 'statusReason'
      expect(attr.types).toEqual [ 'CodeableConcept' ]

      fhirResource = new cqm.models['MedicationDispense']()
      # CodeableConcept
      codeableConcept = DataTypeHelpers.createCodeableConcept('code1', 'system1')
      attr.setValue(fhirResource, codeableConcept)
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.coding[0].code.value).toBe 'code1'
      expect(value.coding[0].system.value).toBe 'system1'

    it 'should support MedicationDispense.daysSupply', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) -> attr.path is 'daysSupply'
      expect(attr.path).toEqual 'daysSupply'
      expect(attr.types).toEqual [ 'SimpleQuantity' ]

      fhirResource = new cqm.models['MedicationDispense']()

      daysSupply = cqm.models.SimpleQuantity.parse({"value": 13, "unit": "kg"})
      attr.setValue(fhirResource, daysSupply)

      value = attr.getValue(fhirResource)
      expect(value).toBeDefined()
      expect(value.value.value).toBe 13
      expect(value.unit.value).toBe 'kg'

    it 'should support MedicationDispense.dosageInstruction.timing', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationDispense']
      attr = attrs.find (attr) -> attr.path is 'dosageInstruction.timing'
      expect(attr.path).toEqual 'dosageInstruction.timing'
      expect(attr.types).toEqual [ 'Timing' ]

      fhirResource = new cqm.models['MedicationDispense']()

      # set Timing
      timing = new cqm.models.Timing()
      timing.code = new cqm.models.CodeableConcept()
      timing.code.coding = [ new cqm.models.Coding() ]
      timing.code.coding[0].system = cqm.models.PrimitiveUri.parsePrimitive('a system')
      timing.code.coding[0].code = cqm.models.PrimitiveCode.parsePrimitive('a code')

      attr.setValue(fhirResource, timing)

      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined()
      expect(value.code.coding[0].system.value).toBe 'a system'
      expect(value.code.coding[0].code.value).toBe 'a code'