require 'test_helper'

class UsersControllerTest  < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    dump_database
    records_set = File.join("records", "base_set")
    users_set = File.join("users", "base_set")
    measures_set = File.join("draft_measures", "base_set")
    collection_fixtures(users_set, records_set, measures_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_measures(@user, Measure.all)
    associate_user_with_patients(@user, Record.all)

    @user.measures.first.value_set_oids.uniq.each do |oid|
      vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
      vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:'bar')
      vs.user = @user
      vs.save!
    end

  end

  test "bundle download" do
    # we need to show downloading bundles is currently is removed
    assert_raises(ActionController::RoutingError) do
      get '/users/bundle'
    end
  end

end
