describe 'DataCriteriaHelpers', ->

  describe 'DiagnosticReport Attributes', ->
    it 'should support DiagnosticReport.status', ->
      DataCriteriaAsserts.assertCode('DiagnosticReport', 'status', 'status', (fhirResource) -> cqm.models.MedicationRequestStatus.isMedicationRequestStatus(fhirResource.status))
