describe 'InputView', ->

  describe 'IntervalQuantityView', ->

    it 'starts with no given interval becomes valid after entry', ->
      view = new Thorax.Views.InputIntervalQuantityView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('.quantity-interval-start input[name="value_value"]:first').val('200').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toEqual null

      view.$('.quantity-interval-start input[name="value_unit"]:first').val('mg').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toEqual null

      view.$('.quantity-interval-end input[name="value_value"]').val('400').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Interval(
        new cqm.models.CQL.Quantity(value: 200, unit: 'mg'),
        new cqm.models.CQL.Quantity(value: 400, unit: ''))

      view.$('.quantity-interval-end input[name="value_unit"]').val('mg').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Interval(
        new cqm.models.CQL.Quantity(value: 200, unit: 'mg'),
        new cqm.models.CQL.Quantity(value: 400, unit: 'mg'))
    
    
    it 'starts with initial quantity and becomes invalid after bad unit entry, valid again after fix', ->
      view = new Thorax.Views.InputIntervalQuantityView(initialValue: new cqm.models.CQL.Interval(
        new cqm.models.CQL.Quantity(value: 200, unit: 'mg')
        new cqm.models.CQL.Quantity(value: 400, unit: 'mg')))
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Interval(
        new cqm.models.CQL.Quantity(value: 200, unit: 'mg')
        new cqm.models.CQL.Quantity(value: 400, unit: 'mg'))
      expect(view.$('.quantity-interval-start input[name="value_value"]').val()).toEqual '200'
      expect(view.$('.quantity-interval-start input[name="value_unit"]').val()).toEqual 'mg'
      expect(view.$('.quantity-interval-end input[name="value_value"]').val()).toEqual '400'
      expect(view.$('.quantity-interval-end input[name="value_unit"]').val()).toEqual 'mg'

      # enter invalid unit
      view.$('.quantity-interval-end input[name="value_unit"]').val('laughs').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.$('.quantity-interval-end .quantity-control-unit').hasClass('has-error')).toBe true
      expect(view.hasValidValue()).toBe false
      expect(view.value).toEqual null

      # enter valid unit
      view.$('.quantity-interval-end input[name="value_unit"]').val('kg').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Interval(
        new cqm.models.CQL.Quantity(value: 200, unit: 'mg')
        new cqm.models.CQL.Quantity(value: 400, unit: 'kg'))

    it 'starts with initial quantity with no low value', ->
      view = new Thorax.Views.InputIntervalQuantityView(initialValue: new cqm.models.CQL.Interval(
        null, new cqm.models.CQL.Quantity(value: 400, unit: 'mg')))
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Interval(
        null, new cqm.models.CQL.Quantity(value: 400, unit: 'mg'))
      expect(view.$('input[name="low_quantity_is_defined"]').prop('checked')).toBe false
      expect(view.$('.quantity-interval-start input[name="value_value"]').val()).toEqual ''
      expect(view.$('.quantity-interval-start input[name="value_value"]').prop('disabled')).toBe true
      expect(view.$('.quantity-interval-start input[name="value_unit"]').val()).toEqual ''
      expect(view.$('.quantity-interval-start input[name="value_unit"]').prop('disabled')).toBe true
      expect(view.$('input[name="high_quantity_is_defined"]').prop('checked')).toBe true
      expect(view.$('.quantity-interval-end input[name="value_value"]').val()).toEqual '400'
      expect(view.$('.quantity-interval-end input[name="value_value"]').prop('disabled')).toBe false
      expect(view.$('.quantity-interval-end input[name="value_unit"]').val()).toEqual 'mg'
      expect(view.$('.quantity-interval-end input[name="value_unit"]').prop('disabled')).toBe false

    it 'starts with initial quantity with no high value', ->
      view = new Thorax.Views.InputIntervalQuantityView(initialValue: new cqm.models.CQL.Interval(
        new cqm.models.CQL.Quantity(value: 400, unit: 'mg'), null))
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.Interval(
        new cqm.models.CQL.Quantity(value: 400, unit: 'mg'), null)
      expect(view.$('input[name="low_quantity_is_defined"]').prop('checked')).toBe true
      expect(view.$('.quantity-interval-start input[name="value_value"]').val()).toEqual '400'
      expect(view.$('.quantity-interval-start input[name="value_value"]').prop('disabled')).toBe false
      expect(view.$('.quantity-interval-start input[name="value_unit"]').val()).toEqual 'mg'
      expect(view.$('.quantity-interval-start input[name="value_unit"]').prop('disabled')).toBe false
      expect(view.$('input[name="high_quantity_is_defined"]').prop('checked')).toBe false
      expect(view.$('.quantity-interval-end input[name="value_value"]').val()).toEqual ''
      expect(view.$('.quantity-interval-end input[name="value_value"]').prop('disabled')).toBe true
      expect(view.$('.quantity-interval-end input[name="value_unit"]').val()).toEqual ''
      expect(view.$('.quantity-interval-end input[name="value_unit"]').prop('disabled')).toBe true
