## All filter implementations should have an #apply(patient) method that returns true/false.

class Thorax.Models.MeasureAuthorFilter extends Thorax.Model
  additionalRequirements: {name: 'email', text: 'E-mail address', type: 'text'}
  initialize: (@email) -> @regexp = new RegExp(@email, "i")
  apply: (patient) -> !!patient.get('user_email')?.match(@regexp)
  label: -> "User contains #{@email}"

class Thorax.Models.MeasureFilter extends Thorax.Model
  additionalRequirements: {name: 'cms_id', text: 'CMS ID', type: 'text'}
  initialize: (@cmsId) -> @regexp = new RegExp(@cmsId, "i")
  apply: (patient) -> !!patient.get('cms_id')?.match(@regexp)
  label: -> "Measure contains #{@cmsId}"

class Thorax.Models.PopulationsFilter extends Thorax.Model
  # TODO determine if this needs tweaking for CV measures
  initialize: (@criteria, @population) ->

  apply: (patient) ->
    calculation = @population.calculate(patient)
    result = calculation.get @criteria
    if result? then result # if it calculates true, return the patient

  label: ->
    if @population.get('title') then "#{@population.get('title')}: #{@criteria} " else "#{@criteria}"
