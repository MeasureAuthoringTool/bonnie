describe 'DataCriteriaHelpers', ->
  it 'has dat_element_categories and primary_date_attributes', ->
    expect(Object.keys(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES).length).toEqual 32
    expect(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES['Encounter']).toEqual { period: 'Period' }
    expect(Object.keys(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES).length).toEqual 39
    expect(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES['Encounter']).toEqual 'management'

  it 'creates interval from period', ->
    period = new cqm.models.Period()
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-05T09:00:00.000+00:00')

    interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
    expect(interval.low.toString()).toEqual period.start.value
    expect(interval.high.toString()).toEqual period.end.value

  it 'creates period from interval', ->
    start = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
    end = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
    interval = new cqm.models.CQL.Interval(start, end)
    period = DataCriteriaHelpers.createPeriodFromInterval(interval)
    expect(period.start.value).toEqual interval.low.toString()
    expect(period.end.value).toEqual interval.high.toString()

  it 'creates PrimitiveDateTime from CQL DateTime', ->
    dateTime = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
    primitiveDateTime = DataCriteriaHelpers.getPrimitiveDateTimeForCqlDateTime(dateTime)
    expect(primitiveDateTime instanceof cqm.models.PrimitiveDateTime).toEqual true
    expect(primitiveDateTime.value).toEqual dateTime.toString()

  it 'creates PrimitiveInstant from CQL DateTime', ->
    dateTime = new cqm.models.CQL.DateTime(2020, 2, 2, 8, 45, 0, 0, 0)
    primitiveInstant = DataCriteriaHelpers.getPrimitiveInstantForCqlDateTime(dateTime)
    expect(primitiveInstant instanceof cqm.models.PrimitiveInstant).toEqual true
    expect(primitiveInstant.value).toEqual dateTime.toString()

  it 'creates PrimitiveDate from CQL Date', ->
    date = new cqm.models.CQL.Date(2020, 4, 5)
    primitiveDate = DataCriteriaHelpers.getPrimitiveDateForCqlDate(date)
    expect(primitiveDate instanceof cqm.models.PrimitiveDate).toEqual true
    expect(primitiveDate.value).toEqual date.toString()
