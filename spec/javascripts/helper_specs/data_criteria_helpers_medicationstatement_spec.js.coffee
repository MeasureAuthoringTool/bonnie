describe 'DataCriteriaHelpers', ->

  describe 'Medication Statement attributes', ->
    it 'should support MedicationStatement.status', ->
      DataCriteriaAsserts.assertCode('MedicationStatement', 'status', cqm.models.MedicationStatementStatus)
