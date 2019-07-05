describe 'InputView', ->

  describe 'DecimalView', ->

    it 'starts with valid null, default params', ->
      view = new Thorax.Views.InputDecimalView()
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'decimal'

    it 'starts with valid initial value', ->
      view = new Thorax.Views.InputDecimalView(initialValue: 6.28, allowNull: false)
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 6.28
      expect(view.$('input').val()).toEqual '6.28'

    it 'starts with invalid null, with allowNull false, custom placeholder', ->
      view = new Thorax.Views.InputDecimalView(allowNull: false, placeholder: 'guess a number')
      view.render()

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'guess a number'

    it 'value bcomes valid after entry', ->
      view = new Thorax.Views.InputDecimalView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('6.28').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 6.28

    it 'value bcomes invalid after bad entry', ->
      view = new Thorax.Views.InputDecimalView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('not a number').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
