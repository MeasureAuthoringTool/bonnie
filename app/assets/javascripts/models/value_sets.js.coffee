class Thorax.Collections.ValueSetsCollection extends Thorax.Collection
  comparator: (vs) -> vs.get('display_name').toLowerCase()

  whiteList: ->
    @select (vs) -> _(vs.get('concepts')).any (c) -> c.white_list

  blackList: ->
    @select (vs) -> _(vs.get('concepts')).any (c) -> c.black_list

  measureToOids: (measures) ->
    measureToOids = {} # measure hqmf_set_id : valueSet oid
    measures.each (m) =>
      measureToOids[m.get('hqmf_set_id')] = m.valueSets().pluck('oid')
    measureToOids

  patientToOids: (patients) ->
    patientToOids = {} # patient medical_record_number : valueSet oid
    patients.each (p) =>
      patientToOids[p.get('medical_record_number')] = p.get('source_data_criteria').pluck('oid')
    patientToOids

  patientToSdc: (patients) ->
    patientToSdc = {} # patient medical_record_number : source_data_criteria
    patients.each (p) =>
      patientToSdc[p.get('medical_record_number')] = p.get('source_data_criteria').models
    patientToSdc