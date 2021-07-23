describe 'DataCriteriaHelpers', ->

  describe 'Communication Attributes', ->
    it 'should support Communication.status', ->
      DataCriteriaAsserts.assertCode('Communication', 'status', 'status', (fhirResource) -> qm.models.CommunicationStatus.isCommunicationStatus(fhirResource.status))
