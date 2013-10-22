module HealthDataStandards
  module SVS
    class Concept
      include Mongoid::Document
      field :white_list, type: Boolean, default: false
      field :black_list, type: Boolean, default: false
    end
  end
end