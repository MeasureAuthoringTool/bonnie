module PatientFhirConverter
  URL = 'https://bonniedev-fhir.semanticbits.com/bonnie-patient-conversion/patients/convertMany'.freeze

  def self.convert(patients)
    begin
      response = RestClient::Request.execute(:method => :put, :url => URL, :timeout => 120,
                                             :payload => patients,
                                             :headers => { content_type: 'application/json' },
                                             :verify_ssl => false)
      response.body
    rescue RestClient::Exception => e
      raise self::RestException.new(e.message)
    rescue Errno::ECONNREFUSED
      raise self::RestException.new("Server refused connection on that port. Is the service running?")
    rescue JSON::ParserError
      raise self::ResponseException.new("JSON parse error")
    end
  end

  # Generic Backend Calculator related exception.
  class PatientFhirConverter < StandardError
  end

  # Error representing a problem with the rest call
  class RestException < PatientFhirConverter
    def initialize(message)
      super("Problem with the rest call to the conversion microservice: #{message}.")
    end
  end

  # Problem with the response from the calculation service
  class ResponseException < PatientFhirConverter
    def initialize(problem_description)
      super("Problem with the response from the conversion microservice: #{problem_description}.")
    end
  end
end
