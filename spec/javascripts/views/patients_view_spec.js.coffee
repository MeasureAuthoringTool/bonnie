describe 'PatientsView', ->

	beforeEach ->
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json')
    @patientsView = new Thorax.Views.Patients(patients: @patients)
    @patientsView.render()

  it 'renders a patient correctly', ->
    expect($('a[href="#patients/5203afe2f7305cbf316eb5b3"]')).toExist
    expect(@patientsView.$el).toHaveText /GP_Peds/
    expect(@patientsView.$el).toHaveText /A/
  
  it 'renders all patient entries correctly', ->
    innerView = @patientsView.$el
    @patients.each (patient) ->
      expect($('a[href="#patients/' + patient.id + '"]')).toExist
      expect(innerView).toHaveText new RegExp(patient.attributes.first)
      expect(innerView).toHaveText new RegExp(patient.attributes.last)