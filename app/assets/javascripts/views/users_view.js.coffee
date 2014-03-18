class Thorax.Views.Users extends Thorax.View
  className: 'user-management'
  template: JST['users/users']

class Thorax.Views.User extends Thorax.View
  template: JST['users/user']
  editTemplate: JST['users/edit_user']
  tagName: 'tr'

  context: ->
    _(super).extend isCurrentUser: bonnie.currentUserId == @model.get('_id')

  events:
    serialize: (attr) ->
      attr.admin ?= false
      attr.portfolio ?= false
  
  approve: -> @model.approve()

  disable: -> @model.disable()

  edit: ->
    @$el.html(@renderTemplate(@editTemplate))
    @populate()

  save: ->
    @serialize()
    @model.save {}, success: => @$el.html(@renderTemplate(@template))

  cancel: -> @$el.html(@renderTemplate(@template))

  showDelete: -> @$('.delete-user').toggleClass('hide')

  delete: -> @model.destroy()
