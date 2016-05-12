class ArchivedMeasure
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic
  
  store_in collection: 'archived_measures'
  
  field :id, type: String
  field :hqmf_id, type: String # should be using this one as primary id!!
  field :hqmf_set_id, type: String
  field :measure_db_id, type: BSON::ObjectId
  
  field :uploaded_at, type: Time
  
  field :measure_hash, type: Hash
  
  belongs_to :user
  
  index "user_id" => 1
  index "measure_db_id" => 1
  
  scope :by_measure_db_id, ->(id) { where({'measure_db_id'=>id }) }
  scope :by_user, ->(user) { where({'user_id'=>user.id}) }
  scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where({'user_id'=>user.id, 'hqmf_set_id'=>hqmf_set_id}) }
  
  def self.from_measure(measure)
    arch_measure = ArchivedMeasure.new
    arch_measure.measure_db_id = measure.id
    arch_measure.hqmf_id = measure.hqmf_id
    arch_measure.hqmf_set_id = measure.hqmf_set_id
    arch_measure.measure_hash = JSON.parse(measure.to_json)
    arch_measure.user = measure.user
    arch_measure.uploaded_at = measure.created_at
    
    return arch_measure
  end
  
  def to_measure
    measure = Measure.new(measure_hash)
    return measure
  end
  
  
end
