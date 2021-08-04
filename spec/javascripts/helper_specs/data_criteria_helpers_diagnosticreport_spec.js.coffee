describe 'DataCriteriaHelpers', ->

  beforeEach ->
    @attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['DiagnosticReport']

  describe 'DiagnosticReport Attributes', ->
    it 'should support DiagnosticReport.status', ->
      DataCriteriaAsserts.assertCode('DiagnosticReport', 'status', (fhirResource) -> cqm.models.DiagnosticReportStatus.isDiagnosticReportStatus(fhirResource.status))

    it 'should support DiagnosticReport.effective', ->
      attr = @attrs.find (attr) -> attr.path is 'effective'
      expect(attr.path).toEqual 'effective'
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

    it 'should support DiagnosticReport.category', ->
      DataCriteriaAsserts.assertCodeableConcept('DiagnosticReport', 'category')

    it 'should support DiagnosticReport.encounter', ->
      encounterAttr = @attrs.find (attr) -> attr.path is 'encounter'
      expect(encounterAttr).toBeDefined
      expect(encounterAttr.path).toBe 'encounter'
      expect(encounterAttr.types.length).toBe 1
      expect(encounterAttr.types[0]).toBe 'Reference'
      expect(encounterAttr.referenceTypes.length).toBe 1
      expect(encounterAttr.referenceTypes[0]).toBe 'Encounter'

      diagnosticReport = new cqm.models.DiagnosticReport()
      expect(encounterAttr.getValue(diagnosticReport)).toBeUndefined

      valueToSet = new cqm.models.Reference()
      valueToSet.reference = cqm.models.PrimitiveString.parsePrimitive('Encounter/XYZ-12345')
      encounterAttr.setValue(diagnosticReport, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = encounterAttr.getValue(diagnosticReport.clone())
      expect(value).toBeDefined
      expect(value.reference.value).toBe 'Encounter/XYZ-12345'