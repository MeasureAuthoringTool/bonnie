class Thorax.Views.InactiveWarningDialog extends Thorax.Views.BonnieView
  template: JST['inactive_warning_dialog']

  display: ->
    @$('#inactiveWarningDialog').modal(
      "keyboard" : true,
      "show" : true)
    MS_IN_SEC = 1000
    # inverval of 1 sec
    timerInterval = rxjs.interval(MS_IN_SEC)
    # number of intervals
    times = @countdownMs / MS_IN_SEC
    @updateCountDown(times)
    countDown = timerInterval.pipe(rxjs.operators.take(times))
    countDown.subscribe((val) =>
      countDownSec = times - val
      @updateCountDown(countDownSec)
    )
  events:
    rendered: -> 
      @$el.on 'hidden.bs.modal', -> @remove()
# List of events should be consistend with the events used watch for user inactivity
    'click': 'close'
    'keydown': 'close'
#    'mousemove': 'close'

  updateCountDown: (sec) ->
    @$('.inactivityCountDown').text(@formatSec(sec))

  close: ->
    @$('#inactiveWarningDialog').modal('hide')

  formatSec: (sec) ->
    @toMinutes(sec) + ':' + @toSeconds(sec)

  toMinutes: (sec) ->
    Math.floor(sec / 60).toString(10).padStart(2, '0')

  toSeconds: (sec) ->
    (sec % 60).toString(10).padStart(2, '0')