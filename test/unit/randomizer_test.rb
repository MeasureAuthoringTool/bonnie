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
    p.languages.length.must_equal 1
    assert !p.race.nil?
    p.race.keys.must_include 'code'
    p.race.keys.must_include 'code_set'
    p.race.keys.length.must_equal 2
    p.race.values.length.must_equal 2
    assert !p.ethnicity.nil?
    p.ethnicity.keys.must_include 'code'
    p.ethnicity.keys.must_include 'code_set'
    p.ethnicity.keys.length.must_equal 2
    p.ethnicity.values.length.must_equal 2
    assert !p.medical_record_number.nil?
    assert !p.addresses.nil?
    p.addresses.length.must_equal 1
    assert !p.birthdate.nil?

    p2 = p.dup
    HQMF::Randomizer.randomize_demographics(p2)

    p.first.must_equal p2.first
    p.last.must_equal p2.last
    p.gender.must_equal p2.gender
    p2.languages.length.must_equal 1
    p.race['code'].must_equal p2.race['code']
    p.ethnicity['code'].must_equal p2.ethnicity['code']
    p.medical_record_number.must_equal p2.medical_record_number
    p2.addresses.length.must_equal 1
    p.birthdate.must_equal p2.birthdate

  end

  test "randomize gender" do
    HQMF::Randomizer.randomize_gender(100).must_equal 'M'
    HQMF::Randomizer.randomize_gender(900).must_equal 'F'
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