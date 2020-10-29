describe 'DataCriteriaHelpers', ->

  beforeEach ->
    @assertCodingWithType = (resourceType, path, title, type) ->
      attrs = DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES[resourceType]
      expect(attr).toBeDefined
      attr = attrs.find (attr) => attr.path is path
      expect(attr.path).toBe path
      expect(attr.title).toBe title
      expect(attr.types.length).toBe 1
      expect(attr.types[0]).toBe type

      fhirResource = new cqm.models[resourceType]()
      expect(attr.getValue(fhirResource)).toBeUndefined

      valueToSet = new cqm.models.Coding()
      valueToSet.code = cqm.models.PrimitiveCode.parsePrimitive('code1')
      valueToSet.system = cqm.models.PrimitiveUrl.parsePrimitive('system1')

      attr.setValue(fhirResource, valueToSet)

      # clone the resource to make sure setter/getter work with correct data type
      value = attr.getValue(fhirResource.clone())
      expect(value).toBeDefined
      expect(value.code.value).toBe 'code1'
      expect(value.system.value).toBe 'system1'

    @assertCodeableConcept = (resourceType, path, title) ->
      @assertCodingWithType(resourceType, path, title, 'CodeableConcept')

    @assertCoding = (resourceType, path, title) ->
      @assertCodingWithType(resourceType, path, title, 'Coding')

  it 'has data_element_categories and primary_date_attributes', ->
    expect(Object.keys(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES).length).toEqual 32
    expect(DataCriteriaHelpers.PRIMARY_TIMING_ATTRIBUTES['Encounter']).toEqual { period: 'Period' }
    expect(Object.keys(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES).length).toEqual 39
    expect(DataCriteriaHelpers.DATA_ELEMENT_CATEGORIES['Encounter']).toEqual 'management'

  describe 'data type converters', ->
    it 'creates interval from period', ->
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-05T09:00:00.000+00:00')

      interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
      expect(interval.low.toString()).toEqual period.start.value
      expect(interval.high.toString()).toEqual period.end.value

    it 'creates interval from period when start and end is not available', ->
      period = new cqm.models.Period()
      interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
      expect(interval).toEqual null

    it 'creates interval from period when start is available but end is not available', ->
      period = new cqm.models.Period()
      period.start = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
      period.end = undefined
      interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
      expect(interval.low.toString()).toEqual period.start.value
      expect(interval.high).toEqual undefined

    it 'creates interval from period when start is not available but end is available', ->
      period = new cqm.models.Period()
      period.start = undefined
      period.end = cqm.models.PrimitiveDateTime.parsePrimitive('2012-02-02T08:45:00.000+00:00')
      interval = DataCriteriaHelpers.createIntervalFromPeriod(period)
      expect(interval.low).toEqual period.start
      expect(interval.high.toString()).toEqual period.end.value

    it 'creates period from interval', ->
      start = new cqm.models.CQL.DateTime(2012, 2, 2, 8, 45, 0, 0, 0)
      end = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
      interval = new cqm.models.CQL.Interval(start, end)
      period = DataCriteriaHelpers.createPeriodFromInterval(interval)
      expect(period.start.value).toEqual interval.low.toString()
      expect(period.end.value).toEqual interval.high.toString()

    it 'creates period from interval when low is undefined', ->
      end = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
      interval = new cqm.models.CQL.Interval(undefined , end)
      period = DataCriteriaHelpers.createPeriodFromInterval(interval)
      expect(period.start).toEqual null
      expect(period.end.value).toEqual interval.high.toString()

    it 'creates period from interval when high is undefined', ->
      start = new cqm.models.CQL.DateTime(2012, 2, 3, 9, 45, 0, 0, 0)
      interval = new cqm.models.CQL.Interval(start , undefined )
      period = DataCriteriaHelpers.createPeriodFromInterval(interval)
      expect(period.start.value).toEqual interval.low.toString()
      expect(period.end).toEqual null

    it 'creates period from datetime string', ->
      date = new cqm.models.CQL.DateTime(2020, 9, 21, 8, 0, 0, 0, 0)
      period = DataCriteriaHelpers.getPeriodForStringDateTime(date.toString())
      expect(period.start.value).toEqual date.toString()
      expect(period.end.value).toEqual date.add(15, cqm.models.CQL.DateTime.Unit.MINUTE).toString()

    it 'creates period from date string', ->
      date = new cqm.models.CQL.Date(2020, 9, 21)
      period = DataCriteriaHelpers.getPeriodForStringDate(date.toString())
      expect(period.start.value).toEqual '2020-09-21T08:00:00.000+00:00'
      expect(period.end.value).toEqual '2020-09-21T08:15:00.000+00:00'

    it 'creates CQL date from date string', ->
      dateString = '2012-02-02T08:45:00.000+00:00'
      cqlDate = DataCriteriaHelpers.getCQLDateFromString(dateString)
      expect(cqlDate.toString()).toEqual '2012-02-02'

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

    it 'creates PrimitiveDateTime from DateTime string', ->
      dateTime = new cqm.models.CQL.DateTime(2020, 2, 2, 8, 45, 0, 0, 0)
      primitiveDateTime = DataCriteriaHelpers.getPrimitiveDateTimeForStringDateTime(dateTime.toString())
      expect(primitiveDateTime instanceof cqm.models.PrimitiveDateTime).toEqual true
      expect(primitiveDateTime.value).toEqual dateTime.toString()

    it 'creates PrimitiveDateTime from Date string', ->
      date = new cqm.models.CQL.Date(2020, 9, 23)
      primitiveDateTime = DataCriteriaHelpers.getPrimitiveDateTimeForStringDate(date.toString())
      expect(primitiveDateTime instanceof cqm.models.PrimitiveDateTime).toEqual true
      expect(primitiveDateTime.value).toEqual '2020-09-23T08:00:00.000+00:00'

    it 'creates PrimitiveDate from DateTime string', ->
      dateTime = new cqm.models.CQL.DateTime(2020, 9, 23, 8, 45, 0, 0, 0)
      primitiveDate = DataCriteriaHelpers.getPrimitiveDateForStringDateTime(dateTime.toString())
      expect(primitiveDate instanceof cqm.models.PrimitiveDate).toEqual true
      expect(primitiveDate.value).toEqual '2020-09-23'

    it 'test stringifyType for different fhir primitive types', ->
      # null value
      stringValue = DataCriteriaHelpers.stringifyType(null)
      expect(stringValue).toEqual 'null'

      # code type
      code = cqm.models.PrimitiveCode.parsePrimitive('code')
      stringValue = DataCriteriaHelpers.stringifyType(code)
      expect(stringValue).toEqual code.value

      # string type
      primitiveString = cqm.models.PrimitiveString.parsePrimitive('somestring')
      stringValue = DataCriteriaHelpers.stringifyType(primitiveString)
      expect(stringValue).toEqual primitiveString.value

      # Integer type
      primitiveInteger = cqm.models.PrimitiveInteger.parsePrimitive(12)
      stringValue = DataCriteriaHelpers.stringifyType(primitiveInteger)
      expect(stringValue).toEqual primitiveInteger.value.toString()

      # Duration type
      duration = new cqm.models.Duration()
      duration.unit = cqm.models.PrimitiveString.parsePrimitive('ml')
      duration.value = cqm.models.PrimitiveDecimal.parsePrimitive(100)
      stringValue = DataCriteriaHelpers.stringifyType(duration)
      expect(stringValue).toEqual "100 'ml'"

      # Range type
      range = new cqm.models.Range()
      range.low = new cqm.models.SimpleQuantity()
      range.low.unit = cqm.models.PrimitiveString.parsePrimitive('mg')
      range.low.value = cqm.models.PrimitiveDecimal.parsePrimitive(12.5)
      range.high = new cqm.models.SimpleQuantity()
      range.high.unit = cqm.models.PrimitiveString.parsePrimitive('mg')
      range.high.value = cqm.models.PrimitiveDecimal.parsePrimitive(15.1)
      stringValue = DataCriteriaHelpers.stringifyType(range)
      expect(stringValue).toEqual "12.5 - 15.1 mg"

      # Ratio type
      ratio = new cqm.models.Ratio()
      ratio.numerator = cqm.models.Quantity.parse({value:1, unit: 'd'})
      ratio.denominator = cqm.models.Quantity.parse({value:2, unit: 'd'})
      stringValue = DataCriteriaHelpers.stringifyType(ratio)
      expect(stringValue).toEqual "1 'd' : 2 'd'"

      # Period type
      period = cqm.models.Period.parse({
          start:'2020-09-02T13:54:57',
          end: '2020-10-02T13:54:57'
        })
      stringValue = DataCriteriaHelpers.stringifyType(period)
      expect(stringValue).toEqual "09/02/2020 5:54 PM - 10/02/2020 5:54 PM"

      # DateTime type
      dateTime = cqm.models.PrimitiveDateTime.parsePrimitive( '2020-09-02T13:54:57')
      stringValue = DataCriteriaHelpers.stringifyType(dateTime)
      expect(stringValue).toEqual "09/02/2020 5:54 PM"

      # Date type
      primitiveDate = cqm.models.PrimitiveDate.parsePrimitive( '2020-09-02T13:54:57')
      stringValue = DataCriteriaHelpers.stringifyType(primitiveDate)
      expect(stringValue).toEqual "09/02/2020"

  describe 'Primary code path', ->
    it 'returns undefined (unsupported) for an empty DataElement getPrimaryCodePath', ->
      expect(DataCriteriaHelpers.getPrimaryCodePath(new cqm.models.DataElement())).toBeUndefined

    it 'returns null for a DataElement unknown resource', ->
      de = new cqm.models.DataElement()
      de.fhir_resource = new cqm.models.Resource()
      de.fhir_resource.resourceType = 'unsupported'
      expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toBe(null)

    it 'returns meta for getPrimaryCodePath', ->
       for res in Object.keys(DataCriteriaHelpers.DATA_ELEMENT_ATTRIBUTES)
        de = new cqm.models.DataElement()
        de.fhir_resource = new cqm.models[res]()
        expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toBeDefined()

    it 'set/get primary codes works for Encounter', ->
      de = new cqm.models.DataElement()
      de.fhir_resource = new cqm.models.Encounter()
      expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toEqual 'type'
      expect(DataCriteriaHelpers.getPrimaryCodes(de)).toEqual []
      coding = new cqm.models.Coding()
      coding.system = cqm.models.PrimitiveUri.parsePrimitive('system')
      coding.code = cqm.models.PrimitiveCode.parsePrimitive('code')
      coding.version = cqm.models.PrimitiveString.parsePrimitive('version')
      DataCriteriaHelpers.setPrimaryCodes(de, [coding])
      expect(DataCriteriaHelpers.getPrimaryCodes(de).length).toEqual 1
      expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].code.value).toEqual 'code'
      expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].system.value).toEqual 'system'
      expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].version.value).toEqual 'version'

    it 'set/get primary codes works for Condition', ->
      de = new cqm.models.DataElement()
      de.fhir_resource = new cqm.models.Condition()
      expect(DataCriteriaHelpers.getPrimaryCodePath(de)).toEqual 'code'
      expect(DataCriteriaHelpers.getPrimaryCodes(de)).toEqual []
      coding = new cqm.models.Coding()
      coding.system = cqm.models.PrimitiveUri.parsePrimitive('system')
      coding.code = cqm.models.PrimitiveCode.parsePrimitive('code')
      coding.version = cqm.models.PrimitiveString.parsePrimitive('version')
      DataCriteriaHelpers.setPrimaryCodes(de, [coding])
      expect(DataCriteriaHelpers.getPrimaryCodes(de).length).toEqual 1
      expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].code.value).toEqual 'code'
      expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].system.value).toEqual 'system'
      expect(DataCriteriaHelpers.getPrimaryCodes(de)[0].version.value).toEqual 'version'
