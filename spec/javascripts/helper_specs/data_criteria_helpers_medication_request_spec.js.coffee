describe 'DataCriteriaHelpers', ->

  describe 'Medication Request attributes', ->
    it 'doesnt support MedicationRequest primary code path', ->
      dataElement = new cqm.models.DataElement()
      dataElement.fhir_resource = new cqm.models['MedicationRequest']()
      expect(DataCriteriaHelpers.isPrimaryCodePathSupported(dataElement)).toBe(false)

    it 'should support MedicationRequest.status', ->
      DataCriteriaAsserts.assertCode('MedicationRequest', 'status', cqm.models.MedicationRequestStatus)

    it 'should support MedicationRequest.intent', ->
      DataCriteriaAsserts.assertCode('MedicationRequest', 'intent', cqm.models.MedicationRequestIntent)

    it 'should support MedicationRequest.category', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationRequest', 'category')

    it 'should support MedicationRequest.reasonCode', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationRequest', 'reasonCode')

    it 'should support MedicationRequest.statusReason', ->
      DataCriteriaAsserts.assertCodeableConcept('MedicationRequest', 'statusReason')

    it 'should support MedicationRequest.dispenseRequest.validityPeriod', ->
      DataCriteriaAsserts.assertPeriod('MedicationRequest', 'dispenseRequest.validityPeriod')

    it 'should support MedicationRequest.dosageInstruction.doseAndRate.rate', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationRequest']
      attr = attrs.find (attr) => attr.path is 'dosageInstruction.doseAndRate.rate'
      expect(attr.path).toEqual 'dosageInstruction.doseAndRate.rate'
      expect(attr.types).toEqual [ 'Ratio', 'Range', 'SimpleQuantity' ]

      fhirResource = new cqm.models['MedicationRequest']()

      # Ratio
      ratio = cqm.models.Ratio.parse({"numerator": {"value": "1", "unit": "ms"}, "denominator": {"value": "2", "unit": "ms"}})
      attr.setValue(fhirResource, ratio)
      value = attr.getValue(fhirResource.clone())

      expect(value.numerator.value.value).toEqual '1'
      expect(value.numerator.unit.value).toEqual 'ms'

      expect(value.denominator.value.value).toEqual '2'
      expect(value.denominator.unit.value).toEqual 'ms'

      # Range
      range = cqm.models.Range.parse({"low": {"value": "3", "unit": "h"}, "high": {"value": "4", "unit": "h"}})
      attr.setValue(fhirResource, range)
      value = attr.getValue(fhirResource.clone())

      expect(value.low.value.value).toEqual '3'
      expect(value.low.unit.value).toEqual 'h'

      expect(value.high.value.value).toEqual '4'
      expect(value.high.unit.value).toEqual 'h'

      # SimpleQuantity
      simpleQuantity = cqm.models.SimpleQuantity.parse({"value": 13, "unit": "kg"})
      attr.setValue(fhirResource, simpleQuantity)
      value = attr.getValue(fhirResource.clone())

      expect(value.value.value).toEqual 13
      expect(value.unit.value).toEqual 'kg'

    it 'should support MedicationRequest.medication', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationRequest']
      attr = attrs.find (attr) -> attr.path is 'medication'
      expect(attr.path).toEqual 'medication'
      expect(attr.types).toEqual [ 'CodeableConcept', 'Reference' ]

      fhirResource = new cqm.models['MedicationRequest']()
      #   CodeableConcept
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

    it 'should support MedicationRequest.dosageInstruction.timing', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationRequest']
      attr = attrs.find (attr) -> attr.path is 'dosageInstruction.timing'
      expect(attr.path).toEqual 'dosageInstruction.timing'
      expect(attr.types).toEqual [ 'Timing' ]

      fhirResource = new cqm.models['MedicationRequest']()

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
