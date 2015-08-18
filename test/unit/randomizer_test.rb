require 'test_helper'

class RandomizerTest < ActiveSupport::TestCase

  setup do

  end

  test "randomize patient demographics" do
  	p = Record.new
    HQMF::Randomizer.randomize_demographics(p)

    assert !p.first.nil?
    assert !p.last.nil?
    assert !p.gender.nil?
    assert !p.languages.nil?
    assert_equal 1, p.languages.length
    assert !p.race.nil?
    assert_includes p.race.keys, 'code'
    assert_includes p.race.keys, 'code_set'
    assert_equal 2, p.race.keys.length
    assert_equal 2, p.race.values.length
    assert !p.ethnicity.nil?
    assert_includes p.ethnicity.keys, 'code'
    assert_includes p.ethnicity.keys, 'code_set'
    assert_equal 2, p.ethnicity.keys.length
    assert_equal 2, p.ethnicity.values.length
    assert !p.medical_record_number.nil?
    assert !p.addresses.nil?
    assert_equal 1, p.addresses.length
    assert !p.birthdate.nil?

    p2 = p.dup
    HQMF::Randomizer.randomize_demographics(p2)

    assert_equal p2.first, p.first
    assert_equal p2.last, p.last
    assert_equal p2.gender, p.gender
    assert_equal 1, p2.languages.length
    assert_equal p2.race['code'], p.race['code']
    assert_equal p2.ethnicity['code'], p.ethnicity['code']
    # assert_equal p2.medical_record_number, p.medical_record_number
    assert_equal 1, p2.addresses.length
    assert_equal p2.birthdate, p.birthdate

  end

  test "randomize gender" do
    assert_equal 'M', HQMF::Randomizer.randomize_gender(100)
    assert_equal 'F', HQMF::Randomizer.randomize_gender(900)
  end

  test 'randomize language' do
    (800...999).each do |percent|
      assert !HQMF::Randomizer.randomize_language(percent).nil?
    end
  end
  test 'randomize race/ethnicity' do
    (0...999).step(10) do |percent|
      assert !HQMF::Randomizer.randomize_race_and_ethnicity(percent).nil?
    end
  end

end
