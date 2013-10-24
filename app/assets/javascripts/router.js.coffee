class BonnieRouter extends Backbone.Router

  initialize: ->
    @mainView = new Thorax.LayoutView(el: '#bonnie')
    # This measure collection gets populated as measures are loaded via their individual JS
    # files (see app/views/measures/show.js.erb)
    @measures = new Thorax.Collections.Measures()
    @patients = new Thorax.Collections.Patients()

  routes:
    '':                   'measures'
    'measures':           'measures'
    'measures/matrix':    'matrix'
    'measures/:id':       'measure'
    'patients':           'patients'
    'patients/:id':       'patient'
    'patients/:id/build': 'patientBuilder'
    
  measures: ->
    # FIXME: Can we cache the generation of these views?
    measuresView = new Thorax.Views.Measures(measures: @measures)
    @mainView.setView(measuresView)

  measure: (id) ->
    measure = @measures.findWhere({hqmf_id: id})
    measure = measure or= @measures.get(id) if @measures.get(id)? if @measures.get(id)?
    measureView = new Thorax.Views.Measure(model: measure, patients: @patients)
    @mainView.setView(measureView)

  patients: ->
    patientsView = new Thorax.Views.Patients(patients: @patients)
    @mainView.setView(patientsView)

  patient: (id) ->
    patientView = new Thorax.Views.Patient(measures: @measures, model: @patients.get(id), sections: @sections, idMap: @template_id_map)
    @mainView.setView(patientView)

  matrix: ->
    matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @mainView.setView(matrixView)
    matrixView.calculateAsynchronously()

  patientBuilder: (id) ->
    measure = @measures.first() # FIXME use a better method for determining measure
    patientBuilderView = new Thorax.Views.PatientBuilder(model: @patients.get(id), measure: measure)
    @mainView.setView patientBuilderView