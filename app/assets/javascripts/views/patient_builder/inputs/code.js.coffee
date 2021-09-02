# Input view whichs stores its value state as Coding.
# It can be used as an editor for PrimitiveCode if accessors are adjusted accordingly.
class Thorax.Views.InputCodeView extends Thorax.Views.BonnieView
  # Same template used by InputCodingView & InputCodeView
  template: JST['patient_builder/inputs/code']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - code value - Optional. Initial value of code.
  #   cqmValueSets - List of CQM Value sets. Optional (FHIR JSON).
  #   allowNull - boolean - Optional. If a null or empty integer is allowed. Defaults to false.
  #   displayName - boolean - Optional. If attribute name to be displayed as label.
  #   codeSystemMap - Required coding systems map (url -> name)
  #   codeType - subtype of primitive code, cqm.models.PrimitiveCode is default
  #   isSystemFixed - boolean - Optional. Default to false. If true, then the Custom system is always the first system from the list of systems.
  #     It's used for a PrimitiveCode, when a system is implied for an attribute (see bindings).
  initialize: ->
    @codeType = cqm.models.PrimitiveCode unless @codeType?
    @setValue(@initialValue)

    if !@hasOwnProperty('allowNull')
      @allowNull = false

    # Capture relevant code systems from value sets (can be from bindings or measure valuesets)
    @codeSystems = {}
    @cqmValueSets.forEach (valueSet) =>
      valueSet.compose?.include?.forEach (vsInclude) =>
        system = vsInclude.system
        if !@codeSystems.hasOwnProperty(system)
          @codeSystems[system] = @codeSystemMap?[system]
    @systemFixed = @cqmValueSets?[0]?.compose?.include?[0]?.system

  events:
    'change input': 'handleCustomInputChange'
    'keyup input': 'handleCustomInputChange'
    'change select[name="valueset"]': 'handleValueSetChange'
    'change select[name="vs_codesystem"]': 'handleValueSetCodeSystemChange'
    'change select[name="vs_code"]': 'handleValueSetCodeChange'
    'change select[name="custom_codesystem_select"]': 'handleCustomCodeSystemChange'
    rendered: ->
      # if there is a value on render, we have to set all the vaues accordingly
      if @value?
        value = @value # local copy, because this will modify value when causing re-selection
        valueSet = @_findValueSetForCode(@value.value)
        # if there is a value set for this code, make all the modifications for the code to be selected
        if valueSet?
          @$("select[name=\"valueset\"] > option[value=\"#{valueSet.id}\"]").prop('selected', true)
          @handleValueSetChange()
          @$("select[name=\"vs_codesystem\"] > option[value=\"#{valueSet.name}\"]").prop('selected', true)
          @handleValueSetCodeSystemChange()
          @$("select[name=\"vs_code\"] > option[value=\"#{value.value}\"]").prop('selected', true)
          @handleValueSetCodeChange()
      else
        @$('select[name="valueset"] > option:first').prop('selected', true)

  #context: ->
  #  _(super).extend

  setValue: (val) ->
    if !val?
      @value = null
    else
      @value = if val instanceof cqm.models.PrimitiveCode then val else @codeType.parsePrimitive(val)

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @allowNull || @value?

  # Event listener for the custom code input fields
  handleCustomInputChange: (e) ->
    @_parseCustomCode()

  # Event listener for select change event on the main select box for chosing custom or from valueset code
  handleValueSetChange: (e) ->
    id = @$('select[name="valueset"]').val()

    # user switched back to no selection
    if id == '--'
      @$('.code-vs-select-input, .code-custom-input').addClass('hidden')
      @_cleanUpValueSetStructures()
      @setValue(null)
      @trigger 'valueChanged', @

    # user wants to enter a custom code
    else if id == 'custom'
      @$('.code-vs-select-input').addClass('hidden')
      @$('.code-vs-select-input input').val('')
      @_cleanUpValueSetStructures()
      @_populateCustomCodeSystemDropdown()
      @$('select[name="custom_codesystem_select"]').val(@systemFixed)
      @$('select[name="custom_codesystem_select"]').prop('disabled', true)
      @$('input[name="custom_codesystem"]').val(@codeSystems[@systemFixed])
      @$('input[name="custom_codesystem"]').prop('disabled', true)
      @setValue(null)
      @trigger 'valueChanged', @
      @$('.code-custom-input').removeClass('hidden')

    # user wants to choose from a valueset
    else
      @$('.code-custom-input').addClass('hidden')
      @_cleanUpValueSetStructures()
      # look for oid and fill out select fields and select the first one
      @_populateValueSetCodeSystemDropdown(id)
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

    @setValue(code)
    @trigger 'valueChanged', @

  # Helper function that builds up a list of code systems in the given value set then builds out the code system select box.
  # This then calls _populateValueSetCodeDropdown to fill out the code drop down with codes in the first system.
  _populateValueSetCodeSystemDropdown: (valueSetId) ->
    @valueSet = @cqmValueSets.find (vs) -> vs.id == valueSetId

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
          codeSystemList = { system: system, name: @codeSystems[system], codes: [] }
          @valueSetCodesByCodeSystem.push codeSystemList
        codeSystemList.codes.push { code: code, display_name: displayName }

    # Sort code systems by name
    @valueSetCodesByCodeSystem.sort( (a, b) -> a.name?.localeCompare(b.name) )
    # wipeout code system selection and replace options
    codeSystemSelect = @$('select[name="vs_codesystem"]').empty()
    @valueSetCodesByCodeSystem.forEach (codeSystem) =>
      $("<option value=\"#{codeSystem.system}\">#{codeSystem.name}</option>").appendTo(codeSystemSelect)
    codeSystemSelect.find('option:first').prop('selected', true)

    @selectedCodeSystem = @valueSetCodesByCodeSystem[0]
    @_populateValueSetCodeDropdown()

  # Helper function that populates the code list for the currently selected code system in a value set.
  _populateValueSetCodeDropdown: ->
    # wipeout code system selection and replace options
    codeSelect = @$('select[name="vs_code"]').empty()

    # Sort codes
    @selectedCodeSystem.codes.sort( (a, b) -> a.code?.localeCompare(b.code) )
    @selectedCodeSystem.codes.forEach (code) =>
      $("<option value=\"#{code.code}\">#{code.code} - #{code.display_name}</option>").appendTo(codeSelect)
    codeSelect.find('option:first').prop('selected', true)

    # set to the first one in the list
    selectedConcept = @selectedCodeSystem.codes[0]

    @setValue(selectedConcept.code)
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
        @setValue(customCode)
      else
        @setValue(null)

    # only custom code, use selected code system
    else
      if customCode != ''
        @setValue(customCode)
      else
        @setValue(null)

    @trigger 'valueChanged', @

  # Helper that builds up the custom code system dropdown based on all code systems in the measure.
  _populateCustomCodeSystemDropdown: ->
    @allCodeSystems = []
    for system, name of @codeSystems
      @allCodeSystems.push {system: system, name: name}
    @allCodeSystems.sort( (a, b) -> a.name?.localeCompare(b.name) )
    @allCodeSystems.splice(0, 0, {system: '', name: 'Custom'})

    # wipeout code system selection and replace options
    codeSystemSelect = @$('select[name="custom_codesystem_select"]').empty()
    @allCodeSystems.forEach (codeSystem) =>
      $("<option value=\"#{codeSystem.system}\">#{codeSystem.name}</option>").appendTo(codeSystemSelect)
    codeSystemSelect.find('option:first').prop('selected', true)

    # configure custom code entry to be empty and active
    @$('input[name="custom_codesystem"]').val('').prop('disabled', false)
    @$('input[name="custom_code"]').val('')

  # TODO: not a great way to find valueset by code as same named code might be in two valueset
  _findValueSetForCode: (code) ->
    valueSet = @cqmValueSets.find (vs) ->
      matchingConcept = vs?.compose?.include?.find (concept) ->
        concept.concept?.find (conceptEntry) ->
          return conceptEntry.code == code
      return matchingConcept?
    return valueSet
