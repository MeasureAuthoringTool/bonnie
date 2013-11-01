class Thorax.Views.Matrix extends Thorax.View

  template: JST['matrix']

  context: ->
    measureIds: @measures.map (m) -> m.get('measure_id')

  calculateAsynchronously: ->
    # FIXME: This calculation code is rough (is timeout best approach to display while "loading"?)
    deferredProcesses = []
    @patients.each (p) =>
      unless p.has('results')
        deferred = $.Deferred()
        deferredProcesses.push(deferred)
        calculate = =>
          results = @measures.map (m) ->
            # FIXME: Just calculate first population for now
            result = m.get('populations').at(0).calculate(p)
            pops = []
            if result.NUMER then pops.push 'NUM'
            else if result.DENOM then pops.push 'DEN'
            else if result.MSRPOPL then pops.push 'POPL'
            else if result.IPP then pops.push 'IPP'
            if result.DENEXCEP then pops.push 'EXC'
            if result.DENEX then pops.push 'EX'
            pops.join('/')
          p.set('results', results)
          deferred.resolve()
        setTimeout calculate, 0 # Defer calculation to allow rendering to happen
    $.when(deferredProcesses...) # Return collected deferred processes
