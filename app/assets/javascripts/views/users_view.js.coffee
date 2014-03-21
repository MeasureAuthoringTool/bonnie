class Thorax.Views.Users extends Thorax.Views.BonnieView
  className: 'user-management'
  template: JST['users/users']

class Thorax.Views.User extends Thorax.Views.BonnieView
  template: JST['users/user']
  editTemplate: JST['users/edit_user']
  tagName: 'tr'

  context: ->
    _(super).extend
      isCurrentUser: bonnie.currentUserId == @model.get('_id')
      csrfToken: $("meta[name='csrf-token']").attr('content')

  events:
    serialize: (attr) ->
      attr.admin ?= false
      attr.portfolio ?= false
    rendered: ->
      @exportBundleView = new Thorax.Views.ExportBundleView() # Modal dialogs for exporting
      @exportBundleView.appendTo(@$el)

  approve: -> @model.approve()

  disable: -> @model.disable()

  bundle: ->
    @exportBundleView.exporting()
    $.fileDownload "#{@model.url()}/bundle",
      successCallback: => @exportBundleView.success()
      failCallback: => @exportBundleView.fail()


  edit: ->
    @$el.html(@renderTemplate(@editTemplate))
    @populate()

  save: ->
    @serialize()
    @model.save {}, success: => @$el.html(@renderTemplate(@template))

  cancel: -> @$el.html(@renderTemplate(@template))

  showDelete: -> @$('.delete-user').toggleClass('hide')

  delete: -> @model.destroy()
