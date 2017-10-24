describe 'CqlLogicView', ->
  describe 'sorting', ->
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

      expectedResults = '[{"statementName":"SDE Ethnicity","final":"NA"},{"statementName":"SDE Ethnicity","final":"NA"},{"statementName":"SDE Payer","final":"NA"},{"statementName":"SDE Payer","final":"NA"},{"statementName":"SDE Race","final":"NA"},{"statementName":"SDE Race","final":"NA"},{"statementName":"SDE Sex","final":"NA"},{"statementName":"SDE Sex","final":"NA"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Inpatient Encounter","final":"TRUE"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Startification1","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Stratification2","final":"NA"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Initial Population","final":"FALSE"},{"statementName":"Measure Population","final":"UNHIT"},{"statementName":"Measure Population","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"Measure Population Exclusion","final":"UNHIT"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"RelatedEDVisit","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"},{"statementName":"MeasureObservation","final":"NA"}]'

      expect(compareResults).toEqual(expectedResults)

      populationLogicView.showRationale(results)

    it 'sorts logic properly for observation measure', ->
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
      expect(populationLogicView.populationStatementViews[2].name).toEqual('Measure Population Exclusion')
      expect(populationLogicView.populationStatementViews[2].cqlPopulations).toEqual(['MSRPOPLEX'])
      expect(populationLogicView.populationStatementViews[3].name).toEqual('MeasureObservation')
      expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['OBSERV_1'])

      expect(populationLogicView.defineStatementViews.length).toBe(1)
      expect(populationLogicView.defineStatementViews[0].name).toEqual('Inpatient Encounter')

      expect(populationLogicView.functionStatementViews.length).toBe(1)
      expect(populationLogicView.functionStatementViews[0].name).toEqual('RelatedEDVisit')

      expect(populationLogicView.unusedStatementViews.length).toBe(2)
      expect(populationLogicView.unusedStatementViews[0].name).toEqual('Startification1')
      expect(populationLogicView.unusedStatementViews[1].name).toEqual('Stratification2')

    it 'sorts logic properly for observation measure with stratification', ->
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
      expect(populationLogicView.populationStatementViews[3].name).toEqual('Measure Population Exclusion')
      expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['MSRPOPLEX'])
      expect(populationLogicView.populationStatementViews[4].name).toEqual('MeasureObservation')
      expect(populationLogicView.populationStatementViews[4].cqlPopulations).toEqual(['OBSERV_1'])

      expect(populationLogicView.defineStatementViews.length).toBe(1)
      expect(populationLogicView.defineStatementViews[0].name).toEqual('Inpatient Encounter')

      expect(populationLogicView.functionStatementViews.length).toBe(1)
      expect(populationLogicView.functionStatementViews[0].name).toEqual('RelatedEDVisit')

      expect(populationLogicView.unusedStatementViews.length).toBe(1)
      expect(populationLogicView.unusedStatementViews[0].name).toEqual('Stratification2')

    it 'sorts logic properly for proportion measure', ->
      measure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS347/CMS735v0.json'), parse: true
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS347/value_sets.json')

      population = measure.get('populations').at(0)
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure, highlightPatientDataEnabled: true, population: population)
      populationLogicView.render()

      expect(populationLogicView.allStatementViews.length).toBe(38)
      expect(populationLogicView.populationStatementViews.length).toBe(5)
      expect(populationLogicView.populationStatementViews[0].name).toEqual('Initial Population')
      expect(populationLogicView.populationStatementViews[0].cqlPopulations).toEqual(['IPP'])
      expect(populationLogicView.populationStatementViews[1].name).toEqual('Denominator 1')
      expect(populationLogicView.populationStatementViews[1].cqlPopulations).toEqual(['DENOM'])
      expect(populationLogicView.populationStatementViews[2].name).toEqual('Denex')
      expect(populationLogicView.populationStatementViews[2].cqlPopulations).toEqual(['DENEX'])
      expect(populationLogicView.populationStatementViews[3].name).toEqual('Numerator')
      expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['NUMER'])
      expect(populationLogicView.populationStatementViews[4].name).toEqual('Denexcep')
      expect(populationLogicView.populationStatementViews[4].cqlPopulations).toEqual(['DENEXCEP'])

  describe 'outdated QDM warning message', ->
    it 'shows for QDM 5.02 measure', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/cqltest/CMS720v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).toContain 'This measure was written using an outdated version of QDM. Please re-package and re-export the measure from the MAT.'

    it 'does not show for QDM 5.3 measure', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/QDM53-measure/CMS10v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).not.toContain 'This measure was written using an outdated version of QDM. Please re-package and re-export the measure from the MAT.'
