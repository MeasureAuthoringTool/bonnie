describe 'InputView', ->

  describe 'DateTimeView', ->

    describe 'initialization', ->

      it 'invalid by default if not allowNull  ', ->
        view = new Thorax.Views.InputDateTimeView({ allowNull: false })
        view.render()

        expect(view.hasValidValue()).toBe false
        view.remove()

      it 'valid by default if allowNull  ', ->
        view = new Thorax.Views.InputDateTimeView({ allowNull: true })
        view.render()

        expect(view.hasValidValue()).toBe true
        view.remove()

      it 'can start with a fully filled datetime', ->
        date = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-23T08:15:00')
        view = new Thorax.Views.InputDateTimeView({ initialValue: date })
        view.render()

        expect(view.hasValidValue()).toBe true
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
        date = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-23T08:15:00')

        @view = new Thorax.Views.InputDateTimeView({ initialValue: date })
        @view.render()

      afterEach ->
        @view.remove()

      it 'triggers valueChanged event when date changes are made', ->
        spyOn(@view, 'trigger')

        # change the date and trigger change event
        @view.$el.find("input[name='date']").val('02/15/2012').datepicker('update')

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        expect(@view.value.value).toEqual('2012-02-15T08:15:00.000+00:00')

      it 'triggers valueChanged event when time changes are made', ->
        spyOn(@view, 'trigger')

        # change the time and trigger change event
        @view.$el.find("input[name='time']").val('9:45 AM').timepicker('setTime', '9:45 AM')

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        expect(@view.value.value).toEqual('2012-02-23T09:45:00.000+00:00')

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
        debugger
        todayMonth = (today.getMonth() + 1).toString().padStart(2, '0')
        todayDate = '2020-' + todayMonth + '-'+today.getDate()+'T08:00:00.000+00:00'
        expect(@view.value.value).toEqual(todayDate)

        # check fields
        expect(@view.$el.find("input[name='date_is_defined']").prop('checked')).toBe true
        expect(@view.$el.find("input[name='date']").val()).toEqual   moment.utc(todayDate).format('L')
        expect(@view.$el.find("input[name='date']").prop('disabled')).toBe false
        expect(@view.$el.find("input[name='time']").val()).toEqual "8:00 AM"
        expect(@view.$el.find("input[name='time']").prop('disabled')).toBe false
