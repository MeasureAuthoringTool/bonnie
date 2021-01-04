describe 'AddExtensionView', ->

  beforeEach ->
    @dataElement = new cqm.models.DataElement()
    @dataElement.fhir_resource = new cqm.models.Encounter()
    @addExtensionView = new Thorax.Views.AddExtensionsView(dataElement: @dataElement, extensionsAccessor: 'extension')

  afterEach ->

  it 'has data element and accessor', ->
    expect(@addExtensionView.dataElement).toBeDefined()
    expect(@addExtensionView.extensionsAccessor).toBeDefined()

  it 'supports get extension', ->
    expect(@addExtensionView.getExtensions()).toBeUndefined()

    extension = new cqm.models.Extension()
    extension.url = 'a valid extension URI';
    extension.value = cqm.models.PrimitiveString.parsePrimitive('text')

    @addExtensionView.setExtensions([
      extension
    ])

    expect(@addExtensionView.getExtensions()).toBeDefined()
