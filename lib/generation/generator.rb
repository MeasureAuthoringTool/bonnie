module HQMF
	class Generator

    # Create a patient with trivial demographic information and no coded entries.
    #
    # @return A Record with a blank slate.
    def self.create_base_patient(initial_attributes = nil)
      patient = Record.new
      
      patient.gender = (Time.now.to_i % 2 == 0) ? ("M") : ("F")
      patient.birthdate = Randomizer.randomize_birthdate(patient)

      if initial_attributes.nil?
        patient = Randomizer.randomize_demographics(patient)
      else
        initial_attributes.each {|attribute, value| patient.send("#{attribute}=", value)}
      end
      
      patient
    end

	end
end