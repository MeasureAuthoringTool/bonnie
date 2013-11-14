describe 'PatientView', ->

	beforeEach ->
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json')

  it 'renders each patient\'s data correctly', ->
    @patients.each (patient) ->
      patientView = new Thorax.Views.Patient(measures: bonnie.measures, model: patient)
      patientView.render()
      expect(patientView.$el).toHaveText new RegExp(patient.id)
      expect(patientView.$el).toHaveText new RegExp(patient.attributes.first)
      expect(patientView.$el).toHaveText new RegExp(patient.attributes.last)
      expect(patientView.$el).toHaveText new RegExp(patient.attributes.gender)
      expect(patientView.$el).toHaveText new RegExp(patient.birthDate)
      # $('a[href="#patients/' + id + '"]')
      expect($('a[href="#patients/' + patient.id + '"]')).toExist

  it 'renders HTML Report for Cancer_Adult_Female B correctly', ->
    patient = @patients.findWhere(first: 'Cancer_Adult_Female', last: 'B')
    patientView = new Thorax.Views.Patient(measures: bonnie.measures, model: patient)
    patientView.render()
    
    # FIXME: This should expect diagnoses, this might be a result of missing hqmf section decoding...
    expect($('#conditions')).toExist
    expect(patientView.$('#conditions')).toHaveText new RegExp('SNOMED-CT: 416053008')
    expect(patientView.$('#conditions')).toHaveText new RegExp('SNOMED-CT: 109886000')
    expect(patientView.$('#conditions')).toHaveText new RegExp('ICD-9-CM: 174.0')
    expect(patientView.$('#conditions')).toHaveText new RegExp('ICD-10-CM: C50.011')
    expect($('#encounters')).toExist
    expect(patientView.$('#encounters')).toHaveText new RegExp('CPT: 99201')
    expect(patientView.$('#encounters')).toHaveText new RegExp('CPT: 99201')
    expect($('#medications')).toExist
    expect(patientView.$('#medications')).toHaveText new RegExp('RxNorm: 1098617')
    expect($('#procedures')).toExist
    expect(patientView.$('#procedures')).toHaveText new RegExp('SNOMED-CT: 116783008')