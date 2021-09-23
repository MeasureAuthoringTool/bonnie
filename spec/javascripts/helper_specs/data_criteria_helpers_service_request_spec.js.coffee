describe 'DataCriteriaHelpers', ->

  describe 'ServiceRequest attributes', ->
    it 'should support ServiceRequest.status', ->
      DataCriteriaAsserts.assertCode('ServiceRequest', 'status', cqm.models.ServiceRequestStatus)

    it 'should support ServiceRequest.intent', ->
      DataCriteriaAsserts.assertCode('ServiceRequest', 'intent', cqm.models.ServiceRequestIntent)

    it 'should support ServiceRequest.doNotPerform', ->
      DataCriteriaAsserts.assertBoolean('ServiceRequest', 'doNotPerform')
