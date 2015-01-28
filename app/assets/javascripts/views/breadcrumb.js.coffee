class Thorax.Views.Breadcrumb extends Thorax.Views.BonnieView

  clear: -> @$el.empty()

  setup: (title, measure, patient) ->
    @addMeasurePeriod()
    if measure?
      @addMeasure(measure)
      if title is "patient builder" and patient?
        @addPatient(patient)
      else if title is "patient bank"
        @addBank()

  addMeasurePeriod: ->
    @$el.append "<li><a href='/#'><i class='fa fa-fw fa-clock-o' aria-hidden='true'></i> Measure Period: #{bonnie.measurePeriod}</a></li>"

  addMeasure: (measure) ->
    @$el.append "<li><a href='#measures/#{measure.get('hqmf_set_id')}'><i class='fa fa-fw fa-tasks' aria-hidden='true'></i> #{measure.get('cms_id')}</a></li>"

  addPatient: (patient) ->
    patient_name = if patient.get('first') then "#{patient.get('last')} #{patient.get('first')}" else "Create new patient"
    @$el.append "<li><i class='fa fa-fw fa-user' aria-hidden='true'></i> #{patient_name}</li>"

  addBank: ->
    @$el.append "<li><i class='fa fa-fw fa-group' aria-hidden='true'></i> Import patients from the patient bank</li>"
