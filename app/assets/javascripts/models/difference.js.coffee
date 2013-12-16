class Thorax.Models.Difference extends Thorax.Model
  initialize: (attrs, options) ->
    @result = options.result
    @expected = options.expected
    # FIXME: bind to expected too after merge
    @listenTo @result, 'change', @update
    @update()
  update: ->
    return unless @result.isPopulated()
    for popCrit, exp of @expected
      if @result.get(popCrit) != exp
        @set(match: false)
        return
    @set(match: true)
