class Thorax.Views.RecordSection extends Thorax.View  
  template: JST['patients/record_section']
  initialize: ->
    @entries = @model.get(@section) if @section? 
  render: ->
    _(super).extend
    for entry in @entries
      entryView = new Thorax.Views.RecordEntry(model: @model, section: @section, entry: entry)
      entryView.render()
      @$("#" + @section).append(entryView.$el.html())
    @
  capitalize: (str) ->
    str.charAt(0).toUpperCase() + str.slice(1) if str?
  getSection: ->
    @capitalize(@section)