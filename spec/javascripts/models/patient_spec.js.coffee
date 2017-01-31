describe 'Patient', ->

  beforeEach ->
    window.bonnieRouterCache.load('base_set')
    collection = new Thorax.Collections.Patients getJSONFixture('records/base_set/patients.json'), parse: true
    @patient = collection.findWhere(first: 'GP_Peds', last: 'A')

  it 'has basic attributes available', ->
    expect(@patient.get('gender')).toEqual 'F'

  it 'correctly performs deep cloning', ->
    clone = @patient.deepClone()
    expect(clone.cid).not.toEqual @patient.cid
    expect(clone.keys()).toEqual @patient.keys()
    expect(clone.get('source_data_criteria').cid).not.toEqual @patient.get('source_data_criteria').cid
    expect(clone.get('source_data_criteria').pluck('id')).toEqual @patient.get('source_data_criteria').pluck('id')
    cloneWithoutId = @patient.deepClone(omit_id: true)
    expect(cloneWithoutId.cid).not.toEqual @patient.cid
    expect(_(@patient.keys()).difference(cloneWithoutId.keys())).toEqual ['_id']

  it 'correctly deduplicates the name when deep cloning and dedupName is an option', ->
    clone = @patient.deepClone({dedupName: true})
    expect(clone.get("first")).toEqual @patient.get("first") + " (1)"

  it 'correctly sorts criteria by multiple attributes', ->
    # Patient has for existing criteria; first get their current order
    startOrder = @patient.get('source_data_criteria').map (dc) -> dc.cid
    # Set some attribute values so that they should sort 4,3,2,1 and sort
    @patient.get('source_data_criteria').at(0).set start_date: 2, end_date: 2
    @patient.get('source_data_criteria').at(1).set start_date: 2, end_date: 1
    @patient.get('source_data_criteria').at(2).set start_date: 1, end_date: 2
    @patient.get('source_data_criteria').at(3).set start_date: 1, end_date: 1
    @patient.sortCriteriaBy 'start_date', 'end_date'
    expect(@patient.get('source_data_criteria').at(0).cid).toEqual startOrder[3]
    expect(@patient.get('source_data_criteria').at(1).cid).toEqual startOrder[2]
    expect(@patient.get('source_data_criteria').at(2).cid).toEqual startOrder[1]
    expect(@patient.get('source_data_criteria').at(3).cid).toEqual startOrder[0]

  describe 'validation', ->

    beforeEach ->
      @errorsForPatientWithout = (field, extraAttrs) ->
        clone = @patient.deepClone()
        clone.set field, ''
        clone.set extraAttrs
        clone.validate()

    it 'passes patient with no issues', ->
      errors = @patient.validate()
      expect(errors).toBeUndefined()

    it 'fails patient missing a first name', ->
      errors = @errorsForPatientWithout('first')
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Name fields cannot be blank'

    it 'fails patient missing a last name', ->
      errors = @errorsForPatientWithout('last')
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Name fields cannot be blank'

    it 'fails patient missing a birthdate', ->
      errors = @errorsForPatientWithout('birthdate')
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Date of birth cannot be blank'

    it 'fails deceased patient without a deathdate', ->
      errors = @errorsForPatientWithout('deathdate', expired: true)
      expect(errors.length).toEqual 1
      expect(errors[0][2]).toEqual 'Deceased patient must have date of death'
      
  describe 'calculateAndSave', ->
  
    # Set up fake/spy functions for materialize and backbone save
    beforeEach ->
      spyOn(@patient, 'materialize').and
        .callFake((callback) -> 
          callback() if callback?)
          
      spyOn(@patient, 'save').and
        .callFake((attrs, options) ->
          options.success() if options.success?)
      
    it 'materializes before saving', (done) ->
      @patient.calculateAndSave {},
        success: =>
          expect(@patient.materialize).toHaveBeenCalled()
          done()
    
    it 'has calc_results for the measure after save', (done) ->
      @patient.calculateAndSave {},
        success: =>
          expect(@patient.get('calc_results')).toBeDefined()
          done()

describe 'Patient saving to backend', ->
  # commented out for now because back end doesn't have this in the database, resulting in this error:
  # Mongoid::Errors::DocumentNotFound (
  # Problem:
  #   Document(s) not found for class Record with id(s) 5863fbdee76e94aee90003c9.
  # Summary:
  # When calling Record.find with an id or array of ids, each parameter must match a document in the database or this error will be raised. The search was for the id(s): 5863fbdee76e94aee90003c9 ... (1 total) and the following ids were not found: 5863fbdee76e94aee90003c9.
  beforeEach (done) ->
    window.measureHistorySpecLoader.load('measure_history_set/single_population_set/CMS68', 'initialLoad', 'CMS68v4', @)
    @patient = @patients.at(0)
    done()

  xit 'calculateAndSave has calc_results for the measure after save', (done) ->
      @patient.calculateAndSave {},
        success: =>
          expect(@patient.get('calc_results')).toBeDefined()
          done()