class Thorax.Views.DeleteAllPatientsDialog extends Thorax.Views.BonnieView
  template: JST['patients/delete_all_patients_dialog']

  events:
    'click button#delete_all_button': 'delete_all_patients',
    'change input#delete_confirm': 'checkboxChange',
    'ready': 'setup'

  initialize: ->
    @patientCount = @patientIds.length;

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

  delete_all_patients: ->
    view = this
    patientIdString = JSON.stringify(@patientIds);
    $.ajax
      url: '/patients/delete_all_patients'
      type: 'POST'
      data: {
        measure_id: @measureId,
        'patients[]': patientIdString
      }
      success: (response) ->
        view.deletePatientsDialog.modal('hide')
        bonnie.showMsg(
          title: 'Success',
          body: "#{patientCount} patients have been successfully deleted. Refresh page to see results"
        )

      error: (response) ->
        error_message = 'Errors: ' + response.statusText

        bonnie.showError(
          title: 'Error',
          body: error_message)

  checkboxChange: ->
    confirmed = @confirmationCheckbox.prop('checked');
    if (confirmed)
      @deleteAllButton.prop('disabled', false);
    else
      @deleteAllButton.prop('disabled', true);
