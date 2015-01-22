class Thorax.Views.ValueSetsBuilder extends Thorax.Views.BonnieView
  template: JST['value_sets_builder/value_sets_builder']
  events:
    'click .search-button': 'search'
    'focus input#searchByNameOrOID': 'resetSearchBar'
    rendered: ->
      @$("[rel='popover']").popover trigger: 'hover', container: 'div.measure-dropdown-group'

  initialize: ->
    @searchResults = new Thorax.Collections.ValueSetsCollection()
    @filters = new Thorax.Collections.ValueSetsCollection()
    @exclusions = new Thorax.Collection()
    @inclusions = new Thorax.Collection()
    @query = ''
    @names = @collection.pluck('display_name')
    @oids = @collection.pluck('oid')
    @whiteList = new Thorax.Collections.ValueSetsCollection(@collection.whiteList())
    @blackList = new Thorax.Collections.ValueSetsCollection(@collection.blackList())
    @measureToOids = @measures.toOids() # measure hqmf_set_id : valueSet oid
    @patientToOids = @patients.toOids() # patient medical_record_number : valueSet oid
    @patientToSdc = @patients.toSdc() # patient medical_record_number : source_data_criteria
    @whiteListCollectionView = new Thorax.CollectionView
      collection: @whiteList
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: true, black: false, measures: @measures, measuresToOids: @measureToOids, patients: @patients, patientsToOids: @patientToOids, patientsToSdc: @patientToSdc)
    @blackListCollectionView = new Thorax.CollectionView
      collection: @blackList
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: false, black: true, measures: @measures, measuresToOids: @measureToOids, patients: @patients, patientsToOids: @patientToOids, patientsToSdc: @patientToSdc)
    @searchResultsCollectionView = new Thorax.CollectionView
      collection: @searchResults
      itemView: (item) => new Thorax.Views.ValueSetView(model: item.model, white: false, black: false, filters: @filters, inclusions: @inclusions, exclusions: @exclusions)
    @listenTo @searchResultsCollectionView, 'update-lists', (model) ->
      @savePatients()
      @collection.remove(@collection.findWhere('oid':model.get('oid')))
      @collection.add model
      @whiteList.reset(@collection.whiteList())
      @blackList.reset(@collection.blackList())
    @listenTo @whiteListCollectionView, 'search-lookup', (model) -> @lookupValueSet(model)
    @listenTo @blackListCollectionView, 'search-lookup', (model) -> @lookupValueSet(model)

  filterContext: (f) ->
    _(f.toJSON()).extend
      includedState: if f.get('included') then 'default' else 'info'
      excludedState: if f.get('excluded') then 'default' else 'info'

  search: (e) ->
    e.preventDefault()
    @query = @$('#searchByNameOrOID').val()
    unless @query == ''
      matchedNames = _(@names).filter( (name)=> name.toLowerCase().indexOf(@query.toLowerCase()) != -1 )
      matchedOids = _(@oids).filter( (oid) => oid.toLowerCase().indexOf(@query.toLowerCase()) != -1 )
      if matchedNames.length > 0
        @searchResults.reset(@collection.filter((vs) -> vs.get('display_name') in matchedNames))
        @$('.input-group').addClass('has-success')
      else if matchedOids.length > 0
        @searchResults.reset(@collection.filter((vs) -> vs.get('oid') in matchedOids))
        @$('.input-group').addClass('has-success')
      else
        # console.log "No search results found for #{@query}"
        @$('.input-group').addClass('has-error')
    else
      @$('.input-group').addClass('has-error')

  selectMeasure: (e) ->
    measure = @$(e.target).model()
    @query = measure.get('title')
    @searchResults.reset(measure.valueSets().models)
    @$('.input-group').addClass('has-success')

  lookupValueSet: (vs) ->
    @query = vs.get('display_name')
    matchedOids = [vs.get('oid')]
    @searchResults.reset(@collection.filter((vs) -> vs.get('oid') in matchedOids))

  resetSearchBar: ->
    @$('.input-group').removeClass('has-success has-error')

  removeFilter: (e) ->
    e.preventDefault()
    filter = @$(e.target).model()
    filterCodes = _(filter.get('concepts')).pluck('_id')
    removedIncCodes = @inclusions.filter((c) => c.get('_id') in filterCodes)
    removedExCodes = @exclusions.filter((c) => c.get('_id') in filterCodes)
    @inclusions.remove removedIncCodes
    @exclusions.remove removedExCodes
    @filters.remove filter
    filter.set 'included', false
    filter.set 'excluded', false
    @updateSearchResults()

  includeFilter: (e) ->
    e.preventDefault()
    filter = @$(e.target).model()
    unless filter.get('included')
      filterCodes = _(filter.get('concepts')).pluck('_id')
      removedExCodes = @exclusions.filter((c) => c.get('_id') in filterCodes)
      @exclusions.remove removedExCodes
      for concept in filter.get('concepts')
        unless concept.code in @inclusions.pluck('code') then @inclusions.add concept
      filter.set 'included', true
      filter.set 'excluded', false
      @updateSearchResults()

  excludeFilter: (e) ->
    e.preventDefault()
    filter = @$(e.target).model()
    unless filter.get('excluded')
      filterCodes = _(filter.get('concepts')).pluck('_id')
      removedIncCodes = @inclusions.filter((c) => c.get('_id') in filterCodes)
      @inclusions.remove removedIncCodes
      for concept in filter.get('concepts')
        unless concept.code in @exclusions.pluck('code') then @exclusions.add concept
      filter.set 'included', false
      filter.set 'excluded', true
      @updateSearchResults()

  updateSearchResults: ->
    for vcid, vsv of @searchResultsCollectionView.children
      vsv.rebuildCodes()
      vsv.render()

  rebuildPatients: (e) ->
    e.preventDefault()
    @savePatients()

  savePatients: ->
    @$(".rebuild-patients").prop('disabled', true)
    @$("#rebuildPatientsDialog").modal backdrop: 'static'
    @$(".rebuild-patients-progress-bar").css('width', '0%')
    @patients.each (p) =>
      p.save null, success: (model, response) =>
        # console.log "Saved #{model.get('last')}, #{@patients.indexOf(p)}"
        index = @patients.indexOf(p)
        perc = (index / @patients.length) * 100
        @$(".rebuild-patients-progress-bar").css('width', perc.toFixed() + '%')
        if @patients.indexOf(p) == @patients.length - 1 then @$("#rebuildPatientsDialog").modal 'hide'
    @$(".rebuild-patients").prop('disabled', false)

class Thorax.Views.ValueSetView extends Thorax.Views.BonnieView
  template: JST['value_sets_builder/value_set']
  events:
    'change .filter-vs': 'updateLists'
    rendered: ->
      @$('.value-set-save').prop('disabled', true)
      @$('select.filter-vs').selectBoxIt()

  initialize: ->
    @codeSystems = {}
    for concept in @model.get('concepts')
      if @white or @black
        if concept.white_list and @white or concept.black_list and @black
          @addToCodeSystems(concept)
      else
        if @inclusions? and @exclusions?
          if @inclusions.isEmpty() and @exclusions.isEmpty()
            @addToCodeSystems(concept)
          else if @inclusions.isEmpty()
            unless concept.code in @exclusions.pluck('code')
              @addToCodeSystems(concept)
          else if @exclusions.isEmpty()
            if concept.code in @inclusions.pluck('code')
              @addToCodeSystems(concept)
          else if concept.code in @inclusions.pluck('code')
            unless concept.code in @exclusions.pluck('code')
              @addToCodeSystems(concept)
        else
          @addToCodeSystems(concept)
    @associatedMeasures = new Thorax.Collection()
    if @measures?
      @measures.each (m) =>
        @associatedMeasures.add m if @model.get('oid') in @measuresToOids[m.get('hqmf_set_id')]
    @associatedPatients = new Thorax.Collection()
    if @patients?
      @patients.each (p) =>
        @associatedPatients.add p if @model.get('oid') in @patientsToOids[p.get('medical_record_number')]

  context: ->
    _(super).extend
      isEmpty: _(_(@codeSystems).pluck('count')).every((c) -> c == 0)
      isWhiteList: @white && !@black
      isBlackList: @black && !@white

  toggleDetails: (e) ->
    e.preventDefault()
    if @white or @black
      @parent.trigger 'search-lookup', @model
    else
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
    @rebuildCodes()
    @$('.value-set-save').prop('disabled', false)
    @$('select.filter-vs').selectBoxIt()

  rebuildCodes: ->
    # console.log "Rebuilding #{@model.get('display_name')} codes..."
    for csn, cs of @codeSystems
      cs['count'] = 0
      cs['collection'].reset()
    for concept in @model.get('concepts')
      if @white or @black
        if concept.white_list and @white
          @addToCodeSystems(concept)
        if concept.black_list and @black
          @addToCodeSystems(concept)
      else
        if @inclusions? and @exclusions?
          if @inclusions.isEmpty() and @exclusions.isEmpty()
            @addToCodeSystems(concept)
          else if @inclusions.isEmpty()
            unless concept.code in @exclusions.pluck('code')
              @addToCodeSystems(concept)
          else if @exclusions.isEmpty()
            if concept.code in @inclusions.pluck('code')
              @addToCodeSystems(concept)
          else if concept.code in @inclusions.pluck('code')
            unless concept.code in @exclusions.pluck('code')
              @addToCodeSystems(concept)
        else
          @addToCodeSystems(concept)

  patientContext: (p) ->
    _(p.toJSON()).extend
      measureId: @measures.detect((m) -> m.get('patients').include(p)).get('hqmf_set_id')
      associatedSDC: new Thorax.Collection(p.get('source_data_criteria').filter((sdc) => sdc.get('oid') == @model.get('oid')))

  addToCodeSystems: (concept) ->
    if @codeSystems[concept['code_system_name']]?
      @codeSystems[concept['code_system_name']]['count']++
      @codeSystems[concept['code_system_name']]['collection'].add concept
    else
      @codeSystems[concept['code_system_name']] = {code_system: concept['code_system_name'], count: 1, collection: new Thorax.Collection(concept), index: _(@codeSystems).keys().length}

  save: (e) ->
    e.preventDefault()
    # console.log "Saving #{@model.get('display_name')}"
    @model.id = @model.get('_id')
    @model.url = "/valuesets/#{@model.id}"
    # console.log @model
    @model.save()
    @parent.trigger 'update-lists', @model

  addFilter: (e) ->
    e.preventDefault()
    if @filters?
      @model.set 'included', false
      @model.set 'excluded', false
      @filters.add @model
