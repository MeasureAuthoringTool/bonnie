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

  setComparator: (key) ->
    @comparator = @comparators[key]
    @
