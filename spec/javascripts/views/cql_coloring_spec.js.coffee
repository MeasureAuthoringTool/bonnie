describe 'CQL Coverage', ->
  beforeEach ->
    bonnie.measures = new Thorax.Collections.Measures()
    jasmine.getJSONFixtures().clearCache()
    @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS10/CMS10v0.json', 'cqm_measure_data/special_measures/CMS10/value_sets.json'
    bonnie.measures.add @cqlMeasure
    @patient1 = new Thorax.Models.Patient getJSONFixture('cqm_patients/special_measures/CMS10/patients.json')[0], parse: true
    @patient2 = new Thorax.Models.Patient getJSONFixture('cqm_patients/special_measures/CMS10/patients.json')[1], parse: true

  xit 'is correct with first patient', ->
    @cqlMeasure.get('patients').add @patient1
    @population = @cqlMeasure.get('populations').first()
    @cqlMeasurePopulationLogic = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population)
    @cqlMeasurePopulationLogic.showCoverage()
    @cqlMeasurePopulationLogic.render()

    initialPopulation = $(@cqlMeasurePopulationLogic.$(".cql-statement")[0])
    expect(initialPopulation.find(".clause-covered").length).toBe(5)
    expect(initialPopulation.find(".clause-uncovered").length).toBe(0)
    denominator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[1])
    expect(denominator.find(".clause-covered").length).toBe(2)
    expect(denominator.find(".clause-uncovered").length).toBe(0)
    numerator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[2])
    expect(numerator.find(".clause-covered").length).toBe(0)
    expect(numerator.find(".clause-uncovered").length).toBe(2)
    denomException = $(@cqlMeasurePopulationLogic.$(".cql-statement")[3])
    expect(denomException.find(".clause-covered").length).toBe(0)
    expect(denomException.find(".clause-uncovered").length).toBe(2)
    inDemographic = $(@cqlMeasurePopulationLogic.$(".cql-statement")[4])
    expect(inDemographic.find(".clause-covered").length).toBe(5)
    expect(inDemographic.find(".clause-uncovered").length).toBe(0)
    encounter = $(@cqlMeasurePopulationLogic.$(".cql-statement")[5])
    expect(encounter.find(".clause-covered").length).toBe(2)
    expect(encounter.find(".clause-uncovered").length).toBe(0)
    encountersDuringMP = $(@cqlMeasurePopulationLogic.$(".cql-statement")[6])
    expect(encountersDuringMP.find(".clause-covered").length).toBe(10)
    expect(encountersDuringMP.find(".clause-uncovered").length).toBe(0)
    medicationsDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[7])
    expect(medicationsDocumented.find(".clause-covered").length).toBe(0)
    expect(medicationsDocumented.find(".clause-uncovered").length).toBe(15)
    MedsNotDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[8])
    expect(MedsNotDocumented.find(".clause-covered").length).toBe(0)
    expect(MedsNotDocumented.find(".clause-uncovered").length).toBe(11)

  xit 'is correct with both patients', ->
    @cqlMeasure.get('patients').add @patient1
    @cqlMeasure.get('patients').add @patient2
    @population = @cqlMeasure.get('populations').first()
    @cqlMeasurePopulationLogic = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population)
    @cqlMeasurePopulationLogic.showCoverage()
    @cqlMeasurePopulationLogic.render()

    initialPopulation = $(@cqlMeasurePopulationLogic.$(".cql-statement")[0])
    expect(initialPopulation.find(".clause-covered").length).toBe(5)
    expect(initialPopulation.find(".clause-uncovered").length).toBe(0)
    denominator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[1])
    expect(denominator.find(".clause-covered").length).toBe(2)
    expect(denominator.find(".clause-uncovered").length).toBe(0)
    numerator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[2])
    expect(numerator.find(".clause-covered").length).toBe(0)
    expect(numerator.find(".clause-uncovered").length).toBe(2)
    denomException = $(@cqlMeasurePopulationLogic.$(".cql-statement")[3])
    expect(denomException.find(".clause-covered").length).toBe(2)
    expect(denomException.find(".clause-uncovered").length).toBe(0)
    inDemographic = $(@cqlMeasurePopulationLogic.$(".cql-statement")[4])
    expect(inDemographic.find(".clause-covered").length).toBe(5)
    expect(inDemographic.find(".clause-uncovered").length).toBe(0)
    encounter = $(@cqlMeasurePopulationLogic.$(".cql-statement")[5])
    expect(encounter.find(".clause-covered").length).toBe(2)
    expect(encounter.find(".clause-uncovered").length).toBe(0)
    encountersDuringMP = $(@cqlMeasurePopulationLogic.$(".cql-statement")[6])
    expect(encountersDuringMP.find(".clause-covered").length).toBe(10)
    expect(encountersDuringMP.find(".clause-uncovered").length).toBe(0)
    medicationsDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[7])
    expect(medicationsDocumented.find(".clause-covered").length).toBe(0)
    expect(medicationsDocumented.find(".clause-uncovered").length).toBe(15)
    MedsNotDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[8])
    expect(MedsNotDocumented.find(".clause-covered").length).toBe(11)
    expect(MedsNotDocumented.find(".clause-uncovered").length).toBe(0)

describe 'CQL Coloring', ->
  beforeEach ->
    bonnie.measures = new Thorax.Collections.Measures()
    jasmine.getJSONFixtures().clearCache()
    @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS10/CMS10v0.json', 'cqm_measure_data/special_measures/CMS10/value_sets.json'
    bonnie.measures.add @cqlMeasure

  xit 'is correct for first patient', ->
    @patient1 = new Thorax.Models.Patient getJSONFixture('cqm_patients/special_measures/CMS10/patients.json')[0], parse: true
    @cqlMeasure.get('patients').add @patient1
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient1, measure: @cqlMeasure)
    @patientBuilder.render()

    initialPopulation = $(@patientBuilder.$(".cql-statement")[0])
    expect(initialPopulation.find(".clause-true").length).toBe(5)
    expect(initialPopulation.find(".clause-false").length).toBe(0)
    denominator = $(@patientBuilder.$(".cql-statement")[1])
    expect(denominator.find(".clause-true").length).toBe(2)
    expect(denominator.find(".clause-false").length).toBe(0)
    numerator = $(@patientBuilder.$(".cql-statement")[2])
    expect(numerator.find(".clause-true").length).toBe(0)
    expect(numerator.find(".clause-false").length).toBe(2)
    denomException = $(@patientBuilder.$(".cql-statement")[3])
    expect(denomException.find(".clause-true").length).toBe(0)
    expect(denomException.find(".clause-false").length).toBe(2)
    inDemographic = $(@patientBuilder.$(".cql-statement")[4])
    expect(inDemographic.find(".clause-true").length).toBe(5)
    expect(inDemographic.find(".clause-false").length).toBe(0)
    encounter = $(@patientBuilder.$(".cql-statement")[5])
    expect(encounter.find(".clause-true").length).toBe(2)
    expect(encounter.find(".clause-false").length).toBe(0)
    encountersDuringMP = $(@patientBuilder.$(".cql-statement")[6])
    expect(encountersDuringMP.find(".clause-true").length).toBe(10)
    expect(encountersDuringMP.find(".clause-false").length).toBe(0)
    medicationsDocumented = $(@patientBuilder.$(".cql-statement")[7])
    expect(medicationsDocumented.find(".clause-true").length).toBe(0)
    expect(medicationsDocumented.find(".clause-false").length).toBe(15)
    MedsNotDocumented = $(@patientBuilder.$(".cql-statement")[8])
    expect(MedsNotDocumented.find(".clause-true").length).toBe(0)
    expect(MedsNotDocumented.find(".clause-false").length).toBe(11)

  xit 'is correct for second patient', ->
    @patient2 = new Thorax.Models.Patient getJSONFixture('cqm_patients/special_measures/CMS10/patients.json')[1], parse: true
    @cqlMeasure.get('patients').add @patient2
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient2, measure: @cqlMeasure)
    @patientBuilder.render()

    initialPopulation = $(@patientBuilder.$(".cql-statement")[0])
    expect(initialPopulation.find(".clause-true").length).toBe(5)
    expect(initialPopulation.find(".clause-uncofalsevered").length).toBe(0)
    denominator = $(@patientBuilder.$(".cql-statement")[1])
    expect(denominator.find(".clause-true").length).toBe(2)
    expect(denominator.find(".clause-false").length).toBe(0)
    numerator = $(@patientBuilder.$(".cql-statement")[2])
    expect(numerator.find(".clause-true").length).toBe(0)
    expect(numerator.find(".clause-false").length).toBe(2)
    denomException = $(@patientBuilder.$(".cql-statement")[3])
    expect(denomException.find(".clause-true").length).toBe(2)
    expect(denomException.find(".clause-false").length).toBe(0)
    inDemographic = $(@patientBuilder.$(".cql-statement")[4])
    expect(inDemographic.find(".clause-true").length).toBe(5)
    expect(inDemographic.find(".clause-false").length).toBe(0)
    encounter = $(@patientBuilder.$(".cql-statement")[5])
    expect(encounter.find(".clause-true").length).toBe(2)
    expect(encounter.find(".clause-false").length).toBe(0)
    encountersDuringMP = $(@patientBuilder.$(".cql-statement")[6])
    expect(encountersDuringMP.find(".clause-true").length).toBe(10)
    expect(encountersDuringMP.find(".clause-false").length).toBe(0)
    medicationsDocumented = $(@patientBuilder.$(".cql-statement")[7])
    expect(medicationsDocumented.find(".clause-true").length).toBe(0)
    expect(medicationsDocumented.find(".clause-false").length).toBe(15)
    MedsNotDocumented = $(@patientBuilder.$(".cql-statement")[8])
    expect(MedsNotDocumented.find(".clause-true").length).toBe(11)
    expect(MedsNotDocumented.find(".clause-false").length).toBe(0)
