module HQMF
  class Range
    # Form an HQMF Range object into a shape that HealthDataStandards understands.
    #
    # @return A Range formatted for storing a HealthDataStandards Record.
    def format
      if low
        low.format
      elsif high
        high.format
      end
    end
  end
end