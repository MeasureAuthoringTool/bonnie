describe 'InputView', ->

  describe 'UnsignedIntegerView', ->

    it 'null not valid by default', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'unsigned integer'

    it 'starts with valid initial value', ->
      view = new Thorax.Views.InputUnsignedIntegerView(initialValue: cqm.models.PrimitiveUnsignedInt.parsePrimitive(22))
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value.value).toBe 22
      expect(view.$('input').val()).toEqual '22'

    it 'starts with null and custom placeholder', ->
      view = new Thorax.Views.InputUnsignedIntegerView(placeholder: 'guess a number')
      view.render()

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'guess a number'

    it 'value becomes valid after valid entry', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      view.$('input').val('6').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value.value).toBe 6

    it 'value becomes valid if zero', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      view.$('input').val('0').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value.value).toBe 0

    it 'value becomes invalid if -1', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      view.$('input').val('-1').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe true
      expect(view.$('input').parent().hasClass('has-error')).toBe true

    it 'value becomes invalid after bad entry', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      view.$('input').val('not a number').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe true
      expect(view.$('input').parent().hasClass('has-error')).toBe true
      expect(view.value).toBe null

    it 'value becomes invalid with leading zeroes', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      view.$('input').val('001').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe true
      expect(view.$('input').parent().hasClass('has-error')).toBe true
      expect(view.value).toBe null

    it 'value becomes invalid with decimals', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      view.$('input').val('123.123').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe true
      expect(view.$('input').parent().hasClass('has-error')).toBe true
      expect(view.value).toBe null

    it 'value becomes invalid with exponent', ->
      view = new Thorax.Views.InputUnsignedIntegerView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe false
      expect(view.$('input').parent().hasClass('has-error')).toBe false
      expect(view.value).toBe null

      view.$('input').val('123e123').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.hasInvalidInput()).toBe true
      expect(view.$('input').parent().hasClass('has-error')).toBe true
      expect(view.value).toBe null
