module CQM
  # Measure contains the information necessary to represent the CQL version of a Clinical Quality Measure,
  # As needed by the Bonnie & Cypress applications
  class Measure
    belongs_to :user
    scope :by_user, ->(user) { where user_id: user.id }
    index 'user_id' => 1
    index 'user_id' => 1, 'hqmf_set_id' => 1
    has_and_belongs_to_many :patients, class_name: 'CQM::Patient'
    # Find the measures matching a patient
    def self.for_patient(record)
      where user_id: record.user_id, hqmf_set_id: { '$in' => record.measure_ids }
    end

    def save_self_and_child_docs
      save!
      package.save! if package.present?
      value_sets.each(&:save!)
    end

    def associate_self_and_child_docs_to_user(user)
      self.user = user
      package.user = user if package.present?
      value_sets.each { |vs| vs.user = user }
    end

    # note that this method doesn't change the _id of embedded documents, but that should be fine
    def make_fresh_duplicate
      m2 = dup_and_remove_user(self)
      m2.package = dup_and_remove_user(package) if package.present?
      m2.value_sets = value_sets.map { |vs| dup_and_remove_user(vs) }
      return m2
    end

    def delete_self_and_child_docs
      package.delete if package.present?
      value_sets.each(&:delete)
      delete
    end

    def destroy_self_and_child_docs
      package.destroy if package.present?
      value_sets.each(&:destroy)
      destroy
    end

    private

    def dup_and_remove_user(mongoid_doc)
      new_doc = mongoid_doc.dup
      new_doc.user = nil
      return new_doc
    end
    
  end

  class PopulationSet
    def bonnie_result_criteria_names
      criteria = populations.as_json.keys
      criteria << 'OBSERV' if observations.present?
      return CQM::Measure::ALL_POPULATION_CODES & criteria # do this last to ensure ordering
    end
  end

  class Stratification
    def bonnie_result_criteria_names
      criteria = population_set.bonnie_result_criteria_names + ['STRAT']
      return CQM::Measure::ALL_POPULATION_CODES & criteria # do this last to ensure ordering
    end
  end
end
