module HQMF
  class Generator

    # Map all patient api coded entry types from HQMF data criteria to Record sections.
    #
    # @param [String] type The type of the coded entry required by a data criteria.
    # @return The section type for the given patient api function type
    def self.classify_entry(type)
      # The possible matches per patientAPI function can be found in hqmf-parser's README
      case type
      when :allProcedures
        "procedures"
      when :proceduresPerformed
        "procedures"
      when :procedureResults
        "procedures"
      when :laboratoryTests
        "vital_signs"
      when :allMedications
        "medications"
      when :activeDiagnoses
        "conditions"
      when :inactiveDiagnoses
        "conditions"
      when :resolvedDiagnoses
        "conditions"
      when :allProblems
        "conditions"
      when :allDevices
        "medical_equipment"
      when :careGoals
        "care_goals"
      when :communications
        "communications"
      when :family_history
        "family_history"
      when :careExperiences
        "care_experiences"
      when :adverseEvents
        "adverse_events"
      when :allergiesIntolerances
        "allergies_intolerances"
      else
        type.to_s
      end
    end

  end
end
