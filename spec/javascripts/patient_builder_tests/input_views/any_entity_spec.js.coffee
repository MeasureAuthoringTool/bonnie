describe 'AnyEntity', ->
  beforeAll ->
    low = cqm.models.CQL.DateTime.parse('1984-01-01T00:00:00.000+00:00')
    high = cqm.models.CQL.DateTime.parse('1984-01-02T00:00:00.000+00:00')
    relevantPeriod = new cqm.models.CQL.Interval(low, high, true, true)
    @encounterPerformed = new Thorax.Models.SourceDataCriteria({qdmDataElement: new cqm.models.EncounterPerformed(description: 'Assessment, Performed', relevantPeriod: relevantPeriod)})

  it 'is displayed for Encounter Performed', ->
    attributeEditor = new Thorax.Views.DataCriteriaAttributeEditorView model: @encounterPerformed
    attributeEditor.render()
    options = attributeEditor.$('select[name="attribute_name"]')[0].options
    optionsValues = Array.from(options).map (option) -> option.value
    optionsTexts = Array.from(options).map (option) -> option.text
    expect(optionsValues).toContain 'participant'
    expect(optionsTexts).toContain 'Participant'

#  describe 'in PatientBuilder', ->
#    beforeEach ->
#      cqmPatient = new cqm.models.Patient({qdmPatient: new cqm.models.QDMPatient()})
#      cqmPatient.qdmPatient.dataElements.push(@encounterPerformed.get('qdmDataElement'))
#      expectedValues = [ {
#        measure_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747",
#        population_index: 0, IPP: 0, DENOM: 0, DENEX: 0, NUMER: 0 } ]
#      cqmPatient.expectedValues = expectedValues
#      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS134v6/CMS134v6.json', 'cqm_measure_data/CMS134v6/value_sets.json'
#      @patient = new Thorax.Models.Patient {cqmPatient: cqmPatient, measure_ids: [@measure?.get('cqmMeasure').hqmf_set_id]}, parse: true
#      @patients = new Thorax.Collections.Patients [@patient], parse: true
#      @bonnie_measures_old = bonnie.measures
#      bonnie.measures = new Thorax.Collections.Measures()
#      bonnie.measures.add @measure
#      @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
#      @patientBuilder.render()
#      @patientBuilder.appendTo('body')
#      editCriteriaViewKeys = Object.keys(@patientBuilder.editCriteriaCollectionView.children)
#      encounterKey = editCriteriaViewKeys[0]
#      @editCriteriaView = @patientBuilder.editCriteriaCollectionView.children[encounterKey]
#      @editCriteriaView.$('select[name="attribute_name"]').val('participant').change()
#
#    afterEach ->
#      @patientBuilder.remove()
#
#    it 'participant list populates with entities', ->
#
#      options = @editCriteriaView.$('select[name="attribute_type"]')[0].options
#
#      expect(options.length).toEqual 5 # includes '--'
#
#      optionsValues = Array.from(options).map (option) -> option.value
#      optionsTexts = Array.from(options).map (option) -> option.text
#
#      expect(optionsValues).toEqual(['PatientEntity', 'CarePartner', 'Practitioner', 'Organization', 'Location'])
#      expect(optionsTexts).toEqual(['PatientEntity', 'CarePartner', 'Practitioner', 'Organization', 'Location'])
#
#    it 'participant enter Location', ->
#      @editCriteriaView.$('select[name="attribute_type"] > option:last').prop('selected', true).change()
#      dataElementText = @editCriteriaView.$('select[name="attribute_type"] > option:last').text()
#      expect(dataElementText).toBe('Location')
#      expect(@editCriteriaView.$('button[data-call-method="addValue"]')).toBeDisabled()
#
#      @editCriteriaView.$('input[placeholder="id"]').val('id#1').change()
#      expect(@editCriteriaView.$('input[placeholder="id"]').val()).toBe('id#1')
#
#      expect(@editCriteriaView.$('button[data-call-method="addValue"]')).not.toBeDisabled()
#      @editCriteriaView.$('button[data-call-method="addValue"]').click()
#      existingValues = @editCriteriaView.$('.existing-values').text().trim()
#      expect(existingValues.includes(dataElementText)).toBe true
#      expect(existingValues.includes('id#1')).toBe true
#
#      # add second
#      @editCriteriaView.$('select[name="attribute_name"]').val('participant').change()
#      @editCriteriaView.$('select[name="attribute_type"] > option:last').prop('selected', true).change()
#      expect(@editCriteriaView.$('button[data-call-method="addValue"]')).toBeDisabled()
#      @editCriteriaView.$('input[placeholder="id"]').val('id#2').change()
#
#      expect(@editCriteriaView.$('button[data-call-method="addValue"]')).not.toBeDisabled()
#      @editCriteriaView.$('button[data-call-method="addValue"]').click()
#
#      # check both added
#      existingValues = @editCriteriaView.$('.existing-values').text().trim()
#      expect(existingValues.includes(dataElementText)).toBe true
#      expect(existingValues.includes('id#1')).toBe true
#      expect(existingValues.includes('id#2')).toBe true
#