window.Bonnie ||= {}
Bonnie.viz ||= {}
Bonnie.viz.measureVisualzation = ->
    my = (selection) ->
        selection.each (data) ->

            # create the root SVG, addressable by #measureVizSVG
            svg = d3.select(this).append('svg')
                .attr('id','measureVizSVG')

            # used to reorganize patient populations after rendering rect's
            window.observer=new MutationObserver((mutations) ->
              mutations.map( (mutation) ->
                for el in mutation.addedNodes
                  if el.nextSibling?
                    next = el.nextSibling
                    next.transform.baseVal.getItem(0).matrix.f = el.getBBox().height+rowHeight + el.transform.baseVal.getItem(0).matrix.f
              ))
              .observe(svg.node(), {attributes: true, childList: true, subtree:false})

            # begin parsing each patient population
            offset = 0
            for population in Thorax.Models.Measure.allPopulationCodes

                # skip non-existent populations
                population_code = measurePopulation?.get(population)?.code
                if not data[population_code] then continue

                # add the parent g and patient population title
                offset+= rowHeight
                populationElement = svg.append('svg:g')
                    .attr("width", width)
                    .attr("class", population)
                    .classed("population", true)
                    .attr("transform", "translate(0,#{offset})")
                textField = populationElement.append('text')
                  .style("font-size", fontSize)
                  .attr("transform", "translate(0, #{rowHeight})")
                  .style("font-weight", "bold")

                # specify None and skip if there is no logic
                if not data[population_code].preconditions?
                  textField.text("#{populationCodes[[population]]}: None")
                  continue

                textField.text("#{populationCodes[[population]]}:")
                if data[population_code].preconditions?
                  rootPrecondition = data[population_code].preconditions[0]

                  # handle top-level OR by nesting it within an AND parent
                  if rootPrecondition.conjunction_code == 'atLeastOneTrue'
                    newRoot = _({}).extend(rootPrecondition)
                    newRoot.conjunction_code = 'allTrue'
                    newRoot.preconditions = [ rootPrecondition ]
                    rootPrecondition = newRoot
                  renderPrecondition(populationElement, rootPrecondition, data[population_code].aggregator, rootPrecondition.conjunction_code == 'atLeastOneTrue')
                offset+= getElementHeight(populationElement)

            # allow the viz to be responsive! specify a viewbox with appropriate dimensions
            calculatedHeight = getElementHeight(svg) + rowHeight*3 # just some buffer room
            svg.attr("viewBox", "0 0 #{width} #{calculatedHeight}")
                .attr("preserveAspectRatio", "xMaxYMin")
                .attr('height',"#{calculatedHeight}")
                .attr('width',"100%")

    width = 700
    rowHeight = 26
    margin =
        top: 10
        right: 10
        bottom: 10
        left: 10
    rowPadding =
        top: 18
        right: 6
    fontSize = "2em"

    dataCriteria = {}
    measurePopulation = {}
    measureValueSets = {}

    populationCodes =
      'STRAT': 'Stratification'
      'IPP': 'Initial Patient Population'
      'DENOM': 'Denominator'
      'NUMER': 'Numerator'
      'DENEXCEP': 'Denominator Exceptions'
      'DENEX': 'Denominator Exclusions'
      'MSRPOPL': 'Measure Population'
      'OBSERV': 'Measure Observations'

    aggregator_map =
      'MEAN': 'Mean of'
      'MEDIAN': 'Median of'

    unit_map =
      'a':'year'
      'mo':'month'
      'wk':'week'
      'd':'day'
      'h':'hour'
      'min':'minute'
      's':'second'

    subset_map =
      'RECENT': 'MOST RECENT'
      'TIMEDIFF': 'Difference between times'
      'DATEDIFF': 'Difference between dates'
      'DATETIMEDIFF': 'Difference between date/times'

    timing_map =
      'DURING':'during'
      'OVERLAP':'overlaps'
      'SBS': 'starts before start of'
      'SAS': 'starts after start of'
      'SBE': 'starts before end of'
      'SAE': 'starts after end of'
      'EBS': 'ends before start of'
      'EAS': 'ends after start of'
      'EBE': 'ends before end of'
      'EAE': 'ends after end of'
      'SDU': 'starts during'
      'EDU': 'ends during'
      'ECW': 'ends concurrent with'
      'SCW': 'starts concurrent with'
      'ECWS': 'ends concurrent with start of'
      'SCWE': 'starts concurrent with end of'
      'SBCW': 'starts before or concurrent with'
      'SBCWE': 'starts before or concurrent with end'
      'SACW': 'starts after or concurrent with'
      'SACWE': 'starts after or concurrent with end'
      'SBDU': 'starts before or during'
      'EBCW': 'ends before or concurrent with'
      'EBCWS': 'ends before or concurrent with start'
      'EACW': 'ends after or concurrent with'
      'EACWS': 'ends after or concurrent with start'
      'EADU': 'ends after or during'
      'CONCURRENT': 'concurrent with'

    my.width = (_) ->
        return width unless arguments.length
        width = _
        my

    my.rowHeight = (_) ->
        return rowHeight unless arguments.length
        rowHeight = _
        my

    my.margin = (_) ->
        return margin unless arguments.length
        margin = _
        my

    my.rowPadding  = (_) ->
        return rowPadding  unless arguments.length
        rowPadding  = _
        my

    my.fontSize = (_) ->
        return fontSize unless arguments.length
        fontSize = _
        my

    my.dataCriteria = (_) ->
        return dataCriteria unless arguments.length
        dataCriteria = _
        my

    my.measurePopulation = (_) ->
        return measurePopulation unless arguments.length
        measurePopulation = _
        my

    my.measureValueSets = (_) ->
        return measureValueSets unless arguments.length
        measureValueSets = _
        my

    renderPrecondition = (parent, preconditions, aggregator=null) ->
        # handle missing conjunction codes
        unless preconditions.conjunction_code?
          if aggregator? # treat as AND if it's an aggregation
            preconditions['conjunction_code'] = 'allTrue'
          else preconditions['conjunction_code'] = 'atLeastOneTrue'

        # compute width based on conjunction code
        elWidth = switch preconditions.conjunction_code
                        when "allTrue" then parent.attr('width')
                        when "atLeastOneTrue"
                          if preconditions.preconditions?
                            parent.attr('width')/preconditions.preconditions.length
                          else parent.attr('width')
        switch
            # recurse on nested preconditions
            when preconditions.preconditions?
                for precondition in preconditions.preconditions

                    # compute offsets based on conjunction code
                    yOffset = switch preconditions.conjunction_code
                        when "allTrue" then getElementHeight(parent)
                        when "atLeastOneTrue" then 0
                    xOffset = switch preconditions.conjunction_code
                        when "allTrue" then 0
                        when "atLeastOneTrue" then parent.node().childNodes.length * elWidth

                    # add vertical padding to sub-elements of preconditions
                    yOffset += rowPadding.top unless yOffset == 0

                    # create parent g with offsets
                    element = parent.append("svg:g")
                        .attr("transform", "translate(#{xOffset},#{yOffset})")
                        .attr("id", preconditions.id)
                        .attr("conjunction_code", preconditions.conjunction_code)
                        .attr("preconditions", preconditions.preconditions.length)
                        .attr("width", elWidth)
                        .attr('negation', preconditions.negation)
                        # uncomment below to flip negation highlighting
                        # .attr('negation_reference', "precondition_#{parseInt(preconditions.id)+1}")

                    # recurse on child precondition
                    renderPrecondition(element, precondition)
            # handle aggregators separately
            when aggregator?
                # create parent g with vertical offset
                element = parent.append("svg:g")
                    .attr("transform", "translate(0,#{getElementHeight(parent)})")
                    .attr("id", preconditions.id)
                    .attr('reference', preconditions.reference)
                    .attr("conjunction_code", preconditions.conjunction_code)
                    .attr("aggregator", aggregator)
                    .attr("width", elWidth)

                # recurse on aggregator preconditions
                renderPrecondition(element, preconditions)
            # handle derived data criteria
            when dataCriteria[preconditions.reference].definition == "derived"
                # create parent g
                element = parent.append("svg:g")
                    .attr("id", preconditions.id)
                    .attr('reference', preconditions.reference)
                    .attr("conjunction_code", preconditions.conjunction_code)
                    .attr("width", elWidth)

                # custom render for derived elements
                renderDerivedElement(element, dataCriteria[preconditions.reference])
            else
                # render the precondition
                element = renderElement(parent, preconditions)

    renderDerivedElement = (parent, derivedElement) ->
      # compute the element width from the parent conjunction code
      index = 0
      conjunction_code = parent.attr('conjunction_code')
      elWidth = switch conjunction_code
        when 'allTrue' then parent.attr('width')
        when 'atLeastOneTrue' then parent.attr('width')/derivedElement.children_criteria.length

      for condition in derivedElement.children_criteria
        condition = dataCriteria[condition]

        # use the correct text description for variables and subtrees
        if condition.type == 'derived'
          if condition.definition == 'derived' and not derivedElement.variable
            desc = getTextDescription(condition)
          else desc = getTextDescription(derivedElement)
        else desc = getTextDescription(condition)

        # compute the offsets from the parent conjunction code
        xOffset = switch conjunction_code
          when 'allTrue' then 0
          when 'atLeastOneTrue' then index*elWidth
        yOffset = switch conjunction_code
          when 'allTrue' then getElementHeight(parent)
          when 'atLeastOneTrue' then 0

        # add vertical padding to sub-elements of preconditions
        yOffset += rowPadding.top unless yOffset == 0

        # create the parent g using offsets
        container = parent.append("g")
            .attr('transform', "translate(#{xOffset}, #{yOffset})")
            .attr('width', elWidth)

        # create element rect with logic text popover
        container.append("rect")
            .attr("width", elWidth-rowPadding.right)
            .attr("height", rowHeight)
            .attr("precondition", condition.key)
            .classed("precondition", true)
            .classed("rationale_target", true)
            .classed(condition.key, true)
            .attr('data-placement', "auto")
            .attr('data-html', true)
            .attr('data-content', desc)
            .attr('data-trigger', "hover focus")
            .attr('data-container', '.d3-measure-viz')
        index++

    renderElement = (parent, precondition) ->
        # handle negations, aggregators, and default preconditions
        if parent.attr('negation')
          desc = "NOT "
          # uncomment below to flip negation highlighting
          # reference = parent.attr('negation_reference')
        else if parent.attr('aggregator')
          desc = "#{aggregator_map[parent.attr('aggregator')]}: "
        else
          desc = ""
          reference = precondition.reference
        desc += getTextDescription(dataCriteria[precondition.reference])
        reference ?= precondition.reference

        # create precondition rect with logic text popover
        parent.append("rect")
            .attr("width", parent.attr("width")-rowPadding.right)
            .attr("height", rowHeight)
            .attr("precondition", reference)
            .attr("negation", precondition.negation)
            .classed("precondition", true)
            .classed("rationale_target", true)
            .classed(precondition.reference, true)
            .attr('data-placement', "auto")
            .attr('data-html', true)
            .attr('data-content', desc)
            .attr('data-trigger', "hover focus")
            .attr('data-container', '.d3-measure-viz')
            .attr('conjunction_code', parent.attr('conjunction_code'))

    getTextDescription = (data) ->
      # derive test description from data
      subset_operator = getSubsetOperatorDescription(data)
      specific_occurrence = getSpecificOccurrenceDescription(data)
      value = if data.value? and data.type != 'characteristic' then parseValue(data.value) else ""
      fieldValues = if data.field_values? then parseFieldValues(data.field_values) else ""
      negation = if data.negation then "(Not Done: #{translateOid(data.negation_code_list_id)})" else ""
      temporal_reference = getTemporalReferenceDescription(data)
      variable = getVariableDescription(data)
      grouping = getGroupingDescription(data)
      satisfies = getSatisfiesDescription(data)
      description = if grouping.length or satisfies.length then "" else "#{data.description}"
      grouping = variable if variable.length

      return "#{subset_operator} #{specific_occurrence}#{grouping}#{description} #{value}#{fieldValues}#{negation}#{satisfies} #{temporal_reference}"

    getSpecificOccurrenceDescription = (data) ->
      if data.specific_occurrence? then "Occurrence #{data.specific_occurrence}: " else ""

    getTemporalReferenceDescription = (data) ->
      if data.temporal_references? then parseTemporalReference(data.temporal_references[0]) else ""

    getVariableDescription = (data) ->
      if data.variable? and data.variable then "$#{data.description}" else ""

    getGroupingDescription = (data) ->
      returnVal = ""
      if data.type == 'derived' and data.definition == 'derived'
        returnVal += "#{translateOperator(data.derivation_operator)} "
        returnVal += getDerivedDescription(data)
      returnVal

    getSatisfiesDescription = (data) ->
      returnVal = ""
      if data.definition == "satisfies_all" or data.definition == "satisfies_any"
        returnVal += "#{translateDefinition(data.definition)} "
        returnVal += getDerivedDescription(data)
      returnVal

    getDerivedDescription = (data) ->
      childrenDescriptions = []
      for children in data.children_criteria
        childrenDescriptions.push "[ #{getTextDescription(dataCriteria[children])} ]"
      childrenDescriptions.join(', ')

    getSubsetOperatorDescription = (data) ->
      returnVal = ""
      if data.subset_operators?
        for value in data.subset_operators
          returnVal += "#{translateSubset(value.type)}#{if value.value? then getValue(value.value) else ''}:"
      returnVal

    pluralizeUnit = (unit, value) ->
      if unit_map[unit]
        if value > 1
          unit_map[unit] + 's'
        else
          unit_map[unit]
      else
        unit

    translateOperator = (operator) ->
      switch operator
        when 'UNION' then 'Union of'
        when 'INTERSECT' then 'Intersection of'
        when 'XPRODUCT' then 'Cross-Product of'

    translateDefinition = (definition) ->
      switch definition
        when 'satisfies_all' then 'SATISFIES ALL'
        when 'satisfies_any' then 'SATISFIES ANY'

    translateSubset = (subset) -> subset_map[subset] || subset

    translateOid = (oid) -> measureValueSets.findWhere({oid: oid})?.get('display_name')

    parseTemporalReference = (temporalReference) ->
      returnVal = ""
      if temporalReference.range
        returnVal += getValue(temporalReference.range)

      reference = ""
      if temporalReference.reference == "MeasurePeriod"
        reference = "\"Measurement Period\""
      else
        if dataCriteria[temporalReference.reference].specific_occurrence?
          reference = "Occurrence #{dataCriteria[temporalReference.reference].specific_occurrence}: #{dataCriteria[temporalReference.reference].description}"
        else
          reference = getTextDescription(dataCriteria[temporalReference.reference])

      returnVal += " #{timing_map[temporalReference.type]} #{reference}"

    parseFieldValues = (fieldValues) ->
      returnVal = "( "
      for key, value of fieldValues
        returnVal += "#{value.key_title}#{getValue(value) || ''}"
      returnVal += " )"

    parseValue = (value) -> "(result#{getValue(value)})"

    getValue = (value, rangeComparison="") ->
      returnVal = ""
      isRange = value.type == 'IVL_PQ'
      isEquivalent = isRange && value.high?.value == value.low?.value && value.high?['inclusive?'] && value.low?['inclusive?']
      isValue = value.type == 'PQ'
      isAnyNonNull = value.type == 'ANYNonNull'
      if isAnyNonNull
        returnVal
      else
        if isValue
          returnVal += " #{rangeComparison}#{if value["inclusive?"] then "=" else ''}"
          returnVal += " #{value.value} #{if value.unit? then pluralizeUnit(value.unit, value.value) else ''}"
        else
          if isRange
            if value.high && value.low
              if isEquivalent
                getValue(value.low)
              else
                returnVal += "#{getValue(value.low, ">")} and #{getValue(value.high, "<")}"
            else
              if value.high
                getValue(value.high, "<")
              else if value.low
                getValue(value.low, ">")
          else
            if value.type == 'CD'
              returnVal += ": #{translateOid(value.code_list_id)}"

    getElementHeight = (element) -> element.node().getBBox().height

    my
