describe 'DataCriteriaHelpers', ->

  describe 'ServiceRequest attributes', ->
    it 'should support ServiceRequest.status', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['ServiceRequest']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'status'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'status'
      expect(attr.title).toBe 'status'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'
      expect(attr.valueSets()[0].id).toBe 'request-status'

      fhirResource = new cqm.models.ServiceRequest()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)
      expect(cqm.models.ServiceRequestStatus.isServiceRequestStatus(fhirResource.status)).toBe true

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'

    it 'should support ServiceRequest.intent', ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES['ServiceRequest']
      expect(attrs).toBeDefined
      attr = attrs.find (attr) => attr.path is 'intent'
      expect(attr).toBeDefined
      expect(attr.path).toBe 'intent'
      expect(attr.title).toBe 'intent'
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe 'Code'
      expect(attr.valueSets()[0].id).toBe 'request-intent'

      fhirResource = new cqm.models.ServiceRequest()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = 'a code'
      attr.setValue(fhirResource, valueToSet)
      expect(cqm.models.ServiceRequestIntent.isServiceRequestIntent(fhirResource.intent)).toBe true

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value).toBe 'a code'
