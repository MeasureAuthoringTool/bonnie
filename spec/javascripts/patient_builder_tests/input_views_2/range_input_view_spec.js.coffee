describe 'InputRangeView', ->

  beforeEach ->
    @view = new Thorax.Views.InputRangeView()
    @view.render()
    spyOn(@view, 'trigger')

  afterEach ->
    @view.remove()

  it 'creates default InputRangeView', ->
    expect(@view.hasValidValue()).toBe false
    expect(@view.value).toBe null

  it 'should be valid InputRangeView if user enters only low value ', ->
    @view.$('input[name="low_value"]').val('4').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.low.value.value).toBe 4
    expect(@view.value.low.unit).toBe null

  it 'should be valid InputRangeView if user enters only high value ', ->
    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.high.value.value).toBe 5
    expect(@view.value.high.unit).toBe null

  it 'should be invalid InputRangeView if user enters both low and high value and low value is greater than high value', ->
    @view.$('input[name="low_value"]').val('6').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.low.value.value).toBe 6
    expect(@view.value.low.unit).toBe null

    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

  it 'should be invalid InputRangeView if user enters both low and high value and low value is greater than high value and high value is zero', ->
    @view.$('input[name="low_value"]').val('6').change()
    @view.$('input[name="high_value"]').val('0').change()
    expect(@view.value.low.value.value).toBe 6
    expect(@view.value.low.unit).toBe null
    expect(@view.value.high.value.value).toBe 0
    expect(@view.value.high.unit).toBe null

    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

  it 'should be valid InputRangeView if user enters both low and high value and low value is equal to high value', ->
    @view.$('input[name="low_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.low.value.value).toBe 5
    expect(@view.value.low.unit).toBe null

    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.high.value.value).toBe 5
    expect(@view.value.high.unit).toBe null

  it 'should be valid InputRangeView if user enters both low and high value and low value is less than high value', ->
    @view.$('input[name="low_value"]').val('4').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.low.value.value).toBe 4
    expect(@view.value.low.unit).toBe null

    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
    expect(@view.value.high.value.value).toBe 5
    expect(@view.value.high.unit).toBe null

  it 'Valid UCUM unit', ->
    expect(@view.isValidUcum('g' )).toBe true
    expect(@view.isValidUcum('s' )).toBe true
    expect(@view.isValidUcum('ms' )).toBe true
    expect(@view.isValidUcum('error' )).toBe false
    expect(@view.isValidUcum('unknown' )).toBe false

  it 'Show error if UCUM unit is not valid', ->
    @view.$('input[name="low_value"]').val('4').change()

    # enter invalid unit
    @view.$('input[name="unit"]').val('laughs').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.$('.range-control-unit').hasClass('has-error')).toBe true
    expect(@view.hasValidValue()).toBe false
    expect(@view.value).toBeNull()

    # enter valid unit
    @view.$('input[name="unit"]').val('cm').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.$('.range-control-unit').hasClass('has-error')).toBe false
    expect(@view.hasValidValue()).toBe true
    expect(@view.value).toBeDefined()
    expect(@view.value.low.value.value).toBe 4
    expect(@view.value.low.unit.value).toBe 'cm'
