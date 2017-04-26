class Thorax.Views.CqlClauseView extends Thorax.View
  template: JST['cql/cql_clause']
  tagName: 'span'
  
  initialize: (element)-> 
    if (element.children)
      @children = []
      for child in element.children
        @children.push(new Thorax.Views.CqlClauseView(child))
    else
      @text = element.text
      @define_name = element.define_name