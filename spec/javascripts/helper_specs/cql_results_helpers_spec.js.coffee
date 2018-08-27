describe 'CQLResultsHelpers', ->
  describe 'prettyResult', ->
    it 'should not destroy objects passed in', ->
      before = {'a': 1, 'b': 2}
      beforeClone = {'a': 1, 'b': 2}
      CQLResultsHelpers.prettyResult(before)
      for key, value in before
        expect(value).toEqual(beforeClone[key])

    it 'should not destroy arrays passed in', ->
      before = [1, 2, 3]
      beforeClone = [1, 2, 3]
      CQLResultsHelpers.prettyResult(before)
      for item, index in before
        expect(item).toEqual(beforeClone[index])

    it 'should properly indent nested objects', ->
      nestedObject = {'one': 'single item', 'three': {'doubleNested': {'a' : '1', 'b': '2', 'c': '3'}, 'nested': 'item'}, 'two': {'nested': 'item', 'nested2': 'item'} }
      prettyNestedObject = """
{
  one: "single item",
  three: {
    doubleNested: {
      a: "1",
      b: "2",
      c: "3"
    },
    nested: "item"
  },
  two: {
    nested: "item",
    nested2: "item"
  }
}
"""
      expect(CQLResultsHelpers.prettyResult(nestedObject)).toEqual(prettyNestedObject)

    it 'should properly indent nested objects and sort out of order elements', ->
      nestedObject = {'three': {'doubleNested': {'b' : '2', 'c': '3', 'a': '1'}, 'aSingleNested': 'item'}, 'two': {'cnested': 'item', 'bnested2': 'item'}, 'one': 'single item' }
      prettyNestedObject = """
{
  one: "single item",
  three: {
    aSingleNested: "item",
    doubleNested: {
      a: "1",
      b: "2",
      c: "3"
    }
  },
  two: {
    bnested2: "item",
    cnested: "item"
  }
}
"""
      expect(CQLResultsHelpers.prettyResult(nestedObject)).toEqual(prettyNestedObject)

  it 'should properly indent a single array', ->
    singleArray = [1, 2, 3]
    expect(CQLResultsHelpers.prettyResult(singleArray)).toEqual('[1,\n2,\n3]')

  it 'should properly indent an array in an object', ->
    arrayObject = {'array': [1, 2, 3]}
    expect(CQLResultsHelpers.prettyResult(arrayObject)).toEqual('{\n  array: [1,\n         2,\n         3]\n}')

  it 'should properly print Quantity with unit', ->
    quantity = new cql.Quantity(value: 1, unit: 'g')
    expect(CQLResultsHelpers.prettyResult(quantity)).toEqual('QUANTITY: 1 g')

  it 'should properly print Quantity without unit', ->
    quantity = new cql.Quantity(value: 5)
    expect(CQLResultsHelpers.prettyResult(quantity)).toEqual('QUANTITY: 5')
