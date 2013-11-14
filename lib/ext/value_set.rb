module HealthDataStandards
  module SVS
    class ValueSet
      # FIXME: We'd like to minimize our client side footprint, but this interferes with JS generation
      # def serializable_hash(options=nil)
      #   super({ only: [:oid, :display_name] }.merge(options || {}))
      # end
    end
  end
end
