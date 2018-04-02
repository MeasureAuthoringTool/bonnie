# Helper module for handling client side errors.
module ErrorHelper
  # Handles the given error by categorizing it based on the included
  # section, as defined in the front end code. If the given error can
  # not be categorized, no error message will be shown (but an email
  # will still be sent to the development team, if on production).
  def self.describe_error(error_info, exception, request)
    # Set the error message if it was not previously set
    error_info[:msg] = 'An unspecified error has occurred.' unless error_info[:msg]

    # Do not process errors if their message includes Costanza. These are
    # errors passed up to Thorax.onException from Costanza, which we do
    # not care about (we've already handled them).
    return if error_info[:msg].include? 'Costanza'

    # If enabled, send an email to the development team containing
    # information about this error.
    ErrorHelper.send_email(error_info, exception, request) if APP_CONFIG['enable_client_error_email']

    case error_info[:section]
    # Handles errors that arise when generating the human readable logic from
    # the measure data criteria.
    when /data-criteria-logic-view-creation/
      {
        title: 'Measure Logic Error',
        summary: 'Error Building Measure Logic View',
        body: 'You have imported a measure that contains logic that cannot be rendered. This is usually caused by errors in the measure logic. Please review the measure logic for correctness, and re-upload the measure.<br>Data criteria reference that failed: <b>' + error_info[:reference] + '</b>'
      }
    # Handles errors that arise when trying to calculate a measure against
    # patients.
    when /qdm-measure-calculation/
      {
        title: 'Measure Calculation Error',
        summary: 'There was an error calculating measure ' + error_info[:cms_id] + '.',
        body: 'One of the data elements associated with the measure is causing an issue. Please review the elements associated with the measure to verify that they are all constructed properly.<br>Error message: <b>' + error_info[:msg] + '</b>'
      }
    when /cql-measure-calculation/
      {
        title: 'Measure Calculation Error',
        summary: 'There was an error calculating measure ' + error_info[:cms_id] + '.',
        body: 'One of the data elements associated with the measure is causing an issue. Please review the elements associated with the measure to verify that they are all constructed properly.<br>Error message: <b>' + error_info[:msg] + '</b>'
      }
    else
      {
        title: 'Unspecified Error',
        summary: 'An error occured.',
        body: '<br>Error message: <b>' + error_info[:msg] + '</b>'
      }
    end
  end

  # Emails an error description notification (if on production).
  def self.send_email(error_info, exception, request)
    if defined? ExceptionNotifier::Notifier
      # Create a new Ruby exception with the given error message, and deliver
      # an email to the development team containing the same error informantion.
      ExceptionNotifier.notify_exception(exception, env: request.env, data: error_info)
    end
  end
end
