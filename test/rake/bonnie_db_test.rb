require 'test_helper'
require 'vcr_setup.rb'

class BonnieDbTest < ActiveSupport::TestCase
  setup do
    dump_database

    patients_set = File.join('cqm_patients', 'CMS903v0')
    users_set = File.join('users', 'base_set')
    collection_fixtures(users_set, patients_set)
    @email = 'bonnie@example.com'
    @user = User.by_email('bonnie@example.com').first

    @hqmf_set_id_1 = '4DC3E7AA-8777-4749-A1E4-37E942036076'
    @hqmf_set_id_2 = 'A4B9763C-847E-4E02-BB7E-ACC596E90E2C'
    @hqmf_set_id_3 = '848D09DE-7E6B-43C4-BEDD-5A2957CCFFE3'
    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
    load_measure_fixtures_from_folder(File.join('measures', 'CMS160v6'), @user)
    load_measure_fixtures_from_folder(File.join('measures', 'CMS177v6'), @user)
    CQM::Measure.where(hqmf_set_id: @hqmf_set_id_1).first.package.delete

    # these patients are already associated with the source measure in the json file
    associate_user_with_patients(@user, CQM::Patient.all)
  end

  test "resave measures" do
    measure_1 = CQM::Measure.where(hqmf_set_id: @hqmf_set_id_1).first
    measure_2 = CQM::Measure.where(hqmf_set_id: @hqmf_set_id_2).first
    measure_w_no_user = CQM::Measure.where(hqmf_set_id: @hqmf_set_id_3).first
    measure_w_no_user.user = nil
    measure_w_no_user.save!

    assert_output(
      "Re-saving \"#{measure_1.title}\" [bonnie@example.com]\n" +
      "Re-saving \"#{measure_2.title}\" [bonnie@example.com]\n" +
      "Re-saving \"#{measure_w_no_user.title}\" [deleted user]\n"
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

  test 'download_measure_package bad environment variables' do
    # Bad email
    ENV['EMAIL'] = 'asdf@example.com'
    ENV['CMS_ID'] = 'CMS160v6'
    ENV['HQMF_SET_ID'] = @hqmf_set_id_3

    assert_output("\e[31m[Error]\e[0m\t\tasdf@example.com not found\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # Bad hqmf_set_id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = 'A4B9763C-847E-4E02-BB7E-ACC596E9zzzz'

    assert_output("\e[31m[Error]\e[0m\t\tmeasure with HQFM set id A4B9763C-847E-4E02-BB7E-ACC596E9zzzz not found for account bonnie@example.com\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # Bad cms_id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = nil
    ENV['CMS_ID'] = 'something'

    assert_output("\e[31m[Error]\e[0m\t\tbonnie@example.com: something: not found\n" \
                  "\e[31m[Error]\e[0m\t\tmeasure with CMS id something not found for account bonnie@example.com\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # No cms id or hqmf set id variables
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = nil
    ENV['CMS_ID'] = nil

    assert_output("\e[31m[Error]\e[0m\t\tExpected CMS_ID or HQMF_SET_ID environment variables\n") { Rake::Task['bonnie:db:download_measure_package'].execute }
  end

  test 'download_measure_package' do
    # check no package from fixture with hqmf set id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = @hqmf_set_id_1

    assert_output("\e[32m[Success]\e[0m\tbonnie@example.com: measure with HQMF set id 4DC3E7AA-8777-4749-A1E4-37E942036076 found\n" \
                  "\e[31m[Error]\e[0m\t\tNo package found for this measure.\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # check no package from fixture with hqmf set id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = nil
    ENV['CMS_ID'] = 'CMS903v0'

    assert_output("\e[32m[Success]\e[0m\tbonnie@example.com: CMS903v0: found\n" \
                  "\e[31m[Error]\e[0m\t\tNo package found for this measure.\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    # check package exists for uploaded package

    # access the package with hqmf_set_id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = @hqmf_set_id_2
    ENV['CMS_ID'] = nil

    assert_output("\e[32m[Success]\e[0m\tbonnie@example.com: measure with HQMF set id A4B9763C-847E-4E02-BB7E-ACC596E90E2C found\n" \
                  "\e[32m[Success]\e[0m\tSuccessfully wrote CMS160v6_bonnie@example.com_2019-07-11.zip\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    assert(File.exist?('CMS160v6_bonnie@example.com_2019-07-11.zip'))
    file_content = File.binread('CMS160v6_bonnie@example.com_2019-07-11.zip')
    measure = CQM::Measure.find_by(hqmf_set_id: @hqmf_set_id_2)
    assert_equal(measure.package.file.data, file_content)
    File.delete('CMS160v6_bonnie@example.com_2019-07-11.zip')

    # access the package with cms_id
    ENV['EMAIL'] = @email
    ENV['HQMF_SET_ID'] = nil
    ENV['CMS_ID'] = 'CMS160v6'

    assert_output("\e[32m[Success]\e[0m\tbonnie@example.com: CMS160v6: found\n" \
                  "\e[32m[Success]\e[0m\tSuccessfully wrote CMS160v6_bonnie@example.com_2019-07-11.zip\n") { Rake::Task['bonnie:db:download_measure_package'].execute }

    assert(File.exist?('CMS160v6_bonnie@example.com_2019-07-11.zip'))
    file_content = File.binread('CMS160v6_bonnie@example.com_2019-07-11.zip')
    measure = CQM::Measure.find_by(cms_id: 'CMS160v6')
    assert_equal(measure.package.file.data, file_content)
    File.delete('CMS160v6_bonnie@example.com_2019-07-11.zip')
  end
end
