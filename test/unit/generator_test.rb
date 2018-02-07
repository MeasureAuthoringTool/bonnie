require 'test_helper'

class GeneratorTest < ActiveSupport::TestCase

  setup do

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
