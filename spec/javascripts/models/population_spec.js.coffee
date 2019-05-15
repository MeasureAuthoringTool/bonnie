describe 'Population', ->

  beforeEach ->
    @population = new Thorax.Models.Population()

  xit 'should return index 0 for stratifier without appended index', ->
    index = @population.getStratIndexFromStratName("STRAT")
    expect(index).toEqual 0

  xit 'should return single digit index appended to stratifier name', ->
    index = @population.getStratIndexFromStratName("STRAT_1")
    expect(index).toEqual 1

  xit 'should return double digit index appended to stratifier name', ->
    index = @population.getStratIndexFromStratName("STRAT_33")
    expect(index).toEqual 33
