class Thorax.Collections.Population extends Thorax.Collection
  model: Thorax.Models.Population

class Thorax.Models.Population extends Thorax.Model
  initialize: ->
    sub_ids = (String.fromCharCode(idx) for idx in [97..122])
    @set 'sub_id', sub_ids[@attributes.index]
