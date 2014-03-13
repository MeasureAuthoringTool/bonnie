require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Creating user creates bundle" do
    dump_database
    assert_equal 0, User.count
    assert_equal 0, HealthDataStandards::CQM::Bundle.count
    u = User.new(email: "test@test.com", first: "first" , last: 'last',password: 'Test1234!') 
    u.save
    assert_equal 1, User.count
    assert_equal 1, HealthDataStandards::CQM::Bundle.count
    assert_equal User.first.bundle , HealthDataStandards::CQM::Bundle.first
  end
end
