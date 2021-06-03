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
    expect(counts).toEqual ['Measures (3)', 'Patients (12)', 'Edit']

  it "opens up the edit grouppopup", ->
    data = [
      {id: 0,  first_name: 'A', last_name: 'B', email: 'a.b@ab.com'},
      {id: 1,  first_name: 'C', last_name: 'D', email: 'a.b@cd.com'},
    ]
    spyOn($, "ajax").and.callFake (e) ->
      e.success(data);
    groupView = new Thorax.Views.GroupView(
      model: new Thorax.Model(_id: 0, name: 'CMS', measure_count: 2, patient_count: 5)
    )
    groupView.edit()
    expect($.ajax).toHaveBeenCalled()
    expect(groupView.model.get('users').length).toEqual(2)
