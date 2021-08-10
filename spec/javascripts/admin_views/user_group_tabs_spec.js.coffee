describe 'UserGroupTabs', ->
  it 'initializes UserGroupTabs', ->
    tabsView = new Thorax.Views.UserGroupTabs(activeTab: 'users')
    tabsView.render()
    expect(tabsView.$('li.active a > span').text()).toEqual 'Users'

    tabsView = new Thorax.Views.UserGroupTabs(activeTab: 'groups')
    tabsView.render()
    expect(tabsView.$('li.active a > span').text()).toEqual 'Groups'
