module Bonnie
  class Version

    def self.current
      return APP_CONFIG["version"]
    end

    def self.fhir_ver
      return APP_CONFIG['support_fhir_version']
    end

  end
end 
