describe 'CqlLogicView', ->
  describe 'Population Logic View', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMS334v1/CMS334v1.json'), parse: true
      #Failing to store and reset the global valueSetsByOid breaks the tests.
      #When integrated with the master branch context switching, this will need to be changed out.
      @universalValueSetsByOid = bonnie.valueSetsByOid

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid

    it 'only uses populations out of main_cql_library', ->
      population = @cqlMeasure.get('populations').first()
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, highlightPatientDataEnabled: true, population: population)
      populationLogicView.render()
      populationStatementViews = populationLogicView.populationStatementViews
      for populationStatement1, index1 in populationStatementViews
        for populationStatement2, index2 in populationStatementViews
          if index1 != index2
            expect(populationStatement1.name).not.toEqual(populationStatement2.name)

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

  describe 'CQL Error warning message', ->
    it 'shows for measure with CQL errors', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS347/CMS735v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).toContain 'This measure appears to have errors in its CQL.  Please re-package and re-export the measure from the MAT.'

    it 'does not show for error-free CQL measure', ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/cqltest/CMS720v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: cqlMeasure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).not.toContain 'This measure appears to have errors in its CQL.  Please re-package and re-export the measure from the MAT.'

  describe 'CQL Clause View', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      # preserve atomicity
      @universalValueSetsByOid = bonnie.valueSetsByOid
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/special_measures/CMSv9999/value_sets.json')
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/special_measures/CMSv9999/CMSv9999.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMSv9999/patients.json'), parse: true

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid

    # Tests that a "let" statement in a library function which doesn't have results for
    # it's parent clause still loads properly without errors
    it 'should load without errors', ->
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @cqlMeasure.get('populations').first())
      populationLogicView.render()
      results = @cqlMeasure.get('populations').first().calculate(@patients.first())
      expect(-> populationLogicView.showRationale(results)).not.toThrow()

  describe 'CQL Statement Results', ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      @universalValueSetsByOid = bonnie.valueSetsByOid
      # TODO: update CQL/CMS146v6 path to CQL/CMS146 when cql-testing-overhaul is merged
      bonnie.valueSetsByOid = getJSONFixture('/measure_data/CQL/CMS146v6/value_sets.json')
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('measure_data/CQL/CMS146v6/CMS146v6.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/CQL/CMS146v6/patients.json'), parse: true
      @population = @cqlMeasure.get('populations').first()
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @cqlMeasure.get('populations').first())
      @populationLogicView.render()
      @populationLogicView.appendTo('body')

    afterEach ->
      @populationLogicView.remove()
      bonnie.valueSetsByOid = @universalValueSetsByOid

    describe 'show all results button', ->
      it 'should exist', ->
        expect($('#show-all-results').length).toEqual(1)

      it 'should toggle when clicked', ->
        expect($('#hide-all-results').length).toEqual(0)
        @populationLogicView.$('#show-all-results').click()
        expect($('#hide-all-results').length).toEqual(1)
        expect($('#show-all-results').length).toEqual(0)

      it 'should trigger all show/hide result buttons and results', ->
        expect($('button[data-call-method="showResult"]').length).toEqual(21)
        expect($('button[data-call-method="hideResult"]').length).toEqual(0)
        @populationLogicView.$('#show-all-results').click()
        expect($('button[data-call-method="showResult"]').length).toEqual(0)
        expect($('button[data-call-method="hideResult"]').length).toEqual(21)
        @populationLogicView.$('#hide-all-results').click()
        expect($('button[data-call-method="showResult"]').length).toEqual(21)
        expect($('button[data-call-method="hideResult"]').length).toEqual(0)

    describe 'show/hide results button', ->
      it 'should toggle when clicked', ->
        expect($('button[data-call-method="hideResult"]').length).toEqual(0)
        @populationLogicView.$('button[data-call-method="showResult"]')[0].click()
        expect($('button[data-call-method="hideResult"]').length).toEqual(1)
        @populationLogicView.$('button[data-call-method="hideResult"]')[0].click()
        expect($('button[data-call-method="hideResult"]').length).toEqual(0)

      it 'should make the result visible/not visible when clicked', ->
        expect($('.cql-statement-result')[0]).toBeHidden()
        @populationLogicView.$('button[data-call-method="showResult"]')[0].click()
        expect($('.cql-statement-result')[0]).toBeVisible()
        @populationLogicView.$('button[data-call-method="hideResult"]')[0].click()
        expect($('.cql-statement-result')[0]).toBeHidden()

      it 'should limit size of long result', ->
        # mock applying less stylesheets
        @populationLogicView.$('.cql-statement-result').attr('style', 'white-space: pre-wrap; height: 200px; overflow-y: scroll;')
        results = @population.calculate(@patients.first())
        @populationLogicView.showRationale(results)
        expect(@populationLogicView.$('.cql-statement-result').height()).toEqual(200)