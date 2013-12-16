class Thorax.Models.Patient extends Thorax.Model
  idAttribute: '_id'
  urlRoot: '/patients'
  
  parse: (attrs) ->
    dataCriteria = _(attrs.source_data_criteria).reject (c) -> c.id is 'MeasurePeriod'
    attrs.source_data_criteria = new Thorax.Collections.PatientDataCriteria(dataCriteria, parse: true)

    attrs.expected_values = new Thorax.Collections.ExpectedValues(attrs.expected_values)

    # This section is a bit unusual: we map from server side values to a more straight forward client
    # side representation; the reverse mapping would usually happen in toJSON(), but in this case it
    # happens on the server in the controller
    attrs.ethnicity = attrs.ethnicity?.code
    attrs.race = attrs.race?.code
    attrs.payer = insurance_providers?[0]?.type || 'OT'

    attrs

  # Create a deep clone of the patient, optionally omitting the id field
  deepClone: (options = {}) ->
    # Clone by fully serializing and de-derializing; we need to stringify to have recursive JSONification happen
    data = if options.omit_id then _(@toJSON()).omit('_id') else @toJSON() # Don't use @omit in case toJSON is overwritten
    json = JSON.stringify data
    new @constructor JSON.parse(json), parse: true

  getBirthDate: -> new Date(@get('birthdate'))
  getPayerName: -> @get('insurance_providers')[0].name
  getValidMeasureIds: (measures) ->
    validIds = {}
    @get('measure_ids').map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('hqmf_set_id'), m)}
    validIds
  getEntrySections: ->
    s for s in Thorax.Models.Patient.sections when @has(s)
  ### Patient HTML Header values ###
  getGender: -> 
    if @get('gender') == 'M'
      "Male"
    else
      "Female"
  getBirthdate: -> @printDate @get('birthdate')
  getExpirationDate: -> if @get('expired') then @printDate(@get('deathdate')) else ''
  getRace: ->
    unless @get('race')? then "Unknown"
    else unless @get('race').name? then "CDC-RE: #{@get('race').code}"
    else @get('race').name
  getEthnicity: ->
    unless @get('ethnicity')? then "Unknown"
    else unless @get('ethnicity').name? then "CDC-RE: #{@get('ethnicity').code}"
    else @get('ethnicity').name
  getInsurance: ->
    insurances = @get('insurance_providers')?map (ip) ->
      ip.name
    insurances?join(", ")
    unless insurances? then ''
  getAddresses: ->
    address = ""
    if @get('addresses')
      for addr in @get('addresses')
        for street in addr.street
          address += street + "\n"
        address += addr.city + ", " + addr.state + ", " + addr.zip + "\n"
        if addr.use
          address += addr.use + "\n"
    if @get('telecoms')
      for telecom in @get('telecoms')
        address += telecom.value + "\n"
        if telecom.use
          address += telecom.use + "\n"
  printDate: (date) ->
    fullDate = new Date(date * 1000)
    (fullDate.getMonth() + 1) + '/' + fullDate.getDay() + '/' + fullDate.getYear()

  materialize: ->
    $.ajax
      url:         "#{@urlRoot}/materialize"
      type:        'POST'
      dataType:    'json'
      contentType: 'application/json'
      data:        JSON.stringify @toJSON()
      processData: false
    .done (data) =>
      # We only want to overwrite certain fields; if the server doesn't provide them, we want them emptied
      defaults = conditions: [], encounters: [], medications: [], procedures: []
      @set _(data).chain().pick('conditions', 'encounters', 'medications', 'procedures').defaults(defaults).value(), silent: true
      @trigger 'materialize' # We use a new event rather than relying on 'change' because we don't want to automatically re-render everything

  getExpectedValue: (population) ->
    measure = population.collection.parent
    expectedValue = @get('expected_values').findWhere(measure_id: measure.get('hqmf_set_id'), population_index: population.index())
    unless expectedValue
      expectedValue = new Thorax.Models.ExpectedValue measure_id: measure.get('hqmf_set_id'), population_index: population.index()
      @get('expected_values').add expectedValue
    for populationCriteria in Thorax.Models.Measure.allPopulationCodes when population.has populationCriteria
      expectedValue.set populationCriteria, 0 unless expectedValue.has populationCriteria
    expectedValue

  getExpectedValues: (measure) ->
    expectedValues = new Thorax.Collections.ExpectedValues()
    measure.get('populations').each (population) =>
      expectedValues.add @getExpectedValue(population)
    expectedValues

class Thorax.Collections.Patients extends Thorax.Collection
  model: Thorax.Models.Patient