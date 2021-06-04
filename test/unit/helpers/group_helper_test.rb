require 'test_helper'

class CqlToElmHelperTest < ActiveSupport::TestCase
  setup do
    @groups = [
      Group.new(:name => "Personal", :is_personal => true),
      Group.new(:name => "SemanticBits"),
      Group.new(:name => "CMS")
    ]
  end

  test 'verify no external groups' do
    sorted_groups = GroupHelper.sort_groups([@groups[0]])
    assert_equal 1, sorted_groups.length
    assert_equal sorted_groups[0].name, 'Personal'
    assert_equal true, sorted_groups[0].is_personal
  end

  test 'verify no internal groups' do
    sorted_groups = GroupHelper.sort_groups([@groups[1]])
    assert_equal 1, sorted_groups.length
    assert_equal 'SemanticBits', sorted_groups[0].name
    assert_equal false, sorted_groups[0].is_personal
  end

  test 'verify group sorting' do
    sorted_groups = GroupHelper.sort_groups(@groups)
    assert_equal 3, sorted_groups.length
    assert_equal 'Personal', sorted_groups[0].name
    assert_equal 'CMS', sorted_groups[1].name
    assert_equal 'SemanticBits', sorted_groups[2].name
  end
end



