describe 'InputView', ->

  describe 'CanonicalView', ->

    it 'null not valid by default', ->
      view = new Thorax.Views.InputCanonicalView()
      view.render()

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'canonical'

    it 'starts with valid null, allowNull true', ->
      view = new Thorax.Views.InputCanonicalView({ allowNull: true })
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'canonical'


    it 'starts with valid initial value', ->
      view = new Thorax.Views.InputCanonicalView(initialValue: cqm.models.PrimitiveCanonical.parsePrimitive('http://hl7.org/fhir/ValueSet/my-valueset|0.8'), allowNull: false)
      view.render()

      expect(view.hasValidValue()).toBe true
      expect(view.value.value).toBe 'http://hl7.org/fhir/ValueSet/my-valueset|0.8'
      expect(view.$('input').val()).toEqual 'http://hl7.org/fhir/ValueSet/my-valueset|0.8'

    it 'starts with invalid null, with allowNull false, custom placeholder', ->
      view = new Thorax.Views.InputCanonicalView(allowNull: false, placeholder: 'guess a number')
      view.render()

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      expect(view.$('input').prop('placeholder')).toEqual 'guess a number'

    it 'value becomes valid after entry', ->
      view = new Thorax.Views.InputCanonicalView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('canonical_uri').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value.value).toBe 'canonical_uri'

    it 'value becomes valid if -1', ->
      view = new Thorax.Views.InputIntegerView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('-1').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe true
      expect(view.value.value).toBe -1

    it 'value becomes invalid after bad entry', ->
      view = new Thorax.Views.InputCanonicalView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('not a number').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

    it 'value becomes invalid with tab char', ->
      view = new Thorax.Views.InputCanonicalView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('123\t123').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

    it 'value becomes invalid with a space', ->
      view = new Thorax.Views.InputCanonicalView(allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null

      view.$('input').val('123 123').change()

      expect(view.trigger).toHaveBeenCalledWith('valueChanged', view)
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null