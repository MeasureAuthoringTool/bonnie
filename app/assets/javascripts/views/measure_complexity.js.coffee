class Thorax.Views.MeasureComplexity extends Thorax.Views.BonnieView

  template: JST['measure/complexity']

  initialize: ->
    @population = @model.get('populations').at(0)

  updatePopulation: (population) ->
    @population = population
    @render()

  events:
    rendered: ->
      content = JST['measure/complexity_popover'](@context())
      @$('span').popover trigger: 'hover', placement: 'right', title: "Complexity", html: true, content: content

  context: ->
    complexity = @model.get('complexity')
    # Calculate overall score; this is just the worst population or variable, over the entire measure
    scores = _(complexity.populations).values()
    scores = scores.concat _(complexity.variables).values()
    overall = _(scores).max()
    # Figure out which populations are currently displayed and grab that complexity data
    complexities = []
    for code in Thorax.Models.Measure.allPopulationCodes
      if population = @population.get(code)
        complexities.push label: code, value: complexity.populations[population.code]
    # Add in the variable complexity data, which is always displayed
    for name, value of complexity.variables
      complexities.push label: "$#{name}", value: value
    _(super).extend complexities: complexities, overall: overall
