Thorax.View.extend
  name: 'matrix'
  template: JST['matrix']
  context: ->
    measureNames: @collection.map (measure) -> measure.get('measure_id')
    patients: _(window.patients).map (patient) =>
      results = @collection.map (measure) ->
        result = measure.calculate(patient)[0]
        if result.DENEXCEP then 'EXC'
        else if result.DENEX then 'EX'
        else if result.NUMER then 'NUM'
        else if result.DENOM then 'DEN'
        else if result.IPP then 'IPP'
        else ''
      _(patient).extend(results: results)
