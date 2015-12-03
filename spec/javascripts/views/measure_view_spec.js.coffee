describe 'MeasureView', ->

  beforeEach ->
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[0], parse: true
    @measure.get('patients').add @patient
    @measureView = new Thorax.Views.Measure(model: @measure, patients: @measure.get('patients'))
    @measureView.render()
    @measureView.appendTo 'body'

  afterEach ->
    @measureView.remove()

  it 'renders measure details', ->
    expect(@measureView.$el).toContainText @measure.get('title')
    expect(@measureView.$el).toContainText @measure.get('cms_id')
    expect(@measureView.$el).toContainText @measure.get('description')

  it 'renders measure populations', ->
    expect(@measureView.$('[data-toggle="tab"]')).toExist()
    expect(@measureView.$('.rationale-target')).toBeVisible()
    expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')
    @measureView.$('[data-toggle="collapse"]').not('.value_sets').click()
    expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).toHaveClass('collapsed')
    @measureView.$('[data-toggle="tab"]').not('.value_sets').last().click()
    expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')

    # TODO: LDY 12/03/15: where is the appropriate location (if any) for these tests?
    #expect(@measureView.$('[data-toggle="collapse"].value_sets')).toHaveClass('collapsed')
    #@measureView.$('[data-toggle="collapse"].value_sets').click()
    #expect(@measureView.$('[data-toggle="collapse"].value_sets')).not.toHaveClass('collapsed')

  it 'renders patient results', ->
    expect(@measureView.$('.patient')).toExist()
    expect(@measureView.$('.toggle-result')).not.toBeVisible()
    expect(@measureView.$('.btn-show-coverage')).not.toBeVisible()
    @measureView.$('[data-call-method="expandResult"]').click()
    expect(@measureView.$('.toggle-result')).toBeVisible()
    expect(@measureView.$('.btn-show-coverage')).toBeVisible()
