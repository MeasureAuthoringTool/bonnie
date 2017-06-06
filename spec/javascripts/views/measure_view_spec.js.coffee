describe 'MeasureView', ->
  describe 'baseline', ->
    beforeEach ->
      window.bonnieRouterCache.load('base_set')
      @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
      # Add some overlapping codes to the value sets to exercise the overlapping value sets feature
      # We add the overlapping codes after 10 non-overlapping codes to provide regression for a bug
      @vs1 = @measure.valueSets().findWhere(display_name: 'Annual Wellness Visit')
      @vs2 = @measure.valueSets().findWhere(display_name: 'Office Visit')
      for n in [1..10]
        @vs1.get('concepts').push { code: "ABC#{n}", display_name: "ABC", code_system_name: "ABC" }
        @vs2.get('concepts').push { code: "XYZ#{n}", display_name: "XYZ", code_system_name: "XYZ" }
      @vs1.get('concepts').push { code: "OVERLAP", display_name: "OVERLAP", code_system_name: "OVERLAP" }
      @vs2.get('concepts').push { code: "OVERLAP", display_name: "OVERLAP", code_system_name: "OVERLAP" }
      @patients = new Thorax.Collections.Patients getJSONFixture('records/base_set/patients.json'), parse: true
      @measure.set('patients', @patients)
      @patient = @patients.at(0)
      @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
      @measureView = @measureLayoutView.showMeasure()
      @measureView.appendTo 'body'

    afterEach ->
      @measureView.remove()

    it 'renders measure details', ->
      expect(@measureView.$el).toContainText @measure.get('title')
      expect(@measureLayoutView.$el).toContainText @measure.get('cms_id')
      expect(@measureView.$el).toContainText @measure.get('description')

    it 'renders measure populations', ->
      expect(@measureView.$('[data-toggle="tab"]')).toExist()
      expect(@measureView.$('.rationale-target')).toBeVisible()
      expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')
      @measureView.$('[data-toggle="collapse"]').not('.value_sets').click()
      expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).toHaveClass('collapsed')
      @measureView.$('[data-toggle="tab"]').not('.value_sets').last().click()
      expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')

    it 'renders value sets and codes', ->
      expect(@measureView.$('.value_sets')).toExist()
      expect(@measureView.$('.value_sets')).toBeVisible()

      expect(@measureView.$('#data_criteria')).toExist()
      expect(@measureView.$('#data_criteria')).toBeVisible()
      expect(@measureView.$('#data_criteria').find('[data-toggle="collapse"].value_sets')).toExist()
      expect(@measureView.$('#data_criteria').find('.row.collapse')).toExist()
      # should only show 10 code results at a time
      longTables = @measureView.$('#data_criteria').find('tbody').filter ->
        return $(@).children('tr').length > 10
      expect(longTables).not.toExist()

      expect(@measureView.$('#supplemental_criteria')).toExist()
      expect(@measureView.$('#supplemental_criteria')).toBeVisible()
      expect(@measureView.$('#supplemental_criteria').find('[data-toggle="collapse"].value_sets')).toExist()
      expect(@measureView.$('#supplemental_criteria').find('.row.collapse')).toExist()

      expect(@measureView.$('#overlapping_value_sets')).toBeVisible()
      expect(@measureView.$('#overlapping_value_sets').find('[data-toggle="collapse"].value_sets')).toExist()
      expect(@measureView.$('#overlapping_value_sets').find('.row.collapse')).toExist()
      expect(@measureView.$('#overlapping_value_sets')).toContainText 'OVERLAP'

      # this assertion is the opposite of below in the 'with attribute value sets' suite
      expect(@measureView.$('#attribute_criteria')).not.toExist()

      expect(@measureView.$('[data-toggle="collapse"].value_sets')).toHaveClass('collapsed')
      @measureView.$('[data-toggle="collapse"].value_sets').click()
      expect(@measureView.$('[data-toggle="collapse"].value_sets')).not.toHaveClass('collapsed')

    it 'renders patient results', ->
      expect(@measureView.$('.patient')).toExist()
      expect(@measureView.$('.toggle-result')).not.toBeVisible()
      expect(@measureView.$('.btn-show-coverage')).not.toBeVisible()
      @measureView.$('[data-call-method="expandResult"]').click()
      expect(@measureView.$('.toggle-result')).toBeVisible()
      expect(@measureView.$('.btn-show-coverage')).toBeVisible()

    it 'warns of patient history using codes not in measure', ->
      expect(@measureLayoutView.$('.missing-codes-warning')).toExist()
      expect(@measureView.$('.patient-status.status-bad').length).toBe(4)

    # makes sure the calculation percentage hasn't changed.
    # should be 33% for CMS156v2 with given test patients as of 1/4/2016
    describe '...', ->
      beforeEach (done) ->
        result = @measure.get('populations').at(0).calculate(@patient)
        waitsForAndRuns( -> result.isPopulated()
          ,
          ->
            done()
        )

      # this is currently failing because several patients were added to the base_set
      # patients json for patient_dashboard tests. The current value showing up is '89',
      # which is probably correct but not yet validated
      # TODO: refactor patient_dashboard tests to use the new infrastructure, which should
      # return the base_set patients file back to how it was.
      it 'computes coverage', ->
        expect(@measureView.$('.dial')[1]).toHaveAttr('value', '33')

  describe 'with attribute value sets', ->
    beforeEach ->
      window.measureHistorySpecLoader.load('measure_history_set/multiple_populations_set/CMS160', 'update1', 'CMS160v5', @)
      @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
      @measureView = @measureLayoutView.showMeasure()
      @measureView.appendTo 'body'

    afterEach ->
      @measureView.remove()

    it 'renders attribute value sets and codes', ->
      expect(@measureView.$('#attribute_criteria')).toExist()
      expect(@measureView.$('#attribute_criteria')).toBeVisible()
      expect(@measureView.$('#attribute_criteria').find('[data-toggle="collapse"].value_sets')).toExist()
      expect(@measureView.$('#attribute_criteria').find('.row.collapse')).toExist()

    it 'does not warn of patient history using codes not in measure', ->
      expect(@measureView.$('.missing-codes-warning')).not.toExist()
      expect(@measureView.$('.patient-status.status-bad')).not.toExist()

  describe 'with bad code tests set', ->
    beforeEach ->
      window.bonnieRouterCache.load('bad_code_checker_set')
      @measure = bonnie.measures.findWhere(cms_id: 'CMS123v6')
      @patients = new Thorax.Collections.Patients getJSONFixture('records/bad_code_checker_set/patients.json'), parse: true
      @measure.set('patients', @patients)
      @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
      @measureView = @measureLayoutView.showMeasure()
      @measureView.appendTo 'body'

    afterEach ->
      @measureView.remove()

    it 'warns of patient history using codes not in measure', ->
      expect(@measureLayoutView.$('.missing-codes-warning')).toExist()
      expect(@measureView.$('.patient-status.status-bad').length).toBe(2)

    it 'displays BAD for patient passing with a bad code', ->
      patientTitle = @measureView.$('.toggle-result-5936ccdc5cc975216200037e').prev()
      expect(patientTitle).toExist()
      expect(patientTitle.find('.patient-status.status-bad')).toExist()

    it 'displays BAD for patient failing with a bad code', ->
      patientTitle = @measureView.$('.toggle-result-5936cd345cc97521620003f6').prev()
      expect(patientTitle).toExist()
      expect(patientTitle.find('.patient-status.status-bad')).toExist()

    it 'displays PASS for patient passing with good codes', ->
      patientTitle = @measureView.$('.toggle-result-5936cc865cc975216200031c').prev()
      expect(patientTitle).toExist()
      expect(patientTitle.find('.patient-status.status-pass')).toExist()

    it 'displays FAIL for patient failing with good codes', ->
      patientTitle = @measureView.$('.toggle-result-5936ccab5cc975216200034e').prev()
      expect(patientTitle).toExist()
      expect(patientTitle.find('.patient-status.status-fail')).toExist()
