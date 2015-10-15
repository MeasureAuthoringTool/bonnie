require 'test_helper'

class PopulationsControllerTest  < ActionController::TestCase
  include Devise::TestHelpers
      
  setup do
    dump_database
    collection_fixtures("users", "draft_measures")
    @user = User.by_email('bonnie@example.com').first
    
    associate_user_with_measures(@user,Measure.all)

    @user.measures.each do |measure|
      measure.value_set_oids.uniq.each_with_index do |oid|
        vs = HealthDataStandards::SVS::ValueSet.new(oid: oid)
        (0..10).each do |index|
          vs.concepts << HealthDataStandards::SVS::Concept.new(code_set: 'foo', code:"bar_#{index}")
        end
        vs.save!
        measure.bonnie_hashes.push(vs.bonnie_version_hash)
      end
    end
    sign_in @user
  end

  test "get population javascript" do
    measure = Measure.all.first
    measure.map_fns = []
    measure.save!
    get :calculate_code, {measure_id: measure.id, id: 0, format: :js}
    assert_response :success
    assert_operator response.body.length, :>, 100
    assert response.body.starts_with? "(function()"
  end

end
