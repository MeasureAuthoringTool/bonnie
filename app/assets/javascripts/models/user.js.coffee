class Thorax.Models.User extends Thorax.Model
  idAttribute: '_id'
  approve: -> $.ajax(url: "#{@url()}/approve", type: "POST").done((data) => @set(data)).fail(-> bonnie.showError({title: "Failed to approve user", summary: 'There was an error approving the user.'}))
  disable: -> $.ajax(url: "#{@url()}/disable", type: "POST").done((data) => @set(data)).fail(-> bonnie.showError({title: "Failed to disable user", summary: 'There was an error disabling the user.'}))

class Thorax.Collections.Users extends Thorax.Collection
  url: '/admin/users'
  model: Thorax.Models.User
  comparators:
    'approved': (u) -> [ u.get('approved'), u.get('email') ]
    'email': 'email'
    'measure_count': (u) -> parseInt(u.get('measure_count')) * -1 # -1 reverses
    'patient_count': (u) -> parseInt(u.get('patient_count')) * -1 # -1 reverses

  initialize: ->
    @setComparator('approved')
    @summary = new Thorax.Model
    @on 'change add reset destroy remove', @updateSummary, this
    @updateSummary()

  updateSummary: ->
    activeUsers = new Thorax.Collection(@filter((u) -> u.get('measure_count')))
    @summary.set
      totalUsers: @length
      totalMeasures: @reduce(((sum, user) -> sum + user.get('measure_count')), 0)
      totalPatients: @reduce(((sum, user) -> sum + user.get('patient_count')), 0)
      activeUsers: activeUsers
      activeMeasuresCount: activeUsers.reduce(((sum, user) -> sum + user.get('measure_count')), 0)
      activeMeasuresMax: _.max(activeUsers.pluck('measure_count'))
      activePatientsCount: activeUsers.reduce(((sum, user) -> sum + user.get('patient_count')), 0)
      activePatientsMax: _.max(activeUsers.pluck('patient_count'))
      topTenPatientCounts: _((new Thorax.Collection(@models, comparator: (u) -> parseInt(u.get('patient_count')) * -1 )).sort().pluck('patient_count')).first(10)

  setComparator: (key) ->
    @comparator = @comparators[key]
    @
