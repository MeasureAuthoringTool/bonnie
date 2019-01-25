module CQM
  # Measure contains the information necessary to represent the CQL version of a Clinical Quality Measure,
  # As needed by the Bonnie & Cypress applications
  class Measure
    belongs_to :user
    scope :by_user, ->(user) { where user_id: user.id }
    index 'user_id' => 1
    # Find the measures matching a patient
    def self.for_patient(record)
      where user_id: record.user_id, hqmf_set_id: { '$in' => record.measure_ids }
    end
    
  end
end