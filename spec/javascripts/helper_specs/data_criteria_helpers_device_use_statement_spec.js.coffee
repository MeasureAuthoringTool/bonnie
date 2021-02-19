describe 'DataCriteriaHelpers', ->

  beforeEach ->
    @attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['DeviceUseStatement']

  describe 'DeviceUseStatement Attributes', ->
    it 'should support DeviceUseStatement.timing', ->
      attr = @attrs.find (attr) -> attr.path is 'timing'
      expect(attr.path).toEqual 'timing'
      expect(attr.title).toEqual 'timing'
      expect(attr.types).toEqual ['DateTime', 'Period', 'Timing']

      # set DateTime
      valueDateTime = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
      fhirResource = new cqm.models.DeviceUseStatement()
      attr.setValue(fhirResource, valueDateTime)
      expect(fhirResource.timing.value).toEqual valueDateTime.toString()

      # set Period
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      attr.setValue(fhirResource, period)

      actualPeriod = attr.getValue(fhirResource)
      # Verify after setting values
      expect(actualPeriod.start.value).toEqual period.start.value
      expect(actualPeriod.end.value).toEqual period.end.value

      # set Timing
      timing = new cqm.models.Timing()
      timing.code = new cqm.models.CodeableConcept()
      timing.code.coding = [ new cqm.models.Coding() ]
      timing.code.coding[0].system = cqm.models.PrimitiveUri.parsePrimitive('a system')
      timing.code.coding[0].code = cqm.models.PrimitiveCode.parsePrimitive('a code')

      attr.setValue(fhirResource, timing)

      timingPeriod = attr.getValue(fhirResource)
      # Verify after setting values
      expect(timingPeriod.code.coding[0].system.value).toEqual 'a system'
      expect(timingPeriod.code.coding[0].code.value).toEqual 'a code'
