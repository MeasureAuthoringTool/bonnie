describe 'CqlTruncatedStatementView', ->
  describe 'nominal function', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS460v0/CMS460v0.json', 'cqm_measure_data/CMS460v0/value_sets.json'
      methadone = getJSONFixture('patients/CMS460v0/MethadoneLessThan90MME_NUMERFail.json')
      opioidTest = getJSONFixture('patients/CMS460v0/Opioid_Test.json')
      @patients = new Thorax.Collections.Patients [methadone, opioidTest], parse: true
      @cqlMeasure.set('patients', @patients)
      @population = @cqlMeasure.get('populations').first()
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population)
      @populationLogicView.render()

    it 'is used for OpioidData DrugIngredients statement instead of normal clause view', ->
      drugIngredientsView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "DrugIngredients" && view.libraryName == "OpioidData")
      expect(drugIngredientsView.rootClauseView instanceof Thorax.Views.CqlTruncatedStatementView).toBe(true)

      ippView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "Initial Population" && view.libraryName == "PotentialOpioidOveruse")
      expect(ippView.rootClauseView instanceof Thorax.Views.CqlClauseView).toBe(true)

    xit 'highlights for coverage', ->
      # SKIP: This clause is not covered (any longer?) in Bonnie-v3.2
      drugIngredientsView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "DrugIngredients" && view.libraryName == "OpioidData")
      expect($(drugIngredientsView.rootClauseView.$el)).toHaveClass('clause-covered')

      # pass fake coverage data to make it uncovered
      drugIngredientsView.showCoverage({})
      expect($(drugIngredientsView.rootClauseView.$el)).toHaveClass('clause-uncovered')

    xit 'highlights for calculation', ->
      # SKIP: This clause is not true (any longer?) in Bonnie-v3.2
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
    beforeAll ->
      # lower the threshold to use the truncated statement view on more statements
      @originalClauseThreshold = Thorax.Views.CqlStatement.MAX_CLAUSE_THRESHOLD
      Thorax.Views.CqlStatement.MAX_CLAUSE_THRESHOLD = 14

    afterAll ->
      Thorax.Views.CqlStatement.MAX_CLAUSE_THRESHOLD = @originalClauseThreshold

    describe 'Encounters during Measurement Period', ->
      beforeAll ->
        jasmine.getJSONFixtures().clearCache()
        @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS460v0/CMS460v0.json', 'cqm_measure_data/CMS460v0/value_sets.json'
        methadone = getJSONFixture('patients/CMS460v0/MethadoneLessThan90MME_NUMERFail.json')
        opioidTest = getJSONFixture('patients/CMS460v0/Opioid_Test.json')
        @patients = new Thorax.Collections.Patients [methadone, opioidTest], parse: true
        @cqlMeasure.set('patients', @patients)
        @population = @cqlMeasure.get('populations').first()
        @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @cqlMeasure, patients: @cqlMeasure.get('patients'))
        @measureView = @measureLayoutView.showMeasure()
        @populationLogicView = @measureView.logicView

      xit 'uses truncated view statement returning list of entries and can request hover highlight of the list of entries', ->
        # SKIP does not have clause-true anymore
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

    xit 'uses truncated view statement returning single entry and can request hover highlight of single entry', ->
      # SKIP: Does not have clause-true anymore
      jasmine.getJSONFixtures().clearCache()
      @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS136v7/CMS136v7.json', 'cqm_measure_data/CMS136v7/value_sets.json'
      passIpp1 = getJSONFixture 'patients/CMS136v7/Pass_IPP1.json'
      passIpp2 = getJSONFixture 'patients/CMS136v7/Pass_IPP2.json'
      @patients = new Thorax.Collections.Patients [passIpp1, passIpp2], parse: true
      @cqlMeasure.set('patients', @patients)
      @population = @cqlMeasure.get('populations').first()
      @populationLogicView = new Thorax.Views.CqlPopulationLogic(model: @cqlMeasure, population: @population, highlightPatientDataEnabled: true)
      @populationLogicView.render()
      results = @population.calculate(@patients.at(0)) # Pass IPP1
      @populationLogicView.showRationale(results)
      firstADHDMedView = _.find(@populationLogicView.allStatementViews, (view) -> view.name == "First ADHD Medication Dispensed" && view.libraryName == "FollowUpCareforChildrenPrescribedADHDMedicationADD")

      # check that the correct view is being used
      expect(firstADHDMedView.rootClauseView instanceof Thorax.Views.CqlTruncatedStatementView).toBe(true)
      expect($(firstADHDMedView.rootClauseView.$el)).toHaveClass('clause-true')

      # spy on the highlight patient data so we can see if the proper element is called out for highlighting.
      spyOn(@populationLogicView, 'highlightPatientData')
      $(firstADHDMedView.rootClauseView.$el).trigger('mouseover')
      # this is the first medication on the test patient
      expect(@populationLogicView.highlightPatientData).toHaveBeenCalledWith(['5cb76e1b08fa188731afd124'])

      # test mouseout functionality
      spyOn(@populationLogicView, 'clearHighlightPatientData')
      $(firstADHDMedView.rootClauseView.$el).trigger('mouseout')
      expect(@populationLogicView.clearHighlightPatientData).toHaveBeenCalled()
