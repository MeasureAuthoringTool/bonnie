window.bonnie ||= {}
bonnie.viz ||= {}
bonnie.viz.MeasureSize = ->
  measure_title = (d) ->
    d.cms_id
  population_title = (d) ->
    d.code
  addedLabels = (show) ->
    c = if show then '' else ' hidden'
    d3.selectAll(".added-label").transition()
      .attr('class', "label added-label#{c}")
  deletedLabels = (show) ->
    c = if show then '' else ' hidden'
    d3.selectAll(".deleted-label").transition()
      .attr('class', "label deleted-label#{c}")

  width = 140
  height = 460
  barHeight = 3
  spacing = 5

  my = (selection) ->
    selection.each (data) ->

      for measure in data

        yOffset = 5

        svg = d3.select(this).append('svg')
          .attr('width', width)
          .attr('height', measure.totals.total * (barHeight + spacing) + measure.populations.length * 17 + spacing * 5)
          .attr('style', 'padding: 30px 15px 0px 15px; vertical-align: top;')

        svg.append('text')
          .attr('id', 'measure_title')
          .attr('class', 'label header')
          .attr('x', width * .2)
          .attr('y', yOffset)
          .text(measure.cms_id)

        yOffset += 15

        svg.append('text')
          .attr('id', 'deleted_title')
          .attr('class', 'label deleted-label hidden')
          .attr('x', 0)
          .attr('y', yOffset)
          .text("removed: #{Math.round((measure.totals.deletions / measure.totals.total) * 100)}%")

        svg.append('text')
          .attr('id', 'added_title')
          .attr('class', 'label added-label hidden')
          .attr('x', width * .45)
          .attr('y', yOffset)
          .text("added: #{Math.round((measure.totals.insertions / measure.totals.total) * 100)}%")

        yOffset += 12

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
    d3.selectAll('.del-line').transition().attr('class', 'logic-line del-line faded')
    d3.selectAll('.unchanged-line').transition().attr('class', 'logic-line unchanged-line faded')
    addedLabels(true)

  my.hideAddedLines = ->
    d3.selectAll('.del-line').transition().attr('class', 'logic-line del-line')
    d3.selectAll('.unchanged-line').transition().attr('class', 'logic-line unchanged-line')
    addedLabels(false)

  my.showDeletedLines = ->
    d3.selectAll('.ins-line').transition().attr('class', 'logic-line ins-line faded')
    d3.selectAll('.unchanged-line').transition().attr('class', 'logic-line unchanged-line faded')
    deletedLabels(true)

  my.hideDeletedLines = ->
    d3.selectAll('.ins-line').transition().attr('class', 'logic-line ins-line')
    d3.selectAll('.unchanged-line').transition().attr('class', 'logic-line unchanged-line')
    deletedLabels(false)

  my.sortByLargest = ->
    d3.selectAll('svg').data(size_data.sort( (a,b) -> b.size - a.size))

  my.sortByMostChange = ->
    d3.selectAll('svg').data(size_data.sort( (a,b) -> b.change - a.change))

  my
