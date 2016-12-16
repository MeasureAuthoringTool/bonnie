describe 'MeasureCollection', ->

  beforeEach ->
    loadState("base_set")
    @measures = bonnie.measures

  it 'has the correct number of measures defined (when defining a measure object for each population)', ->
    expect(@measures.length).toEqual 2



  it 'has the correct number of populations defined (when expanding measures into populations)', ->
    expect(@measures.populations().length).toEqual 3
