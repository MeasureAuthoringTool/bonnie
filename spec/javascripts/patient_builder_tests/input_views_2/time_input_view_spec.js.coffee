describe 'InputView', ->

  describe 'TimeView', ->

    it 'can start with no value', ->
      view = new Thorax.Views.InputTimeView()
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toBe null
      expect(view.$el.find("input[name='time_is_defined']").prop('checked')).toBe false
      expect(view.$el.find("input[name='time']").val()).toEqual ""

    it 'can start with no value, not allowing null', ->
      view = new Thorax.Views.InputTimeView(allowNull: false)
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$el.find("input[name='time_is_defined']").prop('checked')).toBe false
      expect(view.$el.find("input[name='time']").val()).toEqual ""

    it 'can start with a value', ->
      date = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
      time = date.getTime()
      view = new Thorax.Views.InputTimeView(initialValue: time)
      view.render()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual new cqm.models.CQL.DateTime(0, 1, 1, 8, 15, 0, 0, null)
      expect(view.$el.find("input[name='time_is_defined']").prop('checked')).toBe true
      expect(view.$el.find("input[name='time']").val()).toEqual "08:15"

    it 'can start with no value, not allowing null, then the checkbox can be clicked to create default', ->
      view = new Thorax.Views.InputTimeView(allowNull: false)
      view.render()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      spyOn(view, 'trigger')

      # check the box and expect default to be 08:00
      view.$el.find("input[name='time_is_defined']").prop('checked', true).change()
      expect(view.hasValidValue()).toBe true
      expect(view.$el.find("input[name='time']").val()).toEqual '08:00'
      expect(view.value).toEqual cqm.models.PrimitiveTime.parsePrimitive('08:00')

    it 'can start with a value, not allowing null, then unchecked to be null', ->
      date = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
      time = date.getTime()
      view = new Thorax.Views.InputTimeView(initialValue: time, allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      # uncheck the box and expect things to be null
      view.$el.find("input[name='time_is_defined']").prop('checked', false).change()
      expect(view.hasValidValue()).toBe false
      expect(view.value).toBe null
      expect(view.$el.find("input[name='time']").val()).toEqual ''

    it 'can start with a value, not allowing null, then changed', ->
      date = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
      time = date.getTime()
      view = new Thorax.Views.InputTimeView(initialValue: time, allowNull: false)
      view.render()
      spyOn(view, 'trigger')

      # change to 9:45 AM
      view.$el.find("input[name='time']").val('09:45').change()
      expect(view.hasValidValue()).toBe true
      expect(view.value).toEqual cqm.models.PrimitiveTime.parsePrimitive('09:45')