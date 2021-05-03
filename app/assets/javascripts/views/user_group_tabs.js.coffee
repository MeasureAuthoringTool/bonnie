class Thorax.Views.UserGroupTabs extends Thorax.Views.BonnieView

  template: JST['user_group_tabs']

  initialize: ->
    @isUsersActive = @activeTab == 'users'
    @isGroupsActive = @activeTab == 'groups'

