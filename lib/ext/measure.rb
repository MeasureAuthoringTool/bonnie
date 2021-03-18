module CQM
  # Measure contains the information necessary to represent the CQL version of a Clinical Quality Measure,
  # As needed by the Bonnie & Cypress applications
  class Measure
    belongs_to :group, optional: true
    scope :by_user, ->(user) { where group_id: user.current_group.id }
    index 'group_id' => 1
    index 'group_id' => 1, 'set_id' => 1
    has_and_belongs_to_many :patients, class_name: 'CQM::Patient'
    # Find the measures matching a patient
    def self.for_patient(record)
      where group_id: record.group_id, set_id: { '$in' => record.measure_ids }
    end

    # note that this method doesn't change the _id of embedded documents, but that should be fine
    def make_fresh_duplicate
      m2 = dup_and_remove_user(self)
      m2.value_sets = value_sets.map { |vs| dup_and_remove_user(vs) }
      m2
    end

    private

    def dup_and_remove_user(mongoid_doc)
      new_doc = mongoid_doc.dup
      new_doc.group = nil
      new_doc
    end

  end

  class PopulationSet
    def bonnie_result_criteria_names
      criteria = populations.as_json.keys
      criteria << 'OBSERV' if observations.present?
      CQM::Measure::ALL_POPULATION_CODES & criteria # do this last to ensure ordering
    end
  end

  class Stratification
    def bonnie_result_criteria_names
      criteria = population_set.bonnie_result_criteria_names + ['STRAT']
      CQM::Measure::ALL_POPULATION_CODES & criteria # do this last to ensure ordering
    end
  end
end
