require 'test_helper'
require 'vcr_setup.rb'

class BonnieDbTest < ActiveSupport::TestCase
include ActionDispatch::TestProcess
include ActionController::TestCase
  setup do
    dump_database

    records_set = File.join("records", "CMS347v1")
    users_set = File.join("users", "base_set")
    cql_measures_set_1 = File.join("cql_measures", "CMS347v1")
    cql_measures_set_2 = File.join("cql_measures", "CMS160v6")
    cql_measures_set_3 = File.join("cql_measures", "CMS72v5")
    collection_fixtures(users_set, records_set)
    add_collection(cql_measures_set_1)
    add_collection(cql_measures_set_2)
    add_collection(cql_measures_set_3)

    @email = 'bonnie@example.com'
    @hqmf_set_id_1 = '5375D6A9-203B-4FFF-B851-AFA9B68D2AC2'
    @hqmf_set_id_2 = '93F3479F-75D8-4731-9A3F-B7749D8BCD37'
    @hqmf_set_id_3 = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'

    @user = User.by_email('bonnie@example.com').first

    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_1))
    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_2))
    associate_user_with_measures(@user, CqlMeasure.where(hqmf_set_id: @hqmf_set_id_3))
    # these patients are already associated with the source measure in the json file
    associate_user_with_patients(@source_user, Record.all)
  end

  test "resave measures" do
    measure_1 = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_1).first
    measure_2 = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_2).first
    measure_w_no_user = CqlMeasure.where(hqmf_set_id: @hqmf_set_id_3).first
    measure_w_no_user.user = nil
    measure_w_no_user.save!

    assert_output(
                  "Re-saving \"#{measure_1.title}\" [bonnie@example.com]\n" +
                  "Re-saving \"#{measure_w_no_user.title}\" [deleted user]\n" +
                  "Re-saving \"#{measure_2.title}\" [bonnie@example.com]\n"
                 ) { Rake::Task['bonnie:db:resave_measures'].execute }
  end

  test "successfully dump database" do
    path = Rails.root.join 'db', 'backups'
    if !Dir.exist?(path)
      Dir.mkdir(path)
    end
    original_number = Dir.entries(path).size
    Rake::Task['bonnie:db:dump'].execute
    assert_equal original_number + 1, Dir.entries(path).size
  end
  
  test "download_measure_package bad environment variables" do
    # Bad email
    ENV['EMAIL'] = 'asdf@example.com'
    ENV['CMS_ID'] = 'CMS160v6'
    ENV['HQMF_SET_ID'] = @hqmf_set_id_2
    
    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tasdf@example.com not found\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # Bad hqmf_set_id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = '93F3479F-75D8-4731-9A3F-B7749D8Bzzzz'
    
    assert_output("\e[#{31}m#{"[Error]"}\e[0m\t\tmeasure with HQFM set id 93F3479F-75D8-4731-9A3F-B7749D8Bzzzz not found for account bonnie@example.com\n") { Rake::Task['bonnie:db:download_measure_package'].execute }
    
    # Bad cms_id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = nil
    ENV['CMS_ID'] = 'something'
    
    assert_output("\e[31m[Error]\e[0m\t\tbonnie@example.com: something: not found\n" + 
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tmeasure with CMS id something not found for account bonnie@example.com\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # No cms id or hqmf set id variables
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = nil
    ENV['CMS_ID'] = nil
    
    assert_output("\e[31m[Error]\e[0m\t\tExpected CMS_ID or HQMF_SET_ID environment variables\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

  end
  
  
  test "download_measure_package" do
    
    # check no package from fixture with hqmf set id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = @hqmf_set_id_2
    
    assert_output("\e[32m[Success]\e[0m\tbonnie@example.com: measure with HQMF set id 93F3479F-75D8-4731-9A3F-B7749D8BCD37 found\n" + 
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tNo package found for this measure.\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # check no package from fixture with hqmf set id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = nil
    ENV['CMS_ID'] = 'CMS160v6'
    
    assert_output("\e[32m[Success]\e[0m\tbonnie@example.com: CMS160v6: found\n" +
                  "\e[#{31}m#{"[Error]"}\e[0m\t\tNo package found for this measure.\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # check package exists for uploaded package

    # upload the package
    VCR.use_cassette("mat_5_4_valid_vsac_response") do
      # Use VSAC creds from VCR, see vcr_setup.rb
      measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'Test134_v5_4_Artifacts.zip'), 'application/xml')

      # If you need to re-record the cassette for whatever reason, change the vsac_date to the current date
      post :create, {vsac_date: '08/31/2017', include_draft: true, measure_file: measure_file, measure_type: 'ep', calculation_type: 'patient', vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD']}

      assert_response :redirect
      measure = CqlMeasure.where({hqmf_set_id: "7B2A9277-43DA-4D99-9BEE-6AC271A07747"}).first
      assert_equal "40280582-5C27-8179-015C-308B1F99003B", measure['hqmf_id']
    end
    
    # access the package with hqmf_set_id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = @hqmf_set_id_2

    assert_output("\e[32m[Success]\e[0m\tbonnie@example.com: measure with HQMF set id 93F3479F-75D8-4731-9A3F-B7749D8BCD37 found\n" + 
                  "\e[32m[Success]\e[0m\tSuccessfully wrote #{measure.cms_id}_#{email}_#{measure.package.created_at.to_date.to_s}.zip\n") { Rake::Task['bonnie:db:download_measure_package'].execute }
  end

end
