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
