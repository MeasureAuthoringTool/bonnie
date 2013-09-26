class Publishing < Measure
  include Mongoid::Document
  
  embedded_in :measure
  
  scope :by_version, ->(version) {where({'version'=>version})}
  scope :ordered, order_by([:version, :asc])
  
  
end
