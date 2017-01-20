describe 'PatientBankView', ->

  beforeEach ->
    window.bonnieRouterCache.load("base_set")
    @patients = new Thorax.Collections.Patients getJSONFixture('records/base_set/patients.json'), parse: true
    @measure = bonnie.measures.first()
    @patientBankView = new Thorax.Views.PatientBankView model: @measure, patients: @patients

    @collection = @patients.where({ is_shared: true })
    _(@collection).each (patient) -> patient.set({ cms_id: "CMS666v2", user_email: "bonnie@example.com"})
    @patientBankView.collection = @collection

    @measure.get('populations').each (population) =>
      population_differences = @patientBankView.collection.map (patient) => population.differenceFromExpected(patient)
      @patientBankView.allDifferences.add population_differences
    @patientBankView.allDifferences = @patientBankView.allDifferences.groupBy (difference) -> difference.result.population.get('index')
    @patientBankView.differences.reset @patientBankView.allDifferences[@patientBankView.currentPopulation.get('index')]
    @patientBankView.render()
    spyOn(@patientBankView, 'clonePatientIntoMeasure')
    spyOn(@patientBankView, 'exportBankPatients')
    spyOn(@patientBankView, 'showSelectedCoverage')
    spyOn(@patientBankView.bankLogicView, 'showRationale')
    @patientBankView.appendTo 'body'

  afterEach ->
    @patientBankView.remove()
    
  it 'should not open patient bank for non existant measure', ->
    spyOn(bonnie,'showPageNotFound')
    patient = @patients.first()
    bonnie.renderHistoricPatientCompare('non_existant_hqmf_set_id', patient.id, 'non_existant_upload_id')
    expect(bonnie.showPageNotFound).toHaveBeenCalled()

  it 'shows list of shared patients', ->
    shared_patients = @patients.where({ is_shared: true })
    displayed_patients = @patientBankView.$('.shared-patient')
    expect(displayed_patients.length).toEqual shared_patients.length
    expect($('.shared-patient').model().result.patient.get('cms_id')).toBeTruthy()
    expect($('.shared-patient').model().result.patient.get('user_email')).toBeTruthy()

  it 'shows calculation results for each patient', ->
    expect(@patientBankView.$('.shared-patient').model().result).toExist()
    @patientBankView.$('.patient-btn a').click()
    expect(@patientBankView.$('.table')).toBeVisible()

  it 'lets users clone one patient from the bank to the measure', ->
    expect(@patientBankView.$('[data-call-method="cloneBankPatients"]:disabled')).toExist()
    @patientBankView.$('.patient-btn a').click()
    expect(@patientBankView.$('[data-call-method="cloneOnePatient"]')).toBeVisible()
    @patientBankView.$('input.select-patient').prop('checked','true').trigger('change') # There are two patients
    expect(@patientBankView.$('[data-call-method="cloneBankPatients"]:disabled')).not.toExist()
    @patientBankView.$('[data-call-method="cloneBankPatients"]').click()
    expect(@patientBankView.clonePatientIntoMeasure).toHaveBeenCalled()
    expect(@patientBankView.clonePatientIntoMeasure.calls.count()).toEqual 2

  it 'lets users export patients from the bank', ->
    @patientBankView.$('input.select-patient').prop('checked','true').trigger('change')
    expect(@patientBankView.$('[data-call-method="exportBankPatients"]:disabled')).not.toExist()
    @patientBankView.$('[data-call-method="exportBankPatients"]').click()
    expect(@patientBankView.exportBankPatients).toHaveBeenCalled()

  it 'shows measure logic', ->
    expect(@patientBankView.$el).toContainText @measure.get('cms_id')
    expect(@patientBankView.$('.measure-viz')).toExist()

  it 'shows measure coverage for selected patients', ->
    @patientBankView.$('input.select-patient').prop('checked','true').trigger('change')
    expect(@patientBankView.showSelectedCoverage).toHaveBeenCalled()
    expect(@patientBankView.selectedPatients).toBeTruthy()

  it 'toggles logic rationale for expanded patient', ->
    @patientBankView.$('.patient-btn a').trigger('shown.bs.collapse')
    expect(@patientBankView.toggledPatient).toBeTruthy()
    expect(@patientBankView.bankLogicView.showRationale).toHaveBeenCalled()

  describe 'lets user filter the patient list', ->

    beforeEach ->
      @patientBankView.bankFilterView.createFilters()
      @patientBankView.bankFilterView.enableFiltering()

    it 'adds filters for the patient results', ->
      visible_patients1 = @patientBankView.$('.shared-patient:visible').length
      @patientBankView.bankFilterView.$('select option[value="NUMER"]').prop('selected','true').trigger('change')
      @patientBankView.bankFilterView.$('button[type="submit"]').click()
      expect(@patientBankView.bankFilterView.appliedFilters.models[0].get('NUMER')).toBeTruthy()
      @patientBankView.bankFilterView.render()
      visible_patients2 = @patientBankView.$('.shared-patient:visible').length
      expect(visible_patients1).toBeGreaterThan(visible_patients2)

    it 'adds filters with extra information', ->
      @patientBankView.bankFilterView.$('select option[value="From measure..."]').prop('selected','true').trigger('change')
      expect(@patientBankView.bankFilterView.$('input[name="additional_requirements"]')).toExist()
      @patientBankView.bankFilterView.$('input[name="additional_requirements"]').val('CMS66')
      @patientBankView.bankFilterView.$('button[type="submit"]').click()
      expect(@patientBankView.bankFilterView.appliedFilters).toBeTruthy()
      expect(@patientBankView.bankFilterView.appliedFilters.models[0].cmsId).toEqual("CMS66")
