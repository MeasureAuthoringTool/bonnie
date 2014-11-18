class Thorax.Views.Dashboard extends Thorax.Views.BonnieView

  template: JST['dashboard']

  events:
    rendered: ->
      example_data = [{"name":"cms146", "version":1, "complexity":49, "change": 24},{"name":"cms155", "version":1, "complexity":28, "change": 74},{"name":"cms153", "version":1, "complexity":10, "change": 51},{"name":"cms126", "version":1, "complexity":28, "change": 30},{"name":"cms117", "version":1, "complexity":20, "change": 50},{"name":"cms136", "version":1, "complexity":47, "change": 76},{"name":"cms2", "version":1, "complexity":30, "change": 49},{"name":"cms75", "version":1, "complexity":21, "change": 25},{"name":"cms165", "version":1, "complexity":18, "change": 49}]
      real_data = []
      change = 1
      @collection.each (m) ->

        c = m.get('complexity')
        # Calculate overall score; this is just the worst population or variable, over the entire measure
        scores = _(c?.populations).pluck('complexity')
        scores = scores.concat _(c?.variables).pluck('complexity')
        overall = _(scores).max()

        context = 
          name: m.get('cms_id')
          version: m.get('hqmf_version_number')
          complexity: overall || 10
          change: change

        change += 25
        real_data.push context
      @viz = bonnie.viz.MeasureComplexity()
      d3.select(@$el.find('#chart').get(0)).datum(real_data).call(@viz)

  switchGrid: (e) -> 
    @viz.switchGrid()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-grid').hasClass('btn-primary')

  switchGraph: (e) -> 
    @viz.switchGraph()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-graph').hasClass('btn-primary')
