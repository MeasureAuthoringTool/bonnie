class Thorax.Views.EditCodesDisplayView extends Thorax.Views.BuilderChildView
  template: JST['patient_builder/edit_codes_display']

  initialize: ->

  context: ->
    @codeSystemMap = @measure.codeSystemMap() unless @codeSystemMap?
    codes = []
    for codeIndex of @codes
      code = @codes[codeIndex]
      codes.push { system: @codeSystemMap[code.system] || code.system, code: code.code, index: codeIndex }

    _(super).extend
      codes: codes

  removeCode: (e) ->
    e.preventDefault()
    codeIndexToRemove = $(e.target).data().codeIndex
    # Remove the code from dataElementCodes
    removeItemAtIndex = (array, indexToRemove) ->
      [].concat(array.slice(0,indexToRemove), array.slice(indexToRemove + 1))

    codesToKeep = removeItemAtIndex(@parent.model.get('dataElement').dataElementCodes, codeIndexToRemove)
    @parent.updateCodes(codesToKeep)
