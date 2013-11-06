module HealthDataStandards
  module SVS
    class ValueSet
      def serializable_hash(options=nil)
        super({ only: [:oid, :display_name] }.merge(options || {}))
      end
    end
  end
end
