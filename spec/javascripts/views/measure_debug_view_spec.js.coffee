describe 'MeasureDebugView', ->

  it 'renders', ->
    measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    patient = new Thorax.Models.Patient getJSONFixture('patients.json')[3], parse: true
    measure.get('patients').add patient
    view = new Thorax.Views.MeasureDebug(model: measure)
    view.render()
    expect(view.$el).toContainText("#{measure.get('populations').first().get('title')}")
    expect(view.$el).toContainText("#{patient.get('last')}, #{patient.get('first')}")
    view.remove()
    # clean up all changes to the measure, as this is in a global store (not a copy)
    measure.get('patients').reset()
