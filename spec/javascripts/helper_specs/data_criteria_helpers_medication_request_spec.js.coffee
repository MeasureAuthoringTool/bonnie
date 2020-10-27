describe 'DataCriteriaHelpers', ->

  beforeEach ->
    @assertCodingWithType = (resourceType, path, title, type) ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES[resourceType]
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is path
      expect(attr.path).toBe path
      expect(attr.title).toBe title
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe type

      fhirResource = new cqm.models[resourceType]()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

    @assertCodeableConcept = (resourceType, path, title) ->
      @assertCodingWithType(resourceType, path, title, 'CodeableConcept')

    @assertCoding = (resourceType, path, title) ->
      @assertCodingWithType(resourceType, path, title, 'Coding')

    @assertCode = (resourceType, path, title, customAssert) ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES[resourceType]
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is path
      expect(attr).toBeDefined
      expect(attr.path).toBe path
      expect(attr.title).toBe title
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'

      fhirResource = new cqm.models[resourceType]()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)

      if customAssert?
        expect(customAssert(fhirResource)).toBe true

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'

    @assertPeriod = (resourceType, path, title) ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES[resourceType]
      attr = attrs.find (attr) => attr.path is path
      expect(attr.path).toEqual path
      expect(attr.title).toEqual title
      # Create fhir resource and Period
      fhirResource = new cqm.models[resourceType]()
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      # set Period
      attr.setValue(fhirResource, period)

      value = attr.getValue(fhirResource.clone())
      # Verify after setting values
      expect(value.start.value).toEqual period.start.value
      expect(value.end.value).toEqual period.end.value


  describe 'Medication Request attributes', ->
    it 'should support MedicationRequest.status', ->
      @assertCode('MedicationRequest', 'status', 'status', (fhirResource) -> cqm.models.MedicationRequestStatus.isMedicationRequestStatus(fhirResource.status))

    it 'should support MedicationRequest.intent', ->
      @assertCode('MedicationRequest', 'intent', 'intent', (fhirResource) -> cqm.models.MedicationRequestIntent.isMedicationRequestIntent(fhirResource.intent))

    it 'should support MedicationRequest.category', ->
      @assertCodeableConcept('MedicationRequest', 'category', 'category')

    it 'should support MedicationRequest.reasonCode', ->
      @assertCodeableConcept('MedicationRequest', 'reasonCode', 'reasonCode')

    it 'should support MedicationRequest.statusReason', ->
      @assertCodeableConcept('MedicationRequest', 'statusReason', 'statusReason')

    it 'should support MedicationRequest.dosageInstruction.timing.code', ->
      @assertCodeableConcept('MedicationRequest', 'dosageInstruction.timing.code', 'dosageInstruction.timing.code')

    it 'should support MedicationRequest.dispenseRequest.validityPeriod', ->
      @assertPeriod('MedicationRequest', 'dispenseRequest.validityPeriod', 'dispenseRequest.validityPeriod')

    it 'should support MedicationRequest.dosageInstruction.doseAndRate.rate', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationRequest']
      attr = attrs.find (attr) => attr.path is 'dosageInstruction.doseAndRate.rate'
      expect(attr.path).toEqual 'dosageInstruction.doseAndRate.rate'
      expect(attr.title).toEqual 'dosageInstruction.doseAndRate.rate'
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

    it 'should support MedicationRequest.dosageInstructions.timing.repeat.bounds', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['MedicationRequest']
      attr = attrs.find (attr) => attr.path is 'dosageInstructions.timing.repeat.bounds'
      expect(attr.path).toEqual 'dosageInstructions.timing.repeat.bounds'
      expect(attr.title).toEqual 'dosageInstructions.timing.repeat.bounds'
      expect(attr.types).toEqual [ 'Duration', 'Range', 'Period' ]

      fhirResource = new cqm.models['MedicationRequest']()

      # Duration
      duration = cqm.models.Duration.parse({"unit": "ml", "value": "100"})
      attr.setValue(fhirResource, duration)
      value = attr.getValue(fhirResource.clone())

      expect(value.value.value).toEqual '100'
      expect(value.unit.value).toEqual 'ml'

      # Range
      range = cqm.models.Range.parse({"low": {"value": "3", "unit": "h"}, "high": {"value": "4", "unit": "h"}})
      attr.setValue(fhirResource, range)
      value = attr.getValue(fhirResource.clone())

      expect(value.low.value.value).toEqual '3'
      expect(value.low.unit.value).toEqual 'h'

      expect(value.high.value.value).toEqual '4'
      expect(value.high.unit.value).toEqual 'h'

      # Period
      @assertPeriod('MedicationRequest', 'dosageInstructions.timing.repeat.bounds', 'dosageInstructions.timing.repeat.bounds')
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')

      attr.setValue(fhirResource, period)
      value = attr.getValue(fhirResource.clone())

      expect(value.start.value).toEqual '2020-09-02T13:54:57'
      expect(value.end.value).toEqual '2020-10-02T13:54:57'
