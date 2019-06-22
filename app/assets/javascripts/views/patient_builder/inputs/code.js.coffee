# Input view for Code types.
class Thorax.Views.InputCodeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/code']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - CQL Quantity - Optional. Initial value of datetime.
  #   cqmValueSets - List of CQM Value sets. Optional. W
  initialize: ->
    if @initialValue?
      @value = @initialValue.clone()
    else
      @value = null

  events:
    'change input': 'handleCustomInputChange'
    'keyup input': 'handleCustomInputChange'
    'change select[name="valueset"]': 'handleValueSetChange'
    'change select[name="vs_codesystem"]': 'handleValueSetCodeSystemChange'
    'change select[name="vs_code"]': 'handleValueSetCodeChange'
    'change select[name="custom_codesystem_select"]': 'handleCustomCodeSystemChange'

  #context: ->
  #  _(super).extend

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @value?

  # Event listener for the custom code input fields
  handleCustomInputChange: (e) ->
    @_parseCustomCode()

  # Event listener for select change event on the main select box for chosing custom or from valueset code
  handleValueSetChange: (e) ->
    oid = @$('select[name="valueset"]').val()

    # user switched back to no selection
    if oid == ''
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
    codeSystemOid = @$('select[name="vs_codesystem"]').val()
    @selectedCodeSystem = @valueSetCodesByCodeSystem.find (codeSystem) => codeSystem.code_system_oid == codeSystemOid
    # populate code dropdown and select the first code
    @_populateValueSetCodeDropdown()

  # Event listener for code system change on selecting from a value set
  handleValueSetCodeChange: (e) ->
    codeSystemOid = @$('select[name="vs_codesystem"]').val()
    code = @$('select[name="vs_code"]').val()
    selectedConcept = @valueSet.concepts.find (concept) -> concept.code_system_oid == codeSystemOid && concept.code == code
    @value = new cqm.models.CQL.Code(selectedConcept.code, selectedConcept.code_system_oid, undefined, selectedConcept.display_name)
    @trigger 'valueChanged', @

  # Helper function that builds up a list of code systems in the given value set then builds out the code system select box.
  # This then calls _populateValueSetCodeDropdown to fill out the code drop down with codes in the first system.
  _populateValueSetCodeSystemDropdown: (oid) ->
    @valueSet = @cqmValueSets.find (vs) -> vs.oid == oid

    @valueSetCodesByCodeSystem = []
    # iterate over all codes to build list codes organized by code systems
    @valueSet.concepts.forEach (concept) =>
      codeSystemList = @valueSetCodesByCodeSystem.find (codeSystem) -> codeSystem.code_system_oid == concept.code_system_oid
      # create is not existent
      if !codeSystemList?
        codeSystemList = { code_system_oid: concept.code_system_oid, code_system_name: concept.code_system_name, codes: [] }
        @valueSetCodesByCodeSystem.push codeSystemList

      codeSystemList.codes.push concept

    # wipeout code system selection and replace options
    codeSystemSelect = @$('select[name="vs_codesystem"]').empty()
    @valueSetCodesByCodeSystem.forEach (codeSystem) =>
      $("<option value=\"#{codeSystem.code_system_oid}\">#{codeSystem.code_system_name}</option>").appendTo(codeSystemSelect)
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
    @value = new cqm.models.CQL.Code(selectedConcept.code, selectedConcept.code_system_oid, undefined, selectedConcept.display_name)
    @trigger 'valueChanged', @

  # cleans up value set selection stuff
  _cleanUpValueSetStructures: ->
      @valueSet = null
      @valueSetCodesByCodeSystem = null
      @selectedCodeSystem = null

  # Event listener for code system change on selecting from a value set
  handleCustomCodeSystemChange: (e) ->
    codeSystemOid = @$('select[name="custom_codesystem_select"]').val()
    # custom code system, allow entry
    if codeSystemOid == ''
      @$('input[name="custom_codesystem"]').val('').prop('disabled', false)
      @_parseCustomCode()
    # disable custom code system entry
    else
      codeSystem = @allCodeSystems.find (codeSystem) -> codeSystem.oid == codeSystemOid
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
        @value = new cqm.models.CQL.Code(customCode, customCodeSystem, undefined, customCode)
      else
        @value = null

    # only custom code, use oid of selected code system
    else
      if customCode != ''
        @value = new cqm.models.CQL.Code(customCode, codeSystemOid, undefined, customCode)
      else
        @value = null

    @trigger 'valueChanged', @

  # Helper that builds up the custom code system dropdown based on all code systems in the measure.
  _populateCustomCodeSystemDropdown: ->
    @allCodeSystems = [{oid: '', name: 'Custom'}]
    @cqmValueSets.forEach (valueSet) =>
      valueSet.concepts.forEach (concept) =>
        codeSystem = @allCodeSystems.find (codeSystem) -> codeSystem.oid == concept.code_system_oid
        if !codeSystem?
          @allCodeSystems.push({ oid: concept.code_system_oid, name: concept.code_system_name})

    # wipeout code system selection and replace options
    codeSystemSelect = @$('select[name="custom_codesystem_select"]').empty()
    @allCodeSystems.forEach (codeSystem) =>
      $("<option value=\"#{codeSystem.oid}\">#{codeSystem.name}</option>").appendTo(codeSystemSelect)
    codeSystemSelect.find('option:first').prop('selected', true)

    # configure custom code entry to be empty and active
    @$('input[name="custom_codesystem"]').val('').prop('disabled', false)
    @$('input[name="custom_code"]').val('')
