# Do the measure calculation using the restful calculation microservice
module BonnieBackendCalculator
  CALCULATION_SERVICE_URL = 'http://localhost:8081/calculate'.freeze

  def self.calculate(measure, cqm_patients, options)
    cqm_value_sets = measure.value_sets.as_json(:except => :_id)
    post_data = {
      patients: cqm_patients,
      measure: measure,
      valueSets: cqm_value_sets,
      options: options
    }
    begin
      response = RestClient::Request.execute(:method => :post, :url => CALCULATION_SERVICE_URL, :timeout => 120,
                                             :payload => post_data.to_json(methods: :_type),
                                             :headers => {content_type: 'application/json'})

      JSON.parse(response)
    rescue RestClient::Exception => e
      raise self::RestException.new(e.message)
    rescue Errno::ECONNREFUSED
      raise self::RestException.new("Server refused connection on that port. Is the service running?")
    rescue JSON::ParserError
      raise self::ResponseException.new("JSON parse error")
    end
  end

  # Generic Backend Calculator related exception.
  class BackendCalculatorError < StandardError
  end
  # Error representing a problem with the rest call
  class RestException < BackendCalculatorError
    def initialize(message)
      super("Problem with the rest call to the calculation microservice: #{message}.")
    end
  end
  # Problem with the response from the calculation service
  class ResponseException < BackendCalculatorError
    def initialize(problem_description)
      super("Problem with the response from the calculation microservice: #{problem_description}.")
    end
  end
end
