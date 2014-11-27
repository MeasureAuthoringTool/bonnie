window.bonnie ||= {}
bonnie.viz ||= {}
bonnie.viz.MeasureSize = ->
  measure_title = (d) ->
    d.cms_id
  population_title = (d) ->
    d.code
  updateLines = (c) ->
    for line in ['ins','del','unchanged']
      d3.selectAll(".#{line}-line").transition()
        .attr('class', "logic-line #{line}-line#{c}")
  addedLabels = (show) ->
    c = if show then '' else ' hidden'
    d3.selectAll(".added-label").transition()
      .attr('class', "label added-label#{c}")
  deletedLabels = (show) ->
    c = if show then '' else ' hidden'
    d3.selectAll(".deleted-label").transition()
      .attr('class', "label deleted-label#{c}")

  width = 165
  height = 460
  barHeight = 3
  spacing = 5

  my = (selection) ->
    selection.each (data) ->

      color = (line) ->
        switch line
          when 'unchanged' then '#0075c4'
          when 'ins' then '#d9534f'
          when 'del' then '#e2e2e2'
          else 'brand-warning'

      for measure in data

        yOffset = 5

        svg = d3.select(this).append('svg')
          .attr('width', width)
          # .attr('height', height)
          .attr('height', measure.totals.total * barHeight + measure.totals.total * spacing + measure.populations.length * 17 + spacing * 5)
          .attr('style', 'padding: 10px 15px 0 15px;')

        svg.append('text')
          .attr('id', 'measure_title')
          .attr('class', 'label')
          .attr('x', width * .3)
          .attr('y', yOffset)
          .text(measure.cms_id)

        yOffset += 11

        svg.append('text')
          .attr('id', 'deleted_title')
          .attr('class', 'label deleted-label hidden')
          .attr('x', 0)
          .attr('y', yOffset)
          .text("del: #{measure.totals.deletions} / #{measure.totals.total}")

        svg.append('text')
          .attr('id', 'added_title')
          .attr('class', 'label added-label hidden')
          .attr('x', width * .55)
          .attr('y', yOffset)
          .text("ins: #{measure.totals.insertions} / #{measure.totals.total}")

        yOffset += 10

        for datum in measure.populations
          # Add text for the population
          svg.append('text')
            .attr('id', 'population_title')
            .attr('class', 'label')
            .attr('x', 0)
            .attr('y', yOffset += spacing)
            .text(datum.code)

          for line in datum.lines

            yOffset += spacing

            # Add a line for each line of logic
            svg.append('rect')
              .attr('x', 0)
              .attr('y', yOffset)
              .attr('width', width)
              .attr('height', barHeight)
              .attr('class', "logic-line #{line}-line")

            yOffset += barHeight

          yOffset += spacing * 2

  my.showAddedLines = ->
    updateLines(' added-darker')
    addedLabels(true)

  my.hideAddedLines = ->
    updateLines('')
    addedLabels(false)

  my.showDeletedLines = ->
    updateLines(' deleted-darker')
    deletedLabels(true)

  my.hideDeletedLines = ->
    updateLines('')
    deletedLabels(false)

  my
