describe 'InputView', ->

  describe 'BooleanView', ->

    it 'starts with default value - "true"', ->
      view = new Thorax.Views.InputBooleanView()
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe true

    it 'starts with "true" valid initial value', ->
      view = new Thorax.Views.InputBooleanView(initialValue: true)
      view.render()

      expect(view.value).toBe true
      expect(view.hasValidValue()).toBe true
      expect(view.$('select').val()).toEqual 'true'

    it 'starts with "false" valid initial value', ->
      view = new Thorax.Views.InputBooleanView(initialValue: false)
      view.render()

      expect(view.value).toBe false
      expect(view.hasValidValue()).toBe true
      expect(view.$('select').val()).toEqual 'false'

    it 'value can be updated to "true" and "false"', ->
      view = new Thorax.Views.InputBooleanView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe true

      view.$('select').val('false').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe false

      view.$('select').val('true').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe true
