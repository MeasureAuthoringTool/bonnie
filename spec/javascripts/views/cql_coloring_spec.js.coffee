describe 'CQL Coverage', ->

  beforeEach ->
    @universalValueSetsByOid = bonnie.valueSetsByOid
    jasmine.getJSONFixtures().clearCache()
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS10/value_sets.json')
    @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS10/CMS10v0.json'), parse: true
    @patient1 = new Thorax.Models.Patient getJSONFixture('records/CQL/CMS10/patients.json')[0], parse: true
    @patient2 = new Thorax.Models.Patient getJSONFixture('records/CQL/CMS10/patients.json')[1], parse: true

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  it 'is correct with first patient', ->
    @cqlMeasure.get('patients').add @patient1
    @population = @cqlMeasure.get('populations').first()
    @cqlMeasurePopulationLogic = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population)
    @cqlMeasurePopulationLogic.showCoverage()
    @cqlMeasurePopulationLogic.render()

    # For Initial Population
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[0]).find(".clause-covered").length).toBe(5)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[0]).find(".clause-uncovered").length).toBe(0)
    # For Denominator
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[1]).find(".clause-covered").length).toBe(2)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[1]).find(".clause-uncovered").length).toBe(0)
    # For Numerator
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[2]).find(".clause-covered").length).toBe(0)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[2]).find(".clause-uncovered").length).toBe(2)
    # For Denominator Exception
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[3]).find(".clause-covered").length).toBe(0)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[3]).find(".clause-uncovered").length).toBe(2)
    # For Definition: In Demographic 
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[4]).find(".clause-covered").length).toBe(5)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[4]).find(".clause-uncovered").length).toBe(0)
    # For Definition: Encounter
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[5]).find(".clause-covered").length).toBe(2)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[5]).find(".clause-uncovered").length).toBe(0)
    # For Definition: Encounters during MP
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[6]).find(".clause-covered").length).toBe(10)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[6]).find(".clause-uncovered").length).toBe(0)
    # For Definition: Medications Documented
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[7]).find(".clause-covered").length).toBe(0)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[7]).find(".clause-uncovered").length).toBe(15)
    # For Definition: meds not documented for medical reasons
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[8]).find(".clause-covered").length).toBe(0)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[8]).find(".clause-uncovered").length).toBe(11)

  it 'is correct with both patients', ->
    @cqlMeasure.get('patients').add @patient1
    @cqlMeasure.get('patients').add @patient2
    @population = @cqlMeasure.get('populations').first()
    @cqlMeasurePopulationLogic = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population)
    @cqlMeasurePopulationLogic.showCoverage()
    @cqlMeasurePopulationLogic.render()

    # For Initial Population
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[0]).find(".clause-covered").length).toBe(5)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[0]).find(".clause-uncovered").length).toBe(0)
    # For Denominator
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[1]).find(".clause-covered").length).toBe(2)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[1]).find(".clause-uncovered").length).toBe(0)
    # For Numerator
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[2]).find(".clause-covered").length).toBe(0)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[2]).find(".clause-uncovered").length).toBe(2)
    # For Denominator Exception
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[3]).find(".clause-covered").length).toBe(2)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[3]).find(".clause-uncovered").length).toBe(0)
    # For Definition: In Demographic 
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[4]).find(".clause-covered").length).toBe(5)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[4]).find(".clause-uncovered").length).toBe(0)
    # For Definition: Encounter
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[5]).find(".clause-covered").length).toBe(2)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[5]).find(".clause-uncovered").length).toBe(0)
    # For Definition: Encounters during MP
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[6]).find(".clause-covered").length).toBe(10)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[6]).find(".clause-uncovered").length).toBe(0)
    # For Definition: Medications Documented
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[7]).find(".clause-covered").length).toBe(0)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[7]).find(".clause-uncovered").length).toBe(15)
    # For Definition: meds not documented for medical reasons
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[8]).find(".clause-covered").length).toBe(11)
    expect($(@cqlMeasurePopulationLogic.$(".cql-statement")[8]).find(".clause-uncovered").length).toBe(0)

describe 'CQL Coloring', ->

  beforeEach ->
    @universalValueSetsByOid = bonnie.valueSetsByOid
    jasmine.getJSONFixtures().clearCache()
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS10/value_sets.json')
    @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS10/CMS10v0.json'), parse: true

    afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  it 'is correct for first patient', ->
    @patient1 = new Thorax.Models.Patient getJSONFixture('records/CQL/CMS10/patients.json')[0], parse: true
    @cqlMeasure.get('patients').add @patient1
    @patientBuilder1 = new Thorax.Views.PatientBuilder(model: @patient1, measure: @cqlMeasure)
    @patientBuilder1.render()

    # For Initial Population
    expect($(@patientBuilder1.$(".cql-statement")[0]).find(".clause-true").length).toBe(5)
    expect($(@patientBuilder1.$(".cql-statement")[0]).find(".clause-false").length).toBe(0)
    # For Denominator
    expect($(@patientBuilder1.$(".cql-statement")[1]).find(".clause-true").length).toBe(2)
    expect($(@patientBuilder1.$(".cql-statement")[1]).find(".clause-false").length).toBe(0)
    # For Numerator
    expect($(@patientBuilder1.$(".cql-statement")[2]).find(".clause-true").length).toBe(0)
    expect($(@patientBuilder1.$(".cql-statement")[2]).find(".clause-false").length).toBe(2)
    # For Denominator Exception
    expect($(@patientBuilder1.$(".cql-statement")[3]).find(".clause-true").length).toBe(0)
    expect($(@patientBuilder1.$(".cql-statement")[3]).find(".clause-false").length).toBe(2)
    # For Definition: In Demographic 
    expect($(@patientBuilder1.$(".cql-statement")[4]).find(".clause-true").length).toBe(5)
    expect($(@patientBuilder1.$(".cql-statement")[4]).find(".clause-false").length).toBe(0)
    # For Definition: Encounter
    expect($(@patientBuilder1.$(".cql-statement")[5]).find(".clause-true").length).toBe(2)
    expect($(@patientBuilder1.$(".cql-statement")[5]).find(".clause-false").length).toBe(0)
    # For Definition: Encounters during MP
    expect($(@patientBuilder1.$(".cql-statement")[6]).find(".clause-true").length).toBe(10)
    expect($(@patientBuilder1.$(".cql-statement")[6]).find(".clause-false").length).toBe(0)
    # For Definition: Medications Documented
    expect($(@patientBuilder1.$(".cql-statement")[7]).find(".clause-true").length).toBe(0)
    expect($(@patientBuilder1.$(".cql-statement")[7]).find(".clause-false").length).toBe(15)
    # For Definition: meds not documented for medical reasons
    expect($(@patientBuilder1.$(".cql-statement")[8]).find(".clause-true").length).toBe(0)
    expect($(@patientBuilder1.$(".cql-statement")[8]).find(".clause-false").length).toBe(11)

    

  it 'is correct for second patient', ->
    @patient2 = new Thorax.Models.Patient getJSONFixture('records/CQL/CMS10/patients.json')[1], parse: true
    @cqlMeasure.get('patients').add @patient2
    @patientBuilder2 = new Thorax.Views.PatientBuilder(model: @patient2, measure: @cqlMeasure)
    @patientBuilder2.render()
    #@patientBuilder2.appendTo 'body'

    # For Initial Population
    expect($(@patientBuilder2.$(".cql-statement")[0]).find(".clause-true").length).toBe(5)
    expect($(@patientBuilder2.$(".cql-statement")[0]).find(".clause-false").length).toBe(0)
    # For Denominator
    expect($(@patientBuilder2.$(".cql-statement")[1]).find(".clause-true").length).toBe(2)
    expect($(@patientBuilder2.$(".cql-statement")[1]).find(".clause-false").length).toBe(0)
    # For Numerator
    expect($(@patientBuilder2.$(".cql-statement")[2]).find(".clause-true").length).toBe(0)
    expect($(@patientBuilder2.$(".cql-statement")[2]).find(".clause-false").length).toBe(2)
    # For Denominator Exception
    expect($(@patientBuilder2.$(".cql-statement")[3]).find(".clause-true").length).toBe(2)
    expect($(@patientBuilder2.$(".cql-statement")[3]).find(".clause-false").length).toBe(0)
    # For Definition: In Demographic 
    expect($(@patientBuilder2.$(".cql-statement")[4]).find(".clause-true").length).toBe(5)
    expect($(@patientBuilder2.$(".cql-statement")[4]).find(".clause-false").length).toBe(0)
    # For Definition: Encounter
    expect($(@patientBuilder2.$(".cql-statement")[5]).find(".clause-true").length).toBe(2)
    expect($(@patientBuilder2.$(".cql-statement")[5]).find(".clause-false").length).toBe(0)
    # For Definition: Encounters during MP
    expect($(@patientBuilder2.$(".cql-statement")[6]).find(".clause-true").length).toBe(10)
    expect($(@patientBuilder2.$(".cql-statement")[6]).find(".clause-false").length).toBe(0)
    # For Definition: Medications Documented
    expect($(@patientBuilder2.$(".cql-statement")[7]).find(".clause-true").length).toBe(0)
    expect($(@patientBuilder2.$(".cql-statement")[7]).find(".clause-false").length).toBe(15)
    # For Definition: meds not documented for medical reasons
    expect($(@patientBuilder2.$(".cql-statement")[8]).find(".clause-true").length).toBe(11)
    expect($(@patientBuilder2.$(".cql-statement")[8]).find(".clause-false").length).toBe(0)


    