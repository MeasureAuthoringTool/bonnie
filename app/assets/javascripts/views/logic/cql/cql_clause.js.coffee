class Thorax.Views.CqlClauseView extends Thorax.Views.BonnieView
  template: JST['cql/cql_clause']
  tagName: 'span'
  
  events:
    rendered: -> 
      @$el.attr('data-ref-id', @element.ref_id) if @element.ref_id?
      @$el.attr('data-define-name', @element.define_name) if @element.define_name?
  
  initialize: ->
    if (@element.children)
      @children = []
      for child in @element.children
        @children.push(new Thorax.Views.CqlClauseView(element: child))
