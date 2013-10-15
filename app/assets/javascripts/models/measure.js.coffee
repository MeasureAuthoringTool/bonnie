class Thorax.Models.Measure extends Thorax.Model

class Thorax.Collections.Measures extends Thorax.Collection
  model: Thorax.Models.Measure

  collapsed: ->
    # FIXME: We could cache this; if we do, we need to pay attention to if measures are removed
    new Thorax.Collections.Measures(_(@toArray()).uniq (m) -> m.get('hqmf_id'))
