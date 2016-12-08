describe 'ArchivedMeasure', ->

  beforeEach ->
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    # TODO: Add measure fixture that better aligns with archived_measure fixture
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    archive = new Thorax.Models.ArchivedMeasure getJSONFixture('measure_history_reupload_capture/archived_measures.json')[0]
    @measure.get('archived_measures').add archive
  
  it 'has measure archive data available', ->
    archived = @measure.get('archived_measures').models[0]
    expect(archived.get('_id')).toEqual '584089f91841113b96000868'
    expect(archived.get('created_at')).toEqual '2016-12-01T20:37:13.183Z'
    expect(archived.get('hqmf_id')).toEqual '40280381-3D27-5493-013D-4DCA4B826AE4'
    expect(archived.get('hqmf_set_id')).toEqual '42BF391F-38A3-4C0F-9ECE-DCD47E9609D9'
    expect(archived.get('id')).toEqual '584089f91841113b96000868'
    
  it 'has measure available', ->
    archived = @measure.get('archived_measures').models[0]
    archived_measure = archived.get('measure_content')
    expect(archived_measure.measure_logic).toExist()
    expect(archived_measure.value_set_oids).toExist()
    expect(archived_measure.data_criteria).toExist()
