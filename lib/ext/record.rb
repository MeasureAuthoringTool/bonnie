# Extensions to the Record model in health-data-standards to add needed functionality for test patient generation
class Record
  field :type, type: String
  field :measure_ids, type: Array
  field :source_data_criteria, type: Array
  field :expected_values, type: Array
  field :notes, type: String
  field :is_shared, :type => Boolean
  field :origin_data, type: Array

  belongs_to :user
  scope :by_user, ->(user) { where({'user_id'=>user.id}) }
  scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where({'user_id'=>user.id, 'measure_ids'=>{'$in'=>[hqmf_set_id]} }) }
end
