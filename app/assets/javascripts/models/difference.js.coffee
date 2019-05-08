class Thorax.Models.Difference extends Thorax.Model
  initialize: (attrs, options) ->
    @result = options.result
    @expected = options.expected
    @listenTo @result, 'change', @update
    @listenTo @result, 'destroy', @destroy
    @listenTo @expected, 'change', @update
    @update()
  update: ->
    return unless @result.isPopulated()
    match = @expected.isMatch(@result)
    status = switch match
               when true then 'pass'
               when false then 'fail'
               else 'pending'
    # if no expectations are set, use null status instead of failing or passing.
    if _.every(@expected.attributes, (value, key) -> return !value?) then status = null
    @set done: match?, match: match, status: status, comparisons: @expected.comparison(@result)

  toJSON: ->
    _(super).extend({medicalRecordNumber: @result.patient.get('medical_record_number')} if @result.isPopulated())

class Thorax.Collections.Differences extends Thorax.Collection
  model: Thorax.Models.Difference
  initialize: ->
    @summary = new Thorax.Model
    @on 'change add reset destroy remove', @updateSummary, this
  updateSummary: ->
    complete = @select (d) -> d.has('match')
    successful = @select (d) -> d.get('match')
    done = complete.length == @length
    percent = if complete.length > 0 then Math.round((successful.length / complete.length) * 100) else 0
    status = if @isEmpty()
               'new'
             else if successful.length == @length
               'pass'
             else
               'fail'
    # For 508 compliance, each percentage label/input pair has to have a unique ID
    percentage_id = 'percentage-' + Thorax.Models.SourceDataCriteria.generateCriteriaId()

    @summary.set total: @length, matching: successful.length, percentage_id: percentage_id, percent: percent, done: done, status: status
    @trigger 'complete' if done
  toJSON: ->
    {differences: super, summary: @summary.toJSON()}
