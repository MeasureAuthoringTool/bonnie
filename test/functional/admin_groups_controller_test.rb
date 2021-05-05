require 'test_helper'

module Admin
  class GroupsControllerTest < ActionController::TestCase
    include Devise::Test::ControllerHelpers

    setup do
      dump_database
      patients_set = File.join('cqm_patients', 'CMS903v0')
      users_set = File.join('users', 'base_set')
      collection_fixtures(users_set, patients_set)
      @user = User.by_email('bonnie@example.com').first
      @user.init_personal_group
      @user.save

      @user_admin = User.by_email('user_admin@example.com').first
      @user_admin.init_personal_group
      @user_admin.save

      @user_plain = User.by_email('user_plain@example.com').first
      @user_plain.init_personal_group
      @user_plain.save

      # public group associated with user
      sb = Group.new(name: 'SB')
      sb.save!
      @user.groups << sb
      @user.current_group = sb
      @user.save!

      # public group not associated with user
      cms = Group.new(name: 'CMS')
      cms.save

      load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
      associate_user_with_patients(@user, CQM::Patient.all)
    end

    test "access groups page as a non admin" do
      sign_in @user_plain
      not_authorized = assert_raises(RuntimeError) do
        get :index, as: :json
      end
      assert_equal "User #{@user_plain.email} requesting resource requiring admin access", not_authorized.message
    end

    test "access groups page as an admin user" do
      sign_in @user_admin
      get :index, as: :json
      assert_response :success
      index_json = JSON.parse(response.body)
      # only public groups
      assert_equal 2, index_json.count

      # No measures for CMS public group
      assert_equal 'CMS', index_json[0]['name']
      assert_equal 0, index_json[0]['measure_count']
      assert_equal 0, index_json[0]['patient_count']

      # a measure and 4 patients for SB public group
      assert_equal 'SB', index_json[1]['name']
      assert_equal 1, index_json[1]['measure_count']
      assert_equal 4, index_json[1]['patient_count']
    end
  end
end
