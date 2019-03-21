describe 'CqlTruncatedStatementView', ->
  describe 'nominal function', ->
    beforeEach ->
      @universalValueSetsByOid = bonnie.valueSetsByOid
      jasmine.getJSONFixtures().clearCache()
      bonnie.valueSetsByOid = getJSONFixture('cqm_measure_data/special_measures/CMS460/value_sets.json')
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS460/CMS460v0.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS460/patients.json'), parse: true
      @cqlMeasure.set('patients', @patients)
      @population = @cqlMeasure.get('populations').first()
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population)
      @populationLogicView.render()

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid

    it 'is used for OpioidData DrugIngredients statement instead of normal clause view', ->
      drugIngredientsView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "DrugIngredients" && view.libraryName == "OpioidData")
      expect(drugIngredientsView.rootClauseView instanceof Thorax.Views.CqlTruncatedStatementView).toBe(true)

      ippView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "Initial Population" && view.libraryName == "PotentialOpioidOveruse")
      expect(ippView.rootClauseView instanceof Thorax.Views.CqlClauseView).toBe(true)

    it 'highlights for coverage', ->
      @populationLogicView.showCoverage()
      drugIngredientsView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "DrugIngredients" && view.libraryName == "OpioidData")
      expect($(drugIngredientsView.rootClauseView.$el)).toHaveClass('clause-covered')

      # pass fake coverage data to make it uncovered
      drugIngredientsView.showCoverage({})
      expect($(drugIngredientsView.rootClauseView.$el)).toHaveClass('clause-uncovered')

    it 'highlights for calculation', ->
      results = @population.calculate(@patients.first())
      @populationLogicView.showRationale(results)
      drugIngredientsView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "DrugIngredients" && view.libraryName == "OpioidData")
      expect($(drugIngredientsView.rootClauseView.$el)).toHaveClass('clause-true')

      # pass fake highlighing data in to make it false,
      fakeResult = {}
      fakeResult[drugIngredientsView.rootClauseView.ref_id] = { final: 'FALSE' }
      drugIngredientsView.showRationale(fakeResult)
      expect($(drugIngredientsView.rootClauseView.$el)).toHaveClass('clause-false')

      # pass fake highlighing data in to make it unhit
      fakeResult = {}
      drugIngredientsView.showRationale(fakeResult)
      expect($(drugIngredientsView.rootClauseView.$el).attr('class')).toBe('')

  describe 'lowered threshold', ->
    beforeEach ->
      @universalValueSetsByOid = bonnie.valueSetsByOid
      # lower the threshold to use the truncated statement view on more statements
      @originalClauseThreshold = Thorax.Views.CqlStatement.MAX_CLAUSE_THRESHOLD
      Thorax.Views.CqlStatement.MAX_CLAUSE_THRESHOLD = 14

    afterEach ->
      bonnie.valueSetsByOid = @universalValueSetsByOid
      Thorax.Views.CqlStatement.MAX_CLAUSE_THRESHOLD = @originalClauseThreshold

    it 'uses truncated view statement returning list of entries and can request hover highlight of the list of entries', ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.valueSetsByOid = getJSONFixture('cqm_measure_data/special_measures/CMS460/value_sets.json')
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS460/CMS460v0.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS460/patients.json'), parse: true
      @cqlMeasure.set('patients', @patients)
      @population = @cqlMeasure.get('populations').first()
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population, highlightPatientDataEnabled: true)
      @populationLogicView.render()
      results = @population.calculate(@patients.first())
      @populationLogicView.showRationale(results)
      encountersView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "Encounters during Measurement Period" && view.libraryName == "PotentialOpioidOveruse")

      # check that the correct view is being used
      expect(encountersView.rootClauseView instanceof Thorax.Views.CqlTruncatedStatementView).toBe(true)
      expect($(encountersView.rootClauseView.$el)).toHaveClass('clause-true')

      # spy on the highlight patient data so we can see if the proper element is called out for highlighting.
      spyOn(@populationLogicView, 'highlightPatientData')
      $(encountersView.rootClauseView.$el).trigger('mouseover')
      # this is the only encounter on the test patient
      expect(@populationLogicView.highlightPatientData).toHaveBeenCalledWith(['5baba59e5cc9750c8441186f'])

      # test mouseout functionality
      spyOn(@populationLogicView, 'clearHighlightPatientData')
      $(encountersView.rootClauseView.$el).trigger('mouseout')
      expect(@populationLogicView.clearHighlightPatientData).toHaveBeenCalled()

    it 'does not hover highlight of the list of entries when highlightPatientDataEnabled is false', ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.valueSetsByOid = getJSONFixture('cqm_measure_data/special_measures/CMS460/value_sets.json')
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS460/CMS460v0.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS460/patients.json'), parse: true
      @cqlMeasure.set('patients', @patients)
      @population = @cqlMeasure.get('populations').first()
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population, highlightPatientDataEnabled: false)
      @populationLogicView.render()
      results = @population.calculate(@patients.first())
      @populationLogicView.showRationale(results)
      encountersView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "Encounters during Measurement Period" && view.libraryName == "PotentialOpioidOveruse")

      # spy on the highlight patient data so we can see if the proper element is called out for highlighting.
      spyOn(@populationLogicView, 'highlightPatientData')
      $(encountersView.rootClauseView.$el).trigger('mouseover')
      expect(@populationLogicView.highlightPatientData).not.toHaveBeenCalled()

      # test mouseout functionality
      spyOn(@populationLogicView, 'clearHighlightPatientData')
      $(encountersView.rootClauseView.$el).trigger('mouseout')
      expect(@populationLogicView.clearHighlightPatientData).not.toHaveBeenCalled()

    it 'uses truncated view statement returning single entry and can request hover highlight of single entry', ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.valueSetsByOid = getJSONFixture('cqm_measure_data/special_measures/CMS136/value_sets.json')
      @cqlMeasure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/special_measures/CMS136/CMS136v7.json'), parse: true
      @patients = new Thorax.Collections.Patients getJSONFixture('records/special_measures/CMS136/patients.json'), parse: true
      @cqlMeasure.set('patients', @patients)
      @population = @cqlMeasure.get('populations').first()
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population, highlightPatientDataEnabled: true)
      @populationLogicView.render()
      results = @population.calculate(@patients.findWhere(first: "Pass", last: "IPP1"))
      @populationLogicView.showRationale(results)
      firstADHDMedView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "First ADHD Medication Dispensed" && view.libraryName == "FollowUpCareforChildrenPrescribedADHDMedicationADD")

      # check that the correct view is being used
      expect(firstADHDMedView.rootClauseView instanceof Thorax.Views.CqlTruncatedStatementView).toBe(true)
      expect($(firstADHDMedView.rootClauseView.$el)).toHaveClass('clause-true')

      # spy on the highlight patient data so we can see if the proper element is called out for highlighting.
      spyOn(@populationLogicView, 'highlightPatientData')
      $(firstADHDMedView.rootClauseView.$el).trigger('mouseover')
      # this is the first medication on the test patient
      expect(@populationLogicView.highlightPatientData).toHaveBeenCalledWith(['5babbf765cc9753f21828505'])

      # test mouseout functionality
      spyOn(@populationLogicView, 'clearHighlightPatientData')
      $(firstADHDMedView.rootClauseView.$el).trigger('mouseout')
      expect(@populationLogicView.clearHighlightPatientData).toHaveBeenCalled()
