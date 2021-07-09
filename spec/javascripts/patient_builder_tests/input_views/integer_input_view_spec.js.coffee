describe 'InputView', ->

  describe 'IntegerView', ->

    it 'starts with valid null, default params', ->
      view = new Thorax.Views.InputIntegerView()
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'integer'

    it 'starts with valid initial value', ->
      view = new Thorax.Views.InputIntegerView(initialValue: 22, allowNull: false)
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 22
      expect(view.$('input').val()).toEqual '22'

    it 'starts with invalid null, with allowNull false, custom placeholder', ->
      view = new Thorax.Views.InputIntegerView(allowNull: false, placeholder: 'guess a number')
      view.render()

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'guess a number'

    it 'value bcomes valid after entry', ->
      view = new Thorax.Views.InputIntegerView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('6').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 6

    it 'value bcomes invalid after bad entry', ->
      view = new Thorax.Views.InputIntegerView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('not a number').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null