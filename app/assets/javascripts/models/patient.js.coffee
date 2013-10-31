class Thorax.Models.Patient extends Thorax.Model
  idAttribute: '_id'
  urlRoot: '/patients'

  parse: (attrs) ->
    dataCriteria = _(attrs.source_data_criteria).reject (c) -> c.id is 'MeasurePeriod'
    attrs.source_data_criteria = new Thorax.Collections.PatientDataCriteria(dataCriteria, parse: true)
    attrs

  getBirthDate: -> new Date(@attributes.birthdate)

  getPayerName: -> @attributes.insurance_providers[0].name

  getValidMeasureIds: (measures) ->
    validIds = {}
    @attributes.measure_ids.map (m) ->
      validIds[m] = {key: m, value: _.contains(measures.pluck('id'), m)}
    validIds

  getEntrySections: (sections) ->
    entrySections = []
    p = @
    for s in sections
      if p.attributes[s]?
        entrySections.push(s) if s?
    entrySections

  ### Patient HTML Header values ###
  getGender: -> 
    if @attributes.gender == 'M'
      "Male"
    else
      "Female"

  getBirthdate: ->
    fullDate = new Date(@attributes.birthdate)
    fullDate.getMonth() + '/' + fullDate.getDay() + '/' + fullDate.getYear()

  getExpirationDate: ->
    if @attributes.expired
      fullDate = new Date(@attributes.deathdate)
      fullDate.getMonth() + '/' + fullDate.getDay() + '/' + fullDate.getYear()
    else ""

  getRace: ->
    unless @attributes.race? then "Unknown"
    else unless @attributes.race.name? then ("CDC-RE: " + @attributes.race.code)
    else @attributes.race.name

  getEthnicity: ->
    unless @attributes.ethnicity? then "Unknown"
    else unless @attributes.ethnicity.name? then "CDC-RE: " + @attributes.ethnicity.code
    else @attributes.ethnicity.name

  getInsurance: ->
    insurances = @attributes.insurance_providers.map (ip) ->
      ip.name
    insurances.join(", ")

  getAddresses: ->
    address = ""
    if @attributes.addresses
      for addr in @attributes.addresses
        addr.street.each (street) ->
          address += street + "\n"
        address += addr.city + ", " + addr.state + ", " + addr.zip + "\n"
        if addr.use
          address += addr.use + "\n"
    if @attributes.telecoms
      for telecom in @attributes.telecoms
        address += telecom.value + "\n"
        if telecom.use
          address += telecom.use + "\n"

class Thorax.Collections.Patients extends Thorax.Collection
  model: Thorax.Models.Patient