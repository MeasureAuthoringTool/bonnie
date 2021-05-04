describe 'GroupsView', ->
  beforeEach ->
    jasmine.getJSONFixtures().clearCache()
    group_index = getJSONFixture("ajax/groups.json")
    groups = new Thorax.Collections.Groups(group_index)
    groups.trigger('reset', groups, {});
    @view = new Thorax.Views.GroupsView(collection: groups)
    @view.render()

  it 'initializes GroupsView', ->
    # group name column
    groups = @view.$('td.group-name').toArray().map (e) ->
      e.innerText
    expect(groups).toEqual ['CMS', 'SemanticBits', 'Telligen']
    # measure count column
    measureCounts = @view.$('td.measure-count').toArray().map (e) ->
      e.innerText
    expect(measureCounts).toEqual ['2', '1', '0']
    # patient count column
    patientCounts = @view.$('td.patient-count').toArray().map (e) ->
      e.innerText
    expect(patientCounts).toEqual ['10', '2', '0']
    # overall patient & measure counts
    counts = @view.$('th.centered').toArray().map (e) ->
      e.innerText
    expect(counts).toEqual ['Measures (3)', 'Patients (12)']
