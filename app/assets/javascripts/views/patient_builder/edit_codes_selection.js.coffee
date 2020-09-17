class Thorax.Views.EditCodeSelectionView extends Thorax.Views.BuilderChildView
  template: JST['patient_builder/edit_codes_selection']

  initialize: ->
    @model = new Thorax.Model
    @updateCodeSystems() if @concepts?

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
    system = @$('select[name="codesystem"]').val()
    if system is 'custom'
      system = @$('input[name="custom_codesystem"]').val()
      code = @$('input[name="custom_code"]').val()
    @codeSystemMap = @measure.codeSystemMap() unless @codeSystemMap
    @codeSystemMapReversed = Object.fromEntries(Object.entries(@codeSystemMap).map((m) => m.reverse()))
    # Try to resolve code system name to an oid, if not (probably a custom code) default to the name
    systemOid = @codeSystemMapReversed[system] || system

    # add the code unless there is a pre-existing code with the same codesystem/code
    duplicate_exists = @codes.some (c) => (@codeSystemMap[c.system] is system or c.system is system) and c.code is code
    if !duplicate_exists
      index = @codes.length
      cqlCode = new cqm.models.CQL.Code(code, systemOid, null, null)
      @codes.push(cqlCode)
      @parent.updateCodes(@codes)

    @$('select').val('')
    # Let the selectBoxIt() select box know that its value may have changed
    @$('select[name=codesystem]').change()
    @parent.triggerMaterialize()
    @$(':focusable:visible:first').focus()

  addDefaultCodeToDataElement: ->
    codes = DataElementHelpers.getPrimaryCodes @parent.model.get('dataElement')
    if (codes)
      code_list_id = @parent.model.get('codeListId')
      # Make sure there is a default code that can be added
      if @concepts?.length
        cql_coding = new cqm.models.Coding()
        cql_coding.system = cqm.models.PrimitiveUri.parsePrimitive(@concepts[0].system)
        cql_coding.version = cqm.models.PrimitiveString.parsePrimitive(@concepts[0].version)
        cql_coding.code = cqm.models.PrimitiveCode.parsePrimitive(@concepts[0].concept[0].code)
        cql_coding.display = cqm.models.PrimitiveString.parsePrimitive(@concepts[0].concept[0].display)
        cql_coding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
        @parent.updateCodes([ cql_coding ])
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
        for concept in @concepts when concept.code_system_name is codeSystem
          $('<option>').attr('value', concept.code).text("#{concept.code} (#{concept.display_name})").appendTo $codeList
    @$('.codelist-control').focus()

  updateCodeSystems: ->
    debugger
    @codeSystems = _(concept.system for concept in @concepts || []).uniq()
    @render()