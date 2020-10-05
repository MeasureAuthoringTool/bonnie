describe 'InputAgeView', ->

  it 'creates default InputAgeView', ->
    view = new Thorax.Views.InputAgeView()
    view.render()
    spyOn(view, 'trigger')

    expect(view.hasValidValue()).toBe false
    expect(view.value).toBe null

  it 'should be invalid InputAgeView if user enters only value ', ->
    view = new Thorax.Views.InputAgeView()
    view.render()
    spyOn(view, 'trigger')

    view.$('input[name="value_value"]').val('12').change()
    expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
    # invalid view because unit is not entered yet
    expect(view.hasValidValue()).toBe false

  it 'should be valid InputAgeView if user enters both value and valid ucum unit', ->
    view = new Thorax.Views.InputAgeView()
    view.render()
    spyOn(view, 'trigger')

    view.$('input[name="value_value"]').val('12').change()
    expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
    # invalid view because unit is not entered yet
    expect(view.hasValidValue()).toBe false

    view.$('input[name="value_unit"]').val('days').change()
    expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
    # view should be valid as both value and unit is entered
    expect(view.hasValidValue()).toBe true
    expect(view.$('.quantity-control-unit').hasClass('has-error')).toBe false

  it 'should be an invalid InputAgeView if invalid ucum unit entered', ->
    view = new Thorax.Views.InputAgeView()
    view.render()
    spyOn(view, 'trigger')

    view.$('input[name="value_value"]').val('12').change()
    expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
    # invalid view because unit is not entered yet
    expect(view.hasValidValue()).toBe false

    view.$('input[name="value_unit"]').val('test').change()
    expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
    # view should be invalid as unit is not valid ucum unit
    expect(view.hasValidValue()).toBe false
    expect(view.$('.quantity-control-unit').hasClass('has-error')).toBe true

  it 'should be an invalid InputAgeView for valid ucum unit but no value', ->
    view = new Thorax.Views.InputAgeView()
    view.render()
    spyOn(view, 'trigger')

    view.$('input[name="value_unit"]').val('year').change()
    expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
    # view should be invalid as no value provided even if unit is valid
    expect(view.hasValidValue()).toBe false
    expect(view.$('.quantity-control-unit').hasClass('has-error')).toBe true

  it 'can disable and enable all entry fields', ->
    view = new Thorax.Views.InputQuantityView()
    view.render()

    view.disableFields()
    expect(view.$('input[name="value_value"]').prop('disabled')).toBe true
    expect(view.$('input[name="value_unit"]').prop('disabled')).toBe true

    view.enableFields()
    expect(view.$('input[name="value_value"]').prop('disabled')).toBe false
    expect(view.$('input[name="value_unit"]').prop('disabled')).toBe false
