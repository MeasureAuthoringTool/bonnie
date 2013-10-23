class Thorax.Views.PatientHtmlSection extends Thorax.View
  
  template: JST['patients/patient_html_section']

  initialize: ->
    @entries = @model.attributes[@section] if @section? 

  render: ->
    _(super).extend
    for entry in @entries
      entryView = new Thorax.Views.PatientHtmlEntry(model: @model, section: @section, entry: entry, idMap: @idMap)
      entryView.render()
      @$("#" + @section).append(entryView.$el.html())
    @

  capitalize: (str) ->
    str.charAt(0).toUpperCase() + str.slice(1) if str?

  getSection: ->
    @capitalize(@section)