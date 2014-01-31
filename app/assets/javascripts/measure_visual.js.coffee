window.Bonnie ||= {}
Bonnie.viz ||= {}
Bonnie.viz.measureVisualzation = ->
		my = (selection) ->
				selection.each (data) ->

						populationCodes = {'IPP': 'Initial Patient Population', 'DENOM': 'Denominator', 'NUMER': 'Numerator', 'DENEXCEP': 'Denominator Exceptions', 'DENEX': 'Denominator Exclusions', 'MSRPOPL': 'Measure Population', 'OBSERV': 'Measure Observations'}
						# Draw the visualization here?
						svg = d3.select(this).append('svg')
								.append("svg:g")
						
						window.observer=new MutationObserver((mutations) -> 
							mutations.map( (mutation) ->
								for el in mutation.addedNodes
									if el.nextSibling?
										next = el.nextSibling 
										next.transform.baseVal.getItem(0).matrix.f = el.getBBox().height+rowHeight + el.transform.baseVal.getItem(0).matrix.f
							))
							.observe(svg.node(), {attributes: true, childList: true, subtree:false})
						offset = 0
						for population in Thorax.Models.Measure.allPopulationCodes
								offset+= rowHeight+rowPadding.top
								populationElement = svg.append('svg:g')
										.attr("width", width)
										.attr("class", population)
										.classed("population", true)
										.attr("transform", "translate(0,#{offset})")
								textField = populationElement.append('text')
									.attr("transform", "translate(0, -3)")

								if not data[population] 
									continue 		
								if not data[population].preconditions?
									textField.text("#{populationCodes[[population]]}: None")
									continue
								textField.text(populationCodes[[population]])

								renderPrecondition(populationElement, data[population].preconditions[0]) if data[population].preconditions?
								offset+= getElementHeight(populationElement)





		width = 600
		rowHeight = 15
		margin = 
				top: 10
				right: 10
				bottom: 10
				left: 10
		rowPadding = 
				top: 15
				right: 15

		dataCriteria = {}


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

		my.dataCriteria = (_) ->
				return dataCriteria unless arguments.length
				dataCriteria = _
				my


		renderPrecondition = (parent, preconditions) -> 
				# Let's get the width of this element so we can operate on it
				preconditionWidth = parent.attr("width")
				elWidth = switch preconditions.conjunction_code
												when "allTrue" then parent.attr('width')
												when "atLeastOneTrue" then parent.attr('width')/preconditions.preconditions.length
				switch
						when preconditions.preconditions?
								# This is clearly a sub element, recurse...
								for precondition in preconditions.preconditions
										

										yOffset = switch preconditions.conjunction_code
												when "allTrue" then getElementHeight(parent)#parent.node().childNodes.length * (rowHeight+rowPadding.top)
												when "atLeastOneTrue" then 0
										xOffset = switch preconditions.conjunction_code
												when "allTrue" then 0
												when "atLeastOneTrue" then parent.node().childNodes.length * elWidth

										element = parent.append("svg:g")
												.attr("transform", "translate(#{xOffset},#{yOffset})")
												.attr("id", preconditions.id)
												.attr("conjunction_code", preconditions.conjunction_code)
												.attr("preconditions", preconditions.preconditions.length)
												.attr("width", elWidth)

										renderPrecondition(element, precondition)
										

						
						when preconditions.conjunction_code?
								element = parent.append("svg:g")
										.attr("id", preconditions.id)
										.attr('reference', preconditions.reference)
										.attr("conjunction_code", preconditions.conjunction_code)
										.attr("width", elWidth)
								renderDerivedElement(element, dataCriteria[preconditions.reference])
						else
								# This is an actual data Element
								element = renderElement(parent, preconditions)
	
		renderDerivedElement = (parent, derivedElement) ->
			index = 0
			elWidth = parent.attr('width')/derivedElement.children_criteria.length
			for condition in derivedElement.children_criteria
				condition = dataCriteria[condition]
				container = parent.append("g").attr('transform', "translate(#{index*elWidth},0)").attr('width', elWidth)
				container.append("rect")
						.attr("width", elWidth-rowPadding.right)
						.attr("height", rowHeight)
						.attr("precondition", condition.source_data_criteria)
						.classed("precondition", true)
						.classed("rationale_target", true)
						.classed(condition.source_data_criteria, true)
						.attr('data-placement', "auto")
						.attr('data-html', true)
						.attr('data-content', getTextDescription(condition))
						.attr('data-trigger', "hover focus")
						.attr('data-container', '.measure-viz')
						# .attr('conjunction_code', parent.attr('conjunction_code'))
				index++
			

		renderElement = (parent, precondition) ->
				# console.log precondition
				parent.append("rect")
						.attr("width", parent.attr("width")-rowPadding.right)
						.attr("height", rowHeight)
						.attr("precondition", precondition.reference)
						.attr("negation", precondition.negation)
						.classed("precondition", true)
						.classed("rationale_target", true)
						.classed(precondition.reference, true)
						.attr('data-placement', "auto")
						.attr('data-html', true)
						.attr('data-content', getTextDescription(dataCriteria[precondition.reference]))
						.attr('data-trigger', "hover focus")
						.attr('data-container', '.measure-viz')
						.attr('conjunction_code', parent.attr('conjunction_code'))

		getTextDescription = (data) ->
			# debugger
			specific_occurrence = switch data.type
				when "medications"	
					 "Occurrence #{data.specific_occurrence}: " 
				else
					""
			negation = ""
			if data["negation?"] 
				negation = "NOT"

			return "#{negation}#{specific_occurrence}#{data.description} #{parseTemporalReference(data.temporal_references[0])}"

		pluralizeUnit = (unit, value) ->
	  	unit_map = {'a':'year', 'mo':'month', 'wk':'week', 'd':'day', 'h':'hour', 'min':'minute', 's':'second'}
	  	if unit_map[unit]
	  		if value > 1 
	  			unit_map[unit] + 's' 
  			else 
  				unit_map[unit] 
	  	else
	  		unit



		parseTemporalReference = (temporalReference) -> 
		  timing_map = {'DURING':'During', 'SBS':'Starts Before Start of', 'SAS':'Starts After Start of', 'SBE':'Starts Before or During', 'SAE':'Starts After End of', 'EBS':'Ends Before Start of', 'EAS':'Ends During or After', 'EBE':'Ends Before or During', 'EAE':'Ends After End of', 'SDU':'Starts During', 'EDU':'Ends During', 'ECW':'Ends Concurrent with', 'SCW':'Starts Concurrent with', 'CONCURRENT':'Concurrent with'}

				  	
		  returnVal = ""
		  if temporalReference.range
		  	if temporalReference.range.low
		  		if temporalReference.range.low['inclusive?'] == true
			  		returnVal += ">="
			  	else
			  		returnVal += ">"
		  		returnVal += "#{temporalReference.range.low.value} #{pluralizeUnit(temporalReference.range.low.unit, temporalReference.range.low.value)}"
		  	if temporalReference.range.high
		  		if temporalReference.range.high['inclusive?'] == true
			  		returnVal += "<="
			  	else
			  		returnVal += "<"
		  		returnVal += "#{temporalReference.range.high.value} #{pluralizeUnit(temporalReference.range.high.unit, temporalReference.range.high.value)}"

		  reference = ""
		 	if temporalReference.reference == "MeasurePeriod"
		 		reference = "\"Measurement Period\""
		 	else
		 		reference = "Occurrence #{dataCriteria[temporalReference.reference].specific_occurrence}: #{dataCriteria[temporalReference.reference].description}"
		 		

		  returnVal += " #{timing_map[temporalReference.type]} #{reference}"
		  

	  

		getElementHeight = (element) ->
			element.selectAll("rect").size()*(rowHeight + rowPadding.top)

		my

