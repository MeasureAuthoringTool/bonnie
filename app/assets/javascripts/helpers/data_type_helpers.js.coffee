@DataTypeHelpers = class DataTypeHelpers

  @createCodeableConcept: (code, system) ->
    coding = new cqm.models.Coding()
    coding.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
    coding.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')
    @getCodeableConceptForCoding(coding)

  @getCodeableConceptForCoding: (coding) ->
    return null unless coding?
    codeableConcept = new cqm.models.CodeableConcept()
    codeableConcept.coding = [coding]
    codeableConcept

  @createIntervalFromPeriod: (period) ->
    return null if period == undefined ||
      (period?.start == undefined && period?.end == undefined)

    startDate = @getCQLDateTimeFromString(period?.start?.value) if period?.start?.value?
    endDate = @getCQLDateTimeFromString(period?.end?.value) if period?.end?.value?
    new cqm.models.CQL.Interval(startDate, endDate)

  @getCQLDateTimeFromString: (dateStr) ->
    return null if dateStr == undefined
    cqm.models.CQL.DateTime.fromJSDate(new Date(dateStr), 0)

  @getCQLDateFromString: (dateStr) ->
    return null if dateStr == undefined
    date = moment(dateStr, 'YYYY-MM-DD').toDate()
    cqm.models.CQL.Date.fromJSDate(date)

  @createPeriodFromInterval: (interval) ->
    period = new cqm.models.Period()
    period.start = period.end = null
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive interval.low.toString() if interval && interval.low?
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive interval.high.toString() if interval && interval.high?
    return period

  @getPeriodForStringDateTime: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDateTime = @getCQLDateTimeFromString(dateTimeStr)
    interval = new cqm.models.CQL.Interval(cqlDateTime, cqlDateTime.add(15, cqm.models.CQL.DateTime.Unit.MINUTE))
    @createPeriodFromInterval(interval)

  @getPeriodForStringDate: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDateTime = @getCQLDateTimeFromString(dateTimeStr).add(8, cqm.models.CQL.DateTime.Unit.HOUR)
    interval = new cqm.models.CQL.Interval(cqlDateTime, cqlDateTime.add(15, cqm.models.CQL.DateTime.Unit.MINUTE))
    @createPeriodFromInterval(interval)

  @getPrimitiveDateTimeForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveDateTime.parsePrimitive dateTime?.toString()

  @getPrimitiveInstantForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveInstant.parsePrimitive dateTime?.toString()

  @getPrimitiveDateTimeForStringDateTime: (dateTimeStr) ->
    cqm.models.PrimitiveDateTime.parsePrimitive dateTimeStr

  @getPrimitiveDateTimeForStringDate: (dateStr) ->
    return null unless dateStr?
    cqlDateTime = @getCQLDateTimeFromString(dateStr).add(8, cqm.models.CQL.DateTime.Unit.HOUR)
    cqm.models.PrimitiveDateTime.parsePrimitive cqlDateTime.toString()

  @getPrimitiveInstantForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveInstant.parsePrimitive dateTime?.toString()

  @getPrimitiveDateForCqlDate: (date) ->
    cqm.models.PrimitiveDate.parsePrimitive date?.toString()

  @getPrimitiveDateForStringDateTime: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDate = @getCQLDateFromString(dateTimeStr)
    cqm.models.PrimitiveDate.parsePrimitive cqlDate.toString()