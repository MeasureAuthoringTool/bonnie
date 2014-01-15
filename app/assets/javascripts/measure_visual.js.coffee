window.Bonnie ||= {}
Bonnie.viz ||= {}
Bonnie.viz.measureVisualzation = ->
    my = (selection) ->
        selection.each (data) ->
            # Draw the visualization here?
            svg = d3.select(this).selectAll('svg').data([data])
            gEnter = svg.enter().append('svg')
                .attr('width', @width)
                .attr('height', 400)

            rows = 0
            for population in Thorax.Models.Measure.allPopulationCodes
                if not data[population]?
                    # rows++
                    continue

                populationElement = gEnter.append('g')
                    .attr("width", width)
                    .attr("class", population)
                    rows = render(data[population], populationElement, ++rows, 0) if data[population].preconditions?
                            


    width = 600
    rowHeight = 22
    margin = 
        top: 10
        right: 10
        bottom: 10
        left: 10
    rowPadding = 
        top: 5
        bottom: 5
        left: 10
        right: 10

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

    drawCondition = (condition, parent, row, col, columns) ->
        if not col?
            col = 0
        if not columns?
            columns = 1
        # Create an element to hold all children of this precondition    
        element = parent.append("g")
        element.attr("row", row)
            .attr("col", col)
        

        # If there's no condition, return before it causes an error.
        if not condition?
            return row
    
        if condition.preconditions?
            if condition.conjunction_code == "allTrue" or condition.conjunction?
                for precondition in condition.preconditions
                    element.attr("width", parent.attr("width"))
                        .attr("negation", condition.negation)
                    drawCondition(precondition, element, row++)

            else if condition.conjunction_code == "atLeastOneTrue"
                element.attr("width", parent.attr("width"))
                    .attr("negation", condition.negation)
                for precondition in condition.preconditions
                    drawCondition(precondition, element, row, col, condition.preconditions.length)
        else
            if condition.conjunction_code? and dataCriteria[condition.reference].children_criteria?
                for precondition in dataCriteria[condition.reference].children_criteria
                    element.attr("width", parent.attr("width"))
                        .attr("negation", condition.negation)
                    drawGroupData(precondition, element, row++, col)
            element.append("rect")
                .attr("id", condition.id)
                .attr("y", (d) -> row*rowHeight)
                .attr("x", (d) -> parent.attr("width")/columns * col)
                .attr("height", rowHeight - rowPadding.top)
                .attr("width", parent.attr("width")/columns-rowPadding.left)
                .attr("precondition",(d) => condition.reference)
                .attr("negation", condition.negation)
                .attr("class", "precondition")
                .attr('data-placement', "auto")
                .attr('data-html', true)
                .attr('data-content', dataCriteria[condition.reference]['description'])
                .attr('data-trigger', "hover focus")
                .attr('data-container', '.measure-viz')
                .attr('condition', JSON.stringify(condition))
        return row
        
    drawGroupData = (reference, parent, row, col, columns) -> 
        col = 0 unless col?
        columns = 1 unless columns?
        parent.append("rect")
                .attr("id", reference.id)
                .attr("y", (d) -> row*rowHeight)
                .attr("x", (d) -> parent.attr("width")/columns * col)
                .attr("height", rowHeight - rowPadding.top)
                .attr("width", parent.attr("width")/columns-rowPadding.left)
                .attr("precondition",(d) => reference.reference)
                .attr("negation", reference.negation)
                .attr("class", "precondition")
                .attr('data-placement', "auto")
                .attr('data-html', true)
                .attr('data-content', dataCriteria[reference]['description'])
                .attr('data-trigger', "hover focus")
                .attr('data-container', '.measure-viz')
                .attr('reference', JSON.stringify(reference))

    render = (population, parent, row, col) ->
        if population.preconditions[0].conjunction_code == "allTrue"
            return renderAnd(population.preconditions, parent, row++, col, width)
        if population.conjunction_code == "atLeastOneTrue"
            return renderOr(population.preconditions, parent, row, col++, width/population.preconditions.length)
        return row

            

    renderAnd = (conditions, parent, row, col, width) ->
        for condition in conditions
            # If this is a leaf node we should just render it
            if not condition.conjunction_code?
                renderElement(condition, parent, row++, col, width)
                continue
                

            # If this is a node with a groupData lookup we should handle that    
            if condition.conjunction_code? and not condition.preconditions?
                parent.append("g").attr("type", "groupData")
                console.log condition.reference
                continue

            element = parent.append("g").attr("id", condition.id).attr("type", "AND")
            
            if condition.conjunction_code == "allTrue"
                renderAnd(condition.preconditions, element, row++, col, width)              
                continue

            if condition.conjunction_code == "atLeastOneTrue"
                renderOr(condition.preconditions, element, row, col, width)
                continue
    
    renderOr = (conditions, parent, row, col, width) ->
        for condition in conditions
            # If this is a leaf node we should just render it
            if not condition.conjunction_code?
                renderElement(condition, parent, row, col++, width)
                continue

            # If this is a node with a groupData lookup we should handle that    
            if condition.conjunction_code? and not condition.preconditions?
                # Handling logic here
                parent.append("g").attr("type", "groupData")
                console.log condition.reference
                continue
                

            element = parent.append("g").attr("id", condition.id).attr("type", "OR")
            
            if condition.conjunction_code == "allTrue"
                renderAnd(condition.preconditions, element, row++, col, width)

            if condition.conjunction_code == "atLeastOneTrue"
                renderOr(condition.preconditions, element, row, col, width/conditions.length)

    renderElement = (condition, parent, row, col, width) -> 
        parent.append("rect")
            .attr("id", condition.id)
            .attr("y", (d) -> row*rowHeight)
            .attr("x", (d) -> col * width)
            .attr("height", rowHeight - rowPadding.top)
            .attr("width", width-rowPadding.left)
            .attr("precondition",(d) => condition.reference)
            .attr("negation", condition.negation)
            .attr("class", "precondition")
            .attr('data-placement', "auto")
            .attr('data-html', true)
            .attr('data-content', dataCriteria[condition.reference].description)
            .attr('data-trigger', "hover focus")
            .attr('data-container', '.measure-viz')

    my

