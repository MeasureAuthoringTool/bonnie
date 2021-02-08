describe 'InputView', ->

  describe 'IdView', ->

    it 'default is null', ->
      view = new Thorax.Views.InputIdView()
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$('input').prop('placeholder')).toEqual 'id'

    it 'set valid value', ->
      view = new Thorax.Views.InputIdView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      # Enter the valid value
      view.$('input').val('Ke0WJG6mAputCPIR0.e-qw').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value.value).toBe 'Ke0WJG6mAputCPIR0.e-qw'

    it 'enter invalid characters @', ->
      view = new Thorax.Views.InputIdView()
      view.render()
      spyOn(view, 'trigger')

      view.$('input').val('W@&test').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false

    it 'enter valid input but exceeds max length 64', ->
      view = new Thorax.Views.InputIdView()
      view.render()
      spyOn(view, 'trigger')

      view.$('input').val('Ke0WJG6mAputCPIR0TBK3JV03Jr5m1YvfcEDNPKztJImg1GqNn8qwC7BDW5GCUiIo').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
