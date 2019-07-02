describe 'InputView', ->

  describe 'AnyView', ->

    beforeEach ->
      # load up a measure so we have valuesets
      jasmine.getJSONFixtures().clearCache()
      @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'
      @view = new Thorax.Views.InputAnyView(attributeName: 'attributeNameTest', cqmValueSets: @measure.get('cqmValueSets'), codeSystemMap: @measure.codeSystemMap())
      @view.render()

    it 'initializes', ->
      expect(@view.hasValidValue()).toBe false
      expect(@view.currentType).toEqual ''
      expect(@view.value).toBe null
      expect(@view.inputView).toBeUndefined()

    it 'handles change to DateTime', ->
      @view.$('select[name="type"] > option[value="DateTime"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputDateTimeView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'handles change to Time', ->
      @view.$('select[name="type"] > option[value="Time"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputTimeView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'handles change to Quantity', ->
      @view.$('select[name="type"] > option[value="Quantity"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputQuantityView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'handles change to Code', ->
      @view.$('select[name="type"] > option[value="Code"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputCodeView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'handles change to Integer', ->
      @view.$('select[name="type"] > option[value="Integer"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputIntegerView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      expect(@view.inputView.$('input').attr('placeholder')).toEqual 'attributeNameTest'

    it 'handles change to Decimal', ->
      @view.$('select[name="type"] > option[value="Decimal"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputDecimalView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      expect(@view.inputView.$('input').attr('placeholder')).toEqual 'attributeNameTest'

    it 'handles change to Ratio', ->
      @view.$('select[name="type"] > option[value="Ratio"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputRatioView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'handles change back to no type selection', ->
      # set it to some thing first
      @view.$('select[name="type"] > option[value="Decimal"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputDecimalView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

      # change back to no selection
      @view.$('select[name="type"] > option[value=""]').prop('selected', true).change()
      expect(@view.inputView).toBe null
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'handles change from one type to another', ->
      # set it to some thing first
      @view.$('select[name="type"] > option[value="Decimal"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputDecimalView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

      # change to something different
      @view.$('select[name="type"] > option[value="Integer"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputIntegerView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null

    it 'forwards change event from child input view', ->
      @view.$('select[name="type"] > option[value="Integer"]').prop('selected', true).change()
      expect(@view.inputView instanceof Thorax.Views.InputIntegerView).toBe true
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
      spyOn(@view, 'trigger')

      # make change in input view to have value
      @view.inputView.$('input').val('23').change()
      expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
      expect(@view.hasValidValue()).toBe true
      expect(@view.value).toBe 23

      @view.trigger.calls.reset()
      # make change in input view to have no value
      @view.inputView.$('input').val('').change()
      expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
      expect(@view.hasValidValue()).toBe false
      expect(@view.value).toBe null
