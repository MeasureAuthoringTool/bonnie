class Thorax.Views.ValueSetsBuilder extends Thorax.View
  template: JST['value_sets_builder/value_sets_builder']
  events:
    'click .search-button': 'search'
    'focus input#searchByNameOrOID': 'resetSearchBar'

  initialize: ->
    @defaultList = new Thorax.Collection()
    @whiteList = new Thorax.Collection()
    @blackList = new Thorax.Collection()
    @searchResults = new Thorax.Collection(null,comparator: (vs) -> vs.get('display_name')?.toLowerCase())
    @query = ''
    @measureToOids = {}
    @patientToOids = {}
    @patientToSdc = {}
    @measures.each (m) =>
      @measureToOids[m.get('hqmf_set_id')] = []
      for valueSet in m.get('value_sets').models
        unless valueSet.get('oid') in @collection.pluck('oid')
          @collection.add valueSet 
          @measureToOids[m.get('hqmf_set_id')].push valueSet.get('oid')
    @patients.each (p) =>
      @patientToOids[p.get('medical_record_number')] = []
      @patientToSdc[p.get('medical_record_number')] = []
      p.get('source_data_criteria').each (sdc) =>
        @patientToOids[p.get('medical_record_number')].push sdc.get('oid')
        @patientToSdc[p.get('medical_record_number')].push sdc
    @names = @collection.pluck('display_name')
    @oids = @collection.pluck('oid')
    @collection.each (vs) =>
      for concept in vs.get('concepts')
        if concept.black_list then @blackList.add vs
        else if concept.white_list then @whiteList.add vs
        else @defaultList.add vs
    @defaultListCollectionView = new Thorax.CollectionView
      collection: @defaultList
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: false, black: false)
    @whiteListCollectionView = new Thorax.CollectionView
      collection: @whiteList
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: true, black: false, measures: @measures, measuresToOids: @measureToOids, patients: @patients, patientsToOids: @patientToOids, patientsToSdc: @patientToSdc)
    @blackListCollectionView = new Thorax.CollectionView
      collection: @blackList
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: false, black: true, measures: @measures, measuresToOids: @measureToOids, patients: @patients, patientsToOids: @patientToOids, patientsToSdc: @patientToSdc)
    @searchResultsCollectionView = new Thorax.CollectionView
      collection: @searchResults
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: false, black: false)

  search: (e) ->
    e.preventDefault()
    @query = @$('#searchByNameOrOID').val()
    matchedNames = _(@names).filter( (name)=> name.indexOf(@query) != -1 )
    matchedOids = _(@oids).filter( (oid) => oid.indexOf(@query) != -1 )
    if matchedNames.length > 0
      @searchResults.reset(@collection.filter((vs) -> vs.get('display_name') in matchedNames))
      @$('.input-group').addClass('has-success')
    else if matchedOids.length > 0
      @searchResults.reset(@collection.filter((vs) -> vs.get('oid') in matchedOids))
      @$('.input-group').addClass('has-success')
    else 
      console.log "No search results found for #{@query}"
      @$('.input-group').addClass('has-error')
    console.log @searchResults

  associatedMeasures: (valueSets) ->
    associatedMeasures = new Thorax.Collection()
    valueSets.each (vs) =>
      @measures.each (m) =>
        associatedMeasures.add m if vs.get('oid') in @measuresToOids[m.get('hqmf_set_id')]
    associatedMeasures

  associatedPatients: (valueSets) ->
    associatedPatients = new Thorax.Collection()
    valueSets.each (vs) =>
      @patients.each (p) =>
        associatedPatients.add p if vs.get('oid') in @patientsToOids[p.get('medical_record_number')]
    associatedPatients

  selectMeasure: (e) ->
    measure = @$(e.target).model()
    @query = measure.get('title')
    matchingValueSets = @collection.filter((vs) -> measure.get('value_sets').include(vs))
    @searchResults.reset(matchingValueSets)
    @$('.input-group').addClass('has-success')

  resetSearchBar: ->
    @$('.input-group').removeClass('has-success has-error')

class Thorax.Views.ValueSetView extends Thorax.View
  template: JST['value_sets_builder/value_set']
  events:
    'change .filter-vs': 'updateLists'
    rendered: -> @$('.value-set-save').prop('disabled', true)

  initialize: ->
    @codes = new Thorax.Collection()
    for concept in @model.get('concepts')
      if @white or @black
        if concept.white_list and @white then @codes.add concept
        if concept.black_list and @black then @codes.add concept
      else
        @codes.add concept
    @associatedMeasures = new Thorax.Collection()
    if @measures?
      @measures.each (m) =>
        @associatedMeasures.add m if @model.get('oid') in @measuresToOids[m.get('hqmf_set_id')]
    @associatedPatients = new Thorax.Collection()
    if @patients?
      @patients.each (p) =>
        @associatedPatients.add p if @model.get('oid') in @patientsToOids[p.get('medical_record_number')]
        # console.log p.get('source_data_criteria').select((sdc) => sdc in @patientsToSdc[p.get('medical_record_number')])
    # console.log @patientsToSdc

    
  toggleDetails: (e) ->
    e.preventDefault()
    @$('.criteria-details, form').toggleClass('hide')
    @$('.criteria-type-marker').toggleClass('open')

  updateLists: (e) ->
    concept = $(e.target).model()
    originalConcept = _(@model.get('concepts')).findWhere({code: concept.get('code')})
    if e.target.value is 'White-List'
      originalConcept.white_list = true
      originalConcept.black_list = false
    else if e.target.value is 'Black-List'
      originalConcept.white_list = false
      originalConcept.black_list = true
    else if e.target.value is 'None'
      originalConcept.white_list = false
      originalConcept.black_list = false
    @codes.reset()
    for concept in @model.get('concepts')
      if @white or @black
        if concept.white_list and @white then @codes.add concept
        if concept.black_list and @black then @codes.add concept
      else
        @codes.add concept
    @$('.value-set-save').prop('disabled', false)

  patientContext: (p) ->
    _(p.toJSON()).extend
      measureId: @measures.detect((m) -> m.get('patients').include(p)).get('hqmf_set_id')
      associatedSDC: new Thorax.Collection(p.get('source_data_criteria').filter((sdc) => sdc.get('oid') == @model.get('oid')))

  # compareConcept: (originalConcept, currentConcept) ->
  #   if originalConcept.white_list == currentConcept.get('white_list') and originalConcept.black_list == currentConcept.get('black_list') then true else false

  save: (e) ->
    e.preventDefault()
    console.log "Saving #{@model.get('display_name')}"
    # console.log e
    # console.log $(e.target).model()
    # console.log @model
    @model.id = @model.get('_id')
    @model.url = "/valuesets/#{@model.id}"
    console.log @model
    @model.save()
    bonnie.renderValueSetsBuilder()


