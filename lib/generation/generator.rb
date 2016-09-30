module HQMF
  class Generator

    # Create a patient with trivial demographic information and no coded entries.
    #
    # @return A Record with a blank slate.
    def self.create_base_patient(initial_attributes = nil)
      patient = Record.new

      patient.gender = (Time.now.to_i % 2 == 0) ? ("M") : ("F")
      patient.birthdate = Randomizer.randomize_birthdate

      if initial_attributes.nil?
        patient = Randomizer.randomize_demographics(patient)
      else
        initial_attributes.each {|attribute, value| patient.send("#{attribute}=", value)}
      end

      patient
    end


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
