# Input view whichs stores its value state as Coding.
# It can be used as an editor for Coding, CodeableConcept or PrimitiveCode if accessors are adjusted accordingly.
class Thorax.Views.InputCodingView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/coding']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - Coding - Optional. Initial value of code.
  #   cqmValueSets - List of CQM Value sets. Optional (FHIR JSON).
  #   codeSystemMap - Code system map of system oid to system names.
  #   allowNull - boolean - Optional. If a null or empty integer is allowed. Defaults to false.
  initialize: ->
    if @initialValue?
      @value = @initialValue
    else
      @value = null

    if !@hasOwnProperty('allowNull')
      @allowNull = false

  events:
    'change input': 'handleCustomInputChange'
    'keyup input': 'handleCustomInputChange'
    'change select[name="valueset"]': 'handleValueSetChange'
    'change select[name="vs_codesystem"]': 'handleValueSetCodeSystemChange'
    'change select[name="vs_code"]': 'handleValueSetCodeChange'
    'change select[name="custom_codesystem_select"]': 'handleCustomCodeSystemChange'
    rendered: ->
      # if there is a value on render, we have to set all the things correspondingly
      if @value?
        value = @value # local copy, because this will modify value when causing re-selection
        valueSet = @_findValueSetForCode(@value)

        # if there is a value set for this code, make all the modifications for the code to be selected
        if valueSet?
          @$("select[name=\"valueset\"] > option[value=\"#{valueSet.id}\"]").prop('selected', true)
          @handleValueSetChange()
          @$("select[name=\"vs_codesystem\"] > option[value=\"#{value.system}\"]").prop('selected', true)
          @handleValueSetCodeSystemChange()
          @$("select[name=\"vs_code\"] > option[value=\"#{value.code}\"]").prop('selected', true)
          @handleValueSetCodeChange()

        # initial is not found in a value set
        else
          @$("select[name=\"valueset\"] > option[value=\"custom\"]").prop('selected', true)
          @handleValueSetChange()
          isCustomCodeSystem = !(@allCodeSystems.find (codeSystem) -> codeSystem.system == value?.system?.value)?

          # if the code system is in the measure, select it, otherwise select custom and fillthat
          if !isCustomCodeSystem
            @$("select[name=\"custom_codesystem_select\"] > option[value=\"#{value?.system?.value}\"]").prop('selected', true)
          else
            @$("select[name=\"custom_codesystem_select\"] > option[value=\"custom\"]").prop('selected', true)

          @handleCustomCodeSystemChange()
          @$('input[name="custom_codesystem"]').val(value?.system?.value) if isCustomCodeSystem
          @$('input[name="custom_code"]').val(value?.code?.value)
          @handleCustomInputChange()

      # if there is no initial value
      else
        @$('select[name="valueset"] > option:first').prop('selected', true)

  # when an initial code is passed in we need to find if it is in a value set and
  # populate the dropdowns appropiately
  _findValueSetForCode: (code) ->
    valueSet = @cqmValueSets.find (vs) =>
      matchingConcept = vs?.compose?.include?.find (concept) =>
        matchingConceptEntry = concept.concept?.find (conceptEntry) =>
          return concept.system == code.system && conceptEntry.code == code.code
      return matchingConcept?
    return valueSet

  #context: ->
  #  _(super).extend

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  # Event listener for the custom code input fields
  handleCustomInputChange: (e) ->
    @_parseCustomCode()

  # Event listener for select change event on the main select box for chosing custom or from valueset code
  handleValueSetChange: (e) ->
    oid = @$('select[name="valueset"]').val()

    # user switched back to no selection
    if oid == '--'
      @$('.code-vs-select-input, .code-custom-input').addClass('hidden')
      @_cleanUpValueSetStructures()
      @value = null
      @trigger 'valueChanged', @

    # user wants to enter a custom code
    else if oid == 'custom'
      @$('.code-vs-select-input').addClass('hidden')
      @$('.code-vs-select-input input').val('')
      @_cleanUpValueSetStructures()
      @_populateCustomCodeSystemDropdown()
      @value = null
      @trigger 'valueChanged', @
      @$('.code-custom-input').removeClass('hidden')

    # user wants to choose from a valueset
    else
      @$('.code-custom-input').addClass('hidden')
      @_cleanUpValueSetStructures()
      # look for oid and fill out select fields and select the first one
      @_populateValueSetCodeSystemDropdown(oid)
      @$('.code-vs-select-input').removeClass('hidden')

  # Event listener for code system change on selecting from a value set
  handleValueSetCodeSystemChange: (e) ->
    system = @$('select[name="vs_codesystem"]').val()
    @selectedCodeSystem = @valueSetCodesByCodeSystem.find (codeSystem) => codeSystem.system == system
    # populate code dropdown and select the first code
    @_populateValueSetCodeDropdown()

  # reset to nothing selected
  resetCodeSelection: ->
    @$('select[name="valueset"] > option:first').prop('selected', true)
    @handleValueSetChange()

  # Event listener for code system change on selecting from a value set
  handleValueSetCodeChange: (e) ->
    system = @$('select[name="vs_codesystem"]').val()
    code = @$('select[name="vs_code"]').val()
    composeInclude = @valueSet?.compose?.include.find (composeInclude) -> composeInclude?.system == system
    concept = composeInclude?.concept.find (concept) -> concept?.code == code

    cqlCoding = new cqm.models.Coding()
    cqlCoding.system = cqm.models.PrimitiveUri.parsePrimitive(system)
    cqlCoding.version = cqm.models.PrimitiveString.parsePrimitive(composeInclude.version || null)
    cqlCoding.code = cqm.models.PrimitiveCode.parsePrimitive(code)
    cqlCoding.display = cqm.models.PrimitiveString.parsePrimitive(concept?.display || null)
    cqlCoding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)

    @value = cqlCoding
    @trigger 'valueChanged', @

  # Helper function that builds up a list of code systems in the given value set then builds out the code system select box.
  # This then calls _populateValueSetCodeDropdown to fill out the code drop down with codes in the first system.
  _populateValueSetCodeSystemDropdown: (valueSetOid) ->
    @valueSet = @cqmValueSets.find (vs) -> vs.id == valueSetOid

    @valueSetCodesByCodeSystem = []
    # iterate over all codes to build list codes organized by code systems
    @valueSet?.compose?.include?.forEach (composeInclude) =>
      system = composeInclude?.system
      composeInclude?.concept?.forEach (concept) =>
        code = concept?.code
        displayName = concept?.display
        codeSystemList = @valueSetCodesByCodeSystem.find (codeSystem) -> codeSystem.system == system
        # create if not existent
        if !codeSystemList?
          codeSystemList = { system: system, codes: [] }
          @valueSetCodesByCodeSystem.push codeSystemList
        codeSystemList.codes.push { code: code, display_name: displayName }

    # wipeout code system selection and replace options
    codeSystemSelect = @$('select[name="vs_codesystem"]').empty()
    @valueSetCodesByCodeSystem.forEach (codeSystem) =>
      $("<option value=\"#{codeSystem.system}\">#{codeSystem.system}</option>").appendTo(codeSystemSelect)
    codeSystemSelect.find('option:first').prop('selected', true)

    @selectedCodeSystem = @valueSetCodesByCodeSystem[0]
    @_populateValueSetCodeDropdown()

  # Helper function that populates the code list for the currently selected code system in a value set.
  _populateValueSetCodeDropdown: ->
    # wipeout code system selection and replace options
    codeSelect = @$('select[name="vs_code"]').empty()
    @selectedCodeSystem.codes.forEach (code) =>
      $("<option value=\"#{code.code}\">#{code.code} - #{code.display_name}</option>").appendTo(codeSelect)
    codeSelect.find('option:first').prop('selected', true)

    # set to the first one in the list
    selectedConcept = @selectedCodeSystem.codes[0]

    cqlCoding = new cqm.models.Coding()
    cqlCoding.system = cqm.models.PrimitiveUri.parsePrimitive(@selectedCodeSystem.system)
    cqlCoding.code = cqm.models.PrimitiveCode.parsePrimitive(selectedConcept.code)
    cqlCoding.display = cqm.models.PrimitiveString.parsePrimitive(selectedConcept.display_name || null)
    cqlCoding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
    @value = cqlCoding
    @trigger 'valueChanged', @

  # cleans up value set selection stuff
  _cleanUpValueSetStructures: ->
      @valueSet = null
      @valueSetCodesByCodeSystem = null
      @selectedCodeSystem = null

  # Event listener for code system change on selecting from a value set
  handleCustomCodeSystemChange: (e) ->
    system = @$('select[name="custom_codesystem_select"]').val()
    # custom code system, allow entry
    if system == ''
      @$('input[name="custom_codesystem"]').val('').prop('disabled', false)
      @_parseCustomCode()
    # disable custom code system entry
    else
      codeSystem = @allCodeSystems.find (codeSystem) -> codeSystem.system == system
      @$('input[name="custom_codesystem"]').val(codeSystem.name).prop('disabled', true)
      @_parseCustomCode()

  # helper function that parses fields for custom code and turns them into a code if possible.
  _parseCustomCode: ->
    codeSystemOid = @$('select[name="custom_codesystem_select"]').val()
    customCodeSystem = @$('input[name="custom_codesystem"]').val()
    customCode= @$('input[name="custom_code"]').val()

    # custom code system
    if codeSystemOid == ''
      if (customCodeSystem != '' && customCode != '')
        cqlCoding = new cqm.models.Coding()
        cqlCoding.system = cqm.models.PrimitiveUri.parsePrimitive(customCodeSystem)
        cqlCoding.code = cqm.models.PrimitiveCode.parsePrimitive(customCode || null)
        cqlCoding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
        @value = cqlCoding
      else
        @value = null

    # only custom code, use selected code system
    else
      if customCode != ''
        cqlCoding = new cqm.models.Coding()
        cqlCoding.system = cqm.models.PrimitiveUri.parsePrimitive(codeSystemOid)
        cqlCoding.code = cqm.models.PrimitiveCode.parsePrimitive(customCode || null)
        cqlCoding.userSelected = cqm.models.PrimitiveBoolean.parsePrimitive(true)
        @value = cqlCoding
      else
        @value = null

    @trigger 'valueChanged', @

  # Helper that builds up the custom code system dropdown based on all code systems in the measure.
  _populateCustomCodeSystemDropdown: ->
    @allCodeSystems = [{system: '', name: 'Custom'}]
    for oid, name of @codeSystemMap
      @allCodeSystems.push {system: oid, name: name}

    # wipeout code system selection and replace options
    codeSystemSelect = @$('select[name="custom_codesystem_select"]').empty()
    @allCodeSystems.forEach (codeSystem) =>
      $("<option value=\"#{codeSystem.system}\">#{codeSystem.name}</option>").appendTo(codeSystemSelect)
    codeSystemSelect.find('option:first').prop('selected', true)

    # configure custom code entry to be empty and active
    @$('input[name="custom_codesystem"]').val('').prop('disabled', false)
    @$('input[name="custom_code"]').val('')
