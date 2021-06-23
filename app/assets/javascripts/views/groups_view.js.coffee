class Thorax.Views.GroupsView extends Thorax.Views.BonnieView
  template: JST['users/groups']

  initialize: ->
    @userGroupTabs = new Thorax.Views.UserGroupTabs({activeTab: 'groups'})
    @groupSummaryView = new Thorax.View model: @collection.summary, template: JST['users/group_summary']
    @tableHeaderView = new Thorax.View model: @collection.summary, template: JST['users/group_table_header'], tagName: 'thead'

class Thorax.Views.GroupView extends Thorax.Views.BonnieView
  template: JST['users/group']
  tagName: 'tr'
