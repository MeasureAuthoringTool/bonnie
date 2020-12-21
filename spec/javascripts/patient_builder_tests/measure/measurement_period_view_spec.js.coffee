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

  xit 'renders correctly', ->
    expect(@measurementPeriodView.render()).toContain '2012'

  xit 'validates correct date', ->
    @measurementPeriodView.$('input[name="year"]').val('1984').keyup()
    expect(@measurementPeriodView.$('#changePeriod')).not.toBeDisabled()

  xit 'invalidates non number', ->
    @checkInvalidYear(@measurementPeriodView, 'abcd')

  xit 'invalidates decimal', ->
    @checkInvalidYear(@measurementPeriodView, '19.1')

  xit 'invalidates year not 4 digits', ->
    @checkInvalidYear(@measurementPeriodView, '999')

  xit 'invalidates year less than 1', ->
    @checkInvalidYear(@measurementPeriodView, '0000')

  xit 'invalidates year greater than 9999', ->
    @checkInvalidYear(@measurementPeriodView, '10000')
