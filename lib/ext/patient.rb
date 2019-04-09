module CQM
  class Patient
    belongs_to :user
    scope :by_user, ->(user) { where({'user_id'=>user.id}) }
    scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where({ 'user_id' => user.id, 'measure_ids' => hqmf_set_id }) }

    has_and_belongs_to_many :measures, class_name: 'CQM::Measure'
  end
end