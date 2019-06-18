describe 'MeasurementPeriodView', ->

  beforeAll ->
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/CMS160v6/CMS160v6.json', 'cqm_measure_data/CMS160v6/value_sets.json'
    @patients = new Thorax.Collections.Patients [getJSONFixture('patients/CMS160v6/Expired_DENEX.json')], parse: true
    @measure.set('patients', @patients)
    @measurementPeriodView = new Thorax.Views.MeasurementPeriod(model: @measure)
    @measurementPeriodView.render()
    @measurementPeriodView.appendTo('body')
    @checkInvalidYear = (view, year) ->
      view.$('input[name="year"]').val(year).keyup()
      view.validate(new Event('keyup'))
      expect(view.$('#changePeriod')).toBeDisabled()

  afterAll ->
    @measurementPeriodView.remove()

  it 'renders correctly', ->
    expect(@measurementPeriodView.render()).toContain '2012'

  it 'validates correct date', ->
    @measurementPeriodView.$('input[name="year"]').val('1984').keyup()
    expect(@measurementPeriodView.$('#changePeriod')).not.toBeDisabled()

  it 'invalidates non number', ->
    @checkInvalidYear(@measurementPeriodView, 'abcd')

  it 'invalidates decimal', ->
    @checkInvalidYear(@measurementPeriodView, '19.1')

  it 'invalidates year not 4 digits', ->
    @checkInvalidYear(@measurementPeriodView, '999')

  it 'invalidates year less than 1', ->
    @checkInvalidYear(@measurementPeriodView, '0000')

  it 'invalidates year greater than 9999', ->
    @checkInvalidYear(@measurementPeriodView, '10000')
