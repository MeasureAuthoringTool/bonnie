describe 'RelatedToView', ->
  beforeAll ->
    low = cqm.models.CQL.DateTime.parse('1984-01-01T00:00:00.000+00:00')
    high = cqm.models.CQL.DateTime.parse('1984-01-02T00:00:00.000+00:00')
    relevantPeriod = new cqm.models.CQL.Interval(low, high, true, true)
    @careGoal = new Thorax.Models.SourceDataCriteria({qdmDataElement: new cqm.models.CareGoal(relevantPeriod: relevantPeriod)})
    @communicationPerformed = new Thorax.Models.SourceDataCriteria({qdmDataElement: new cqm.models.CommunicationPerformed(authorDateTime: high)})
    @assessmentPerformed = new Thorax.Models.SourceDataCriteria({qdmDataElement: new cqm.models.AssessmentPerformed(description: 'Assessment, Performed', relevantPeriod: relevantPeriod)})

  it 'is displayed for Care Goal', ->
    attributeEditor = new Thorax.Views.DataCriteriaAttributeEditorView model: @careGoal
    attributeEditor.render()
    checkOptionsIncludeRelatedTo(attributeEditor)

  it 'is displayed for Communication, Performed', ->
    attributeEditor = new Thorax.Views.DataCriteriaAttributeEditorView model: @communicationPerformed
    attributeEditor.render()
    checkOptionsIncludeRelatedTo(attributeEditor)

  it 'is displayed for Assessment, Performed', ->
    attributeEditor = new Thorax.Views.DataCriteriaAttributeEditorView model: @assessmentPerformed
    attributeEditor.render()
    checkOptionsIncludeRelatedTo(attributeEditor)

  describe 'in PatientBuilder', ->
    beforeEach ->
      cqmPatient = new cqm.models.Patient({qdmPatient: new cqm.models.QDMPatient()})
      cqmPatient.qdmPatient.dataElements.push(@careGoal.get('qdmDataElement'))
      cqmPatient.qdmPatient.dataElements.push(@communicationPerformed.get('qdmDataElement'))
      cqmPatient.qdmPatient.dataElements.push(@assessmentPerformed.get('qdmDataElement'))
      expectedValues = [ {
        measure_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747",
        population_index: 0, IPP: 0, DENOM: 0, DENEX: 0, NUMER: 0 } ]
      cqmPatient.expectedValues = expectedValues
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS134v6/CMS134v6.json', 'cqm_measure_data/CMS134v6/value_sets.json'
      @patient = new Thorax.Models.Patient {cqmPatient: cqmPatient, measure_ids: [@measure?.get('cqmMeasure').hqmf_set_id]}, parse: true
      @patients = new Thorax.Collections.Patients [@patient], parse: true
      @bonnie_measures_old = bonnie.measures
      bonnie.measures = new Thorax.Collections.Measures()
      bonnie.measures.add @measure
      @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
      @patientBuilder.render()
      @patientBuilder.appendTo('body')
      editCriteriaViewKeys = Object.keys(@patientBuilder.editCriteriaCollectionView.children)
      careGoalKey = editCriteriaViewKeys[0]
      communicationPerformedKey = editCriteriaViewKeys[1]
      assessmentPerformedKey = editCriteriaViewKeys[2]
      careGoalKey = editCriteriaViewKeys[0]
      @careGoalEditCriteriaView = @patientBuilder.editCriteriaCollectionView.children[careGoalKey]
      @careGoalEditCriteriaView.$('select[name="attribute_name"]').val('relatedTo').change()

    afterEach ->
      @patientBuilder.remove()

    it 'RelatedTo list populates with other data elements', ->
      expect(@careGoalEditCriteriaView.$('select[name="related_to"]')[0].options.length).toEqual 3 # includes '--'
      expect(@careGoalEditCriteriaView.$('select[name="related_to"]')).not.toContainText 'CareGoal'

    it 'Adding relatedTo adds id to patient and displays data element with timing attribute', ->
      @careGoalEditCriteriaView.$('select[name="related_to"] > option:last').prop('selected', true).change()
      dataElementText = @careGoalEditCriteriaView.$('select[name="related_to"] > option:last').text()
      dataElementTiming = '01/01/1984 12:00 AM - 01/02/1984 12:00 AM'
      @careGoalEditCriteriaView.$('button[data-call-method="addValue"]').click()
      existingValues = @careGoalEditCriteriaView.$('.existing-values').text().trim()
      expect(existingValues.includes(dataElementText)).toBe true
      expect(existingValues.includes(dataElementTiming)).toBe true


checkOptionsIncludeRelatedTo = (attributeEditor) ->
  options = attributeEditor.$('select[name="attribute_name"]')[0].options
  optionsValues = Array.from(options).map (option) -> option.value
  optionsTexts = Array.from(options).map (option) -> option.text
  expect(optionsValues).toContain 'relatedTo'
  expect(optionsTexts).toContain 'Related To'