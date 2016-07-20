class Thorax.Views.MeasureHistoryView extends Thorax.Views.BonnieView
  template: JST['measure_history']

  initialize: ->
    @patientData = undefined
    @measureData = undefined
    @measureDiffView = new Thorax.Views.MeasureHistoryDiffView(model: @model)
    @measureTimelineView = new Thorax.Views.MeasureHistoryTimelineView(model: @model, upload_summaries: @upload_summaries, patients: @patients)
    
  switchPopulation: (e) ->
    population = $(e.target).model()
    console.log(population)
    population.measure().set('displayedPopulation', population)
    @trigger 'population:update', population
    @measureDiffView.updatePopulation(population)
    @measureTimelineView.updatePopulation(population)
    
  
  populationContext: (population) ->
    _(population.toJSON()).extend
      isActive:  population is population.measure().get('displayedPopulation')
      populationTitle: population.get('title') || population.get('sub_id')

  prettyDate: (UnixDate) =>
    d = new Date(UnixDate)
    d.getMonth() + 1 + '/' + d.getDate() + '/' + d.getFullYear()

  prettyDateTime: (UnixDate) =>
    d = new Date(UnixDate)
    d.getMonth() + 1 + '/' + d.getDate() + '/' + d.getFullYear() + ' ' + d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds()

  patientHistory: (patientData, measureData, population) ->
    console.log '-------------------------------'
    console.log patientData
    console.log measureData
    console.log population
    console.log '-------------------------------'

    @$('#patientHistory').empty();
    # Get all the unique patient and measure dates to use for the ordinal xScale
    patientDates = []
    $.each patientData, (index, value) =>
      $.each value.times, (index, value) =>
        patientDates.push value.updateTime
        return
      return
    measureDates = []
    $.each measureData, (index, value) =>
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
      "<span>" + d.changed.replace(/\n/g,'<br/>') + "</span>"
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
    ).attr('y', height + 11).attr('text-anchor', 'middle').attr('fill', (d) ->
      return if d.oldVersion then 'blue' else 'black'
    ).text('MEASURE').attr('class', (d) ->
      return if d.oldVersion then 'measureUpdateLabel' else 'measureCreatedLabel'
    ).on('click', (d) =>
      #alert 'Set up diff between ' + d.oldVersion + ' and ' + d.newVersion
      @measureDiffView.loadDiff d.oldVersion, d.newVersion
      return
    ).append('svg:tspan').attr('x', (d) ->
      x(d.updateTime) + margin.left
    ).attr('dy', 13).text((d) -> 
      return if d.oldVersion then "UPDATED" else "CREATED"
    ).append('svg:tspan').attr('x', (d) ->
      x(d.updateTime) + margin.left
    ).attr('dy', 13).text (d) =>
      @prettyDate d.updateTime
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
    # Set up the 508-compliant version of the timeline table
    header = '<thead><tr><th>Patient</th>'
    body = '<tbody>'
    footer = '<tfoot><tr><th>Measure Updates</th>'
    # Print out the header with all the dates involved in patient/measure history
    $.each uniqueDates, (index, value) =>
      header += '<th>' + (@prettyDateTime value) + '</th>'
      return
    # For each patinet, if an event occurred, populate the table cell
    # TODO: link to the specific version of the patient after the change was made
    $.each patientData, (index, patient) =>
      rowData = '<th>' + patient['label'] + '</th>'
      i = 0
      $.each uniqueDates, (index, dateValue) =>
        rowData += '<td>'
        $.each patient['times'], (index, patientTime) =>
          if dateValue == patientTime['updateTime']
            if patientTime['changed']
              rowData += '<strong>Updates:</strong> ' + patientTime['changed']
            else
              rowData += 'Patient Created'
            rowData += '<br><strong>Result:</strong> ' + patientTime['result']
          return
        i++
        return
      body += '<tr>' + rowData
      return
    # For each measure update, add a row with diff links
    $.each uniqueDates, (index, dateValue) =>
      footer += '<td>'
      i = 0
      $.each measureData, (index, updateDate) =>
        if dateValue == updateDate['updateTime']
          footer += '<a href="/measures/historic_diff?new_id=' + updateDate['newVersion'] + '&old_id=' + updateDate['oldVersion'] + '">Show updates to this measure made on '+(@prettyDateTime updateDate['updateTime'])+'</a>'
        i++
        return
      return
    $('#508timeline').html '<table class="sr-only">' + header + body + footer + '</table>'
    return
