describe 'Result', ->

  beforeEach ->
    @measure = bonnie.measures.get('40280381-3D61-56A7-013E-5D1EF9B76A48')
    collection = new Thorax.Collections.Patients getJSONFixture('patients.json'), parse: true
    @patient = collection.findWhere(first: 'GP_Peds', last: 'A')

  it 'correctly handles fixing specific occurrence results', ->
  	result = this.measure.get('populations').at(0).calculate(@patient)
  	specificsRationale = result.specificsRationale()
  	expect(specificsRationale.DENEX.OccurrenceAAcutePharyngitis1_precondition_4).toEqual false
  	expect(specificsRationale.DENEX.GROUP_SBS_CHILDREN_47).toEqual false
  	expect(specificsRationale.NUMER.OccurrenceAAmbulatoryEdVisit3).toEqual false
