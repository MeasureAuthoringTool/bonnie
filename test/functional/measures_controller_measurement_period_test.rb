require 'test_helper'
require 'vcr_setup.rb'

class MeasuresControllerMeasurementPeriodTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  tests MeasuresController

  setup do
    @error_dir = File.join('log', 'load_errors')
    FileUtils.rm_r @error_dir if File.directory?(@error_dir)
    dump_database
    users_set = File.join('users', 'base_set')
    patients_set = File.join('cqm_patients', 'CMS903v0')
    load_measure_fixtures_from_folder(File.join('measures', 'CMS160v6'), @user)
    collection_fixtures(users_set, patients_set)
    @user = User.by_email('bonnie@example.com').first
    associate_user_with_patients(@user, CQM::Patient.all)
    sign_in @user

    @vcr_options = {match_requests_on: [:method, :uri_no_st]}
  end

  test 'update measurement period' do
    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
    measure = CQM::Measure.where({cms_id: 'CMS903v0'}).first
    measure_id = measure.id
    assert_equal '2012', measure.measure_period['low']['value'].slice(0,4)
    post :measurement_period, params: {
      year: '1984',
      id: measure.id.to_s,
      measurement_period_shift_dates: 'true'
    }
    measure = CQM::Measure.where(id: measure_id).first
    assert_equal '1984', measure.measure_period['low']['value'].slice(0,4)
    patient = CQM::Patient.by_user(@user).first
    assert_equal 1966, patient.qdmPatient.birthDatetime.year
    assert_equal 1984, patient.qdmPatient.dataElements.first.authorDatetime.year
    assert_equal 1984, patient.qdmPatient.dataElements.first.relevantPeriod.high.year
  end

  test 'update measurement period without updating patients' do
    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
    measure = CQM::Measure.where({cms_id: 'CMS903v0'}).first
    measure_id = measure.id
    assert_equal '2012', measure.measure_period['low']['value'].slice(0,4)
    post :measurement_period, params: {
      year: '1984',
      id: measure.id.to_s,
      measurement_period_shift_dates: nil
    }
    measure = CQM::Measure.where(id: measure_id).first
    assert_equal '1984', measure.measure_period['low']['value'].slice(0,4)
    patient = CQM::Patient.by_user(@user).first
    assert_equal 1994, patient.qdmPatient.birthDatetime.year
    assert_equal 2012, patient.qdmPatient.dataElements.first.authorDatetime.year
    assert_equal 2012, patient.qdmPatient.dataElements.first.relevantPeriod.high.year
  end

  test 'data element goes outside of date range after conversion and fails' do
    load_measure_fixtures_from_folder(File.join('measures', 'CMS903v0'), @user)
    measure = CQM::Measure.where({cms_id: 'CMS903v0'}).first
    measure_id = measure.id
    assert_equal '2012', measure.measure_period['low']['value'].slice(0,4)
    patient = CQM::Patient.by_user(@user).first
    # lower the authordatetime year so that when the measurement period is
    # shift this date will cause a RangeError
    patient.qdmPatient.dataElements.first.authorDatetime.change(year: 1972)
    patient.save!
    post :measurement_period, params: {
      year: '0003',
      id: measure.id.to_s,
      measurement_period_shift_dates: 'true'
    }
    # All patients should be failing because of their birthDatetime
    body_text = 'Element(s) on '
    CQM::Patient.by_user(@user).all.each { |p| body_text += p.givenNames[0] + ' ' + p.familyName + ', ' }
    body_text += 'could not be shifted. Please make sure shift will keep all years between 1 and 9999'
    assert_equal 'Error Updating Measurement Period', flash[:error][:title]
    assert_equal 'Error Updating Measurement Period', flash[:error][:summary]
    assert_equal body_text, flash[:error][:body]
    measure = CQM::Measure.where(id: measure_id).first
    assert_equal '2012', measure.measure_period['low']['value'].slice(0,4)
    patient = CQM::Patient.by_user(@user).first
    assert_equal 1994, patient.qdmPatient.birthDatetime.year
    assert_equal 2012, patient.qdmPatient.dataElements.first.authorDatetime.year
    assert_equal 2012, patient.qdmPatient.dataElements.first.relevantPeriod.high.year
  end

  test 'update measurement period float' do
    check_invalid_year('19.1')
  end

  test 'update measurement period not 4 digits' do
    check_invalid_year('999')
  end

  test 'update measurement period not year too low' do
    check_invalid_year('0000')
  end

  test 'update measurement period not year too high' do
    check_invalid_year('10000')
  end

  def check_invalid_year(year)
    measure = CQM::Measure.first
    assert_equal '2012', measure.measure_period['low']['value'].slice(0,4)
    post :measurement_period, params: {
      year: year,
      id: measure.id.to_s,
      measurement_period_shift_dates: 'true'
    }
    assert_equal 'Error Updating Measurement Period', flash[:error][:title]
    assert_equal 'Error Updating Measurement Period', flash[:error][:summary]
    assert_equal 'Invalid year selected. Year must be 4 digits and between 1 and 9999', flash[:error][:body]
  end
end
