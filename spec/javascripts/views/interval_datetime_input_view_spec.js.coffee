describe 'InputView', ->

  describe 'IntervalDateTimeView', ->

    describe 'initalization', ->

      it 'can start with a fully filled interval', ->
        start = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
        end = new cqm.models.CQL.DateTime(2012, 2, 24, 9, 0, 0, 0, 0)
        view = new Thorax.Views.InputIntervalDateTimeView(initialValue: new cqm.models.CQL.Interval(start, end))
        view.render()

        expect(view.$el.find("input[name='start_date_is_defined']").prop('checked')).toBe true
        expect(view.$el.find("input[name='start_date']").val()).toEqual  "02/23/2012"
        expect(view.$el.find("input[name='start_date']").prop('disabled')).toBe false
        expect(view.$el.find("input[name='start_time']").val()).toEqual "8:15 AM"
        expect(view.$el.find("input[name='start_time']").prop('disabled')).toBe false

        expect(view.$el.find("input[name='end_date_is_defined']").prop('checked')).toBe true
        expect(view.$el.find("input[name='end_date']").val()).toEqual "02/24/2012"
        expect(view.$el.find("input[name='end_date']").prop('disabled')).toBe false
        expect(view.$el.find("input[name='end_time']").val()).toEqual "9:00 AM"
        expect(view.$el.find("input[name='end_time']").prop('disabled')).toBe false
        view.remove()

      it 'can start with an interval with no end', ->
        start = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
        view = new Thorax.Views.InputIntervalDateTimeView(initialValue: new cqm.models.CQL.Interval(start, null))
        view.render()

        expect(view.$el.find("input[name='start_date_is_defined']").prop('checked')).toBe true
        expect(view.$el.find("input[name='start_date']").val()).toEqual  "02/23/2012"
        expect(view.$el.find("input[name='start_date']").prop('disabled')).toBe false
        expect(view.$el.find("input[name='start_time']").val()).toEqual "8:15 AM"
        expect(view.$el.find("input[name='start_time']").prop('disabled')).toBe false

        expect(view.$el.find("input[name='end_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='end_date']").val()).toEqual ""
        expect(view.$el.find("input[name='end_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='end_time']").val()).toEqual ""
        expect(view.$el.find("input[name='end_time']").prop('disabled')).toBe true
        view.remove()

      it 'can start with an interval with no start', ->
        end = new cqm.models.CQL.DateTime(2012, 2, 24, 9, 0, 0, 0, 0)
        view = new Thorax.Views.InputIntervalDateTimeView(initialValue: new cqm.models.CQL.Interval(null, end))
        view.render()

        expect(view.$el.find("input[name='start_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='start_date']").val()).toEqual  ""
        expect(view.$el.find("input[name='start_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='start_time']").val()).toEqual ""
        expect(view.$el.find("input[name='start_time']").prop('disabled')).toBe true

        expect(view.$el.find("input[name='end_date_is_defined']").prop('checked')).toBe true
        expect(view.$el.find("input[name='end_date']").val()).toEqual "02/24/2012"
        expect(view.$el.find("input[name='end_date']").prop('disabled')).toBe false
        expect(view.$el.find("input[name='end_time']").val()).toEqual "9:00 AM"
        expect(view.$el.find("input[name='end_time']").prop('disabled')).toBe false
        view.remove()

      it 'can start with an interval with no start and end', ->
        view = new Thorax.Views.InputIntervalDateTimeView(initialValue: new cqm.models.CQL.Interval(null, null))
        view.render()

        expect(view.$el.find("input[name='start_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='start_date']").val()).toEqual  ""
        expect(view.$el.find("input[name='start_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='start_time']").val()).toEqual ""
        expect(view.$el.find("input[name='start_time']").prop('disabled')).toBe true

        expect(view.$el.find("input[name='end_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='end_date']").val()).toEqual ""
        expect(view.$el.find("input[name='end_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='end_time']").val()).toEqual ""
        expect(view.$el.find("input[name='end_time']").prop('disabled')).toBe true
        view.remove()

      it 'can default to a [null, null] interval if none is provided', ->
        view = new Thorax.Views.InputIntervalDateTimeView()
        view.render()

        expect(view.$el.find("input[name='start_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='start_date']").val()).toEqual  ""
        expect(view.$el.find("input[name='start_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='start_time']").val()).toEqual ""
        expect(view.$el.find("input[name='start_time']").prop('disabled')).toBe true

        expect(view.$el.find("input[name='end_date_is_defined']").prop('checked')).toBe false
        expect(view.$el.find("input[name='end_date']").val()).toEqual ""
        expect(view.$el.find("input[name='end_date']").prop('disabled')).toBe true
        expect(view.$el.find("input[name='end_time']").val()).toEqual ""
        expect(view.$el.find("input[name='end_time']").prop('disabled')).toBe true
        view.remove()

    describe 'handles changes', ->

      beforeEach ->
        start = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
        end = new cqm.models.CQL.DateTime(2012, 2, 24, 9, 0, 0, 0, 0)
        @view = new Thorax.Views.InputIntervalDateTimeView(initialValue: new cqm.models.CQL.Interval(start, end))
        @view.render()

      afterEach ->
        @view.remove()

      it 'triggers valueChanged event when date changes are made', ->
        spyOn(@view, 'trigger')

        # change the start date and trigger change event
        @view.$el.find("input[name='start_date']").val('02/15/2012').change()

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        newStart = new cqm.models.CQL.DateTime(2012, 2, 15, 8, 15, 0, 0, 0)
        newEnd = new cqm.models.CQL.DateTime(2012, 2, 24, 9, 0, 0, 0, 0)
        newInterval = new cqm.models.CQL.Interval(newStart, newEnd)
        expect(@view.value).toEqual(newInterval)

      it 'triggers valueChanged event when time changes are made', ->
        spyOn(@view, 'trigger')

        # change the end time and trigger change event
        @view.$el.find("input[name='end_time']").val('9:45 AM').change()

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        newStart = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
        newEnd = new cqm.models.CQL.DateTime(2012, 2, 24, 9, 45, 0, 0, 0)
        newInterval = new cqm.models.CQL.Interval(newStart, newEnd)
        expect(@view.value).toEqual(newInterval)

      it 'triggers valueChange when end null check boxes checked', ->
        spyOn(@view, 'trigger')

        # change the end date and trigger change event
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()

        expect(@view.trigger).toHaveBeenCalledWith('valueChanged', @view)
        newStart = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
        newInterval = new cqm.models.CQL.Interval(newStart, null)
        expect(@view.value).toEqual(newInterval)

      it 'handles unchecking of both start and end', ->
        # uncheck both
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()

        expect(@view.value).toEqual(new cqm.models.CQL.Interval(null, null))

      it 'handles unchecking of start', ->
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()

        expect(@view.value).toEqual(new cqm.models.CQL.Interval(null, new cqm.models.CQL.DateTime(2012, 2, 24, 9, 0, 0, 0, 0)))

      it 'handles the user entering a end time before start time', ->
        @view.$el.find("input[name='end_date']").val('02/15/2012').change()

        newStart = new cqm.models.CQL.DateTime(2012, 2, 23, 8, 15, 0, 0, 0)
        newEnd = new cqm.models.CQL.DateTime(2012, 2, 15, 9, 0, 0, 0, 0)
        newInterval = new cqm.models.CQL.Interval(newStart, newEnd)
        expect(@view.value).toEqual(newInterval)

      it 'handles the user unchecking both ends, then re-enabling, using dates based on today for default', ->
        # uncheck both
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', false).change()
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', false).change()
        expect(@view.value).toEqual(new cqm.models.CQL.Interval(null, null))

        # check both
        @view.$el.find("input[name='end_date_is_defined']").prop('checked', true).change()
        @view.$el.find("input[name='start_date_is_defined']").prop('checked', true).change()

        # get today in MP year and check the defaults are today 8:00-8:15
        today = new Date()
        newStart = new cqm.models.CQL.DateTime(2012, today.getMonth() + 1, today.getDate(), 8, 0, 0, 0, 0)
        newEnd = new cqm.models.CQL.DateTime(2012, today.getMonth() + 1, today.getDate(), 8, 15, 0, 0, 0)
        newInterval = new cqm.models.CQL.Interval(newStart, newEnd)
        expect(@view.value).toEqual(newInterval)

        # check fields
        expect(@view.$el.find("input[name='start_date_is_defined']").prop('checked')).toBe true
        expect(@view.$el.find("input[name='start_date']").val()).toEqual  moment.utc(newStart.toJSDate()).format('L')
        expect(@view.$el.find("input[name='start_date']").prop('disabled')).toBe false
        expect(@view.$el.find("input[name='start_time']").val()).toEqual "8:00 AM"
        expect(@view.$el.find("input[name='start_time']").prop('disabled')).toBe false

        expect(@view.$el.find("input[name='end_date_is_defined']").prop('checked')).toBe true
        expect(@view.$el.find("input[name='end_date']").val()).toEqual moment.utc(newEnd.toJSDate()).format('L')
        expect(@view.$el.find("input[name='end_date']").prop('disabled')).toBe false
        expect(@view.$el.find("input[name='end_time']").val()).toEqual "8:15 AM"
        expect(@view.$el.find("input[name='end_time']").prop('disabled')).toBe false