class Thorax.Views.GroupsView extends Thorax.Views.BonnieView
  className: 'group-management'
  template: JST['users/groups']

  initialize: ->
    @userGroupTabs = new Thorax.Views.UserGroupTabs({activeTab: 'groups'})
    @groupSummaryView = new Thorax.View model: @collection.summary, template: JST['users/group_summary']
    @tableHeaderView = new Thorax.View model: @collection.summary, template: JST['users/group_table_header'], tagName: 'thead'

class Thorax.Views.GroupView extends Thorax.Views.BonnieView
  template: JST['users/group']
  tagName: 'tr'

  # Get the users for a group and display in popup
  edit: ->
    view = this
    $.ajax
      url: "admin/users/users_by_group?id=#{@model.get('_id')}"
      type: 'GET'
      success: (data) ->
        view.model.set users: data
        editDialog = new Thorax.Views.GroupEditDialog(model: view.model)
        editDialog.appendTo($('#bonnie'))
        editDialog.display()
