class Thorax.Views.RecordEntry extends Thorax.View
  template: JST['patients/record_entry']
  getDescription: -> @entry.description
  # FIXME: Migrate hqmf decoding
  getCodes: -> 
    codes = []
    if @entry.codes
      for code, value of @entry.codes
        codes.push("#{code}: #{value}")
    codes
  # FIXME: Default value should be UNK, but can't pass in params via templates...
  getTime: (nil_string='present') -> 
    if @entry.start_time? or @entry.end_time?
      start_string = if @entry.start_time? then new Date(@entry.start_time * 1000) else nil_string
      end_string = if @entry.end_time? then new Date(@entry.end_time * 1000) else nil_string
      "#{start_string} - #{end_string}"
    else if @entry.time? then new Date(@entry.time * 1000)
  getStatus: ->
    Thorax.Models.Patient.templateOidMap[@entry.oid]?['status']
  getResults: ->
    results = []
    if @entry.values?
      for value in @entry.values
        if value.scalar?
          scalar = value.scalar
          if value.units?
            scalar += " #{value.units}"
          results.push(scalar)
        else if value.codes?
          for system, vals of value.codes
            results.push("#{system}: " + vals.join(',') + " (#{value.description})")
        else results.push('UNKNOWN VALUE')
    results
  getFields: ->
    fields = []
    field_keys = (key for key, value of @entry when key not in ['codes', 'time', 'description', 'mood_code', 'values', '_id', '_type', 'start_time', 'end_time', 'status_code', 'negationInd', 'oid'])
    field_values = (@entry[key] for key in field_keys) if field_keys?
    # FIXME: Handle case where field_value is a hash
    for key in field_keys
      fields.push("#{key} : #{field_values[key]}") if field_values[key]?
    fields