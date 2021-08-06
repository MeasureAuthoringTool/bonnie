describe 'DataCriteriaHelpers', ->

  describe 'Communication Attributes', ->
    it 'should support Communication.status', ->
      DataCriteriaAsserts.assertCode('Communication', 'status', cqm.models.CommunicationStatus)
