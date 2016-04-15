window.bonnie ||= {}
bonnie.viz ||= {}
bonnie.viz.MeasureRibbonCell = ->
  width  = 50
  height = 50
  barHeight = height / 5
  # Display order for Continuous Variable
  cvOrder = ['OBSERV', 'MSRPOPL', 'MSRPOPLEX', 'IPP']
  # Display order for Episode of Care
  ecOrder = ['NUMER', 'DENOM', 'IPP', 'DENEXCEP', 'DENEX', 'NUMEX']
  my = (selection) ->
    selection.each (data) ->
      order = if _(data).any((d) -> d.name is 'MSRPOPL') then cvOrder else ecOrder

      for name in order
        unless _(data).any((d) -> d.name is name)
          data.push name: name, expected: 0, actual: 0, match: true

      d3.select(this).append('svg')
        .attr('viewBox', "0 0 #{width} #{height}")
        .attr('preserveAspectRatio', 'none')
        .selectAll('rect').data(data).enter().append('rect')
          .attr('width', width)
          .attr('height', barHeight)
          .attr('y', (o) -> barHeight * _(order).indexOf(o.name))
          .attr('class', (o) ->
            result = if o.expected
              if o.actual is o.expected then 'success' else 'fail'
            else
              if o.actual then 'absent' else 'none'
            "#{o.name.toLowerCase()} expectation-#{result}")

  my.width = (w) ->
    return width unless w
    width = w
    my

  my.height = (h) ->
    return height unless h
    height = h
    my

  my
