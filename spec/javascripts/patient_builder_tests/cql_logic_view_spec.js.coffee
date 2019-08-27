describe 'CqlLogicView', ->
  describe 'Population Logic View', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS334v1/CMS334v1.json'), parse: true

    it 'only uses populations out of main_cql_library', ->
      populationSet = @measure.get('populations').first()
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @measure, highlightPatientDataEnabled: true, population: populationSet)
      populationLogicView.render()
      populationStatementViews = populationLogicView.populationStatementViews
      for populationStatement1, index1 in populationStatementViews
        for populationStatement2, index2 in populationStatementViews
          if index1 != index2
            expect(populationStatement1.name).not.toEqual(populationStatement2.name)

  describe 'sorting', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS903v0/CMS903v0.json', 'cqm_measure_data/CMS903v0/value_sets.json'

    it 'proof of concept', ->
      populationSet = @measure.get('populations').first()
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @measure, highlightPatientDataEnabled: true, population: populationSet)
      populationLogicView.render()
      visit1ED = getJSONFixture 'patients/CMS903v0/Visit_1 ED.json'
      visits1Excl2ED = getJSONFixture 'patients/CMS903v0/Visits 1 Excl_2 ED.json'
      visits2Excl2ED = getJSONFixture 'patients/CMS903v0/Visits 2 Excl_2 ED.json'
      visits2ED = getJSONFixture 'patients/CMS903v0/Visits_2 ED.json'
      testPatients = new Thorax.Collections.Patients [visit1ED, visits1Excl2ED, visits2Excl2ED, visits2ED], parse: true
      expectedResults = getJSONFixture 'cqm_measure_data/CMS903v0/expected_results.json'
      results = populationSet.calculate(testPatients.first())

      results.get('clause_results')['LikeCMS32']

      compareResults = JSON.stringify(_.map(results.get('clause_results')['LikeCMS32'],
        (clauseResult) -> _.omit(clauseResult, 'raw')))

      expect(compareResults).toEqual(JSON.stringify(expectedResults))

      populationLogicView.showRationale(results)

    it 'sorts logic properly for observation measure', ->
      populationSet = @measure.get('populations').first()
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @measure, highlightPatientDataEnabled: true, population: populationSet)
      populationLogicView.render()

      expect(populationLogicView.allStatementViews.length).toBe(13)

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
      expect(populationLogicView.defineStatementViews[0].name).toEqual('Emergency Department ED Visit')

      expect(populationLogicView.unusedStatementViews.length).toBe(3)
      expect(populationLogicView.unusedStatementViews[1].name).toEqual('Strat1')
      expect(populationLogicView.unusedStatementViews[0].name).toEqual('Strat2')
      expect(populationLogicView.unusedStatementViews[2].name).toEqual('Strat3')

    it 'sorts logic properly for observation measure with stratification', ->
      populationSet = @measure.get('populations').at(1)
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @measure, highlightPatientDataEnabled: true, population: populationSet)
      populationLogicView.render()

      expect(populationLogicView.allStatementViews.length).toBe(13)

      expect(populationLogicView.populationStatementViews.length).toBe(5)
      expect(populationLogicView.populationStatementViews[0].name).toEqual('Strat1')
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
      expect(populationLogicView.defineStatementViews[0].name).toEqual('Emergency Department ED Visit')

      expect(populationLogicView.unusedStatementViews.length).toBe(2)
      expect(populationLogicView.unusedStatementViews[0].name).toEqual('Strat2')
      expect(populationLogicView.unusedStatementViews[1].name).toEqual('Strat3')

    it 'sorts logic properly for proportion measure', ->
      measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'

      populationSet = measure.get('populations').first()
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure, highlightPatientDataEnabled: true, population: populationSet)
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
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS720v0/CMS720v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).toContain 'This measure was written using an outdated version of QDM. Please re-package and re-export the measure from the MAT.'

    it 'shows for QDM 5.3 measure', ->
      jasmine.getJSONFixtures().clearCache()
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS160v6/CMS160v6.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).toContain 'This measure was written using an outdated version of QDM. Please re-package and re-export the measure from the MAT.'

    it 'does not show for QDM 5.4 measure', ->
      jasmine.getJSONFixtures().clearCache()
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS231v0/CMS231v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).not.toContain 'This measure was written using an outdated version of QDM. Please re-package and re-export the measure from the MAT.'


  describe 'CQL Error warning message', ->
    it 'shows for measure with CQL errors', ->
      jasmine.getJSONFixtures().clearCache()
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/deprecated_measures/CMS735/CMS735v0.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).toContain 'This measure appears to have errors in its CQL.  Please re-package and re-export the measure from the MAT.'

    it 'does not show for error-free CQL measure', ->
      jasmine.getJSONFixtures().clearCache()
      measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/CMS160v6/CMS160v6.json'), parse: true
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: measure)
      populationLogicView.render()
      expect(populationLogicView.$el.html()).not.toContain 'This measure appears to have errors in its CQL.  Please re-package and re-export the measure from the MAT.'

  describe 'CQL Clause View', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMSv9999/CMSv9999.json', 'cqm_measure_data/CMSv9999/value_sets.json'
      patientBlank = getJSONFixture 'patients/CMSv9999/Patient_Blank.json'
      @patients = new Thorax.Collections.Patients [patientBlank], parse: true

    # Tests that a "let" statement in a library function which doesn't have results for
    # it's parent clause still loads properly without errors
    it 'should load without errors', ->
      populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @measure, population: @measure.get('populations').first())
      populationLogicView.render()
      results = @measure.get('populations').first().calculate(@patients.first())
      expect(-> populationLogicView.showRationale(results)).not.toThrow()

  describe 'CQL Statement Results', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS146v6/CMS146v6.json', 'cqm_measure_data/CMS146v6/value_sets.json'
      passIpp = getJSONFixture 'patients/CMS146v6/Pass_IPP.json'
      @patients = new Thorax.Collections.Patients [passIpp], parse: true
      @population = @measure.get('populations').first()

    beforeEach ->
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @measure, population: @measure.get('populations').first())
      @populationLogicView.render()
      @populationLogicView.appendTo('body')

    afterEach ->
      @populationLogicView.remove()

    describe 'show all results button', ->
      it 'should exist', ->
        expect($('#show-all-results').length).toEqual(1)

      it 'should toggle when clicked', ->
        expect($('#hide-all-results').length).toEqual(0)
        @populationLogicView.$('#show-all-results').click()
        expect($('#hide-all-results').length).toEqual(1)
        expect($('#show-all-results').length).toEqual(0)

      it 'should trigger all show/hide result buttons and results', ->
        expect($('button[data-call-method="showResult"]').length).toEqual(11)
        expect($('button[data-call-method="hideResult"]').length).toEqual(0)
        @populationLogicView.$('#show-all-results').click()
        expect($('button[data-call-method="showResult"]').length).toEqual(0)
        expect($('button[data-call-method="hideResult"]').length).toEqual(11)
        @populationLogicView.$('#hide-all-results').click()
        expect($('button[data-call-method="showResult"]').length).toEqual(11)
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
