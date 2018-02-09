describe 'CqlLogicView', ->
  describe 'sorting', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS32/CMS32v7.json'), parse: true
      #Failing to store and reset the global valueSetsByOid breaks the tests.
      #When integrated with the master branch context switching, this will need to be changed out.
      @universalValueSetsByOid = bonnie.valueSetsByOid
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/core_measures/CMS32/value_sets.json')

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid

    it 'proof of concept', ->
      population = @cqlMeasure.get('populations').first()
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, highlightPatientDataEnabled: true, population: population)
      populationLogicView.render()

      testPatients = new Thorax.Collections.Patients getJSONFixture('records/core_measures/CMS32/patients.json'), parse: true

      results = population.calculate(testPatients.first())

      results.get('clause_results')['MedianTimefromEDArrivaltoEDDepartureforDischargedEDPatients']

      compareResults = JSON.stringify(_.map(results.get('clause_results')['MedianTimefromEDArrivaltoEDDepartureforDischargedEDPatients'],
        (clauseResult) -> _.omit(clauseResult, 'raw')))

      expectedResults = '[{"statementName":"SDE Ethnicity","final":"NA"},{"statementName":"SDE Ethnicity","final":"NA"},{"statementName":"SDE Payer","final":"NA"},{"statementName":"SDE Payer","final":"NA"},{"statementName":"SDE Race","final":"NA"},{"statementName":"SDE Race","final":"NA"},{"statementName":"SDE Sex","final":"NA"},{"statementName":"SDE Sex","final":"NA"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"ED Visit","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Initial Population","final":"TRUE"},{"statementName":"Measure Population","final":"TRUE"},{"statementName":"Measure Population","final":"TRUE"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 1","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 2","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Stratification 3","final":"NA"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"TRUE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Population Exclusions","final":"FALSE"},{"statementName":"Measure Observation","final":"NA"},{"statementName":"Measure Observation","final":"NA"},{"statementName":"Measure Observation","final":"NA"},{"statementName":"Measure Observation","final":"NA"},{"statementName":"Measure Observation","final":"NA"}]'

      expect(compareResults).toEqual(expectedResults)

      populationLogicView.showRationale(results)

    it 'sorts logic properly for observation measure', ->
      population = @cqlMeasure.get('populations').first()
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, highlightPatientDataEnabled: true, population: population)
      populationLogicView.render()

      expect(populationLogicView.allStatementViews.length).toBe(8)

      expect(populationLogicView.populationStatementViews.length).toBe(4)
      expect(populationLogicView.populationStatementViews[0].name).toEqual('Initial Population')
      expect(populationLogicView.populationStatementViews[0].cqlPopulations).toEqual(['IPP'])
      expect(populationLogicView.populationStatementViews[1].name).toEqual('Measure Population')
      expect(populationLogicView.populationStatementViews[1].cqlPopulations).toEqual(['MSRPOPL'])
      expect(populationLogicView.populationStatementViews[2].name).toEqual('Measure Population Exclusions')
      expect(populationLogicView.populationStatementViews[2].cqlPopulations).toEqual(['MSRPOPLEX'])
      expect(populationLogicView.populationStatementViews[3].name).toEqual('Measure Observation')
      expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['OBSERV_1'])

      expect(populationLogicView.defineStatementViews.length).toBe(1)
      expect(populationLogicView.defineStatementViews[0].name).toEqual('ED Visit')

      expect(populationLogicView.unusedStatementViews.length).toBe(3)
      expect(populationLogicView.unusedStatementViews[0].name).toEqual('Stratification 1')
      expect(populationLogicView.unusedStatementViews[1].name).toEqual('Stratification 2')
      expect(populationLogicView.unusedStatementViews[2].name).toEqual('Stratification 3')

    it 'sorts logic properly for observation measure with stratification', ->
      population = @cqlMeasure.get('populations').at(1)
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, highlightPatientDataEnabled: true, population: population)
      populationLogicView.render()

      expect(populationLogicView.allStatementViews.length).toBe(8)

      expect(populationLogicView.populationStatementViews.length).toBe(5)
      expect(populationLogicView.populationStatementViews[0].name).toEqual('Stratification 1')
      expect(populationLogicView.populationStatementViews[0].cqlPopulations).toEqual(['STRAT'])
      expect(populationLogicView.populationStatementViews[1].name).toEqual('Initial Population')
      expect(populationLogicView.populationStatementViews[1].cqlPopulations).toEqual(['IPP'])
      expect(populationLogicView.populationStatementViews[2].name).toEqual('Measure Population')
      expect(populationLogicView.populationStatementViews[2].cqlPopulations).toEqual(['MSRPOPL'])
      expect(populationLogicView.populationStatementViews[3].name).toEqual('Measure Population Exclusions')
      expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['MSRPOPLEX'])
      expect(populationLogicView.populationStatementViews[4].name).toEqual('Measure Observation')
      expect(populationLogicView.populationStatementViews[4].cqlPopulations).toEqual(['OBSERV_1'])

      expect(populationLogicView.defineStatementViews.length).toBe(1)
      expect(populationLogicView.defineStatementViews[0].name).toEqual('ED Visit')

      expect(populationLogicView.unusedStatementViews.length).toBe(2)
      expect(populationLogicView.unusedStatementViews[0].name).toEqual('Stratification 2')
      expect(populationLogicView.unusedStatementViews[1].name).toEqual('Stratification 3')

    it 'sorts logic properly for proportion measure', ->
      measure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/core_measures/CMS160/value_sets.json')

      population = measure.get('populations').at(0)
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure, highlightPatientDataEnabled: true, population: population)
      populationLogicView.render()

      expect(populationLogicView.allStatementViews.length).toBe(28)
      expect(populationLogicView.populationStatementViews.length).toBe(4)
      expect(populationLogicView.populationStatementViews[0].name).toEqual('Initial Population 1')
      expect(populationLogicView.populationStatementViews[0].cqlPopulations).toEqual(['IPP'])
      expect(populationLogicView.populationStatementViews[1].name).toEqual('Denominator 1')
      expect(populationLogicView.populationStatementViews[1].cqlPopulations).toEqual(['DENOM'])
      expect(populationLogicView.populationStatementViews[2].name).toEqual('Denominator Exclusion 1')
      expect(populationLogicView.populationStatementViews[2].cqlPopulations).toEqual(['DENEX'])
      expect(populationLogicView.populationStatementViews[3].name).toEqual('Numerator 1')
      expect(populationLogicView.populationStatementViews[3].cqlPopulations).toEqual(['NUMER'])

  describe 'outdated QDM warning message', ->
    it 'shows for QDM 5.02 measure', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS720/CMS720v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).toContain 'This measure was written using an outdated version of QDM. Please re-package and re-export the measure from the MAT.'

    it 'does not show for QDM 5.3 measure', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).not.toContain 'This measure was written using an outdated version of QDM. Please re-package and re-export the measure from the MAT.'

  describe 'CQL Error warning message', ->
    it 'shows for measure with CQL errors', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS347/CMS735v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).toContain 'This measure appears to have errors in its CQL.  Please re-package and re-export the measure from the MAT.'

    it 'does not show for error-free CQL measure', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).not.toContain 'This measure appears to have errors in its CQL.  Please re-package and re-export the measure from the MAT.'
