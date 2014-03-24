require 'test_helper'

class GeneratorTest < ActiveSupport::TestCase

  setup do

  end

  test "create base patient" do

    p = HQMF::Generator.create_base_patient

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

    p = HQMF::Generator.create_base_patient({first: 'John', last: 'Smith'})

    p.first.must_equal 'John'
    p.last.must_equal 'Smith'
    assert !p.gender.nil?
    assert !p.birthdate.nil?

  end

  test "validate classify entry" do
    HQMF::Generator.classify_entry(:allProcedures).must_equal "procedures"
    HQMF::Generator.classify_entry(:proceduresPerformed).must_equal "procedures"
    HQMF::Generator.classify_entry(:procedureResults).must_equal "procedures"
    HQMF::Generator.classify_entry(:laboratoryTests).must_equal "vital_signs"
    HQMF::Generator.classify_entry(:allMedications).must_equal "medications"
    HQMF::Generator.classify_entry(:activeDiagnoses).must_equal "conditions"
    HQMF::Generator.classify_entry(:inactiveDiagnoses).must_equal "conditions"
    HQMF::Generator.classify_entry(:resolvedDiagnoses).must_equal "conditions"
    HQMF::Generator.classify_entry(:allProblems).must_equal "conditions"
    HQMF::Generator.classify_entry(:allDevices).must_equal "medical_equipment"

    HQMF::Generator.classify_entry(:conditions).must_equal "conditions"
    HQMF::Generator.classify_entry(:encounters).must_equal "encounters"
  end


end