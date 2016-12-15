describe 'Result', ->

  beforeEach ->
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    @measure = bonnie.measures.get('40280381-3D61-56A7-013E-5D1EF9B76A48')
    collection = new Thorax.Collections.Patients getJSONFixture('records/base_set/patients.json'), parse: true
    @patient = collection.findWhere(first: 'GP_Peds', last: 'A')

  it 'correctly handles fixing specific occurrence results', ->
    result = this.measure.get('populations').at(0).calculate(@patient)
    waitsForAndRuns( -> result.isPopulated()
      ,
      ->
        specificsRationale = result.specificsRationale()
        expect(specificsRationale.DENEX.OccurrenceAAcutePharyngitis1_precondition_4).toEqual false
        expect(specificsRationale.DENEX.GROUP_SBS_CHILDREN_47).toEqual false
        expect(specificsRationale.NUMER.OccurrenceAAmbulatoryEdVisit3).toEqual false
        )

  it 'allows for deferring use of results until populated', ->
    result1 = new Thorax.Models.Result({}, population: @measure.get('populations').first(), patient: @patient)
    expect(result1.calculation.state()).toEqual 'pending'
    result1.set(rationale: 'RATIONALE')
    expect(result1.calculation.state()).toEqual 'resolved'
    result2 = new Thorax.Models.Result({ rationale: 'RATIONALE' }, population: @measure.get('populations').first(), patient: @patient)
    expect(result2.calculation.state()).toEqual 'resolved'
