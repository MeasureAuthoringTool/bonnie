require 'test_helper'

class GroupHelperTest < ActiveSupport::TestCase
  setup do
    @groups = [
      Group.new(:name => "personal", :is_personal => true),
      Group.new(:name => "SemanticBits"), # not specifying is_personal will default to false
      Group.new(:name => "bravo"),
      Group.new(:name => "CMS")
    ]
  end

  test 'verify no external groups' do
    sorted_groups = GroupHelper.sort_groups([@groups[0]])
    assert_equal 1, sorted_groups.length
    assert_equal sorted_groups[0].name, 'personal'
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
    assert_equal 4, sorted_groups.length
    assert_equal 'personal', sorted_groups[0].name
    assert_equal 'bravo', sorted_groups[1].name
    assert_equal 'CMS', sorted_groups[2].name
    assert_equal 'SemanticBits', sorted_groups[3].name
  end

  test 'verify empty array' do
    sorted_groups = GroupHelper.sort_groups([])
    assert_equal 0, sorted_groups.length
  end
end



