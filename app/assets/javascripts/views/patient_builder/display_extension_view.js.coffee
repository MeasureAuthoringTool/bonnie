# View for displaying the extensions of the Resource/DataCriteria
class Thorax.Views.DisplayExtensionsView extends Thorax.Views.BonnieView
  template: JST['patient_builder/display_extensions']

  initialize: ->
    @dataElement = @model.get('dataElement')

  context: ->
    # Extendions are show in the order of their definition, but groupped by URLs
    # each element is an object { url: '...', values: [ ... ] }
    extensions = []
    # Keep a map of url -> index-in-extensions-array for quick search by url
    extensionsUrls = {}

    @dataElement.fhir_resource?.extension.forEach (extension, originalIndex) =>
      url = extension.url?.value
      if !extensionsUrls.hasOwnProperty(url)
        extensionsUrls[url] = extensions.length
        extensions.push({ url: extension.url?.value, values: [] })
      extensions[extensionsUrls[url]].values.push({ url: url, value: DataCriteriaHelpers.stringifyType(extension.value), index: originalIndex })

    _(super).extend
      extensions: extensions

  removeExtension: (e) ->
    index = $(e.target).data('extension-index')
    @dataElement.fhir_resource?.extension.splice(index, 1);
    @trigger 'extensionModified', @
