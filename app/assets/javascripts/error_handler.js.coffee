# Initialize Costanza front-end error handling/tracking
Costanza.init (info, rawError) ->
  $.ajax
    url: 'application/client_error'
    method: 'GET'
    dataType: 'json'
    data: info
    success: (message) ->
      bonnie.showError(message) if message
    error: () ->
      console.error(info) if info
