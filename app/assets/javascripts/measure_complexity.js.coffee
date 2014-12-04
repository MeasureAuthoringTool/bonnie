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
    top: 79.5
    right: 49.5
    bottom: 39.5
    left: 39.5

  width = 1100 - margin.right
  height = 700 - margin.top - margin.bottom
  xScale = null
  yScale = null
  radiusScale = null
  x = d3.scale.ordinal().rangeRoundBands([
    0
    width
  ], .5)
  charted = false

  my = (selection) ->
    selection.each (data) ->

      unless charted

        # Create a dynamic scale based on the actual data
        minComplexity = 0
        maxComplexity = d3.max(data, (d) -> d.complexity) * 1.2
        biggestChange = d3.max(data, (d) -> Math.abs(d.change))
        minChange = d3.max([biggestChange, 1]) * -1.2
        maxChange = d3.max([biggestChange, 1]) * 1.2
        # Various scales. These domains make assumptions of data, naturally.
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
          height
          0
        ])
        radiusScale = d3.scale.linear().domain([
          minComplexity
          maxComplexity
        ]).range([
          5
          50
        ])
        colorScale = (input) ->
          return "#0075C4" if input <= -25
          return "#3391D0" if input < 0
          return "#CCCCCC" if input == 0
          return "#eca9a7" if input <= 25
          return "#d9534f"

        # The x & y axes.
        # FIXME had to remove [, d3.format(",d")] from ticks()...
        xAxis = d3.svg.axis().orient("bottom").scale(xScale).ticks(12)
        yAxis = d3.svg.axis().scale(yScale).orient("left")

        # Create the SVG container and set the origin.
        svg = d3.select(this).append("svg")
          .attr("width", width + margin.left + margin.right)
          .attr("height", height + margin.top + margin.bottom).append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")")

        # Add the x-axis.
        svg.append("g")
          .attr("id", "xAxis")
          .attr("class", "x axis")
          .attr("transform", "translate(0," + height + ")")
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
          .attr("y", height - 6)
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

      # Position the dots on the x/y axis  
      position = (dot) ->
        dot.attr("cx", (d) -> xScale radius(d))
          .attr("cy", (d) -> yScale y(d))
          .attr "r", (d) -> radiusScale radius(d)

      # Defines a sort order so that the smallest dots are drawn on top.
      order = (a, b) ->
        radius(b) - radius(a)

      # Add a dot per measure and set the colors. 
      dot = svg.append("g")
        .attr("class", "dots")
        .selectAll(".dot")
        .data(data)
        .enter().append("circle")
        .attr("class", "dot")
        .style("fill", (d) -> colorScale color(d))
        .call(position)
        .sort(order)

      text = svg.selectAll("dot")
        .data(data)
        .enter()
        .append("text")

      # Add CMS label
      textLabels = text
        .attr("class", "cmsLabel")
        .attr("x", (d) -> xScale(radius(d)) - 25)
        .attr("y", (d) -> yScale(y(d)) + (radiusScale(radius(d))) + 20)
        .text(name = (d) -> d.name)

  my.switchGrid = ->
    #Defines interaction for pressing grid button
    d3.selectAll(".dot").transition()
      .attr("cx", (d, i) -> ( i % gridLength ) * 125 + 100 )
      .attr("cy", (d, i) -> ( i // gridLength ) * 140 )

    #label transistion
    d3.selectAll(".cmsLabel").transition()
      .attr("x", (d, i) -> ( i % gridLength ) * 125 + 75 )
      .attr("y", (d, i) -> ( i // gridLength ) * 140 + 75 )

    #Add the axis
    active = (if xAxis.active then false else true)
    newOpacity = (if active then 0 else 1)
    d3.selectAll(".axis").style "opacity", newOpacity
    d3.select(".y .axis").style "opacity", newOpacity
    d3.select("#xLabel").style "opacity", newOpacity
    d3.select("#yLabel").style "opacity", newOpacity

  my.switchGraph = ->
    # Defines interaction for pressing graph button
    d3.selectAll(".dot").transition()
      .attr("cx", (d) -> xScale radius(d))
      .attr("cy", (d) -> yScale y(d))

    #Remove axis
    active = (if xAxis.active then true else false)
    newOpacity = (if active then 0 else 1)
    d3.selectAll(".axis").style "opacity", newOpacity
    d3.select(".y .axis").style "opacity", newOpacity
    d3.select("#xLabel").style "opacity", newOpacity
    d3.select("#yLabel").style "opacity", newOpacity

    #Move the labels back
    d3.selectAll(".cmsLabel").transition()
      .attr("x", (d) -> xScale(radius(d)) - 25)
      .attr("y", (d) -> yScale(y(d)) + (radiusScale(radius(d))) + 20)

  my
