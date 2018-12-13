describe 'Direct Reference Code Usage', ->
  # Originally BONNIE-939

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @oldBonnieValueSetsByOid = bonnie.valueSetsByOid
    bonnie.valueSetsByOid = getJSONFixture('measure_data/core_measures/CMS32/value_sets.json')
    @measure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS32/CMS32v7.json'), parse: true
    bonnie.measures.add(@measure, { parse: true })
    @patients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS32/patients.json'), parse: true

  afterEach ->
    bonnie.valueSetsByOid = @oldBonnieValueSetsByOid

  it 'Field Value Dropdown should contain direct reference code element', ->
    patientBuilder = new Thorax.Views.PatientBuilder(model: @patients.first(), measure: @measure)
    dataCriteria = patientBuilder.model.get('source_data_criteria').models
    edVisitIndex = dataCriteria.findIndex((m) ->
      m.attributes.description is 'Encounter, Performed: Emergency Department Visit')
    emergencyDepartmentVisit = dataCriteria[edVisitIndex]
    editCriteriaView = new Thorax.Views.EditCriteriaView(model: emergencyDepartmentVisit, measure: @measure)
    editFieldValueView = editCriteriaView.editFieldValueView
    expect(editFieldValueView.render()).toContain('drc-')

  it 'Adding direct reference code element should calculate correctly', ->
    @measure.set('patients', [patientThatCalculatesDrc])
    population = @measure.get('populations').first()
    patientThatCalculatesDrc = @patients.findWhere(first: "Visits 2 Excl")
    results = population.calculate(patientThatCalculatesDrc)
    library = "MedianTimefromEDArrivaltoEDDepartureforDischargedEDPatients"
    statementResults = results.get("statement_results")
    titleOfClauseThatUsesDrc = statementResults[library]['Measure Population Exclusions'].raw[0]._dischargeDisposition.title
    expect(titleOfClauseThatUsesDrc).toBe "Patient deceased during stay (discharge status = dead) (finding)"



