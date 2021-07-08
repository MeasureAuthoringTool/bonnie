class Thorax.Views.InactiveWarningDialog extends Thorax.Views.BonnieView
  template: JST['inactive_warning_dialog']

  MS_IN_SEC = 1000

  display: ->
    @$('#inactiveWarningDialog').modal(
      "keyboard" : true,
      "show" : true)
    # inverval of 1 sec
    @timerInterval = rxjs.interval(MS_IN_SEC)
    @updateCountDown(@leftTimeToLogoutMs())
    @timerInterval.subscribe(() =>
      @updateCountDown(@leftTimeToLogoutMs())
    )
  events:
    rendered: -> 
      @$el.on 'hidden.bs.modal', -> @remove()
# List of the events should be consistent with the events used watch for user inactivity
    'click': 'close'
    'keydown': 'close'
#    'mousemove': 'close'

  leftTimeToLogoutMs: () ->
    leftTimeMs = @logoutAtMs - Date.now()
    return leftTimeMs if leftTimeMs > 0
    return 0

  updateCountDown: (ms) ->
    sec = ms / MS_IN_SEC
    @$('.inactivityCountDown').text(@formatTime(sec))

  close: ->
    @$('#inactiveWarningDialog').modal('hide')

  formatTime: (sec) ->
    @toMinutes(sec) + ':' + @toSeconds(sec)

  toMinutes: (sec) ->
    Math.trunc(Math.floor(sec / 60)).toString(10).padStart(2, '0')

  toSeconds: (sec) ->
    Math.trunc((sec % 60)).toString(10).padStart(2, '0')