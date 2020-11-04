describe 'InputView', ->

  describe 'SampledDataView', ->
    it 'starts with no origin, period, or dimensions, then valid after entry', ->
      @sampledData = new cqm.models.SampledData()
      @sampledData.data = null

      view = new Thorax.Views.InputSampledDataView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('.origin-view input[name="value_value"]:first').val('200').change()
      @sampledData.origin = new cqm.models.Quantity()
      @sampledData.origin.value = cqm.models.PrimitiveDecimal.parsePrimitive(200)
      @sampledData.origin.unit = cqm.models.PrimitiveString.parsePrimitive('')

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toEqual @sampledData

      @sampledData.period = cqm.models.PrimitiveDecimal.parsePrimitive(20.0)

      view.$('.period-view input[name="value"]:first').val('20.0').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toEqual @sampledData

      @sampledData.dimensions = cqm.models.PrimitivePositiveInt.parsePrimitive(25)

      view.$('.dimensions-view input[name="value"]:first').val('25').change()
      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual @sampledData

    it 'starts with initial SampledData and becomes invalid after bad unit entry, valid again after fix', ->
      @sampledData = new cqm.models.SampledData()
      @sampledData.origin = new cqm.models.Quantity()
      @sampledData.origin.value = cqm.models.PrimitiveDecimal.parsePrimitive(200)
      @sampledData.origin.unit = cqm.models.PrimitiveString.parsePrimitive('')
      @sampledData.period = cqm.models.PrimitiveDecimal.parsePrimitive(20.0)
      @sampledData.dimensions = cqm.models.PrimitivePositiveInt.parsePrimitive(25)
      @sampledData.data = null

      view = new Thorax.Views.InputSampledDataView(initialValue: @sampledData)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe true

      # enter invalid origin value
      @sampledData.origin.value = null
      view.$('.origin-view input[name="value_value"]:first').val('').change()
      expect(view.hasValidValue()).toBe false
      expect(view.$('.origin-view input[name="value_value"]:first').val()).toEqual ''
      expect(view.value).toEqual @sampledData

      # enter different valid origin value
      @sampledData.origin.value = cqm.models.PrimitiveDecimal.parsePrimitive(45)
      @sampledData.origin.unit = cqm.models.PrimitiveString.parsePrimitive('km')
      view.$('.origin-view input[name="value_value"]:first').val(45).change()
      view.$('.origin-view input[name="value_unit"]:first').val('km').change()
      expect(view.hasValidValue()).toBe true
      expect(view.$('.origin-view input[name="value_value"]:first').val()).toEqual '45'
      expect(view.$('.origin-view input[name="value_unit"]:first').val()).toEqual 'km'
      expect(view.$('.origin-view .quantity-control-unit').hasClass('has-error')).toBe false
      expect(view.value).toEqual @sampledData

    it 'supports all SampledData fields', ->
      expected = new cqm.models.SampledData()
      expected.origin = new cqm.models.Quantity()
      expected.origin.value = cqm.models.PrimitiveDecimal.parsePrimitive(200)
      expected.origin.unit = cqm.models.PrimitiveString.parsePrimitive('km')
      expected.period = cqm.models.PrimitiveDecimal.parsePrimitive(20.0)
      expected.dimensions = cqm.models.PrimitivePositiveInt.parsePrimitive(25)
      expected.factor = cqm.models.PrimitiveDecimal.parsePrimitive(20.5)
      expected.lowerLimit = cqm.models.PrimitiveDecimal.parsePrimitive(10.0)
      expected.upperLimit = cqm.models.PrimitiveDecimal.parsePrimitive(30.0)
      expected.data = cqm.models.PrimitiveString.parsePrimitive('E')

      view = new Thorax.Views.InputSampledDataView()
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('.origin-view input[name="value_value"]:first').val('200').change()
      view.$('.origin-view input[name="value_unit"]:first').val('km').change()
      view.$('.period-view input[name="value"]:first').val('20.0').change()
      view.$('.dimensions-view input[name="value"]:first').val('25').change()
      view.$('.factor-view input[name="value"]:first').val('20.5').change()
      view.$('.lower-limit-view input[name="value"]:first').val('10.0').change()
      view.$('.upper-limit-view input[name="value"]:first').val('30.0').change()
      view.$('.data-view input[name="value"]:first').val('E').change()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual expected
