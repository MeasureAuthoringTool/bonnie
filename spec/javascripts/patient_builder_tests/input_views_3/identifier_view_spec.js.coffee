describe 'InputIdentifierView', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure 'cqm_measure_data/CMS1027v0/CMS1027v0.json'
    @view = new Thorax.Views.InputIdentifierView({
      cqmValueSets: @measure.get('cqmValueSets'),
      codeSystemMap: @measure.codeSystemMap(),
      defaultYear: '2020'
    })
    @view.render()

  it 'initializes', ->
    expect(@view.hasValidValue()).toBe false
    expect(@view.subviews).toBeDefined()
    expect(@view.subviews.length).toBe 6
    expect(@view.value).toBe undefined

  it 'with valid values for sub views', ->
    expect(@view.hasValidValue()).toBe false
    # use
    @view.useView.$('select[name="valueset"] > option[value="identifier-use"]').prop('selected', true).change()
    expect(@view.useView.hasValidValue()).toBe true
    expect(@view.useView.value.value).toBe 'official'
    expect(@view.hasValidValue()).toBe true

    # type
    @view.typeView.$('select[name="valueset"] > option[value="identifier-type"]').prop('selected', true).change()
    expect(@view.typeView.hasValidValue()).toBe true
    expect(@view.typeView.value.system.value).toBe 'http://terminology.hl7.org/CodeSystem/v2-0203'
    expect(@view.hasValidValue()).toBe true

    # system
    @view.systemView.$('input[name="value"]').val('some text').change()
    expect(@view.systemView.hasValidValue()).toBe true
    expect(@view.systemView.value.value).toEqual 'some text'
    expect(@view.hasValidValue()).toBe true

    # value
    @view.valueView.$('input[name="value"]').val('ab235csad45r').change()
    expect(@view.valueView.hasValidValue()).toBe true
    expect(@view.valueView.value.value).toEqual 'ab235csad45r'
    expect(@view.hasValidValue()).toBe true

    # period start date
    @view.periodView.$("input[name='start_date_is_defined']").prop('checked', true).change()
    @view.periodView.$('input[name="start_date"]').val('02/11/2020').datepicker('update')
    @view.periodView.$('input[name="start_time"]').val('8:00 AM').timepicker('setTime', '8:00 AM')
    expect(@view.periodView.hasValidValue()).toBe true
    expect(@view.periodView.value.start.value).toBe '2020-02-11T08:00:00.000+00:00'

    # period end date
    @view.periodView.$("input[name='end_date_is_defined']").prop('checked', true).change()
    @view.periodView.$('input[name="end_date"]').val('02/11/2020').datepicker('update')
    @view.periodView.$('input[name="end_time"]').val('8:00 AM').timepicker('setTime', '8:00 AM')
    expect(@view.periodView.hasValidValue()).toBe true
    expect(@view.value.period.end.value).toBe '2020-02-11T08:00:00.000+00:00'

    # period reset
    @view.periodView.$("input[name='start_date_is_defined']").prop('checked', false).change()
    @view.periodView.$("input[name='end_date_is_defined']").prop('checked', false).change()
    expect(@view.value.period).toBeUndefined()

    # assigner
    @view.assignerView.$('input[name="value"]').val('SB').change()
    expect(@view.assignerView.hasValidValue()).toBe true
    expect(@view.assignerView.value.value).toEqual 'SB'
    expect(@view.hasValidValue()).toBe true
