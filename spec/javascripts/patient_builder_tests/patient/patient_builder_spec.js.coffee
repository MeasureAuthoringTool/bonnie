describe 'PatientBuilderView', ->

  beforeEach (done) ->
    jasmine.DEFAULT_TIMEOUT_INTERVAL = 20000;
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure 'fhir_measure_data/CMS104_eoc.json'
    @patients = new Thorax.Collections.Patients [getJSONFixture('fhir_patients/CMS104_eoc/mickey_mouse.json')], parse: true
    @patient = @patients.models[0]
    @bonnie_measures_old = bonnie.measures
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add @measure
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    @patientBuilder.render()
    spyOn(@patientBuilder.model, 'materialize')
    spyOn(@patientBuilder.originalModel, 'save').and.returnValue(true)
    @$el = @patientBuilder.$el
    setTimeout(() ->
      try
        done()
      catch err
        done.fail(err)
    , 1)

  afterEach ->
    bonnie.measures = @bonnie_measures_old

  it 'should not open patient builder for non existent measure', ->
    spyOn(bonnie,'showPageNotFound')
    bonnie.showPageNotFound.calls.reset()
    bonnie.renderPatientBuilder('non_existant_set_id', @patient.id)
    expect(bonnie.showPageNotFound).toHaveBeenCalled()

  it 'should set the main view when calling showPageNotFound', ->
    spyOn(bonnie.mainView,'setView')
    bonnie.renderPatientBuilder('non_existant_set_id', @patient.id)
    expect(bonnie.mainView.setView).toHaveBeenCalled()

  it 'renders the builder correctly', ->
    expect(@$el.find(":input[name='first']")).toHaveValue @patient.getFirstName()
    expect(@$el.find(":input[name='last']")).toHaveValue @patient.getLastName()
    expect(@$el.find(":input[name='birthdate']")).toHaveValue @patient.getBirthDate()
    expect(@$el.find(":input[name='deathtime']")).toHaveValue @patient.getDeathTime()
    expect(@$el.find(":input[name='notes']")).toHaveValue @patient.getNotes()
    # expect(@patientBuilder.html()).not.toContainText "Warning: There are elements in the Patient History that do not use any codes from this measure's value sets:"

  it 'displays a warning if codes on dataElements do not exist on measure', ->
    @measure.attributes.cqmValueSets = []
    patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
    patientBuilder.render()
    expect(patientBuilder.html()).toContainText "Warning: There are elements in the Patient History that do not use any codes from this measure's value sets:"

#   it 'does not display compare patient results button when there is no history', ->
#     expect(@patientBuilder.$('button[data-call-method=showCompare]:first')).not.toExist()

  it "displays warning if patient is deceased, but the measure does not contain the associated value set code.  Warning goes away on setting deceased to false", ->
    jasmine.getJSONFixtures().clearCache()
    undead_measure = loadFhirMeasure 'fhir_measure_data/BonnieCohort.json' # no dead code
    dead_patients = new Thorax.Collections.Patients [getJSONFixture('fhir_patients/BonnieCohort/dead_test.json')], parse: true
    dead_patient = dead_patients.models[0]
    @bonnie_measures_old = bonnie.measures
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add @measure
    patientBuilder = new Thorax.Views.PatientBuilder(model: dead_patient, measure: undead_measure, patients: dead_patients)
    patientBuilder.render()
    expect(patientBuilder.html()).toContainText "Patient Characteristic Expired: Dead (finding)"
    patientBuilder.$('input[type=checkbox][name=expired]:first').click()
    expect(patientBuilder.html()).not.toContainText "Patient Characteristic Expired: Dead (finding)"

  it "toggles patient expiration correctly", ->
    measure = loadFhirMeasure 'fhir_measure_data/CMS1010V0.json'
    livingJohnSmith = getJSONFixture('fhir_patients/CMS1010V0/john_smith.json')
    delete livingJohnSmith.fhir_patient.deceasedDateTime
    patients = new Thorax.Collections.Patients [livingJohnSmith], parse: true
    patient = patients.models[0]
    bonnie_measures_old = bonnie.measures
    bonnie.measures = new Thorax.Collections.Measures()
    bonnie.measures.add measure
    patientBuilder = new Thorax.Views.PatientBuilder(model: patient, measure: measure, patients: patients)
    patientBuilder.render()
    spyOn(patientBuilder.model, 'materialize')
    spyOn(patientBuilder.originalModel, 'save').and.returnValue(true)
    patientBuilder.appendTo 'body'

    # Press deceased check box and enter death date
    patientBuilder.$('input[type=checkbox][name=expired]:first').click()
    patientBuilder.$('input[name=deathdate]').val('01/02/1994')
    patientBuilder.$('input[name=deathtime]').val('1:15 PM')
    patientBuilder.$("button[data-call-method=save]").click()
    expect(patientBuilder.model.get('expired')).toEqual true
    expect(patientBuilder.model.get('deathdate')).toEqual '01/02/1994'
    expect(patientBuilder.model.get('deathtime')).toEqual "1:15 PM"
    expiredElement = patientBuilder.model.get('cqmPatient').fhir_patient.deceased
    expect(expiredElement.value).toEqual '1994-01-02T13:15:00.000Z'
    # Remove deathdate from patient
    patientBuilder.$('input[type=checkbox][name=expired]:first').click()
    patientBuilder.$("button[data-call-method=save]").click()
    expect(patientBuilder.model.get('expired')).toEqual false
    expect(patientBuilder.model.get('deathdate')).toEqual undefined
    expect(patientBuilder.model.get('deathtime')).toEqual undefined
    expiredElement = patientBuilder.model.get('cqmPatient').fhir_patient.deceased
    expect(expiredElement.value).toEqual false
    patientBuilder.remove()

  describe "setting basic attributes and saving", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.$(':input[name=last]').val("LAST NAME")
      @patientBuilder.$(':input[name=first]').val("FIRST NAME")
      @patientBuilder.$('select[name=gender]').val('female')
      @patientBuilder.$(':input[name=birthdate]').val('01/02/1993')
      @patientBuilder.$(':input[name=birthtime]').val('1:15 PM')
      @patientBuilder.$('select[name=race]').val('2131-1')
      @patientBuilder.$('select[name=ethnicity]').val('2135-2')
      @patientBuilder.$(':input[name=notes]').val('EXAMPLE NOTES FOR TEST')
      @patientBuilder.$("button[data-call-method=save]").click()

    it "dynamically loads race, ethnicity, and gender codes from measure", ->
      expect(@patientBuilder.$('select[name=race]')[0].options.length).toEqual 6
      expect(@patientBuilder.$('select[name=ethnicity]')[0].options.length).toEqual 2
      expect(@patientBuilder.$('select[name=gender]')[0].options.length).toEqual 4

    it "serializes the attributes correctly", ->
      thoraxPatient = @patientBuilder.model
      fhirPatient = thoraxPatient.get('cqmPatient').fhir_patient
      expect(fhirPatient.name[0].family.value).toEqual 'LAST NAME'
      expect(fhirPatient.name[0].given[0].value).toEqual 'FIRST NAME'
      # If the measure doesn't have birthDate as a data criteria, the patient is forced to have one without a code
      expect(fhirPatient.birthDate).not.toBeUndefined()
      expect(fhirPatient.birthDate.value).toEqual "1993-01-02"
      expect(thoraxPatient.getBirthDate()).toEqual '01/02/1993'
      expect(fhirPatient.deceased.value).toEqual "2020-09-10T08:00:00.000Z"
      expect(thoraxPatient.getDeathDate()).toEqual '09/10/2020'
      expect(thoraxPatient.getDeathTime()).toEqual '8:00 AM'
      expect(thoraxPatient.getNotes()).toEqual 'EXAMPLE NOTES FOR TEST'
      expect(thoraxPatient.getGender().display).toEqual 'female'
      expect(fhirPatient.gender.value).toEqual 'female'

      raceElement = (fhirPatient.extension.find (ext) -> ext.url.value == "http://hl7.org/fhir/us/core/StructureDefinition/us-core-race")
      expect(raceElement.extension[0].value.code.value).toEqual '2131-1'
      expect(raceElement.extension[0].value.display.value).toEqual 'Other Race'
      expect(raceElement.extension[0].value.system.value).toEqual 'urn:oid:2.16.840.1.113883.6.238'
      expect(raceElement.extension[0].value.userSelected.value).toEqual true

      ethnicityElement = (fhirPatient.extension.find (ext) -> ext.url.value == "http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity")
      expect(ethnicityElement.extension[0].value.code.value).toEqual '2135-2'
      expect(ethnicityElement.extension[0].value.display.value).toEqual 'Hispanic or Latino'
      expect(ethnicityElement.extension[0].value.system.value).toEqual 'urn:oid:2.16.840.1.113883.6.238'
      expect(ethnicityElement.extension[0].value.userSelected.value).toEqual true

    it "displays correct values on the UI after saving", ->
      expect(@patientBuilder.$(':input[name=last]')[0].value).toEqual 'LAST NAME'
      expect(@patientBuilder.$(':input[name=first]')[0].value).toEqual 'FIRST NAME'
      expect(@patientBuilder.$(':input[name=birthdate]')[0].value).toEqual '01/02/1993'
      expect(@patientBuilder.$(':input[name=notes]')[0].value).toEqual 'EXAMPLE NOTES FOR TEST'
      expect(@patientBuilder.$('select[name=race]')[0].value).toEqual '2131-1'
      expect(@patientBuilder.$('select[name=ethnicity]')[0].value).toEqual '2135-2'
      expect(@patientBuilder.$('select[name=gender]')[0].value).toEqual 'female'

    it "tries to save the patient correctly", ->
      expect(@patientBuilder.originalModel.save).toHaveBeenCalled()

    afterEach -> @patientBuilder.remove()

  describe "adding encounters to patient", ->
    beforeEach ->
      @patientBuilder.appendTo 'body'
      @patientBuilder.render()
      # simulate dragging an encounter onto the patient
      @addEncounter = (position, targetSelector) ->
        $('.panel-title').click() # Expand the criteria to make draggables visible
        criteria = @$el.find(".draggable:eq(#{position})").draggable()
        target = @$el.find(targetSelector)
        targetView = target.view()
        # We used to simulate a drag, but that had issues with different viewport sizes, so instead we just
        # directly call the appropriate drop event handler
        if targetView.dropCriteria
          target.view().dropCriteria({ target: target }, { draggable: criteria })
        else
          target.view().drop({ target: target }, { draggable: criteria })

    it "adds data criteria to model when dragged", ->
      # force materialize to get any patient characteristics that should exist added
      @patientBuilder.materialize();
      initialDataElementCount = @patientBuilder.model.get('cqmPatient').data_elements.length
      # droppable 1 is encounter
      @addEncounter 1, '.criteria-data.droppable:first'
      expect(@patientBuilder.model.get('cqmPatient').data_elements.length).toEqual(initialDataElementCount + 1)

    it "has a default date authoredOn primary timing attributes", ->
      date = @patientBuilder.model.get('source_data_criteria').first().get('dataElement').fhir_resource['authoredOn']
      expect(date.value).toBeDefined()

    it "acquires the authoredOn datetime of the drop target when dropping on an existing criteria", ->
      date = @patientBuilder.model.get('source_data_criteria').first().get('dataElement').fhir_resource['authoredOn']
      # droppable 3 is encounter
      @addEncounter 3, '.criteria-data.droppable:first'
      droppedResource = @patientBuilder.model.get('source_data_criteria').last().get('dataElement').fhir_resource
      expect(droppedResource['period'].start.value).toEqual date.value
      endDate = cqm.models.CQL.DateTime.fromJSDate(new Date(date.value), 0).add(15, cqm.models.CQL.DateTime.Unit.MINUTE).toString()
      expect(droppedResource['period'].end.value).toEqual endDate

    it "acquires the authoredOn datetime of the drop target when dropping on an existing criteria even datetime is null", ->
      @patientBuilder.model.get('source_data_criteria').first().get('dataElement').fhir_resource['authoredOn'] = null
      # droppable 3 is encounter
      @addEncounter 3, '.criteria-data.droppable:first'
      droppedResource = @patientBuilder.model.get('source_data_criteria').last().get('dataElement').fhir_resource
      expect(droppedResource['period']).toBe null

    afterEach -> @patientBuilder.remove()

  describe "setting expected values for patient based measure", ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      measure = loadFhirMeasure 'fhir_measures/EXM130/EXM130Test.json'
      patientsJSON = []
      patientsJSON.push(getJSONFixture('fhir_patients/EXM130/IPP_DENOM_Pass_Test.json'))
      patients = new Thorax.Collections.Patients patientsJSON, parse: true
      @patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: measure)
      @patientBuilder.appendTo 'body'
      @selectPopulationEV = (population, save=true) ->
        @patientBuilder.$("input[type=checkbox][name=#{population}]:first").click()
        @patientBuilder.$("button.btn-primary[data-call-method=save]:first").click() if save

    afterEach -> @patientBuilder.remove()

    it "auto unselects DENOM and IPP when IPP is unselected", ->
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 0
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto selects DENOM and IPP when NUMER is selected", ->
      @selectPopulationEV('NUMER', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 1

    it "auto unselects DENOM when IPP is unselected", ->
      @selectPopulationEV('DENOM', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto unselects DENOM and NUMER when IPP is unselected", ->
      @selectPopulationEV('NUMER', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto selects DENOM and IPP when NUMER is selected", ->
      @selectPopulationEV('NUMER', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 1
      expect(expectedValues.get('DENOM')).toEqual 1
      expect(expectedValues.get('NUMER')).toEqual 1

    it "auto unselects DENOM when IPP is unselected", ->
      @selectPopulationEV('DENOM', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

    it "auto unselects DENOM and NUMER when IPP is unselected", ->
      @selectPopulationEV('NUMER', false)
      @selectPopulationEV('IPP', true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('DENOM')).toEqual 0
      expect(expectedValues.get('NUMER')).toEqual 0

  describe "setting expected values for CV measure", ->
    beforeEach ->
      jasmine.getJSONFixtures().clearCache()
      cqlMeasure = loadFhirMeasure 'fhir_measures/CMS111/CMS111.json'
      patientsJSON = []
      patientsJSON.push(getJSONFixture('fhir_patients/CMS111/IPP_MSRPOPL_MSRPOPEX_NO_OBS.json'))
      patients = new Thorax.Collections.Patients patientsJSON, parse: true
      @patientBuilder = new Thorax.Views.PatientBuilder(model: patients.first(), measure: cqlMeasure)
      @patientBuilder.appendTo 'body'
      @setPopulationVal = (population, value=0, save=true) ->
        @patientBuilder.$("input[type=number][name=#{population}]:first").val(value).change()
        @patientBuilder.$("button.btn-primary[data-call-method=save]:first").click() if save

    afterEach -> @patientBuilder.remove()

    it "IPP removal removes membership of all populations in CV measures", ->
      @setPopulationVal('IPP', 0, true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('MSRPOPL')).toEqual 0
      expect(expectedValues.get('MSRPOPLEX')).toEqual 0
      expect(expectedValues.get('OBSERV')).toBeUndefined()

    it "MSRPOPLEX addition adds membership to all populations in CV measures", ->
      @setPopulationVal('MSRPOPLEX', 4, true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 4
      expect(expectedValues.get('MSRPOPL')).toEqual 4
      expect(expectedValues.get('MSRPOPLEX')).toEqual 4
      # 4 MSRPOPLEX and 4 MSRPOPL means there should be no OBSERVs
      expect(expectedValues.get('OBSERV')).toBeUndefined()

    it "MSRPOPLEX addition and removal adds and removes OBSERVs in CV measures", ->
      # First set IPP to 0 to zero out all population membership
      @setPopulationVal('IPP', 0, true)
      @setPopulationVal('MSRPOPLEX', 3, true)
      @setPopulationVal('MSRPOPL', 4, true)
      expectedValues = @patientBuilder.model.get('expected_values').findWhere(population_index: 0)
      expect(expectedValues.get('IPP')).toEqual 4
      expect(expectedValues.get('MSRPOPL')).toEqual 4
      expect(expectedValues.get('MSRPOPLEX')).toEqual 3
      # 4 MSRPOPL and 3 MSRPOPLEX means there should be 1 OBSERVs
      expect(expectedValues.get('OBSERV').length).toEqual 1
      @setPopulationVal('MSRPOPL', 6, true)
      expect(expectedValues.get('IPP')).toEqual 6
      expect(expectedValues.get('MSRPOPL')).toEqual 6
      expect(expectedValues.get('MSRPOPLEX')).toEqual 3
      # 6 MSRPOPL and 3 MSRPOPLEX means there should be 3 OBSERVs
      expect(expectedValues.get('OBSERV').length).toEqual 3
      # Should remove all observs
      @setPopulationVal('MSRPOPLEX', 6, true)
      expect(expectedValues.get('IPP')).toEqual 6
      expect(expectedValues.get('MSRPOPL')).toEqual 6
      expect(expectedValues.get('MSRPOPLEX')).toEqual 6
      # 6 MSRPOPLEX and 6 MSRPOPL means there should be no OBSERVs
      expect(expectedValues.get('OBSERV')).toBeUndefined()
      # set IPP to 0, should zero out all populations
      @setPopulationVal('IPP', 0, true)
      expect(expectedValues.get('IPP')).toEqual 0
      expect(expectedValues.get('MSRPOPL')).toEqual 0
      expect(expectedValues.get('MSRPOPLEX')).toEqual 0
      expect(expectedValues.get('OBSERV')).toBeUndefined()

#   describe "editing basic attributes of a criteria", ->
#     # SKIP: This should be re-enabled with patient builder timing work
#     beforeEach ->
#       @patientBuilder.appendTo 'body'
#       # need to be specific with the query to select one of the data criteria with a period.
#       # this is due to QDM 5.0 changes which make several data criteria only have an author time.
#       $dataCriteria = @patientBuilder.$('div.patient-criteria:contains(Diagnosis: Diabetes):first')
#       $dataCriteria.find('button[data-call-method=toggleDetails]:first').click()
#       $dataCriteria.find(':input[name=start_date]:first').val('01/1/2012')
#       $dataCriteria.find(':input[name=start_time]:first').val('3:33')
#       # verify DOM as well
#       expect($dataCriteria.find(':input[name=end_date]:first')).toBeDisabled()
#       expect($dataCriteria.find(':input[name=end_time]:first')).toBeDisabled()
#       @patientBuilder.$("button[data-call-method=save]").click()

#     xit "serializes the attributes correctly", ->
#       # SKIP: Re-endable with Patient Builder Timing Attributes
#       dataCriteria = this.patient.get('cqmPatient').qdmPatient.conditions()[0]
#       expect(dataCriteria.get('prevelancePeriod').low).toEqual moment.utc('01/1/2012 3:33', 'L LT').format('X') * 1000
#       expect(dataCriteria.get('prevelancePeriod').high).toBeUndefined()

#     afterEach -> @patientBuilder.remove()

#   describe "setting and unsetting a criteria as not performed", ->
#     beforeEach ->
#       @patientBuilder.appendTo 'body'

#     it "does not serialize negationRationale for element that can't be negated", ->
#       # 0th source_data_criteria is a diagnosis and therefore cannot have a negation and will not contain the negation
#       expect(@patientBuilder.model.get('source_data_criteria').at(0).get('qdmDataElement').negationRationale).toEqual undefined

#     it "serializes negationRationale to null for element that can be negated but isnt", ->
#       # 1st source_data_criteria is an encounter that is not negated
#       expect(@patientBuilder.model.get('source_data_criteria').at(1).get('qdmDataElement').negationRationale).toEqual null

#     it "serializes negationRationale for element that is negated", ->
#       # The 2nd source_data_criteria is an intervention with negationRationale set to 'Emergency Department Visit' code:
#       expect(@patientBuilder.model.get('source_data_criteria').at(2).get('qdmDataElement').negationRationale.code).toEqual '4525004'
#       expect(@patientBuilder.model.get('source_data_criteria').at(2).get('qdmDataElement').negationRationale.system).toEqual '2.16.840.1.113883.6.96'

#     it "toggles negations correctly", ->
#       @patientBuilder.$('.criteria-data').children().toggleClass('hide')
#       expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation')).toBe false
#       expect(@patientBuilder.model.get('source_data_criteria').at(1).get('qdmDataElement').negationRationale).toBeNull()
#       @patientBuilder.$('input[name=negation]:first').click()
#       @patientBuilder.$('select[name="valueset"]').val('drc-99a051cdb6879ebe3d81f5c15cecbf4157040a6e1c12c711bacb61246e5a0d61').change()
#       # No need to select code for test, one is selected by default
#       expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation')).toBe true
#       expect(@patientBuilder.model.get('source_data_criteria').at(1).get('qdmDataElement').negationRationale).toExist()
#       @patientBuilder.$('input[name=negation]:first').click()
#       expect(@patientBuilder.model.get('source_data_criteria').at(1).get('negation')).toBe false
#       expect(@patientBuilder.model.get('source_data_criteria').at(1).get('qdmDataElement').negationRationale).toBeNull()

#     afterEach -> @patientBuilder.remove()

#   describe "blurring basic fields of a criteria", ->
#     beforeEach ->
#       @patientBuilder.appendTo 'body'
#       @patientBuilder.$(':text[name=start_date]:first').blur()

#     xit "materializes the patient", ->
#       # SKIP: Re-enable with Patient Builder Work
#       expect(@patientBuilder.model.materialize).toHaveBeenCalled()
#       expect(@patientBuilder.model.materialize.calls.count()).toEqual 1

#     afterEach -> @patientBuilder.remove()

#   describe "adding codes to an encounter", ->
#     beforeEach ->
#       @patientBuilder.appendTo 'body'
#       @addCode = (codeSet, code, submit = true) ->
#         @patientBuilder.$('.codeset-control:first').val(codeSet).change()
#         $codelist = @patientBuilder.$('.codelist-control:first')
#         expect($codelist.children("[value=#{code}]")).toExist()
#         $codelist.val(code).change()

#     # FIXME Our test JSON doesn't yet support value sets very well... write these tests when we have a source of value sets independent of the measures
#     xit "adds a code", ->

#     afterEach -> @patientBuilder.remove()

# describe 'Direct Reference Code Usage', ->
#   # Originally BONNIE-939

#   beforeEach ->
#     jasmine.getJSONFixtures().clearCache()
#     @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS903v0/CMS903v0.json', 'cqm_measure_data/CMS903v0/value_sets.json'
#     bonnie.measures.add(@measure, { parse: true })
#     @patient = new Thorax.Models.Patient getJSONFixture('patients/CMS903v0/Visits 2 Excl_2 ED.json'), parse: true

#   xit 'Field Value Dropdown should contain direct reference code element', ->
#     # SKIP: Re-enable with Patient Builder Code Work
#     patientBuilder = new Thorax.Views.PatientBuilder(model: @patients.first(), measure: @measure)
#     dataCriteria = patientBuilder.model.get('source_data_criteria').models
#     edVisitIndex = dataCriteria.findIndex((m) ->
#       m.attributes.description is 'Encounter, Performed: Emergency Department Visit')
#     emergencyDepartmentVisit = dataCriteria[edVisitIndex]
#     editCriteriaView = new Thorax.Views.EditCriteriaView(model: emergencyDepartmentVisit, measure: @measure)
#     editFieldValueView = editCriteriaView.editFieldValueView
#     expect(editFieldValueView.render()).toContain('drc-')

#   it 'Adding direct reference code element should calculate correctly', ->
#     population = @measure.get('populations').first()
#     results = population.calculate(@patient)
#     library = "LikeCMS32"
#     statementResults = results.get("statement_results")
#     titleOfClauseThatUsesDrc = statementResults[library]['Measure Population Exclusions'].raw[0].dischargeDisposition.display
#     expect(titleOfClauseThatUsesDrc).toBe "Patient deceased during stay (discharge status = dead) (finding)"

# describe 'Allergy', ->
#   # Originally BONNIE-785

#   beforeAll ->
#     jasmine.getJSONFixtures().clearCache()
#     @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS12v0/CMS12v0.json', 'cqm_measure_data/CMS12v0/value_sets.json'
#     bonnie.measures.add @measure
#     medAllergy = getJSONFixture("patients/CMS12v0/MedAllergyEndIP_DENEXCEPPass.json")
#     @patients = new Thorax.Collections.Patients [medAllergy], parse: true
#     @patient = @patients.at(0) # MedAllergyEndIP_DENEXCEPPass
#     @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measure, patients: @patients)
#     sourceDataCriteria = @patientBuilder.model.get("source_data_criteria")
#     @allergyIntolerance = sourceDataCriteria.findWhere({qdmCategory: "allergy"})
#     @patientBuilder.render()
#     @patientBuilder.appendTo('body')

#   afterEach ->
#     @patientBuilder.remove()

#   it 'is displayed on Patient Builder Page in Elements section', ->
#     expect(@patientBuilder.$el.find("div#criteriaElements").html()).toContainText "allergy"

#   it 'highlight is triggered by relevant cql clause', ->
#     cqlLogicView = @patientBuilder.populationLogicView.getView().cqlLogicView
#     sourceDataCriteria = cqlLogicView.latestResult.patient.get('source_data_criteria')
#     patientDataCriteria = _.find(sourceDataCriteria.models, (sdc) -> sdc.get('qdmCategory') == 'allergy')
#     dataCriteriaIds = [patientDataCriteria.get('_id').toString()]
#     spyOn(patientDataCriteria, 'trigger')
#     cqlLogicView.highlightPatientData(dataCriteriaIds)
#     expect(patientDataCriteria.trigger).toHaveBeenCalled()
