class Thorax.Views.EditCodesDisplayView extends Thorax.Views.BuilderChildView
  template: JST['patient_builder/edit_codes_display']

  initialize: ->

  context: ->
    @codeSystemMap = @measure.codeSystemMap() unless @codeSystemMap?
    # convert codeable concepts into model: { system, code, index }
    codes = []
    for codeIndex of @codes
      coding = @codes[codeIndex]
      system = coding.system?.value
      code = coding.code?.value
      codes.push { system: @codeSystemMap[system] || system, code: code, index: codeIndex }

    _(super).extend
      codes: codes

  removeCode: (e) ->
    e.preventDefault()
    codeIndexToRemove = $(e.target).data().codeIndex
    # Remove the code from data element
    removeItemAtIndex = (array, indexToRemove) ->
      [].concat(array.slice(0,indexToRemove), array.slice(indexToRemove + 1))

    codesToKeep = removeItemAtIndex(DataElementHelpers.getPrimaryCodes(@parent.model.get('dataElement')), codeIndexToRemove)
    @parent.updateCodes(codesToKeep)
