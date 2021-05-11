class Thorax.Views.EditCodeSelectionView extends Thorax.Views.BuilderChildView
  template: JST['patient_builder/edit_codes_selection']

  initialize: ->
    @model = new Thorax.Model
    @updateCodeSystems() if @concepts?
    @codeSystemMap = @measure.codeSystemMap() unless @codeSystemMap
    # Maps code system name to code system uri
    @codeSystemByNameMap = @measure.codeSystemByNameMap() unless @codeSystemByNameMap

  events:
    'change select[name=codesystem]': (e) ->
      @model.set codeSystem: $(e.target).val()
      @changeConcepts(e)
      @validateForAddition()
    'change select[name=code]' : ->
      @validateForAddition()
    'keyup input[name=custom_code]': 'validateForAddition'
    'keyup input[name=custom_codesystem]': 'validateForAddition'

  addCode: (e) ->
    e.preventDefault()
    code = @$('select[name="code"]').val()
    # System - is a coding systen name
    system = @$('select[name="codesystem"]').val()
    if system is 'custom'
      system = @$('input[name="custom_codesystem"]').val()
      code = @$('input[name="custom_code"]').val()

    # add the code unless there is a pre-existing code with the same codesystem/code
    duplicate_exists = @codes.some (c) => (@codeSystemMap[c.system?.value] is system or c.system?.value is system) and c.code?.value is code
    if !duplicate_exists
      index = @codes.length
      cqlCoding = new cqm.models.Coding()
      cqlCoding.system = cqm.models.PrimitiveUri.parsePrimitive(@getCodeSystemFhirUri(system))
      cqlCoding.code = cqm.models.PrimitiveCode.parsePrimitive(code)
      cqlCoding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
      @codes.push(cqlCoding)
      @parent.updateCodes(@codes)

    @$('select').val('')
    # Let the selectBoxIt() select box know that its value may have changed
    @$('select[name=codesystem]').change()
    @parent.triggerMaterialize()
    @$(':focusable:visible:first').focus()

  # Convert sysem name to system URI
  getCodeSystemFhirUri: (system) ->
    @codeSystemByNameMap[system] || system

  addDefaultCodeToDataElement: ->
    codes = DataCriteriaHelpers.getPrimaryCodes @parent.model.get('dataElement')
    if (codes)
      code_list_id = @parent.model.get('codeListId')
      # Make sure there is a default code that can be added
      if @concepts?.length
        cqlCoding = new cqm.models.Coding()
        cqlCoding.system = cqm.models.PrimitiveUri.parsePrimitive(@concepts[0].system)
        cqlCoding.version = cqm.models.PrimitiveString.parsePrimitive(@concepts[0].version)
        cqlCoding.code = cqm.models.PrimitiveCode.parsePrimitive(@concepts[0].concept[0].code)
        cqlCoding.display = cqm.models.PrimitiveString.parsePrimitive(@concepts[0].concept[0].display)
        cqlCoding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
        @parent.updateCodes([ cqlCoding ])
    null

  validateForAddition: ->
    attributes = @serialize(set: false) # Gets copy of attributes from form without setting model
    if attributes.codesystem is 'custom'
      @$('.btn[data-call-method=addCode]').prop 'disabled', attributes.custom_codesystem is '' or attributes.custom_code is ''
# focusing on the button causes an interruption in typing, so no focus for custom code entry
    else
      @$('.btn[data-call-method=addCode]').prop 'disabled', attributes.codesystem is '' or attributes.code is ''
      @$('.btn').focus() #  advances the focus too the add Button

  changeConcepts: (e) ->
    codeSystem = $(e.target).val()
    $codeList = @$('.codelist-control').empty()
    if codeSystem isnt 'custom'
      blankEntry = if codeSystem is '' then '--' else "Choose a #{codeSystem} code"
      $codeList.append("<option value>#{blankEntry}</option>")
      if codeSystem isnt ''
        codeSystemUri = @getCodeSystemFhirUri(codeSystem)
        for concept in @concepts when concept.system is codeSystemUri
          for conceptEntry in concept.concept
            $('<option>').attr('value', conceptEntry.code).text("#{conceptEntry.code} (#{conceptEntry.display})").appendTo $codeList
    @$('.codelist-control').focus()

  updateCodeSystems: ->
    # Maps code system name to code system uri
    @codeSystemMap = @measure.codeSystemMap() unless @codeSystemMap
    @codeSystems = _((@codeSystemMap[concept.system] || concept.system) for concept in @concepts || []).uniq().sort()
    @render()
