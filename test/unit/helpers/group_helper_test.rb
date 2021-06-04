require 'test_helper'

class CqlToElmHelperTest < ActiveSupport::TestCase
  test 'verify personal group only' do
    groups = []
    groups << Group.new(:name => "personal", :is_personal => true)

    sorted_groups = sort_groups(groups)
    assert_equal 1, sorted_groups.length
  end
end


