describe 'InputView', ->

  describe 'DateTimeView', ->

    describe 'initalization', ->

      it 'can start with a fully filled datetime', ->
        date = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
        view = new Thorax.Views.InputDateTimeView(initialValue: date)
        view.render()

        expect(view.$el.find("input[name='date_is_defined']").prop('checked')).toBe true
        expect(view.$el.find("input[name='date']").val()).toEqual  "02/23/2012"
        expect(view.$el.find("input[name='date']").prop('disabled')).toBe false
        expect(view.$el.find("input[name='time']").val()).toEqual "8:15 AM"
        expect(view.$el.find("input[name='time']").prop('disabled')).toBe false
        view.remove()

      it 'can default to null datetime if none is provided', ->
        view = new Thorax.Views.InputDateTimeView()
        view.render()

        expect(view.$el.find("input[name='date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='date']").val()).toEqual  ""
        expect(view.$el.find("input[name='date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='time']").val()).toEqual ""
        expect(view.$el.find("input[name='time']").prop('disabled')).toBe true

        view.remove()

    describe 'handles changes', ->

      beforeEach ->
        date = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)

        @view = new Thorax.Views.InputDateTimeView(initialValue: date)
        @view.render()

      afterEach ->
        @view.remove()

      it 'triggers valueChanged event when date changes are made', ->
        spyOn(@view, 'trigger')

        # change the date and trigger change event
        @view.$el.find("input[name='date']").val('02/15/2012').datepicker('update')

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        newDate = new cqm.models.CQL.DateTime(2012, 2, 15, 8, 15, 0, 0, 0)
        expect(@view.value).toEqual(newDate)

      it 'triggers valueChanged event when time changes are made', ->
        spyOn(@view, 'trigger')

        # change the time and trigger change event
        @view.$el.find("input[name='time']").val('9:45 AM').timepicker('setTime', '9:45 AM')

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        newDate= new cqm.models.CQL.DateTime(2012, 2, 23, 9, 45, 0, 0, 0)
        expect(@view.value).toEqual(newDate)

      it 'triggers valueChange when end null check boxes checked', ->
        spyOn(@view, 'trigger')

        # change the date and trigger change event
        @view.$el.find("input[name='date_is_defined']").prop('checked', false).change()

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        expect(@view.value).toBe null

      it 'handles the user unchecking both ends, then re-enabling, using dates based on today for default', ->
        # uncheck
        @view.$el.find("input[name='date_is_defined']").prop('checked', false).change()
        expect(@view.value).toBe null

        # check
        @view.$el.find("input[name='date_is_defined']").prop('checked', true).change()

        # get today in MP year and check the default is today 8:00-8:15
        today = new Date()
        newDate = new cqm.models.CQL.DateTime(2012, today.getMonth() + 1, today.getDate(), 8, 0, 0, 0, 0)
        expect(@view.value).toEqual(newDate)

        # check fields
        expect(@view.$el.find("input[name='date_is_defined']").prop('checked')).toBe true
        expect(@view.$el.find("input[name='date']").val()).toEqual  moment.utc(newDate.toJSDate()).format('L')
        expect(@view.$el.find("input[name='date']").prop('disabled')).toBe false
        expect(@view.$el.find("input[name='time']").val()).toEqual "8:00 AM"
        expect(@view.$el.find("input[name='time']").prop('disabled')).toBe false
