
  describe 'MeasureView', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'
      # Add some overlapping codes to the value sets to exercise the overlapping value sets feature
      # We add the overlapping codes after 10 non-overlapping codes to provide regression for a bug
      @vs1 = _.find(@measure.valueSets(), (val_set) -> val_set.display_name is 'Bipolar Disorder')
      @vs2 = _.find(@measure.valueSets(), (val_set) -> val_set.display_name is 'Dysthymia')
      for n in [1..10]
        @vs1.concepts.push { code: "ABC#{n}", display_name: "ABC", code_system_name: "ABC" }
        @vs2.concepts.push { code: "XYZ#{n}", display_name: "XYZ", code_system_name: "XYZ" }
      @vs1.concepts.push { code: "OVERLAP", display_name: "OVERLAP", code_system_name: "OVERLAP" }
      @vs2.concepts.push { code: "OVERLAP", display_name: "OVERLAP", code_system_name: "OVERLAP" }
      patientsJSON = [getJSONFixture('patients/CMS160v6/Expired_DENEX.json'), getJSONFixture('patients/CMS160v6/Pass_NUM2.json')]
      @patients = new Thorax.Collections.Patients patientsJSON, parse: true
      @measure.set('patients', @patients)
      @patient = @patients.at(0)
      @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
      @measureView = @measureLayoutView.showMeasure()
      @measureView.appendTo 'body'
      @cqlMeasureValueSetsView = new Thorax.Views.MeasureValueSets(model: @measure, measure: @measure, patients: @patients)
      @cqlMeasureValueSetsView.appendTo 'body'

    afterAll ->
      # Remove the 11 extra codes that were added for value set overlap testing
      @vs1.concepts.splice(-11, 11)
      @vs2.concepts.splice(-11, 11)
      @measureView.remove()
      @cqlMeasureValueSetsView.remove()

    # makes sure the calculation percentage hasn't changed.
    # should be 33% for CMS160v6 with given test patients as of 2018-03-29
    describe '...', ->
      beforeEach (done) ->
        result = @measure.get('populations').at(0).calculate(@patient)
        waitsForAndRuns( -> result.isPopulated()
          ,
          ->
            done()
        )
      it 'computes coverage', ->
        expect(@measureView.$('.dial')[1]).toHaveAttr('value', '33')

    it 'shows measurement period indicator', ->
      expect(@measureLayoutView.$('[data-call-method="changeMeasurementPeriod"]')).toExist()

    it 'shows measurement period year', ->
      expect(@measureLayoutView.$('[data-call-method="changeMeasurementPeriod"]')).toContainText('2012')

    it 'changeMeasurementPeriod creates the MeasurementPeriod View', ->
      spyOn(Thorax.Views.MeasurementPeriod.prototype, 'initialize')
      @measureLayoutView.changeMeasurementPeriod(new Event('click'))
      expect(Thorax.Views.MeasurementPeriod.prototype.initialize).toHaveBeenCalled()

    it 'should not open measure view for non existent measure', ->
      spyOn(bonnie,'showPageNotFound')
      bonnie.renderMeasure('non_existant_hqmf_set_id')
      expect(bonnie.showPageNotFound).toHaveBeenCalled()

    it 'renders measure details', ->
      expect(@measureView.$el).toContainText @measure.get('cqmMeasure').title
      expect(@measureLayoutView.$el).toContainText @measure.get('cqmMeasure').cms_id
      expect(@measureView.$el).toContainText @measure.get('cqmMeasure').description


    it 'renders patient results', ->
      expect(@measureView.$('.patient')).toExist()
      expect(@measureView.$('.toggle-result')).not.toBeVisible()
      expect(@measureView.$('.btn-show-coverage')).not.toBeVisible()
      @measureView.$('[data-call-method="expandResult"]').click()
      expect(@measureView.$('.toggle-result')).toBeVisible()
      expect(@measureView.$('.btn-show-coverage')).toBeVisible()

    it 'renders measure populations', ->
      expect(@measureView.$('[data-toggle="tab"]')).toExist()
      expect(@measureView.$('.rationale-target')).toBeVisible()
      expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')
      @measureView.$('[data-toggle="collapse"]').not('.value_sets').click()
      expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).toHaveClass('collapsed')
      @measureView.$('[data-toggle="tab"]').not('.value_sets').last().click()
      expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')


  describe 'CQL', ->
    beforeAll ->
      @bonnie_measures_old = bonnie.measures
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqlMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS134v6/CMS134v6.json', 'cqm_measure_data/CMS134v6/value_sets.json'
      @measureWithError = loadMeasureWithValueSets 'cqm_measure_data/CMS136v7/CMS136v7.json', 'cqm_measure_data/CMS136v7/value_sets.json'
      bonnie.measures.add @cqlMeasure
      bonnie.measures.add @measureWithError

      @cqlPatients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS134v6/Elements_Test.json')], parse: true
      @patientsWithError = new Thorax.Collections.Patients [getJSONFixture('patients/CMS136v7/Pass_IPP1.json')], parse: true

      @cqlMeasureValueSetsView = new Thorax.Views.MeasureValueSets(model: @cqlMeasure, measure: @cqlMeasure, patients: @cqlPatients)
      @cqlMeasureValueSetsView.appendTo 'body'
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      @measureView.appendTo 'body'

    afterAll ->
      bonnie.measures = @bonnie_measures_old
      @cqlMeasureValueSetsView.remove()
      @measureView.remove()

    # TODO: Commented out in PR#1481 as it was failing in previous builds, and unrelated to MAT-1308
    xit 'has QRDA export button disabled', ->
      expect(@measureView.$("button[data-call-method=exportQrdaPatients]")).toBeDisabled()

    it 'does not show SDEs for older measure', ->
      expect(@measureView.$(".sde-defines")).not.toExist()

    it 'can click excel export button', ->
      spyOn($, 'fileDownload').and.callFake () ->
        expect(arguments[0]).toEqual('patients/excel_export')
      @measureView.$("button[data-call-method=exportExcelPatients]").click()
      expect($.fileDownload).toHaveBeenCalled()

    it 'can click share patients button', ->
      bonnie.isPortfolio = true
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      @measureView.appendTo 'body'
      spyOn(@measureView, 'sharePatients')
      @measureView.$("button[data-call-method=sharePatients]").click()
      expect(@measureView.sharePatients).toHaveBeenCalled()
      @measureView.remove()
      bonnie.isPortfolio = false

    it 'clicks on convert to fhir patients button', ->
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      @measureView.appendTo 'body'
      expect(@measureView.$("button[data-call-method=convertQdmPatients]")).toBeDisabled()
      #TODO: Update once we enable conversion
      # spyOn($, 'fileDownload').and.callFake () ->
      # expect(arguments[0]).toEqual('patients/convert_patients?hqmf_set_id=7B2A9277-43DA-4D99-9BEE-6AC271A07747')
      # @measureView.$("button[data-call-method=convertQdmPatients]").click()
      # expect($.fileDownload).toHaveBeenCalled()
      # @measureView.remove()

    it 'can remove patient belonging to multiple measures', ->
      secondMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS10v0/CMS10v0.json', 'cqm_measure_data/CMS10v0/value_sets.json'
      bonnie.measures.add secondMeasure
      patient = @cqlPatients.models[0]
      patient.attributes.cqmPatient.measure_ids.push(secondMeasure.attributes.cqmMeasure.hqmf_set_id)
      expect(patient.attributes.cqmPatient.measure_ids.length).toEqual(2)
      @measureView.populationCalculation.adjustMeasureIds(patient, secondMeasure.attributes.cqmMeasure.hqmf_set_id, null)
      expect(patient.attributes.cqmPatient.measure_ids.length).toEqual(1)

    it 'share patients button not available for non-portfolio users', ->
      @measureView = new Thorax.Views.Measure(model: @cqlMeasure, patients: @cqlPatients, populations: @cqlMeasure.get('populations'), population: @cqlMeasure.get('displayedPopulation'))
      @measureView.appendTo 'body'
      expect(@measureView.$("button[data-call-method=sharePatients]")).not.toExist()
      @measureView.remove()

    it 'shows error dialog if cql calculation error occurs', ->
      spyOn(bonnie, 'showError')
      @measureWithError.get('populations').at(0).calculate(@patientsWithError.at(0))
      expect(bonnie.showError).toHaveBeenCalled()

    it 'shows error dialog if error occurs in batch cql calculation', ->
      spyOn(bonnie, 'showError')
      bonnie.cqm_calculator.calculateAll @measureWithError, @patientsWithError
      expect(bonnie.showError).toHaveBeenCalled()

    describe 'value sets view', ->
      it 'exists', ->
        expect(@cqlMeasureValueSetsView.$('.value_sets')).toExist()
        expect(@cqlMeasureValueSetsView.$('.value_sets')).toBeVisible()

      it 'has the right number of value sets', ->
        expect(@cqlMeasureValueSetsView.terminology.length).toEqual(33)
        expect(@cqlMeasureValueSetsView.overlappingValueSets.length).toEqual(12)

      it 'renders direct reference codes', ->
        expect(@cqlMeasureValueSetsView.$('#terminology')).toContainText 'Direct Reference Code'


      it 'renders terminology section', ->
        expect(@cqlMeasureValueSetsView.$('#terminology')).toExist()
        expect(@cqlMeasureValueSetsView.$('#terminology')).toBeVisible()
        expect(@cqlMeasureValueSetsView.$('#terminology')).toContainText 'Annual Wellness Visit'

      it 'renders overlapping value sets section', ->
        expect(@cqlMeasureValueSetsView.$('#overlapping_value_sets')).toExist()
        expect(@cqlMeasureValueSetsView.$('#overlapping_value_sets')).toBeVisible()
        expect(@cqlMeasureValueSetsView.$('#overlapping_value_sets').find('[data-toggle="collapse"].value_sets')).toExist()
        expect(@cqlMeasureValueSetsView.$('#overlapping_value_sets').find('.row.collapse')).toExist()
        expect(@cqlMeasureValueSetsView.$('#overlapping_value_sets')).toContainText 'Glomerulonephritis and Nephrotic Syndrome'

      it 'has terminology section', ->
        expect(@cqlMeasureValueSetsView.$('#terminology')).toExist()
        expect(@cqlMeasureValueSetsView.$('#terminology')).toBeVisible()
        expect(@cqlMeasureValueSetsView.$('#terminology').find('[data-toggle="collapse"].value_sets')).toExist()
        expect(@cqlMeasureValueSetsView.$('#terminology').find('.row.collapse')).toExist()

      it 'shows only 10 codes at a time', ->
        longTables = @cqlMeasureValueSetsView.$('#terminology').find('tbody').filter ->
          return $(@).children('tr').length > 10
        expect(longTables).not.toExist()

      it 'uncollapses when clicked', ->
        expect(@cqlMeasureValueSetsView.$('[data-toggle="collapse"].value_sets')).toHaveClass('collapsed')
        @cqlMeasureValueSetsView.$('[data-toggle="collapse"].value_sets').click()
        expect(@cqlMeasureValueSetsView.$('[data-toggle="collapse"].value_sets')).not.toHaveClass('collapsed')

      describe 'overlapping value sets', ->
        beforeEach ->
          @cqlOverlapMeasureValueSetsView = new Thorax.Views.MeasureValueSets(model: @cqlMeasure, measure: @cqlMeasure, patients: @cqlPatients)
          # reset initial overlapping value sets collection
          @cqlOverlapMeasureValueSetsView.overlappingValueSets = new Thorax.Collections.ValueSetsCollection([])
          @cqlOverlapMeasureValueSetsView.overlappingValueSets.comparator = (vs) -> [vs.get('name1'), vs.get('oid1')]
          @addValueSet = (name, oid, cid, codes) ->
            valueSet = { name: name, oid: oid, codes: codes, cid: cid}
            @cqlOverlapMeasureValueSetsView.addSummaryValueSet(valueSet, oid, cid, name, codes)

          @getCodesAndResetSummaryValueSets = (index) ->
            @cqlOverlapMeasureValueSetsView.summaryValueSets = [ @cqlOverlapMeasureValueSetsView.summaryValueSets[index] ]
            codes = @cqlOverlapMeasureValueSetsView.summaryValueSets[0].codes
            @cqlOverlapMeasureValueSetsView.summaryValueSets = []
            codes

        it 'behaves properly with 3 overlaps with single code', ->
          # grab codes of length 1 from a summary value set then reset summary value sets
          codes = @getCodesAndResetSummaryValueSets(22) # Vascular Access for Dialysis

          # add 3 valuesets with an overlapping code to summary valuesets
          @addValueSet('dup1', '1.2.3.4.5', 'c12345', codes)
          @addValueSet('dup2', '5.4.3.2.1', 'c54321', codes)
          @addValueSet('dup3', '3.2.1.5.4', 'c32154', codes)

          # repopulate overlapping value sets
          @cqlOverlapMeasureValueSetsView.findOverlappingValueSets()

          # The matches are 1-2, 1-3, 2-3, 2-1, 3-1, 3-2 which is (2 * (n choose 2))
          expect(@cqlOverlapMeasureValueSetsView.overlappingValueSets.length).toEqual(6)
          for child in @cqlOverlapMeasureValueSetsView.overlappingValueSets.models
            expect(child.attributes.codes.length).toEqual(10)

        it 'behaves properly with 3 overlaps with multiple codes', ->
          # grab codes of length 10 from a summary value set then reset summary value sets
          codes = @getCodesAndResetSummaryValueSets(16) # Office Visit

          # add 3 valuesets with an overlapping code to summary valuesets
          @addValueSet('dup1', '1.2.3.4.5', 'c12345', codes)
          @addValueSet('dup2', '5.4.3.2.1', 'c54321', codes)
          @addValueSet('dup3', '3.2.1.5.4', 'c32154', codes)

          # repopulate overlapping value sets
          @cqlOverlapMeasureValueSetsView.findOverlappingValueSets()

          # The matches are 1-2, 1-3, 2-3, 2-1, 3-1, 3-2 which is (2 * (n choose 2))
          expect(@cqlOverlapMeasureValueSetsView.overlappingValueSets.length).toEqual(6)
          for child in @cqlOverlapMeasureValueSetsView.overlappingValueSets.models
            expect(child.attributes.codes.length).toEqual(10)

        it 'behaves properly with 4 overlaps with single code', ->
          # grab codes of length 1 from a summary value set then reset summary value sets
          codes = @getCodesAndResetSummaryValueSets(22) # Vascular Access for Dialysis

          @addValueSet('dup1', '1.2.3.4.5', 'c12345', codes)
          @addValueSet('dup2', '5.4.3.2.1', 'c54321', codes)
          @addValueSet('dup3', '3.2.1.5.4', 'c32154', codes)
          @addValueSet('dup4', '2.1.5.4.3', 'c21543:', codes)

          # repopulate overlapping value sets
          @cqlOverlapMeasureValueSetsView.findOverlappingValueSets()

          # (2 * (4 choose 2)) = 12
          expect(@cqlOverlapMeasureValueSetsView.overlappingValueSets.length).toEqual(12)
          for child in @cqlOverlapMeasureValueSetsView.overlappingValueSets.models
            expect(child.attributes.codes.length).toEqual(10)

  describe 'Hybrid Measures', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS529v0/CMS529v0.json', 'cqm_measure_data/CMS529v0/value_sets.json'
      bonnie.measures.add @measure
      @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS529v0/Pass_IPP_DENOM_NUMER.json')], parse: true
      @measureView = new Thorax.Views.Measure(model: @measure, patients: @patients, populations: @measure.get('populations'), population: @measure.get('displayedPopulation'))
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    it 'display SDE section', ->
      expect(@measureView.$('.sde-defines')).toExist()

  describe 'Excel Export: Episode based ratio measure', ->
    beforeAll ->
      jasmine.getJSONFixtures().clearCache()
      bonnie.measures = new Thorax.Collections.Measures()
      @cqmMeasure = loadMeasureWithValueSets 'cqm_measure_data/CMS871v2/CMS871v2.json', 'cqm_measure_data/CMS871v2/value_sets.json'
      @population = @cqmMeasure.get('populations').at(0)
      patient = getJSONFixture 'patients/CMS871v2/patient_1.json'
      @cqmPatients = new Thorax.Collections.Patients [patient], parse: true
      @cqmMeasure.set('patients', @cqmPatients)
      @measureView = new Thorax.Views.Measure(model: @cqmMeasure, patients: @cqmPatients, populations: @cqmMeasure.get('populations'), population: @cqmMeasure.get('displayedPopulation'))
      bonnie.measures.add @cqmMeasure
      @measureView.appendTo 'body'

    afterAll ->
      @measureView.remove()

    it 'exports patient in excel', ->
      spyOn($, 'fileDownload').and.callFake () ->
        expect(arguments[0]).toEqual('patients/excel_export')
      @measureView.$("button[data-call-method=exportExcelPatients]").click()
      expect($.fileDownload).toHaveBeenCalled()
