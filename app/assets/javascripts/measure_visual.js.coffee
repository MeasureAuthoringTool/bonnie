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
            gIPP = gEnter.append('g')
            gIPP.attr("width", width)
            gIPP.attr("class", "IPP")
            rows = drawCondition(data.IPP.preconditions[0], gIPP, 0)
            if data.DENOM.preconditions?
                gDENOM = gEnter.append('g')
                gDENOM.attr("width", width)
                gDENOM.attr("class", "DENOM")
                rows = drawCondition(data.DENOM.preconditions[0], gDENOM, ++rows)
            else
                rows++
            if data.NUMER.preconditions?
                gNUMER = gEnter.append('g')
                gNUMER.attr("width", width)
                gNUMER.attr("class", "NUMER")
                rows = drawCondition(data.NUMER.preconditions[0], gNUMER, ++rows)
            else
                rows++


            if data.DENEX.preconditions?
                gDENEX = gEnter.append('g')
                gDENEX.attr("width", width)
                gDENEX.attr("class", "DENEX")
                rows = drawCondition(data.DENEX.preconditions[0], gDENEX, ++rows)
            else
                rows++
            


                


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
        if not condition
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
                    drawCondition(precondition, element, row, col++, condition.preconditions.length)
        else
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
                console.log dataCriteria[condition.reference]
        return row
            
        

    my

