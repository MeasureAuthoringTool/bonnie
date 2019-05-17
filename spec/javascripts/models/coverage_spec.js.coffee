describe 'Coverage', ->

  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    bonnie.measures = new Thorax.Collections.Measures()
    @valueSetsPath = 'cqm_measure_data/special_measures/CMS890/value_sets.json'
    @cqlPatients = new Thorax.Collections.Patients getJSONFixture('cqm_patients/special_measures/CMS890/patients.json'), parse: true
    @components = getJSONFixture('cqm_measure_data/special_measures/CMS890/components.json')

  xit 'calculates coverage correctly for composite measures', ->
    measure = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS890/CMS890v0.json', @valueSetsPath
    measure.set('patients',@cqlPatients)
    bonnie.measures.add measure

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 72

  xit 'calculates coverage correctly for a component measure', ->
    measure = new Thorax.Models.Measure @components[0], parse: true
    measure.set('cqmValueSets', getJSONFixture(@valueSetsPath))
    measure.set('patients', @cqlPatients)
    bonnie.measures.add measure

    expect(measure.get('populations').at(0).coverage().get('coverage')).toEqual 22

