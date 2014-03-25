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
    expect(@measureView.$('.measure-listing').text()).not.toContainText @measure.get('cms_id')
    @measureView.$('.measure-listing').click()
    expect(@measureView.$('.measure-listing.active').size() == 0).toBe true
    @measureView.$('.select-patient').click()
    @measureView.$('.measure-listing:first').click()
    expect(@measureView.$('.measure-listing.active').size() == 0).toBe false
    @measureView.remove()
