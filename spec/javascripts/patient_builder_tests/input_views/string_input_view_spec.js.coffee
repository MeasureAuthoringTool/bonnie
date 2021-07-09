describe 'InputView', ->

  describe 'StringView', ->

    it 'starts with valid null, default params', ->
      view = new Thorax.Views.InputStringView()
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'string'
    
    it 'starts with valid initial value', ->
      view = new Thorax.Views.InputStringView(initialValue: 'bonnie test', allowNull: false)
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 'bonnie test'
      expect(view.$('input').val()).toEqual 'bonnie test'

    it 'starts with invalid null, with allowNull false, custom placeholder', ->
      view = new Thorax.Views.InputStringView(allowNull: false, placeholder: 'this is a string')
      view.render()

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'this is a string'
    
    it 'value bcomes valid after entry', ->
      view = new Thorax.Views.InputStringView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('test string').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 'test string'
    
    it 'value bcomes null and invalid after empty string is entered', ->
      view = new Thorax.Views.InputStringView(initialValue: 'starting string', allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe 'starting string'

      view.$('input').val('').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null