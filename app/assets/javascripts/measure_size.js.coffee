window.bonnie ||= {}
bonnie.viz ||= {}
bonnie.viz.MeasureSize = ->
  measure_title = (d) ->
    d.cms_id
  population_title = (d) ->
    d.code

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
          .attr('height', measure.totals.total * barHeight + measure.totals.total * spacing + measure.populations.length * 17 + spacing*5)
          .attr('style', 'padding: 10px 15px 0 15px;')

        svg.append('text')
          .attr('id', 'measure_title')
          .attr('class', 'label')
          .attr('x', width*.3)
          .attr('y', yOffset)
          .text(measure.cms_id)

        yOffset += 11

        svg.append('text')
          .attr('id', 'deleted_title')
          .attr('class', 'label')
          .attr('x', 0)
          .attr('y', yOffset)
          .text("del: #{measure.totals.deletions} / #{measure.totals.total}")

        svg.append('text')
          .attr('id', 'added_title')
          .attr('class', 'label')
          .attr('x', width*.55)
          .attr('y', yOffset)
          .text("ins: #{measure.totals.insertions} / #{measure.totals.total}")

        yOffset += 10

        for datum in measure.populations
          # Add text for the population
          svg.append('text')
            .attr('id', 'population_title')
            .attr('class', 'label')
            .attr('x', 0)
            .attr('y', yOffset+=spacing)
            .text(datum.code)

          for line in datum.lines

            yOffset+=spacing

            # Add a line for each line of logic
            svg.append('rect')
              .attr('x', 0)
              .attr('y', yOffset)
              .attr('width', width)
              .attr('height', barHeight)
              .attr('class', "#{datum.code}-logic-line")
              .style('fill', color(line) )

            # svg.append('line')
            #   .attr('x1', 0)
            #   .attr('y1', yOffset)
            #   .attr('x2', width)
            #   .attr('y2', yOffset)
            #   .attr('class', "#{datum.code}-logic-line")
            #   .attr('stroke-width', barHeight)
            #   .attr('stroke', color(line))

            yOffset+=barHeight

          yOffset += 10

  my
