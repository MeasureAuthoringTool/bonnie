require 'test_helper'
require 'vcr_setup'

class PatientsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  setup do
    dump_database
    users_set = File.join("users", "base_set")
    collection_fixtures(users_set)
    @user = User.by_email('bonnie@example.com').first
    @user.init_personal_group
    @user.save

    load_measure_fixtures_from_folder(File.join("measures", "CMS134v6"), @user)
    @measure = CQM::Measure.where({"cms_id" => "CMS134v6"}).first
    sign_in @user

    qdm_data_element = {
      "dataElementCodes"=>[{"code"=>"M", "system"=>"2.16.840.1.113883.5.1", "display"=>"Male"}],
      "_id"=>"5ccb0c8857a11ed7a196dc9e",
      "qdmTitle"=>"Patient Characteristic Sex",
      "hqmfOid"=>"2.16.840.1.113883.10.20.28.4.55",
      "qdmCategory"=>"patient_characteristic",
      "qdmStatus"=>"gender",
      "qdmVersion"=>"5.4",
      "_type"=>"QDM::PatientCharacteristicSex",
      "codeListId"=>"2.16.840.1.113762.1.4.1",
      "description"=>"Patient Characteristic Sex: ONCAdministrativeSex",
      "id"=>{"qdmVersion"=>"5.4", "namingSystem"=>nil, "value"=>"5ccb0c8857a11ed7a196dc9e"}
    }
    qdm_patient = {
      'birthDatetime' => '1930-09-09',
      'qdmVersion' => '-1.3',
      'dataElements' => [qdm_data_element],
      'extendedData' => {'adverse_event' => 'ADVERSE EVENT', 'encounter' => 'ENCOUNTER', 'family_history' => 'MYSTERIOUS'}
    }
    @patient = { 'cqmPatient' => {
      'givenNames'=> ['Betty'],
      'providers'=>[],
      'familyName'=> 'Boop',
      'bundleId'=> 'F',
      'expectedValues' => ['true'],
      'notes'=> 'Boop-Oop-a-Doop',
      'qdmPatient' => qdm_patient,
      'measure_ids' => ["244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"],
      'group_id' => @user.current_group.id
    }}
  end

  test "create" do
    assert_equal 0, CQM::Patient.count

    post :create, params: @patient
    assert_response :success
    assert_equal 1, CQM::Patient.count
    r = CQM::Patient.first
    assert_equal "Betty", r.givenNames[0]
    assert_equal "Boop", r.familyName
    assert_equal "F", r.bundleId
    assert_equal '-1.3', r.qdmPatient.qdmVersion
    assert_equal '2.16.840.1.113883.10.20.28.4.55', r.qdmPatient.dataElements.first.hqmfOid
    assert_equal 1, r.expectedValues.length
    assert_equal 1, r.qdmPatient.dataElements.length
    json = JSON.parse(response.body)

    assert_equal "Betty", json["givenNames"][0]
    assert_equal "Boop", json["familyName"]
    assert_equal "F", json["bundleId"]
    assert_equal '-1.3', json["qdmPatient"]["qdmVersion"]
    assert_equal '2.16.840.1.113883.10.20.28.4.55', json["qdmPatient"]['dataElements'][0]['hqmfOid']
    assert_equal 1, json["expectedValues"].length
  end

  test "share patients" do
    patients_set = File.join('cqm_patients', 'CMS32v7')
    collection_fixtures(patients_set)
    associate_user_with_patients(@user,CQM::Patient.all)
    post :share_patients, params: {hqmf_set_id: "3FD13096-2C8F-40B5-9297-B714E8DE9133", selected: ["123456", "789012345"]}
    assert_response :redirect
    CQM::Patient.by_user(@user).all.each { |patient| assert_equal patient.measure_ids, ["123456", "789012345", "3FD13096-2C8F-40B5-9297-B714E8DE9133"]}
  end

  test "create patient for component measure of composite measure" do
    load_measure_fixtures_from_folder(File.join("measures", "CMS890_v5_6"), @user)
    assert_equal 0, CQM::Patient.count
    qdm_patient = {
      'birthDatetime' => '1930-09-09',
      'qdmVersion' => '-1.3',
      'extendedData' => {'adverse_event' => 'ADVERSE EVENT', 'encounter' => 'ENCOUNTER', 'family_history' => 'MYSTERIOUS'}
    }
    composite_patient = {'cqmPatient' => {
      'givenNames'=> ['Betty'],
      'familyName'=> 'Boop',
      'qdmPatient' => qdm_patient,
      'measure_ids' => ["244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&3000797E-11B1-4F62-A078-341A4002A11C"],
      'group_id' => @user.current_group.id}}

    expected_measure_ids = ["244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&3000797E-11B1-4F62-A078-341A4002A11C",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&920D5B27-DF5A-4770-BD60-FC4EE251C4D2",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&7B905B21-D904-454F-885B-9CE5D19674E3",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&BA108B7B-90B4-4692-B1D0-5DB554D2A1A2",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&5B20AFEA-D4AF-4F7A-A5A3-F1F6165B9E5F",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&F03324C2-9147-457B-BC34-811BB7859C91",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC&E22EA997-4EC1-4ED2-876C-3671099CB325",
                            "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"]
    post :create, params: composite_patient
    assert_response :success
    assert_equal 1, CQM::Patient.count
    patient = CQM::Patient.first
    assert_equal "Betty", patient.givenNames[0]
    assert_equal "Boop", patient.familyName
    assert_equal '-1.3', patient.qdmPatient.qdmVersion
    assert_equal expected_measure_ids.sort, patient.measure_ids.sort
  end

  test "update" do
    assert_equal 0, CQM::Patient.count
    patient = CQM::Patient.new
    patient.group = @user.current_group
    patient.save!
    assert_equal 1, CQM::Patient.count
    updated_patient = @patient
    updated_patient['_id'] = patient.id.to_s
    updated_patient['id'] = patient.id.to_s

    post :update, params: updated_patient
    assert_response :success
    assert_equal 1, CQM::Patient.count
    retrieved_patient = CQM::Patient.first
    assert_equal "Betty", retrieved_patient.givenNames[0]
    assert_equal "Boop", retrieved_patient.familyName
    assert_equal '-1.3', retrieved_patient.qdmPatient.qdmVersion
    assert_equal '2.16.840.1.113883.10.20.28.4.55', retrieved_patient.qdmPatient.dataElements.first.hqmfOid
    json = JSON.parse(response.body)

    assert_equal "Betty", json["givenNames"][0]
    assert_equal "Boop", json["familyName"]
    assert_equal '-1.3', json["qdmPatient"]["qdmVersion"]
    assert_equal '2.16.840.1.113883.10.20.28.4.55', json["qdmPatient"]['dataElements'][0]['hqmfOid']
  end

  test "destroy" do
    records_set = File.join("cqm_patients", "CMS134v6")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, CQM::Patient.all)
    patient = CQM::Patient.first
    assert_equal 3, @user.current_group.patients.count
    delete :destroy, params: {id: patient.id}
    assert_response :success
    assert_equal 2, @user.current_group.patients.count
    patient = CQM::Patient.where({id: patient.id}).first
    assert_nil patient
  end

  test "invalid patients" do
    assert_equal 0, CQM::Patient.count
    @patient['cqmPatient']['qdmPatient']['_type'] = 'QDMPatient'
    post :create, params: @patient
    assert_response :internal_server_error
    assert_equal 0, CQM::Patient.count

    @patient['cqmPatient']['qdmPatient'].delete('_type')
    post :create, params: @patient
    assert_response :success
    assert_equal 1, CQM::Patient.count

    updated_patient = @patient
    updated_patient['cqmPatient']['qdmPatient']['_type'] = 'QDMPatient'
    updated_patient['cqmPatient']['givenNames'] = ['These', 'are', 'not', 'real', 'names']
    updated_patient['_id'] = CQM::Patient.first._id.to_s
    updated_patient['id'] = CQM::Patient.first.id.to_s
    post :update, params: updated_patient
    assert_response :internal_server_error
    assert_equal 1, CQM::Patient.count
    assert_equal 1, CQM::Patient.first.givenNames.length
  end

  test "export patients as QRDA" do
    skip('QRDA Export not supported for QDM5.6')
    records_set = File.join("cqm_patients", "CMS134v6")
    collection_fixtures(records_set)
    associate_user_with_patients(@user, CQM::Patient.all)
    associate_measure_with_patients(@measure, CQM::Patient.all)
    get :qrda_export, params: {hqmf_set_id: @measure.hqmf_set_id, isCQL: 'true'}
    assert_response :success
    assert_equal 'application/zip', response.header['Content-Type']
    assert_equal "attachment; filename=\"#{@measure.cms_id}_patient_export.zip\"", response.header['Content-Disposition']
    assert_equal 'fileDownload=true; path=/', response.header['Set-Cookie']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']

    Dir.mkdir(Rails.root.join('tmp')) unless Dir.exist?(Rails.root.join('tmp'))
    zip_path = File.join('tmp', 'test.zip')
    File.open(zip_path, 'wb') {|file| response.body_parts.each { |part| file.write(part)}}
    Zip::ZipFile.open(zip_path) do |zip_file|
      assert_equal 3, zip_file.glob(File.join('qrda','**.xml')).length
      html_files = zip_file.glob(File.join('html', '**.html'))
      assert_equal 3, html_files.length
      html_files.each do |html_file| # search each HTML file to ensure alternate measure data is not included
        doc = Nokogiri::HTML(html_file.get_input_stream.read)
        xpath = "//b[contains(text(), 'SNOMED-CT:')]/i/span[@onmouseover and contains(text(), '417005')]"
        assert_equal 0, doc.xpath(xpath).length
      end
    end
    File.delete(zip_path)
  end

  test "excel export sheet names" do
    measure_hqmf_set_id = "AD9F4340-93FE-406E-BB86-2AE6A1CA3422"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'patient_details.json'))

    pop_details = [
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_10_char.json')),
        pop: "1 - Population"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_29_char.json')),
        pop: "Population 1"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_30_char.json')),
        pop: "Population 1"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_31_char.json')),
        pop: "Population 1"
      },
      {
        fixture: File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'population_details_title_32_char.json')),
        pop: "Population 1"
      }
    ]

    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'statement_details.json'))

    # Tests using different lengths of population titles.
    pop_details.each do |population_details|
      get :excel_export, params: {calc_results: calc_results, patient_details: patient_details, population_details: population_details[:fixture], statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id}
      assert_response :success
      assert_equal 'application/xlsx', response.header['Content-Type']
      assert_equal 'binary', response.header['Content-Transfer-Encoding']
      temp = Tempfile.new(["test", ".xlsx"])
      temp.write(response.body)
      temp.rewind()
      doc = Roo::Spreadsheet.open(temp.path)
      sheet1 = doc.sheet(population_details[:pop])

      assert !sheet1.nil?

      temp.close()
      temp.unlink()
    end
  end

  test "Excel export composite measure" do
    measure_hqmf_set_id = "244B4F52-C9CA-45AA-8BDB-2F005DA05BFC"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'composite_excel', 'statement_details.json'))

    get :excel_export, params: {calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id}
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)

    sheet = doc.sheet("1 - Population Criteria Section")
    if sheet.row(3)[9] == "doe"
      jon_doe_row = sheet.row(3)
      jane_smith_row = sheet.row(4)
    else
      jon_doe_row = sheet.row(4)
      jane_smith_row = sheet.row(3)
    end

    assert_equal "\nKEY\n", doc.sheet("KEY").row(1)[0]
    expected_rows = JSON.parse(File.read(File.join(Rails.root, "test", "fixtures", "expected_excel_results","CMS321v0_shared_patients_composite.json")))
    # There was a change in how Roo parses "FALSE", but it does not affect the actual excel export.
    jon_doe_row[12] = "FALSE" if jon_doe_row[12] == false
    jane_smith_row[12] = "FALSE" if jane_smith_row[12] == false

    assert_equal expected_rows["jon_doe_row"], jon_doe_row
    assert_equal expected_rows["jane_smith_row"], jane_smith_row

    temp.close()
    temp.unlink()
  end

  test "Excel export fields check" do
    measure_hqmf_set_id = "442F4F7E-3C22-4641-9BEE-0E968CC38EF2"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'excel_fields_check', 'statement_details.json'))

    get :excel_export, params: {calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id}
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)

    key_sheet = doc.sheet("KEY")
    assert_equal "\nKEY\n", key_sheet.row(1)[0]
    assert_equal "Interval", key_sheet.row(7)[0]
    assert_equal "INTERVAL: start value - end value", key_sheet.row(7)[1]
    assert_equal "INTERVAL: 11/20/2010 - 11/20/2012 or INTERVAL: 1 - 4", key_sheet.row(7)[2]

    sheet1 = doc.sheet("1 - Population Criteria Section")

    row2 = sheet1.row(2)
    assert_equal "IPP", row2[0]
    assert_equal "DENOM", row2[1]
    assert_equal "notes", row2[8]
    assert_equal "last", row2[9]
    assert_equal "first", row2[10]

    row3 = sheet1.row(3)
    assert_equal 0.0, row3[0]
    assert_equal "test2", row3[8]
    assert_equal "last_a", row3[9]
    assert_equal "first_a", row3[10]
    assert_equal "02/02/2011", row3[11]
    # The actual export will show "TRUE", but roo now shows true
    row3[12] = "TRUE" if row3[12] == true
    assert_equal "TRUE", row3[12]
    assert_equal "10/05/2017", row3[13]
    assert_equal "Not Hispanic or Latino", row3[14]
    assert_equal "Asian", row3[15]
    assert_equal "M", row3[16]

    row4 = sheet1.row(4)
    assert_equal 0.0, row4[0]
    assert_equal "test1", row4[8]
    assert_equal "last_b", row4[9]
    assert_equal "first_b", row4[10]
    assert_equal "03/04/1971", row4[11]
    # The actual export will show "FALSE", but roo now shows false
    row4[12] = "FALSE" if row4[12] == false
    assert_equal "FALSE", row4[12]
    assert_nil row4[13]
    assert_equal "Not Hispanic or Latino", row4[14]
    assert_equal "American Indian or Alaska Native", row4[15]
    assert_equal "M", row4[16]

    temp.close()
    temp.unlink()
  end

  test "Excel export cv measures" do
    measure_hqmf_set_id = "28AC347D-2F91-4A0C-9395-2602134BAA89"
    calc_results = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'calc_results.json'))
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'statement_details.json'))

    get :excel_export, params: {calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id}
    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)
    sheet1 = doc.sheet("1 - Population Criteria Section")

    row2 = sheet1.row(2)
    assert_equal "OBSERV", row2[2]
    assert_equal "OBSERV", row2[6]

    #Ensure that observe equal each other as they should
    row3 = sheet1.row(3)
    assert_equal "[115]", row3[2]
    assert_equal "[115]", row3[6]

    #Ensure that observ [nil] equals observ [nil] properly
    s1_r4 = sheet1.row(4)
    assert_equal "[nil]", s1_r4[2]
    assert_equal "[nil]", s1_r4[6]

    #Ensure that patients whose expected observ is nil evaluate correctly when value is []
    sheet3 = doc.sheet("3 - Stratification 2")
    s3_r4 = sheet3.row(4)
    assert_equal "[]", s3_r4[3]
    assert_equal "[]", s3_r4[8]

    temp.close()
    temp.unlink()
  end

  test "Excel export no results tests" do
    measure_hqmf_set_id = "28AC347D-2F91-4A0C-9395-2602134BAA89"
    patient_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'patient_details.json'))
    population_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'population_details.json'))
    statement_details = File.read(File.join(Rails.root, 'test', 'fixtures', 'functional', 'patient_controller', 'continuous_variable', 'statement_details.json'))
    calc_results = {}.to_json
    get :excel_export, params: {calc_results: calc_results, patient_details: patient_details, population_details: population_details, statement_details: statement_details, file_name: "test", measure_hqmf_set_id: measure_hqmf_set_id}

    assert_response :success
    assert_equal 'application/xlsx', response.header['Content-Type']
    assert_equal 'binary', response.header['Content-Transfer-Encoding']
    temp = Tempfile.new(["test", ".xlsx"])
    temp.write(response.body)
    temp.rewind()
    doc = Roo::Spreadsheet.open(temp.path)

    # Check we only get the error sheet and that it is as expected
    assert_equal 1, doc.sheets.length
    assert_equal "Error", doc.sheets[0]
    assert_equal "Measure has no patients, please re-export with patients", doc.sheet(0).row(1)[0]

    temp.close()
    temp.unlink()
  end

  test 'convert_patients success' do
    patient_hash = JSON.parse File.read(File.join(Rails.root, 'test/fixtures/patient_conversion/qdm_test_patient_to_convert.json'))
    patient = CQM::Patient.new(patient_hash[0])
    patient.group = @user.current_group
    patient.save!
    assert_equal 1, CQM::Patient.count

    vcr_options = {match_requests_on: [:method, :uri_no_st]}
    VCR.use_cassette('patient_conversion_service_success', vcr_options) do
      # convert patient
      post :convert_patients, params: { hqmf_set_id: 'AA2A4BBC-864F-45EE-B17A-7EBCC62E6AAC'}
      assert_response :success
      assert_equal response.content_type, 'application/zip'
      assert_not_nil response.body
    end
  end

  test 'convert_patients:RestException' do
    patient_hash = JSON.parse File.read(File.join(Rails.root, 'test/fixtures/patient_conversion/qdm_test_patient_to_convert.json'))
    patient = CQM::Patient.new(patient_hash[0])
    patient.group = @user.current_group
    patient.save!
    assert_equal 1, CQM::Patient.count

    vcr_options = {match_requests_on: [:method, :uri_no_st]}
    VCR.use_cassette('patient_conversion_service_rest_exception', vcr_options) do
      # convert patient
      begin
        post :convert_patients, params: { hqmf_set_id: 'AA2A4BBC-864F-45EE-B17A-7EBCC62E6AAC'}
      rescue StandardError => e
        assert_equal e.message, 'Problem with the rest call to the conversion microservice: 400 Bad Request.'
      end
    end
  end

  test 'json_export success' do
    measure = CQM::Measure.new
    measure.hqmf_set_id = 'AA2A4BBC-864F-45EE-B17A-7EBCC62E6AAC'
    measure.group = @user.current_group
    measure.population_criteria = {}
    measure.save!

    patient_hash = JSON.parse File.read(File.join(Rails.root, 'test/fixtures/patient_conversion/qdm_test_patient_to_convert.json'))
    patient = CQM::Patient.new(patient_hash[0])
    patient.group = @user.current_group
    patient.measure_ids = [ @measure.hqmf_set_id ]
    patient.save!
    assert_equal 1, CQM::Patient.count

    post :json_export, params: {hqmf_set_id: 'AA2A4BBC-864F-45EE-B17A-7EBCC62E6AAC'}
    assert_response :success
    assert_equal response.content_type, 'application/zip'
    assert_not_nil response.body
  end

  test 'import json patients rejects non zip files' do
    assert_equal 0, CQM::Patient.all.count

    import_file = fixture_file_upload('test/fixtures/patient_import/patients_430FFC53-4122-4421-88CC-2EDD8117BB3C_QDM_56_1633717655_meta.json', 'application/json')
    post :json_import, params: { patient_import_file: import_file, measure_id: 'measure_123', hqmf_set_id: 'set_id_123'}

    assert_equal flash[:error][:title], 'Error Importing Patients'
    assert_equal flash[:error][:summary], 'Import Patients file must be in a zip file.'

    assert_equal 0, CQM::Patient.all.count
  end

  test 'import json patients rejects missing patients json' do
    assert_equal 0, CQM::Patient.all.count

    import_file = fixture_file_upload('test/fixtures/patient_import/patients_QDM_56_missing_patients.zip', 'application/zip')
    post :json_import, params: { patient_import_file: import_file, measure_id: @measure.id, hqmf_set_id: @measure.hqmf_set_id}

    assert_equal 'Unable to Import Patients', flash[:error][:summary]

    assert_equal 0, CQM::Patient.all.count
  end

  test 'import json patients rejects missing meta json' do
    assert_equal 0, CQM::Patient.all.count

    import_file = fixture_file_upload('test/fixtures/patient_import/patients_QDM_56_missing_meta.zip','application/zip')

    post :json_import, params: { patient_import_file: import_file, measure_id: @measure.id, hqmf_set_id: @measure.hqmf_set_id}

    assert_not_nil flash
    assert_equal 'Unable to Import Patients', flash[:error][:summary]
    assert_equal 0, CQM::Patient.all.count
  end

  test 'import json patients success with matching populations' do
    assert_equal 0, CQM::Patient.all.count
    load_measure_fixtures_from_folder(File.join("measures", "CMS135v10"), @user)
    measure = CQM::Measure.where({"cms_id" => "CMS135v10"}).first
    import_file = fixture_file_upload('test/fixtures/patient_import/patients_430FFC53-4122-4421-88CC-2EDD8117BB3C_QDM_56_1633717655.zip', 'application/zip')

    post :json_import, params: { patient_import_file: import_file, measure_id: measure.id, hqmf_set_id: measure.hqmf_set_id}

    assert_not_nil flash
    assert_equal 'QDM PATIENT IMPORT COMPLETED', flash[:msg][:title]

    assert_equal 123, CQM::Patient.all.count
    assert_equal 123, CQM::Patient.where(:expectedValues.not => {"$size"=>0}).size
  end

  test 'import json patients success with different populations' do
    measure = CQM::Measure.new
    measure.hqmf_set_id = 'AA2A4BBC-864F-45EE-B17A-7EBCC62E6AAC'
    measure.group = @user.current_group
    measure.population_criteria = {}
    measure.save!

    patient_hash = JSON.parse File.read(File.join(Rails.root, 'test/fixtures/patient_conversion/qdm_test_patient_to_convert.json'))
    patient = CQM::Patient.new(patient_hash[0])
    patient.group = @user.current_group
    patient.measure_ids = [ @measure.hqmf_set_id ]
    patient.save!
    assert_equal 1, CQM::Patient.count

    import_file = fixture_file_upload('test/fixtures/patient_import/patients_430FFC53-4122-4421-88CC-2EDD8117BB3C_QDM_56_1633717655.zip', 'application/zip')

    post :json_import, params: { patient_import_file: import_file, measure_id: measure.id, hqmf_set_id: measure.hqmf_set_id}

    assert_not_nil flash
    assert_equal 'QDM PATIENT IMPORT COMPLETED', flash[:msg][:title]
    assert flash[:msg][:body].include?('Due to mismatching populations, the Expected Values have been cleared from imported patients.')

    assert_equal 124, CQM::Patient.count
    assert_equal 123, CQM::Patient.where(:expectedValues => {"$size"=>0}).size # The 123 imported patients
  end

  test 'delete all patients' do

    assert_equal 0, CQM::Patient.count

    measure = CQM::Measure.new
    measure.hqmf_set_id = 'AA2A4BBC-864F-45EE-B17A-7EBCC62E6AAC'
    measure.group = @user.current_group
    measure.population_criteria = {}
    measure.save!

    patients = ['61699b94b7b4da7e338e2215', '6169a5663598f039f4a9c86e']

    patient_hash = JSON.parse File.read(File.join(Rails.root, 'test/fixtures/patient_conversion/qdm_test_patient_to_convert.json'))
    patient = CQM::Patient.new(patient_hash[0])
    patient.id = BSON::ObjectId.from_string(patients[0])
    patient.group = @user.current_group
    patient.measure_ids = [ measure.hqmf_set_id ]
    patient.save!
    assert_equal 1, CQM::Patient.count

    patient = CQM::Patient.new(patient_hash[0])
    patient.id = BSON::ObjectId.from_string(patients[1])
    patient.group = @user.current_group
    patient.measure_ids = [ measure.hqmf_set_id ]
    patient.save!
    assert_equal 2, CQM::Patient.count

    post :delete_all_patients, params: { patients: patients, hqmf_set_id: measure.hqmf_set_id}

    assert_not_nil flash
    assert_equal 'Success', flash[:msg][:title]
    assert flash[:msg][:body].include?('2 patients have been successfully deleted.')

    assert_equal 0, CQM::Patient.count
  end

end
