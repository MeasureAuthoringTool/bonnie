describe 'MeasureCalculationView', ->

  beforeEach ->
    @measure = bonnie.measures.first()
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json'), parse: true
    @measure.set('patients', @patients)
    @measureCalculationView = new Thorax.Views.MeasureCalculation(model: @measure, populationIndex: 0)
    @measureCalculationView.render()

  it 'renders correctly', ->
    expect(@measureCalculationView.$el).toContainText @patients.first().get('last')

  # deprecated
  # it 'correctly displays a patient when selected', ->
  #   patient = @patients.findWhere(first: 'GP_Peds', last: 'C')
  #   expect(@measureCalculationView.$('td')).not.toContainText("#{patient.get('last')}, #{patient.get('first')}")
  #   @measureCalculationView.$("button[data-model-cid='#{patient.cid}']").click()
  #   expect(@measureCalculationView.$('td')).toContainText("#{patient.get('last')}, #{patient.get('first')}")

  # deprecated
  # it 'correctly displays totals when patients are selected', ->
  #   patient1 = @patients.findWhere(first: 'GP_Peds', last: 'B')
  #   patient2 = @patients.findWhere(first: 'GP_Peds', last: 'C')
  #   expect(@measureCalculationView.$('td')).not.toContainText("2")
  #   @measureCalculationView.$("button[data-model-cid='#{patient1.cid}']").click()
  #   @measureCalculationView.$("button[data-model-cid='#{patient2.cid}']").click()
  #   expect(@measureCalculationView.$('td')).toContainText("2")

  # FIXME: Uncomment this test after patiests.json has been updated
  # it 'correctly displays results when patients are selected', ->
  #   patient = @patients.findWhere(first: 'GP_Peds', last: 'C')
  #   expect(@measureCalculationView.$('th')).not.toContainText("#{patient.get('last')}, #{patient.get('first')}")
  #   @measureCalculationView.$("button[data-model-cid='#{patient.cid}']").click()
  #   expect(@measureCalculationView.$('th')).toContainText("#{patient.get('last')}, #{patient.get('first')}")    
