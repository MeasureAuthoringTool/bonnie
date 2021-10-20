describe 'DataCriteriaHelpers', ->

  describe 'Communication Attributes', ->
    it 'should support Communication.status', ->
      DataCriteriaAsserts.assertCode('Communication', 'status', cqm.models.CommunicationStatus)

    it 'should support Communication.statusReason', ->
      DataCriteriaAsserts.assertCodeableConcept('Communication',
        'statusReason', cqm.models.CodeableConcept)
