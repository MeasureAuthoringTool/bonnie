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
    assert !p.medical_record_assigner.nil?
    assert !p.addresses.nil?
    assert_equal 1, p.addresses.length
    assert !p.birthdate.nil?

    p2 = HQMF::Generator.create_base_patient({first: 'John', last: 'Smith'})

    assert_equal 'John', p2.first
    assert_equal 'Smith', p2.last
    assert !p2.gender.nil?
    assert !p2.birthdate.nil?
    assert_not_equal p.medical_record_number, p2.medical_record_number  # Should differ each time generated

  end

  test "validate classify entry" do
    assert_equal "procedures", HQMF::Generator.classify_entry(:allProcedures)
    assert_equal "procedures", HQMF::Generator.classify_entry(:proceduresPerformed)
    assert_equal "procedures", HQMF::Generator.classify_entry(:procedureResults)
    assert_equal "vital_signs", HQMF::Generator.classify_entry(:laboratoryTests)
    assert_equal "medications", HQMF::Generator.classify_entry(:allMedications)
    assert_equal "conditions", HQMF::Generator.classify_entry(:activeDiagnoses)
    assert_equal "conditions", HQMF::Generator.classify_entry(:inactiveDiagnoses)
    assert_equal "conditions", HQMF::Generator.classify_entry(:resolvedDiagnoses)
    assert_equal "conditions", HQMF::Generator.classify_entry(:allProblems)
    assert_equal "medical_equipment", HQMF::Generator.classify_entry(:allDevices)
    assert_equal "care_goals", HQMF::Generator.classify_entry(:careGoals)
    assert_equal "family_history", HQMF::Generator.classify_entry(:family_history)
    assert_equal "care_experiences", HQMF::Generator.classify_entry(:careExperiences)


    assert_equal "conditions", HQMF::Generator.classify_entry(:conditions)
    assert_equal "encounters", HQMF::Generator.classify_entry(:encounters)
  end


end
