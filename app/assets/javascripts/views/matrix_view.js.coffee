Thorax.View.extend
  name: 'matrix'
  template: JST['matrix']
  context: ->
    measures: @measures.models
    patients: @patients.map (patient) =>
      results = @measures.map (measure) ->
        result = measure.calculate(patient)
        if result.DENEXCEP then 'EXC'
        else if result.DENEX then 'EX'
        else if result.NUMER then 'NUM'
        else if result.DENOM then 'DEN'
        else if result.IPP then 'IPP'
        else ''
      _(patient.toJSON()).extend(results: results)
