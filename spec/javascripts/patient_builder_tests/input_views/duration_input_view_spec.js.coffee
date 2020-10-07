describe 'InputView', ->

  describe 'DurationView', ->
    beforeEach ->
      @view = new Thorax.Views.InputDurationView()
      @view.render()
      spyOn(@view, 'trigger')

    afterEach ->
      @view.remove()

    it 'starts with no duration value and becomes valid after entry', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

      # Enter duration value
      @view.$('input[name="value_value"]').val('200').change()
      expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.value.value).toEqual 200
      expect(@view.value.unit.value).toEqual ''

      # Enter duration valid ucum unit
      @view.$('input[name="value_unit"]').val('days').change()
      expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.value.value).toEqual 200
      expect(@view.value.unit.value).toEqual 'days'

    it 'starts with valid value/unit and becomes invalid after bad unit entry, valid again after fix', ->
      # Enter valid duration
      @view.$('input[name="value_value"]').val('200').change()
      @view.$('input[name="value_unit"]').val('days').change()
      expect(@view.value.value.value).toEqual 200
      expect(@view.value.unit.value).toEqual 'days'
      expect(@view.hasValidValue()).toBe true

      # enter invalid unit
      @view.$('input[name="value_unit"]').val('laughs').change()
      expect(@view.$('.quantity-control-unit').hasClass('has-error')).toBe true
      expect(@view.hasValidValue()).toBe false

      # enter valid unit
      @view.$('input[name="value_unit"]').val('years').change()
      expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
      expect(@view.$('.quantity-control-unit').hasClass('has-error')).toBe false
      expect(@view.hasValidValue()).toBe true
      expect(@view.value.value.value).toEqual 200
      expect(@view.value.unit.value).toEqual 'years'

    it 'can disable and enable all entry fields', ->
      @view.disableFields()
      expect(@view.$('input[name="value_value"]').prop('disabled')).toBe true
      expect(@view.$('input[name="value_unit"]').prop('disabled')).toBe true

      @view.enableFields()
      expect(@view.$('input[name="value_value"]').prop('disabled')).toBe false
      expect(@view.$('input[name="value_unit"]').prop('disabled')).toBe false
