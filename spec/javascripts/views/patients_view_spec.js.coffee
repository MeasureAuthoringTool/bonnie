describe 'PatientsView', ->

	beforeEach ->
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json')
    @patientsView = new Thorax.Views.Patients(patients: @patients)
    @patientsView.render()

  it 'renders a patient correctly', ->
    expect(@patientsView.$el).toHaveText /5203afe2f7305cbf316eb5b3/
    expect($('a[href="#patients/5203afe2f7305cbf316eb5b3"]')).toExist
    expect(@patientsView.$el).toHaveText /GP_Peds/
    expect(@patientsView.$el).toHaveText /A/
    expect(@patientsView.$el).toHaveText /F/
    # expect(@patientsView.$el).toHaveText new RegExp('#patients/5203afe2f7305cbf316eb5b3')
  
  it 'renders all patient entries correctly', ->
    innerView = @patientsView.$el
    @patients.every (patient) ->
      expect(innerView).toHaveText new RegExp(patient.id)
      expect($('a[href="#patients/' + patient.id + '"]')).toExist
      expect(innerView).toHaveText new RegExp(patient.attributes.first)
      expect(innerView).toHaveText new RegExp(patient.attributes.last)
      expect(innerView).toHaveText new RegExp(patient.attributes.gender)