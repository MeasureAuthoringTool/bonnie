describe 'CqlLogicView', ->

  beforeEach -> 
    jasmine.getJSONFixtures().clearCache()
    @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/cqltest/CMS720v0.json'), parse: true
    #Failing to store and reset the global valueSetsByOid breaks the tests.
    #When integrated with the master branch context switching, this will need to be changed out.
    @universalValueSetsByOid = bonnie.valueSetsByOid

  afterEach ->
    bonnie.valueSetsByOid = @universalValueSetsByOid

  it 'proof of concept', ->
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/cqltest/value_sets.json')

    population = @cqlMeasure.get('populations').first()
    populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, highlightPatientDataEnabled: true, population: population)
    populationLogicView.render()

    testPatients = new Thorax.Collections.Patients getJSONFixture('records/cqltest/patients.json'), parse: true

    results = population.calculate(testPatients.first())

    results.get('clause_results')['MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients']

    compareResults = JSON.stringify(_.map(results.get('clause_results')['MedianTimefromEDArrivaltoEDDepartureforAdmittedEDPatients'],
      (clauseResult) -> _.omit(clauseResult, 'raw')))

    expectedResults = '[{"statementName":"SDE Ethnicity","final":"NA"},{"statementName":"SDE Ethnicity","final":"NA"},{"statementName":"SDE Payer","final":"NA"},{"statementName":"SDE Payer","final":"NA"},{"statementName":"SDE Race","final":"NA"},{"statementName":"SDE Race","final":"NA"},{"statementName":"SDE Sex","final":"NA"},{"statementName":"SDE Sex","final":"NA"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Measure Population","final":"UNHIT"},{"statementName":"Measure Population","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"}]'

    expect(compareResults).toEqual(expectedResults)

    populationLogicView.showRationale(results)

  it 'sorts logic properly', ->
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/cqltest/value_sets.json')

    population = @cqlMeasure.get('populations').first()
    populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, highlightPatientDataEnabled: true, population: population)
    populationLogicView.render()

    expect(populationLogicView.allStatementViews.length).toBe(8)

    expect(populationLogicView.populationStatementViews.length).toBe(4)
    expect(populationLogicView.populationStatementViews[0].name).toEqual('Initial Population')
    expect(populationLogicView.populationStatementViews[0].cqlPopulations).toEqual(['IPP'])
    expect(populationLogicView.populationStatementViews[1].name).toEqual('Measure Population')
    expect(populationLogicView.populationStatementViews[1].cqlPopulations).toEqual(['MSRPOPL'])
    expect(populationLogicView.populationStatementViews[2].name).toEqual('MeasureObservation')
    expect(populationLogicView.populationStatementViews[2].cqlPopulations).toEqual(['OBSERV_1'])
    expect(populationLogicView.populationStatementViews[3].name).toEqual('Measure Population Exclusion')
    expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['MSRPOPLEX'])

    expect(populationLogicView.defineStatementViews.length).toBe(3)
    expect(populationLogicView.defineStatementViews[0].name).toEqual('Inpatient Encounter')
    expect(populationLogicView.defineStatementViews[1].name).toEqual('Startification1')
    expect(populationLogicView.defineStatementViews[2].name).toEqual('Stratification2')

    expect(populationLogicView.functionStatementViews.length).toBe(1)
    expect(populationLogicView.functionStatementViews[0].name).toEqual('RelatedEDVisit')

  it 'sorts logic properly with stratification', ->
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/cqltest/value_sets.json')

    population = @cqlMeasure.get('populations').at(1)
    populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, highlightPatientDataEnabled: true, population: population)
    populationLogicView.render()

    expect(populationLogicView.allStatementViews.length).toBe(8)

    expect(populationLogicView.populationStatementViews.length).toBe(5)
    expect(populationLogicView.populationStatementViews[0].name).toEqual('Startification1')
    expect(populationLogicView.populationStatementViews[0].cqlPopulations).toEqual(['STRAT'])
    expect(populationLogicView.populationStatementViews[1].name).toEqual('Initial Population')
    expect(populationLogicView.populationStatementViews[1].cqlPopulations).toEqual(['IPP'])
    expect(populationLogicView.populationStatementViews[2].name).toEqual('Measure Population')
    expect(populationLogicView.populationStatementViews[2].cqlPopulations).toEqual(['MSRPOPL'])
    expect(populationLogicView.populationStatementViews[3].name).toEqual('MeasureObservation')
    expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['OBSERV_1'])
    expect(populationLogicView.populationStatementViews[4].name).toEqual('Measure Population Exclusion')
    expect(populationLogicView.populationStatementViews[4].cqlPopulations).toEqual(['MSRPOPLEX'])

    expect(populationLogicView.defineStatementViews.length).toBe(2)
    expect(populationLogicView.defineStatementViews[0].name).toEqual('Inpatient Encounter')
    expect(populationLogicView.defineStatementViews[1].name).toEqual('Stratification2')

    expect(populationLogicView.functionStatementViews.length).toBe(1)
    expect(populationLogicView.functionStatementViews[0].name).toEqual('RelatedEDVisit')
