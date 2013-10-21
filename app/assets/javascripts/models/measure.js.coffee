class Thorax.Collections.Measures extends Thorax.Collection
  model: Thorax.Models.Measure

  collapsed: ->
    # FIXME: We could cache this; if we do, we need to pay attention to if measures are removed
    new Thorax.Collections.Measures(_(@toArray()).uniq (m) -> m.get('hqmf_id'))

class Thorax.Models.Measure extends Thorax.Model
  parse: (attrs) ->
    sourceDataCriteria = new Thorax.Collections.DataCriteria
    for key, criteria of attrs.source_data_criteria
      sourceDataCriteria.add criteria
    attrs.source_data_criteria = sourceDataCriteria
    attrs