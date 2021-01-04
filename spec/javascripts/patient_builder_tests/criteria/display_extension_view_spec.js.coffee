describe 'DisplayExtensionView', ->

  beforeEach ->
    @dataElement = new cqm.models.DataElement()
    @dataElement.fhir_resource = new cqm.models.Encounter()
    @displayView = new Thorax.Views.DisplayExtensionsView(dataElement: @dataElement, extensionsAccessor: 'extension')

  afterEach ->

  it 'has data element and accessor', ->
    expect(@displayView.dataElement).toBeDefined()
    expect(@displayView.extensionsAccessor).toBeDefined()

  it 'supports get extension', ->
    expect(@displayView.getExtensions()).toBeUndefined()

    extension = new cqm.models.Extension()
    extension.url = 'a valid extension URI';
    extension.value = cqm.models.PrimitiveString.parsePrimitive('text')

    @dataElement.fhir_resource.extension = [
      extension
    ]
    expect(@displayView.getExtensions()).toBeDefined()
