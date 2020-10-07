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

  it 'should be invalid InputRangeView if user enters only low value ', ->
    @view.$('input[name="low_value"]').val('4').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

  it 'should be invalid InputRangeView if user enters only high value ', ->
    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

  it 'should be valid InputRangeView if user enters both low and high value and low value is greater than high value', ->
    @view.$('input[name="low_value"]').val('6').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

  it 'should be valid InputRangeView if user enters both low and high value and low value is equal to high value', ->
    @view.$('input[name="low_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true

  it 'should be valid InputRangeView if user enters both low and high value and low value is less than high value', ->
    @view.$('input[name="low_value"]').val('4').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe false

    @view.$('input[name="high_value"]').val('5').change()
    expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
    expect(@view.hasValidValue()).toBe true
