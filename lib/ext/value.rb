module HQMF
  class Value
    # Translate a Ruby time object to an HL7 timestamp string (YYYYMMDD).
    #
    # @return An HL7 timestamp string (YYYYMMDD) equivalent to time.
    def self.time_to_ts(time)
      time.strftime("%Y%m%d%H%M%S")
    end

    # Translate an HQMF Value object into a shape that HealthDataStandards understands.
    #
    # @return A Value formatted for storing a HealthDataStandards Record.
    def format
      if type == "PQ" || type == "CMP"
        { "scalar" => value, "units" => unit }
      elsif type == "TS"
        to_seconds
      end
    end
    
    # Translate the time stored in this Value into epoch seconds.
    #
    # @return Epoch seconds equivalent to the time stored in this Value.
    def to_seconds
      return nil unless type == "TS"

      to_time_object.utc.to_i
    end
    
    # Translate the time represented by this Value into a Ruby time object.
    #
    # @return A Ruby time object equivalent to the time represented by this Value.
    def to_time_object
      return nil unless type == "TS"

      year = value[0,4].to_i
      month = value[4,2].to_i
      day = value[6,2].to_i
      hour = 0
      minute = 0
      second = 0
      if (value.length > 8)
        hour = value[8,2].to_i
        minute = value[10,2].to_i
        second = value[12,2].to_i
      end
      
      Time.gm(year, month, day, hour, minute, second)
    end
  end
end
