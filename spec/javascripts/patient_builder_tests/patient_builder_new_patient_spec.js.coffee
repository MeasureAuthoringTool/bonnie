describe 'Patient Builder New Patient', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS134v6/CMS134v6.json', 'cqm_measure_data/CMS134v6/value_sets.json'
    @patient = new Thorax.Models.Patient {measure_ids: [@measure?.get('cqmMeasure').hqmf_set_id]}, parse: true
    @patients = new Thorax.Collections.Patients [@patient], parse: true
    @bonnie_measures_old = bonnie.measures
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add @measure
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    @patientBuilder.render()

  afterAll ->
    bonnie.measures = @bonnie_measures_old

  it 'should select default ethnicity option', ->
    expect(@patientBuilder.$('#ethnicity').val()).toEqual ''
    expect(@patientBuilder.$('#ethnicity option:selected').text()).toEqual 'Choose an Ethnicity'

  it 'should select default gender option', ->
    expect(@patientBuilder.$('#gender').val()).toEqual ''
    expect(@patientBuilder.$('#gender option:selected').text()).toEqual 'Choose a Gender'

  it 'should select default race option', ->
    expect(@patientBuilder.$('#race').val()).toEqual ''
    expect(@patientBuilder.$('#race option:selected').text()).toEqual 'Choose a Race'
