describe 'PatientView', ->

	beforeEach ->
    @patients = Fixtures.Patients
    @patients.every (patient) ->
      unless patient.has('id')
        patient.set('id', patient.attributes._id)

  it 'renders each patient\'s data correctly', ->
    @patients.every (patient) ->
      patientView = new Thorax.Views.Patient(measures: Fixtures.Measures, model: patient)
      patientView.render()
      expect(patientView.$el).toHaveText new RegExp(patient.id)
      expect(patientView.$el).toHaveText new RegExp(patient.attributes.first)
      expect(patientView.$el).toHaveText new RegExp(patient.attributes.last)
      expect(patientView.$el).toHaveText new RegExp(patient.attributes.gender)
      expect(patientView.$el).toHaveText new RegExp(patient.birthDate)
      # $('a[href="#patients/' + id + '"]')
      expect($('a[href="#patients/' + patient.id + '"]')).toExist