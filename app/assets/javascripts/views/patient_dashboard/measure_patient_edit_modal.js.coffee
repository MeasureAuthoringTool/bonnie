
class Thorax.Views.MeasurePatientEditModal extends Thorax.Views.BonnieView
  template: JST['patient_dashboard/edit_modal']

  events:
    'ready': 'setup'

  setup: ->
    @editDialog = @$("#patientEditModal")

  display: (patient, rowIndex) ->
    @patient = patient
    @rowIndex = rowIndex
    @measure = @dashboard.measure
    @populationSet = @dashboard.populationSet
    @populations = @dashboard.populations
    @patients = @measure.get('patients')
    @measures = @measure.collection
    @patientBuilderView = new Thorax.Views.PatientBuilder model: patient, measure: @measure, patients: @patients, measures: @measures, inPatientDashboard: true
    @patientBuilderView.appendTo(@$('.modal-body'))
    $("#saveButton").prop('disabled', false) # Save button was being set to disabled
    @editDialog.modal(
      "backdrop" : "static",
      "keyboard" : true,
      "show" : true).find('.modal-dialog').css('width','80%')

  save: (e) ->
    # Save via patient builder, sending a callback so we can ensure we get a patient with the ID set
    @patientBuilderView.save e, success: (patient) =>
      @editDialog.modal('hide')
      @$('.modal-body').empty() # Clear out patientBuilderView
      @result = @populationSet.calculateResult patient
      @result.calculationsComplete =>
        @patientResult = @result.toJSON()[0] # Grab the first and only item from collection
        @patientData = new Thorax.Models.PatientDashboardPatient patient, @dashboard.patientDashboard, @measure, @patientResult, @populations, @populationSet
        @dashboard.updatePatientDataSources @result, @patientData
        if @rowIndex?
          $('#patientDashboardTable').DataTable().row(@rowIndex).data(@patientData).draw()
        else # New patient added, with no pre existing row index.
          node = $('#patientDashboardTable').DataTable().row.add(@patientData).draw().node()
          @rowIndex = $('#patientDashboardTable').DataTable().row(node).index()
        @dashboard.updateDisplay(@rowIndex)

  close: ->
    @$('.modal-body').empty() # Clear out patientBuilderView
