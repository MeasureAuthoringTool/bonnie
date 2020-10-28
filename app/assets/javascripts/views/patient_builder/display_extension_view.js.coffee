# View for displaying the extensions of the Resource/DataCriteria
class Thorax.Views.DisplayExtensionsView extends Thorax.Views.BonnieView
  template: JST['patient_builder/display_extensions']

  initialize: ->
    @dataElement = @model.get('dataElement')

  context: ->
    # build extension url and value map
    extensions = []
    fhirExtensions = @dataElement.fhir_resource?.extension || []
    for extension in fhirExtensions
      extensions.push({url: extension.url?.value, value: DataCriteriaHelpers.stringifyType(extension.value)})

    _(super).extend
      extensions: extensions

  removeExtension: (e) ->
    index = $(e.target).data('extension-index')
    @dataElement.fhir_resource?.extension.splice(index, 1);
    @trigger 'extensionModified', @
