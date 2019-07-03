describe 'InputView', ->

  describe 'CompositeView', ->

    beforeEach ->
      @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS134v6/Elements_Test.json')], parse: true
      @patient = @patients.at(0)
      sourceDataCriteria = @patient.get('source_data_criteria')
      dataElements = sourceDataCriteria.map (sdc) -> sdc.get('qdmDataElement')
      @laboratoryTest = dataElements.filter((element) -> element.qdmCategory is 'laboratory_test')[0]

    it 'starts with no valid value', ->
      view = new Thorax.Views.InputCompositeView(schema: @laboratoryTest.schema, attributeName: 'attributeNameTest')
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
