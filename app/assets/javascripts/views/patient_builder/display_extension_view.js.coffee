# View for displaying the extensions on the Resource/DataCriteria
class Thorax.Views.DisplayExtensionView extends Thorax.Views.BonnieView
  template: JST['patient_builder/display_extension']

  initialize: ->
    @dataElement = @model.get('dataElement')

  context: ->
    debugger
    # build extension url and value map
    extensions = []
    fhirExtensions = @dataElement.fhir_resource?.extension || []
    for extension in fhirExtensions
      extensions.push({url: extension.url?.value, value: DataCriteriaHelpers.stringifyPrimitiveType(extension.value)})

    _(super).extend
      extensions: extensions

  removeValue: (e) ->
    attributeName = $(e.target).data('attribute-name')
    @trigger 'attributesModified', @
