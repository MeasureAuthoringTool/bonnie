describe "Population state between routes", ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    @patient = new Thorax.Models.Patient getJSONFixture('records/core_records/CMS160/patients.json')[0], parse: true
    @measureToTest = new Thorax.Models.Measure getJSONFixture('measure_data/core_measures/CMS160/CMS160v6.json'), parse: true
    @oldValueSetsByOid = bonnie.valueSetsByOid
    bonnie.valueSetsByOid = getJSONFixture('/measure_data/core_measures/CMS160/value_sets.json')
    @measureToTest.get('patients').add @patient

  afterEach ->
    bonnie.valueSetsByOid = @oldValueSetsByOid

  it "starts with the first population", ->
    @measureView = new Thorax.Views.MeasureLayout(measure: @measureToTest, patients: @measureToTest.get('patients'))
    @measureView = @measureView.showMeasure()
    @measureView.appendTo 'body'

    populationNavs = @measureView.$('[data-toggle="tab"]')
    # ensure 2 populations exists
    expect(populationNavs.length).toBe(3)
    active = @measureView.$('.nav.nav-tabs > li.active > a')[0]
    # ensure that the first is currently selected
    expect(active).toBe(populationNavs[0])
    expect(active.text).toBe(@measureToTest.get('displayedPopulation').get('title'))
    expect(@measureToTest.get('displayedPopulation').cid).toBe(@measureToTest.get('populations').first().cid)

    @measureView.remove()

  it "changes the displayedPopulation state when selected", ->
    @measureView = new Thorax.Views.MeasureLayout(measure: @measureToTest, patients: @measureToTest.get('patients'))
    @measureView = @measureView.showMeasure()
    @measureView.appendTo 'body'
    # simulate click on the measure view to select different population
    @measureView.$('[data-toggle="tab"]').last().click()

    populationNavs = @measureView.$('[data-toggle="tab"]')
    active = @measureView.$('.nav.nav-tabs > li.active > a')[0]
    # ensure that the third is currently selected
    expect(active).toBe(populationNavs[2])
    expect(active.text).toBe(@measureToTest.get('displayedPopulation').get('title'))
    expect(@measureToTest.get('displayedPopulation').cid).toBe(@measureToTest.get('populations').at(2).cid)

    @measureView.remove()

  it "carries over changes between views", ->
    @measureView = new Thorax.Views.MeasureLayout(measure: @measureToTest, patients: @measureToTest.get('patients'))
    @measureView = @measureView.showMeasure()
    @measureView.appendTo 'body'
    # simulate click on the measure view to select different population
    @measureView.$('[data-toggle="tab"]').last().click()
    @measureView.remove()

    # Switch to patient builder view after removing the other view
    @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient, measure: @measureToTest)
    @patientBuilder.render()
    @patientBuilder.appendTo 'body'

    populationNavs = @patientBuilder.$('[data-toggle="tab"]')
    active = @patientBuilder.$('.nav.nav-tabs > li.active > a')[0]
    # ensure that the third is currently selected
    expect(active).toBe(populationNavs[2])
    expect(active.text.trim()).toBe(@measureToTest.get('displayedPopulation').get('title'))
    expect(@measureToTest.get('displayedPopulation').cid).toBe(@measureToTest.get('populations').at(2).cid)

    @patientBuilder.remove()

  # temporarily disabled until we figure how to reset the URL
  # see https://jira.mitre.org/browse/BONNIE-318
  xit "resets when user goes to measures route", ->
    @measureView = new Thorax.Views.MeasureLayout(measure: @measureToTest, patients: @measureToTest.get('patients'))
    @measureView = @measureView.showMeasure()
    @measureView.appendTo 'body'
    # simulate click on the measure view to select different population
    @measureView.$('[data-toggle="tab"]').last().click()
    @measureView.remove()

    # ensure the test starts with the second population
    expect(@measureToTest.get('displayedPopulation').cid).toBe(@measureToTest.get('populations').at(1).cid)
    temp = bonnie.mainView
    bonnie.mainView = {setView: (view)->{}}
    try
      Backbone.history.start
        silent:true,
        pushState:true
    catch e
      console.error(e)
    bonnie.navigate("measures", trigger: true)
    bonnie.mainView = temp
    Backbone.history.stop()
    # ensure the test starts ends with the first
    expect(@measureToTest.get('displayedPopulation').cid).toBe(@measureToTest.get('populations').first().cid)
