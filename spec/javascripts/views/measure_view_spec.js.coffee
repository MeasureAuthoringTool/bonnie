describe 'MeasureView', ->

  beforeEach ->
    @measure = bonnie.measures.first()
    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[0], parse: true
    @measure.get('patients').add @patient
    @measureView = new Thorax.Views.Measure(model: @measure, patients: @measure.get('patients'))
    @measureView.render()

  it 'renders correctly', ->
    expect(@measureView.$el).toContainText @measure.get('description')

  it 'sets up patient tranfers correctly', ->
    @measureView.appendTo 'body'
    @measureView.$('.toggle-measure-listing').click()
    expect(@measureView.$('.measure-listing')).not.toContainText @measure.get('cms_id')
    @measureView.$('.measure-listing').click()
    expect(@measureView.$('.measure-listing.active').length).toEqual 0
    expect(@measureView.$(".btn-clone-#{bonnie.measures.last().get('hqmf_set_id')}")).toBeHidden()
    @measureView.$('.select-patient').click()
    @measureView.$('.measure-listing:first').click()
    expect(@measureView.$('.measure-listing.active').length).not.toEqual 0
    expect(@measureView.$(".btn-clone-#{bonnie.measures.last().get('hqmf_set_id')}")).toBeVisible()
    @measureView.remove()
