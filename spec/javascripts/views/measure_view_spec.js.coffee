describe 'MeasureView', ->

  beforeEach ->
    @measure = bonnie.measures.first()
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
    expect(@measureView.$('[data-call-method="measureSettings"]')).toExist()
    expect(@measureView.$('[data-call-method="patientsSettings"]')).toExist()

  it 'renders measure populations', ->
    expect(@measureView.$('[data-toggle="tab"]')).toExist()
    expect(@measureView.$('.rationale-target')).toBeVisible()
    expect(@measureView.$('[data-toggle="collapse"]')).not.toHaveClass('collapsed')
    @measureView.$('[data-toggle="collapse"]').click()
    expect(@measureView.$('[data-toggle="collapse"]')).toHaveClass('collapsed')
    @measureView.$('[data-toggle="tab"]').last().click()
    expect(@measureView.$('[data-toggle="collapse"]')).not.toHaveClass('collapsed')

  it 'renders patient results', ->
    expect(@measureView.$('.patient.row')).toExist()
    expect(@measureView.$('[data-call-method="expandResult"]')).toExist()
    expect(@measureView.$('.toggle-result')).not.toBeVisible()
    expect(@measureView.$('.btn-show-coverage')).not.toBeVisible()
    @measureView.$('[data-call-method="expandResult"]').click()
    expect(@measureView.$('.toggle-result')).toBeVisible()
    expect(@measureView.$('.btn-show-coverage')).toBeVisible()

  it 'sets up patient transfers', ->
    @measureView.$('.toggle-measure-listing').click()
    expect(@measureView.$('.measure-listing')).not.toContainText @measure.get('cms_id')
    @measureView.$('.measure-listing').click()
    expect(@measureView.$('.measure-listing.active')).not.toExist()
    expect(@measureView.$(".btn-clone-#{bonnie.measures.last().get('hqmf_set_id')}")).toBeHidden()
    @measureView.$('.select-patient').click()
    @measureView.$('.measure-listing:first').click()
    expect(@measureView.$('.measure-listing.active')).toExist()
    expect(@measureView.$(".btn-clone-#{bonnie.measures.last().get('hqmf_set_id')}")).toBeVisible()
