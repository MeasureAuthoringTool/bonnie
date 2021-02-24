describe 'DataCriteriaHelpers', ->

  beforeEach ->
    @attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['DiagnosticReport']

  describe 'DiagnosticReport Attributes', ->
    it 'should support DiagnosticReport.status', ->
      DataCriteriaAsserts.assertCode('DiagnosticReport', 'status', 'status', (fhirResource) -> cqm.models.DiagnosticReportStatus.isDiagnosticReportStatus(fhirResource.status))

    it 'should support DiagnosticReport.effective', ->
      attr = @attrs.find (attr) -> attr.path is 'effective'
      expect(attr.path).toEqual 'effective'
      expect(attr.title).toEqual 'effective'
      expect(attr.types).toEqual ['DateTime', 'Period']

      # set DateTime
      valueDateTime = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00')
      fhirResource = new cqm.models.DiagnosticReport()
      attr.setValue(fhirResource, valueDateTime)
      expect(fhirResource.effective.value).toEqual '2012-02-02T08:45:00'

      # set Period
      # Create condition fhir resource and Period
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2020-09-02T13:54:57')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2020-10-02T13:54:57')
      # set Period
      attr.setValue(fhirResource, period)

      actualPeriod = attr.getValue(fhirResource)
      # Verify after setting values
      expect(actualPeriod.start.value).toEqual period.start.value
      expect(actualPeriod.end.value).toEqual period.end.value
