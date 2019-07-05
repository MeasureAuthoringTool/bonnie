describe 'InputView', ->

  describe 'QuantityView', ->

    it 'starts with no quantity and becomes valid after entry', ->
      view = new Thorax.Views.InputQuantityView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input[name="value_value"]').val('200').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Quantity(value: 200, unit: '')

      view.$('input[name="value_unit"]').val('mg').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Quantity(value: 200, unit: 'mg')
    
    it 'starts with initial quantity and becomes invalid after bad unit entry, valid again after fix', ->
      view = new Thorax.Views.InputQuantityView(initialValue: new cqm.models.CQL.Quantity(value: 200, unit: 'm'))
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Quantity(value: 200, unit: 'm')
      expect(view.$('input[name="value_value"]').val()).toEqual '200'
      expect(view.$('input[name="value_unit"]').val()).toEqual 'm'

      # enter invalid unit
      view.$('input[name="value_unit"]').val('laughs').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.$('.quantity-control-unit').hasClass('has-error')).toBe true
      expect(view.hasValidValue()).toBe false
      expect(view.value).toEqual null

      # enter valid unit
      view.$('input[name="value_unit"]').val('cm').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.$('.quantity-control-unit').hasClass('has-error')).toBe false
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Quantity(value: 200, unit: 'cm')
    
    it 'can disable and enable all entry fields', ->
      view = new Thorax.Views.InputQuantityView()
      view.render()

      view.disableFields()
      expect(view.$('input[name="value_value"]').prop('disabled')).toBe true
      expect(view.$('input[name="value_unit"]').prop('disabled')).toBe true

      view.enableFields()
      expect(view.$('input[name="value_value"]').prop('disabled')).toBe false
      expect(view.$('input[name="value_unit"]').prop('disabled')).toBe false