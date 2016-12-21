describe 'MeasureDebugView', ->

  it 'renders', ->
    window.bonnieRouterCache.load('base_set')
    measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    patient = measure.get('patients').first()
    view = new Thorax.Views.MeasureDebug(model: measure)
    view.render()
    expect(view.$el).toContainText("#{measure.get('populations').first().get('title')}")
    expect(view.$el).toContainText("#{patient.get('last')}, #{patient.get('first')}")
    view.remove()
