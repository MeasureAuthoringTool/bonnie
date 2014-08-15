class Thorax.Views.Matrix extends Thorax.Views.BonnieView

  template: JST['matrix']

  initialize: ->
    @collection.comparator = (m) -> if match = m.get('cms_id').match(/CMS([0-9]+)/) then parseInt(match[1]) else 0
    @collection.sort()
    @patients.comparator = (p) -> [p.get('last'), p.get('first')]
    @patients.sort()

  context: ->
    _(super).extend measures: @collection.populations().map (p) -> name: p.displayName(), hqmf_set_id: p.measure().get('hqmf_set_id')

  patientContext: (p) ->
    _(p.toJSON()).extend results: @collection.populations().map (m) -> m.calculate(p)


class Thorax.Views.MatrixCell extends Thorax.Views.BonnieView

  tagName: 'td'

  template: -> null # Empty template, everything is in the class name

  events:
    rendered: ->
      if @model.differenceFromExpected().has('match')
        popoverContent = JST['population_calculation_results'](patient: @model.patient.toJSON(), comparisons: @model.differenceFromExpected().get('comparisons'))
        title = "#{@model.population.displayName()} - #{@model.patient.get('last')}, #{@model.patient.get('first')}"
        @$el.popover trigger: 'hover', placement: 'bottom', container: 'body', title: title, html: true, content: popoverContent
    mouseover: ->
      @$el.addClass('highlight-box')
      @$el.parent().find('td.patient-name').addClass('highlight-font')
      @$el.closest('table').find("th.measure-#{@model.population.displayName()}").addClass('highlight-font')
    mouseout: ->
      @$el.removeClass('highlight-box')
      @$el.parent().find('td.patient-name').removeClass('highlight-font')
      @$el.closest('table').find("th.measure-#{@model.population.displayName()}").removeClass('highlight-font')
    model:
      change: -> @$el.addClass(@className())

  className: ->
    difference = @model.differenceFromExpected()
    return 'blank' if !difference.has('match') # Not yet calculated
    return 'blank' if difference.get('match') && @model.get('IPP') == 0 # Matches expectations, but not in IPP, so not noteworthy
    return 'match' if difference.get('match') # Matches expectations
    return 'problem' # Doesn't match
