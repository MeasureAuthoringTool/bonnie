describe 'Allergy Intolerance', ->
  # Originally BONNIE-785

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @universalValueSetsByOid = bonnie.valueSetsByOid
    bonnie.valueSetsByOid = getJSONFixture("measure_data/special_measures/CMS12v0/value_sets.json")
    @measure = new Thorax.Models.Measure getJSONFixture("measure_data/special_measures/CMS12v0/CMS12v0.json"), parse: true
    bonnie.measures.add @measure
    @patients = new Thorax.Collections.Patients getJSONFixture("records/special_measures/CMS12v0/patients.json"), parse: true
    @patient = @patients.findWhere(first: "MedAllergyEndIP", last: "DENEXCEPPass")
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    sourceDataCriteria = @patientBuilder.model.get("source_data_criteria")
    @allergyIntolerance = sourceDataCriteria.findWhere({definition: "allergy_intolerance"})
    @patientBuilder.render()

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  it 'is displayed on Patient Builder Page in Elements section', ->
    expect(@patientBuilder.$el.find("div#criteriaElements").html()).toContainText "allergies intolerances"
