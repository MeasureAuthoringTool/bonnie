describe 'InputView', ->

  describe 'InputPeriodView', ->

    describe 'initalization', ->

      it 'creates default InputPeriodView', ->
        view = new Thorax.Views.InputPeriodView()
        view.render()
        # by default start date checkbox is unchecked and datetime widget is disabled
        expect(view.$el.find("input[name='start_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='start_date']").val()).toEqual  ''
        expect(view.$el.find("input[name='start_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='start_time']").val()).toEqual ''
        expect(view.$el.find("input[name='start_time']").prop('disabled')).toBe true

        # by default end date checkbox is unchecked and datetime widget is disabled
        expect(view.$el.find("input[name='end_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='end_date']").val()).toEqual ''
        expect(view.$el.find("input[name='end_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='end_time']").val()).toEqual ''
        expect(view.$el.find("input[name='end_time']").prop('disabled')).toBe true
        view.remove()

    describe 'handles changes', ->

      beforeEach ->
        @view = new Thorax.Views.InputPeriodView()
        @view.render()
        spyOn(@view, 'trigger')

      afterEach ->
        @view.remove()

      it 'triggers valueChanged event when start date checkbox is checked', ->
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', true).change()
        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)

      it 'triggers valueChanged event when end date checkbox is checked', ->
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', true).change()
        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)

      it 'triggers valueChanged event when start & end date is updated', ->
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', true).change()
        # change the start date and trigger change event
        @view.$el.find("input[name='start_date']").val('09/15/2020').datepicker('update')
        start = new cqm.models.CQL.DateTime(2020, 9, 15, 8, 0, 0, 0, 0)
        expect(@view.value.start.value).toEqual(start.toString())
        expect(@view.value.end).toBe undefined

        # change the end date and trigger change event
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', true).change()
        @view.$el.find("input[name='end_date']").val('09/20/2020').datepicker('update')
        end = new cqm.models.CQL.DateTime(2020, 9, 20, 8, 15, 0, 0, 0)
        expect(@view.value.start.value).toEqual(start.toString())
        expect(@view.value.end.value).toEqual(end.toString())

      it 'triggers valueChanged event when time changes are made', ->
        # change the end time and trigger change event
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', true).change()
        @view.$el.find("input[name='start_date']").val('09/15/2020').datepicker('update')
        @view.$el.find("input[name='start_time']").val('9:45 AM').timepicker('setTime', '9:45 AM')

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        start = new cqm.models.CQL.DateTime(2020, 9, 15, 9, 45, 0, 0, 0)
        expect(@view.value.start.value).toEqual(start.toString())

      it 'triggers valueChange when start date checkbox unchecked', ->
        # set the start date and trigger change event
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', true).change()
        @view.$el.find("input[name='start_date']").val('09/20/2020').datepicker('update')
        start = new cqm.models.CQL.DateTime(2020, 9, 20, 8, 0, 0, 0, 0)
        expect(@view.value.start.value).toEqual(start.toString())

        # uncheck the start date checkbox and trigger change event
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()
        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        expect(@view.value.start).toBe undefined

      it 'triggers valueChange when end date checkbox unchecked', ->
        # set the end date and trigger change event
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', true).change()
        @view.$el.find("input[name='end_date']").val('09/20/2020').datepicker('update')
        end = new cqm.models.CQL.DateTime(2020, 9, 20, 8, 15, 0, 0, 0)
        expect(@view.value.end.value).toEqual(end.toString())

        # uncheck the end date checkbox and trigger change event
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()
        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        expect(@view.value.end).toBe undefined
