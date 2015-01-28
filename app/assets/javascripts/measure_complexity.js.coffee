window.bonnie ||= {}
bonnie.viz ||= {}
bonnie.viz.MeasureComplexity = ->
  # Various accessors that specify the four dimensions of data to visualize.
  x = (d) ->
    d.complexity
  y = (d) ->
    d.change
  radius = (d) ->
    d.complexity
  color = (d) ->
    d.change
  name = (d) ->
    d.name
  ComplexListing = (d) ->
    d.ComplexListing

  gridLength = 8

  # Chart dimensions.
  margin =
    top: 39.5
    right: 49.5
    bottom: 39.5
    left: 39.5

  width = 1100 - margin.right
  graphHeight = 700 - margin.top - margin.bottom
  gridHeight = null

  xScale = null
  yScale = null
  radiusScale = null
  x = d3.scale.ordinal().rangeRoundBands([
    0
    width
  ], .5)
  charted = false
  positionDotGraph = positionLabelGraph = positionDotGrid = positionLabelGrid = null

  my = (selection) ->
    selection.each (data) ->

      unless charted
        # Set the height for the grid dynamically based on number of measures
        gridHeight = Math.ceil(data.length / gridLength) * 140 + 40

        # Create dynamic scales based on the actual data
        minComplexity = 0
        maxComplexity = d3.max(data, (d) -> d.complexity) * 1.2
        biggestChange = d3.max(data, (d) -> Math.abs(d.change))
        minChange = d3.max([biggestChange, 1]) * -1.2
        maxChange = d3.max([biggestChange, 1]) * 1.2

        xScale = d3.scale.linear().domain([
          minComplexity
          maxComplexity
        ]).range([
          0
          width
        ])
        yScale = d3.scale.linear().domain([
          minChange
          maxChange
        ]).range([
          graphHeight
          0
        ])
        radiusScale = d3.scale.linear().domain([
          minComplexity
          d3.max([maxComplexity, 50])
        ]).range([
          5
          50
        ])
        colorScale = (input) ->
          return "#0075C4" if input <= -40
          return "#C1D1F1" if input < 0
          return "#CCCCCC" if input == 0
          return "#ECA9A7" if input <= 40
          return "#D9534F"
        colorLegend = (input) ->
          return "Large -" if input <= -40
          return "Moderate -" if input < 0
          return "No Change" if input == 0
          return "Moderate +" if input <= 40
          return "Large +"

        # Tooltip
        tooltip = d3.tip().attr('class', 'complexity-tooltip').direction('e').html (d) ->
          # We display the old complexity scores (overall then by population) compared to the new scores; we
          # display populations by canonical order, then numerical order, ie IPP then IPP_1 then DENOM etc
          # First pair up all the old and new population scores, using an algorithm that doesn't assume the
          # measures have the same populations
          pairs = []
          for population in d.measure1Scores.populations
            pairs.push { name: population.name, oldScore: population.complexity }
          for population in d.measure2Scores.populations
            if match = _(pairs).findWhere(name: population.name)
              match.newScore = population.complexity
            else
              pairs.push { name: population.name, newScore: population.complexity }
          # Then sort canonically, using Thorax.Models.Measure.allPopulationCodes
          pairs = _(pairs).sortBy (p) ->
            sortArray = p.name.split('_')
            sortArray[0] = Thorax.Models.Measure.allPopulationCodes.indexOf(sortArray[0])
            sortArray.push(0) if sortArray.length == 1
            sortArray # Sorts by an array where first element is order of the population and second is population num
          # Finally, variables
          variables = []
          for variable in d.measure1Scores.variables
            variables.push { name: variable.name, oldScore: variable.complexity }
          for variable in d.measure2Scores.variables
            if match = _(variables).findWhere(name: variable.name)
              match.newScore = variable.complexity
            else
              variables.push { name: variable.name, newScore: variable.complexity }
          JST['dashboard/complexity_popover'](name: d.name, old: d.oldComplexity, new: d.complexity, pairs: pairs, variables: variables)

        # The x & y axes.
        # FIXME had to remove [, d3.format(",d")] from ticks()...
        xAxis = d3.svg.axis().orient("bottom").scale(xScale).ticks(12)
        yAxis = d3.svg.axis().scale(yScale).orient("left")

        # Create the SVG container and set the origin.
        svg = d3.select(this).append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", graphHeight + margin.top + margin.bottom).append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

        # Add the x-axis.
        svg.append("g")
          .attr("id", "xAxis")
          .attr("class", "x axis")
          .attr("transform", "translate(0," + graphHeight + ")")
          .call xAxis

        # Add the y-axis.
        svg.append("g")
          .attr("id", "yAxis")
          .attr("class", "y axis")
          .call yAxis

        # Add an x-axis label.
        svg.append("text")
          .attr("id", "xLabel")
          .attr("class", "x label")
          .attr("text-anchor", "end")
          .attr("x", width)
          .attr("y", graphHeight - 6)
          .text "complexity"

        # Add a y-axis label.
        svg.append("text")
          .attr("id", "yLabel")
          .attr("class", "y label")
          .attr("text-anchor", "end")
          .attr("y", 6)
          .attr("dy", ".75em")
          .attr("transform", "rotate(-90)")
          .text "change in complexity"
        charted = true

      # Helpers for positioning the dots and labels in grid and graph mode
      positionDotGraph = (dot) ->
        dot.attr("cx", (d) -> xScale radius(d))
           .attr("cy", (d) -> yScale y(d))
           .attr "r", (d) -> radiusScale radius(d)

      positionLabelGraph = (label) ->
        label.attr("x", (d) -> xScale(radius(d)) - 30)
             .attr("y", (d) -> yScale(y(d)) + (radiusScale(radius(d))) + 20)
             .style('opacity', 0)

      positionDotGrid = (dot) ->
        dot.attr("cx", (d, i) -> ( i % gridLength ) * 125 + 40 )
           .attr("cy", (d, i) -> ( i // gridLength ) * 140 + 40 )
           .attr "r", (d) -> radiusScale radius(d)

      positionLabelGrid = (label) ->
        label.attr("x", (d, i) -> ( i % gridLength ) * 125 + 10 )
             .attr("y", (d, i) -> ( i // gridLength ) * 140 + 115 )
             .style('opacity', 1)

      # Defines a sort order to show the largest dots first
      order = (a, b) ->
        radius(b) - radius(a)

      # Set up tooltips
      svg.call(tooltip)

      # Add a dot per measure and set the colors. 
      dot = svg.append("g")
        .selectAll(".dot")
        .data(data)
        .enter().append("circle")
        .attr("class", "dot")
        .style("fill", (d) -> colorScale color(d))
        .sort(order)
        .call(positionDotGraph)
        .on('mouseover', tooltip.show)
        .on('mouseout', tooltip.hide)

      # Add CMS labels, hidden
      text = svg.append("g")
        .selectAll(".cmsLabel")
        .data(data)
        .enter().append("text")
        .attr("class", "cmsLabel")
        .text(name = (d) -> d.name)
        .sort(order)
        .call(positionLabelGraph)

      # Add legend
      legend = svg.selectAll(".legend")
        .data([50, 20, 0, -20, -50])
        .enter().append("g")
        .attr("class", "legend")
        .attr("transform", (d, i) -> "translate(0," + i * 20 + ")")

      legend.append("rect")
        .attr("x", width - 18)
        .attr("width", 18)
        .attr("height", 18)
        .style("fill", colorScale)

      legend.append("text")
        .attr("x", width - 24)
        .attr("y", 9)
        .attr("dy", ".35em")
        .style("text-anchor", "end")
        .text(colorLegend)

  setAxisVisibility = (visible) ->
    newOpacity = (if visible then 1 else 0)
    d3.selectAll(".axis").style "opacity", newOpacity
    d3.select(".y .axis").style "opacity", newOpacity
    d3.select("#xLabel").style "opacity", newOpacity
    d3.select("#yLabel").style "opacity", newOpacity

  my.switchGrid = ->
    # Adjust height
    d3.select("svg").attr("height", gridHeight + margin.top + margin.bottom)
    # Defines interaction for pressing grid button; first move the dots
    d3.selectAll(".dot").transition().call(positionDotGrid)
    # Next the labels, plus make them visible
    d3.selectAll(".cmsLabel").transition().call(positionLabelGrid)
    # Hide the axis
    setAxisVisibility(false)

  my.switchGraph = ->
    # Adjust height
    d3.select("svg").attr("height", graphHeight + margin.top + margin.bottom)
    # Defines interaction for pressing graph button; first move the dots
    d3.selectAll(".dot").transition().call(positionDotGraph)
    # Move the labels back and hide them
    d3.selectAll(".cmsLabel").transition().call(positionLabelGraph)
    # Show the axis
    setAxisVisibility(true)

  my
