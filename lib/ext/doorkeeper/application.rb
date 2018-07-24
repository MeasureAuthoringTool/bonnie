module Doorkeeper
  class Application
    include Mongoid::Document

    # Add the confidential field that is now expected in doorkeeper 4.4.0
    field :confidential, type: Boolean, default: true

    # Make it report support of confidential field.
    def self.supports_confidentiality?
      true
    end
  end
end
