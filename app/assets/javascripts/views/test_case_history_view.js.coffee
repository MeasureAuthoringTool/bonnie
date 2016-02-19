class Thorax.Views.TestCaseHistoryView extends Thorax.Views.BonnieView
  template: JST['test_case_history']

  initialize: ->
    patientData = undefined
    measureData = undefined
    $.when($.get('/measures/history?id='+@model.attributes['hqmf_set_id'], (data) ->
      measureData = data
      # console.log 'RETRIEVED MEASURE DATA - ' + JSON.stringify(measureData)
      return
    ), $.get('/patients/history?id='+@model.attributes['hqmf_set_id'], (data) ->
      patientData = data
      # console.log 'RETRIEVED TEMP DATA - ' + JSON.stringify(patientData)
      return
    )).then ->
      patientHistory patientData, measureData
      return

  prettyDate = (UnixDate) ->
    d = new Date(UnixDate)
    d.getMonth() + 1 + '/' + d.getDate() + '/' + d.getFullYear()

  patientHistory = (patientData, measureData) ->
    # Get all the unique patient and measure dates to use for the ordinal xScale
    patientDates = []
    $.each patientData, (index, value) ->
      $.each value.times, (index, value) ->
        patientDates.push value.updateTime
        return
      return
    measureDates = []
    $.each measureData, (index, value) ->
      measureDates.push value.updateTime
      return
    uniqueDates = jQuery.unique(patientDates.concat(measureDates)).sort()
    # Set up the height, width, margins, and ordinal x axis scale
    bubbleRadius = 12
    bubbleMargin = 15
    gutter = 40
    # For the measure update label at the bottom of the timeline
    width = uniqueDates.length * 50
    # 50px per event
    height = patientData.length * (bubbleRadius + bubbleMargin) * 2
    margin = 
      top: 10
      right: 30
      bottom: 10
      left: 30
    x = d3.scale.ordinal().domain(uniqueDates).rangePoints([
      0
      width
    ])
    # Set up the Tooltip for each bubble
    tip = d3.tip().attr('class', 'd3-tip').offset([
      -10
      0
    ]).html((d) ->
      if d.changed
        '<span>' + d.changed + '</span>'
      else
        'Patient Created'
    )
    # Draw the chart
    chart = d3.select('#patientHistory').append('svg').attr('width', width + margin.left + margin.right).attr('height', height + gutter)
    # Call the tooltip library
    chart.call tip
    # Draw the measure update lines
    chart.selectAll('line').data(measureData).enter().append('line').attr('x1', (d) ->
      x(d.updateTime) + margin.left
    ).attr('y1', 0).attr('x2', (d) ->
      x(d.updateTime) + margin.left
    ).attr('y2', height).attr('stroke-width', 6).attr('stroke', 'gray').attr 'stroke-dasharray', '2,1'
    # Draw the measure update labels
    chart.selectAll('text').data(measureData).enter().append('text').attr('x', (d) ->
      x(d.updateTime) + margin.left
    ).attr('y', height + 11).attr('text-anchor', 'middle').attr('fill', 'blue').text('MEASURE').attr('class', 'measureUpdateLabel').on('click', (d) ->
      alert 'Set up diff between ' + d.oldVersion + ' and ' + d.newVersion
      return
    ).append('svg:tspan').attr('x', (d) ->
      x(d.updateTime) + margin.left
    ).attr('dy', 13).text('UPDATED').append('svg:tspan').attr('x', (d) ->
      x(d.updateTime) + margin.left
    ).attr('dy', 13).text (d) ->
      prettyDate d.updateTime
    # Draw the patient update bubbles
    patientData.forEach (datum, index) ->
      data = datum.times
      minTime = 999999999999999
      maxTime = 0
      $.each data, (index, value) ->
        if value.updateTime < minTime
          minTime = value.updateTime
        if value.updateTime > maxTime
          maxTime = value.updateTime
        return
      # Background for each patient
      chart.append('line').attr('x1', x(minTime) + margin.left).attr('y1', (index + 1) * (bubbleRadius + bubbleMargin) * 2 - (bubbleRadius * 2 + bubbleMargin) + bubbleRadius).attr('x2', x(maxTime) + margin.left).attr('y2', (index + 1) * (bubbleRadius + bubbleMargin) * 2 - (bubbleRadius * 2 + bubbleMargin) + bubbleRadius).attr('stroke-width', 2).attr 'stroke', 'gray'
      # Patient labels              
      chart.append('text').attr('x', x(minTime)).attr('y', (index + 1) * (bubbleRadius + bubbleMargin) * 2 - (bubbleRadius * 2 + bubbleMargin) - (bubbleMargin / 4)).text(datum.label).attr 'class', 'timeline-label'
      # Create a group for the bubble and icon
      bubbles = chart.append('g').selectAll('circle').data(data).enter().append('g')
      # Add all the relevant actions to the group
      bubbles.attr('class', 'patientUpdateIndicator').on('mouseover', tip.show).on('mouseout', tip.hide).on('click', (d, i) ->
        alert 'Redirect to the version of ' + datum.label + ' updated on ' + new Date(d.updateTime)
        return
      ).attr 'id', (d, i) ->
        if d.id then d.id else 'timelineItem_' + index + '_' + i
      # Add a backing to the bubbles so none of the background shows through   
      bubbles.append('circle').attr('cx', (d) ->
        x(d.updateTime) + margin.left
      ).attr('cy', (index + 1) * (bubbleRadius + bubbleMargin) * 2 - (bubbleRadius + bubbleMargin)).attr('r', bubbleRadius).style('fill', 'white').style('stroke', 'white').style 'stroke-width', 2
      # Add icons to the bubbles
      bubbles.append('text').attr('x', (d) ->
        x(d.updateTime) + margin.left
      ).attr('y', (index + 1) * (bubbleRadius + bubbleMargin) * 2 - (bubbleRadius + bubbleMargin)).text((d) ->
        if d.result == 'pass'
          "\uf00c"
        else
          "\uf00d"
      ).style('fill', (d) ->
        if d.result == 'pass'
          '#004119'
        else
          '#730800'
      ).style('font-family', 'FontAwesome').attr('text-anchor', 'middle').attr('dominant-baseline', 'central').attr 'font-size', bubbleRadius * 1.5 + 'px'
      # Add the bubbles in the correct place with fill and stroke    
      bubbles.append('circle').attr('cx', (d) ->
        x(d.updateTime) + margin.left
      ).attr('cy', (index + 1) * (bubbleRadius + bubbleMargin) * 2 - (bubbleRadius + bubbleMargin)).attr('r', bubbleRadius).style('fill', (d) ->
        if d.result == 'pass'
          '#20744c'
        else
          '#a63b12'
      ).style('fill-opacity', 0.5).style('stroke', (d) ->
        if d.result == 'pass'
          '#004119'
        else
          '#730800'
      ).style 'stroke-width', 2
      return
    return
