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

    def save_self_and_child_docs()
      self.save!
      self.package.save! if self.package.present?
      self.value_sets.each{ |vs| vs.save! }
    end

    def associate_self_and_child_docs_to_user(user)
      self.user = user
      self.package.user = user if self.package.present?
      self.value_sets.each{ |vs| vs.user = user }
    end

    # note that this method doesn't change the _id of embedded documents, but that should be fine
    def get_fresh_duplicate()
      m2 = dup_and_remove_user(self)
      m2.package = dup_and_remove_user(self.package) if self.package.present?
      m2.value_sets = self.value_sets.map{ |vs| dup_and_remove_user(vs) }
      return m2
    end

    def delete_self_and_child_docs()
      self.package.delete if self.package.present?
      self.value_sets.each{ |vs| vs.delete }
      self.delete
    end

    def destroy_self_and_child_docs()
      self.package.destroy if self.package.present?
      self.value_sets.each{ |vs| vs.destroy }
      self.destroy
    end

    private

    def dup_and_remove_user(mongoid_doc)
      new_doc = mongoid_doc.dup
      new_doc.user = nil
      return new_doc
    end
    
  end
end