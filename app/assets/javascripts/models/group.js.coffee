class Thorax.Models.Group extends Thorax.Model
  idAttribute: '_id'

class Thorax.Collections.Groups extends Thorax.Collection
  url: '/admin/groups'
  model: Thorax.Models.Group

  initialize: ->
    @summary = new Thorax.Model
    @on 'reset', @updateSummary

  updateSummary: ->
    @summary.set
      totalGroups: @length
      totalMeasures: @reduce(((sum, group) -> sum + group.get('measure_count')), 0)
      totalPatients: @reduce(((sum, group) -> sum + group.get('patient_count')), 0)
