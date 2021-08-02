describe 'DataCriteriaHelpers', ->

  describe 'Communication Attributes', ->
    it 'should support Communication.status', ->
      DataCriteriaAsserts.assertCode('Communication', 'status', 'status', (fhirResource) -> cqm.models.CommunicationStatus.isCommunicationStatus(fhirResource.status))
