describe 'InputView', ->

  describe 'CompositeView', ->

    it 'starts with no valid value', ->
      view = new Thorax.Views.InputCompositeView(attributeName: 'attributeNameTest')
      view.render()
      expect(view.hasValidValue()).toBe false 
      expect(view.value).toBe null