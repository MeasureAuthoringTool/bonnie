describe 'InputObservationComponentView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure 'cqm_measure_data/CMS1027v0/CMS1027v0.json'
    @view = new Thorax.Views.InputObservationComponentView({
      cqmValueSets: @measure.get('cqmValueSets'),
      codeSystemMap: @measure.codeSystemMap(),
      defaultYear: '2020'
    })
    @view.render()

  it 'initializes', ->
    expect(@view.hasValidValue()).toBe false
    expect(@view.subviews).toBeDefined()
    expect(@view.subviews.length).toBe 2
    expect(@view.value).toBe null

  it 'with valid values for sub views', ->
    expect(@view.hasValidValue()).toBe false

    # ==== Code ====
    expect(@view.$(".observation-component-code-view select[name='valueset']").val()).toBe '--'

    # pick valueset
    @view.$('.observation-component-code-view select[name="valueset"] > option[value="observation-codes"]').prop('selected', true).change()
    expect(@view.hasValidValue()).toBe true

# pick system
    @view.$('.observation-component-code-view select[name="vs_codesystem"] > option[value="http://loinc.org"]').prop('selected', true).change()
    expect(@view.hasValidValue()).toBe true

# pick code
    @view.$('.observation-component-code-view select[name="vs_code"] > option[value="1-8"]').prop('selected', true).change()
# check value
    expect(@view.value).toBeDefined()
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.code.coding[0].code.value).toEqual '1-8'
    expect(@view.value.code.coding[0].system.value).toEqual 'http://loinc.org'

    # === Value ====
    expect(@view.$(".observation-component-value-view select[name='type']").val()).toBe ''

    # pick a type
    @view.$('.observation-component-value-view select[name="type"] > option[value="String"]').prop('selected', true).change()

    expect(@view.$(".observation-component-value-view input[name='value']").val()).toBe ''

    @view.$(".observation-component-value-view input[name='value']").val('135').change()

    expect(@view.value).toBeDefined()
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.value.value).toBe '135'
