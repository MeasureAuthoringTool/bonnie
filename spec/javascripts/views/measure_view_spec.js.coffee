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

  it 'renders measure details correctly', ->
    expect(@measureView.$('.measure-title')).toContainText @measure.get('title')
    expect(@measureView.$('.measure-title')).toContainText @measure.get('cms_id')
    expect(@measureView.$('.measure-dsp')).toContainText @measure.get('description')
    expect(@measureView.$('[data-toggle="tab"]')).toExist()

  it 'renders measure populations correctly', ->
    expect(@measureView.$('.rationale-target')).toBeVisible()
    expect(@measureView.$('[data-toggle="collapse"]')).not.toHaveClass('collapsed')
    @measureView.$('[data-toggle="collapse"]').click()
    expect(@measureView.$('[data-toggle="collapse"]')).toHaveClass('collapsed')
    @measureView.$('[data-toggle="tab"]').last().click()
    expect(@measureView.$('[data-toggle="collapse"]')).not.toHaveClass('collapsed')

  it 'sets up patient transfers correctly', ->
    @measureView.appendTo 'body'
    @measureView.$('.toggle-measure-listing').click()
    expect(@measureView.$('.measure-listing')).not.toContainText @measure.get('cms_id')
    @measureView.$('.measure-listing').click()
    expect(@measureView.$('.measure-listing.active')).not.toExist()
    expect(@measureView.$(".btn-clone-#{bonnie.measures.last().get('hqmf_set_id')}")).toBeHidden()
    @measureView.$('.select-patient').click()
    @measureView.$('.measure-listing:first').click()
    expect(@measureView.$('.measure-listing.active')).toExist()
    expect(@measureView.$(".btn-clone-#{bonnie.measures.last().get('hqmf_set_id')}")).toBeVisible()
