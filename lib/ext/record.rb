# Extensions to the Record model in health-data-standards to add needed functionality for test patient generation
class Record
  field :type, type: String
  field :measure_ids, type: Array
  field :source_data_criteria, type: Array
  field :expected_values, type: Hash

  belongs_to :user
  scope :by_user, ->(user) { where({'user_id'=>user.id}) }
end