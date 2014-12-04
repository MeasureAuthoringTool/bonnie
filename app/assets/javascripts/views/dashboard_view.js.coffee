class Thorax.Views.Dashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/setup']
  className: "dashboard"

  initialize: ->
    @collection = new Thorax.Collections.MeasureSets
    @collection.fetch()

  compare: ->
    measureSet1 = @$('#measureSet1').val()
    measureSet2 = @$('#measureSet2').val()
    bonnie.navigate "dashboard/complexity/#{measureSet1}/#{measureSet2}", trigger: true

class Thorax.Views.SizeDashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/size']
  className: "dashboard"

  events:
    'mouseover .added-box': 'showAddedLines'
    'mouseout .added-box': 'hideAddedLines'
    'mouseover .deleted-box': 'showDeletedLines'
    'mouseout .deleted-box': 'hideDeletedLines'
    rendered: ->
      # FIXME: instead of these two lines, maybe just more buttons in the grid/graph area
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      $('.nav-dashboard-size').addClass('active')
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

  showAddedLines: (e) ->
    @$('.added-box').addClass('darker')
    @viz.showAddedLines()

  hideAddedLines: (e) ->
    @$('.added-box').removeClass('darker')
    @viz.hideAddedLines()

  showDeletedLines: (e) ->
    @$('.deleted-box').addClass('darker')
    @viz.showDeletedLines()

  hideDeletedLines: (e) ->
    @$('.deleted-box').removeClass('darker')
    @viz.hideDeletedLines()

  sortByLargest: (e) ->
    console.log "Should sort by largest size..."
    @$('.sort').toggleClass('btn-primary btn-default') unless @$('.sort-largest').hasClass('btn-primary')

  sortByMostChange: (e) ->
    console.log "Should sort by most change..."
    @$('.sort').toggleClass('btn-primary btn-default') unless @$('.sort-change').hasClass('btn-primary')

class Thorax.Views.ComplexityDashboard extends Thorax.Views.BonnieView
  template: JST['dashboard/complexity']
  className: "dashboard"

  events:
    rendered: ->
      # FIXME: instead of these two lines, maybe just more buttons in the grid/graph area
      $('.indicator-circle, .navbar-nav > li').removeClass('active')
      $('.nav-dashboard').addClass('active')
      @viz = bonnie.viz.MeasureComplexity()
      d3.select(@$el.find('#chart').get(0)).datum(@collection.complexityVizData()).call(@viz)
    collection:
      sync: -> @render()

  switchGrid: (e) -> 
    @viz.switchGrid()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-grid').hasClass('btn-primary')

  switchGraph: (e) -> 
    @viz.switchGraph()
    @$('.switch').toggleClass('btn-primary btn-default') unless @$('.switch-graph').hasClass('btn-primary')
