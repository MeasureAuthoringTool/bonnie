class Thorax.Views.DeleteAllPatientsDialog extends Thorax.Views.BonnieView
  template: JST['patients/delete_all_patients_dialog']

  events:
    'click button#delete_all_button': 'deleteAllPatients',
    'change input#delete_confirm': 'checkboxChange',
    'ready': 'setup'

  initialize: ->
    @patients = @model.get('patients')
    @patientIds = @patients.map (patient) -> patient.id
    @measureId = @model.get('cqmMeasure').get("hqmf_set_id")
    @measureName = @model.get('cqmMeasure').title
    @patientCount = @patientIds.length;

  context: ->
    _(super).extend
      token: $('meta[name="csrf-token"]').attr('content')

  setup: ->
    @deletePatientsDialog = @$("#delete_all_patients_dialog")
    @confirmationCheckbox = @$("#delete_confirm")
    @deleteAllButton = @$("#delete_all_button")
    @deleteAllButton.prop('disabled', true);

  display: ->
    @deletePatientsDialog.modal(
      "backdrop": "static",
      "keyboard": false,
      "show": true)

  deleteAllPatients: ->
    view = this
    $.ajax
      url: '/patients/delete_all_patients'
      type: 'POST'
      data: {
        hqmf_set_id: @measureId,
        patients: @patientIds
      }
      success: (resp) ->
        view.deletePatientsDialog.modal('hide')
        # the page should refresh
        window.location.reload()
      error: (resp) ->
        if resp?.responseJSON?.redirect
          # app level error -> refresh the page to display an error
          window.window.location.reload()
        else
          # not an app level error (network, etc)
          # display the error in place
          errorMessage = 'Errors: ' + resp.statusText
          bonnie.showError(
            title: 'Error',
            body: errorMessage)

  checkboxChange: ->
    confirmed = @confirmationCheckbox.prop('checked');
    if (confirmed)
      @deleteAllButton.prop('disabled', false);
    else
      @deleteAllButton.prop('disabled', true);
