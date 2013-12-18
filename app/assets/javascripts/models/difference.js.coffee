class Thorax.Models.Difference extends Thorax.Model
  initialize: (attrs, options) ->
    @result = options.result
    @expected = options.expected
    @listenTo @result, 'change', @update
    @listenTo @expected, 'change', @update
    @update()
  update: ->
    return unless @result.isPopulated()
    @set match: @expected.isMatch(@result)

class Thorax.Collections.Differences extends Thorax.Collection
  model: Thorax.Models.Difference
  initialize: ->
    @summary = new Thorax.Model
    @on 'change add reset', @updateSummary, this
  updateSummary: ->
    complete = @select (d) -> d.has('match')
    successful = @select (d) -> d.get('match')
    percent = Math.round((successful.length / complete.length) * 100)
    done = complete.length == @length
    status = if successful.length == @length then 'pass' else 'fail'
    @summary.set total: @length, matching: successful.length, percent: percent, done: done, status: status
