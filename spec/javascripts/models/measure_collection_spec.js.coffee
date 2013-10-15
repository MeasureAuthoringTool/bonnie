describe 'MeasureCollection', ->

  beforeEach ->
    @measures = Fixtures.Measures

  it 'has the correct number of measures defined (when defining a measure object for each population)', ->
    expect(@measures.length).toEqual 3

  it 'has the correct number of measures defined (when collapsing populations into a single measure)', ->
    expect(@measures.collapsed().length).toEqual 2
