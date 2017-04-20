# Initialize Costanza front-end error handling/tracking
Costanza.init (info, rawError) ->
  # Still print out the raw error for developers.
  console.error rawError
  
  # First check:
  # Ignore mirrored Costanza error messages (we have already handled these).
  # This check stops doubled error message popups from appearing.
  #
  # Second check:
  # Ignore logic highlighting errors. TODO: The highlighting bug should be
  # fixed, and when that happens, the second check should be removed.
  unless /Costanza/i.test(rawError.toString()) || /highlight-target/i.test(info.section)
    info.url = window.location.href
    $.ajax
      url: 'application/client_error'
      method: 'POST'
      dataType: 'json'
      data: info
      success: (message) ->
        bonnie.showError(message) if message
      error: (jqXHR, textStatus, errorThrown) ->
        connectionError =
          title: 'Connection Issues'
          body: 'An error occurred in Bonnie. You may be experiencing network connectivity issues. Please check your network connection and try reloading Bonnie.'
        bonnie.showError(connectionError)
