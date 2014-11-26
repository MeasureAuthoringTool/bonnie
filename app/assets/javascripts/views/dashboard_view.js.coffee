class Thorax.Views.Dashboard extends Thorax.LayoutView
  template: JST['dashboard/layout']

  events:
    rendered: ->
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      if @isSize
        $('.nav-dashboard-size').addClass('active')
      else
        $('.nav-dashboard').addClass('active')

  initialize: ->
    if @isSize
      @setView new Thorax.Views.SizeDashboard(collection: @collection)
    else
      @setView new Thorax.Views.ComplexityDashboard(collection: @collection)

class Thorax.Views.SizeDashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/size']

  events:
    rendered: ->
      example_data = [
        {
          cms_id: 'cms126v1'
          populations: [
            {
              code: 'IPP'
              lines: ['unchanged', 'unchanged', 'ins', 'del', 'unchanged', 'del']
              insertions: 1
              deletions: 2
              unchanged: 3
              total: 6
            },{
              code: 'DENOM'
              lines: ['unchanged', 'ins', 'ins', 'del', 'ins', 'del']
              insertions: 3
              deletions: 2
              unchanged: 1
              total: 6
            },{
              code: 'NUMER'
              lines: ['unchanged', 'unchanged', 'unchanged', 'unchanged', 'unchanged', 'del']
              insertions: 0
              deletions: 1
              unchanged: 5
              total: 6
            }
          ]
          totals: {
            total: 18
            deletions: 5
            insertions: 4
          }
        }
      ]

      LINE_STATES = ['unchanged', 'ins', 'del']
      MEASURE_POPULATIONS = [
        ['IPP', 'DENOM', 'NUMER']
        ['IPP', 'DENOM', 'DENEX', 'NUMER']
        ['IPP', 'DENOM', 'NUMER', 'DENEXCL']
        ['IPP', 'DENOM', 'DENEX', 'NUMER', 'DENEXCL']
        ['IPP', 'MSRPOPL', 'OBSERV']
      ]

      for i in [0..93]
        measure = {}
        measure['cms_id'] = "cms#{Math.floor(Math.random() * 300) + 1}v#{Math.floor(Math.random() * 4) + 1}"
        measure['populations'] = []
        sum =
          total: 0
          deletions: 0
          insertions: 0

        p = Math.floor(Math.random() * 5)
        for criteria in MEASURE_POPULATIONS[p]
          n = Math.floor(Math.random() * 10) + 1
          population = {
            code: "#{criteria}_#{i}"
          }
          lines = []
          for ii in [0..n]
            lines.push LINE_STATES[Math.floor(Math.random() * 3)]
          population['lines'] = lines
          population['insertions'] = _(lines).filter( (l) -> l == 'ins' ).length
          population['deletions'] = _(lines).filter( (l) -> l == 'del' ).length
          population['unchanged'] = _(lines).filter( (l) -> l == 'unchanged' ).length
          population['total'] = lines.length
          measure['populations'].push population
          sum.total += lines.length
          sum.deletions += population['insertions']
          sum.insertions += population['deletions']

        measure['totals'] = sum
        example_data.push measure

      @viz = bonnie.viz.MeasureSize()
      d3.select(@$el.find('#size-grid').get(0)).datum(example_data).call(@viz)

  sortByLargest: (e) ->
    console.log "Should sort by largest size..."
    @$('.sort').toggleClass('btn-primary btn-default') unless @$('.sort-largest').hasClass('btn-primary')

  sortByMostChange: (e) ->
    console.log "Should sort by most change..."
    @$('.sort').toggleClass('btn-primary btn-default') unless @$('.sort-change').hasClass('btn-primary')

class Thorax.Views.ComplexityDashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/complexity']

  events:
    rendered: ->
      example_data = [
        {
          name: 'cms146'
          version: 1
          complexity: 49
          change: 24
        }, {
          name: 'cms155'
          version: 1
          complexity: 28
          change: 74
        }, {
          name: 'cms153'
          version: 1
          complexity: 10
          change: 51
        }, {
          name: 'cms126'
          version: 1
          complexity: 28
          change: 30
        }, {
          name: 'cms117'
          version: 1
          complexity: 20
          change: 50
        }, {
          name: 'cms136'
          version: 1
          complexity: 47
          change: 76
        }, {
          name: 'cms2'
          version: 1
          complexity: 30
          change: 49
        }, {
          name: 'cms75'
          version: 1
          complexity: 21
          change: 25
        }, {
          name: 'cms165'
          version: 1
          complexity: 18
          change: 49
        }
      ]

      for i in [0..(93 - example_data.length)]
        measure = {}
        measure['name'] = "cms#{Math.floor(Math.random() * 300) + 1}v#{Math.floor(Math.random() * 4) + 1}"
        measure['version'] = Math.floor(Math.random() * 5) + 1
        measure['complexity'] = Math.floor(Math.random() * 150)
        measure['change'] = Math.floor(Math.random() * 100)
        example_data.push measure

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
      d3.select(@$el.find('#chart').get(0)).datum(example_data).call(@viz)

  switchGrid: (e) -> 
    @viz.switchGrid()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-grid').hasClass('btn-primary')

  switchGraph: (e) -> 
    @viz.switchGraph()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-graph').hasClass('btn-primary')
