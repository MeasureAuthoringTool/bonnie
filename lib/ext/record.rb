class Record
  belongs_to :measure
  field :source_data_criteria, :type => Array
  
  scope :belongs_to_measure, ->(measure_id) { where('measures' => measure_id) }
end
