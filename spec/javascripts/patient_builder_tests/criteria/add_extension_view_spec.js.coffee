describe 'AddExtensionView', ->

  beforeEach ->
    @dataElement = new cqm.models.DataElement()
    @dataElement.fhir_resource = new cqm.models.Encounter()
    @view = new Thorax.Views.AddExtensionsView(dataElement: @dataElement, extensionsAccessor: 'extension')
    @view.render()

  afterEach ->
    @view?.remove()

  it 'has data element and accessor', ->
    expect(@view.dataElement).toBeDefined()
    expect(@view.extensionsAccessor).toBeDefined()

  it 'supports get extension', ->
    expect(@view.getExtensions()).toBeUndefined()

    extension = new cqm.models.Extension()
    extension.url = 'a valid extension URI';
    extension.value = cqm.models.PrimitiveString.parsePrimitive('text')

    @view.setExtensions([
      extension
    ])

    expect(@view.getExtensions()).toBeDefined()

  it 'supports CodeableConcept', ->
    expect(@view.value).not.toBeDefined()

    # expand
    @view.$('div[data-cy="extensions-form-group"] > a').click().change()

    # enter extension url
    @view.$('input[name="url"]').val('example.org').change()

    expect(@view.urlValid).toBe true

    # select type
    @view.$('select[name="value_type"] > option[value="CodeableConcept"]').prop('selected', true).change()
    expect(@view.$('select[name="value_type"]').val()).toBe 'CodeableConcept'

    expect(@view.selectedValueTypeView).toBeDefined()

    # pick valueset
    expect(@view.$('select[name="valueset"]').val()).toBe '--'
    @view.$('select[name="valueset"] > option[value="custom"]').prop('selected', true).change()
    expect(@view.$('select[name="valueset"]').val()).toBe 'custom'

    # enter custom system
    @view.$('input[name="custom_codesystem"]').val('system1').change()
    # enter custom code
    @view.$('input[name="custom_code"]').val('code1').change()

    expect(@view.selectedValueTypeView.value.coding[0].code.value).toEqual 'code1'
    expect(@view.selectedValueTypeView.value.coding[0].system.value).toEqual 'system1'
