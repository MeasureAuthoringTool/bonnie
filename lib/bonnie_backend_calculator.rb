
# Do the measure calculation using the restful calculation microservice, 
# will convert patients to QDM model prior to calculation.
module BonnieBackendCalculator
  def self.calculate(measure, patients, value_sets, options)
    # convert patients to QDM, TODO: convert only as necessary
    qdm_patients, failed_patients = PatientHelper.convert_patient_models(patients)

    post_data = {
      patients: qdm_patients,
      measure: measure,
      valueSets: value_sets,
      options: options
    }
    begin
      response = RestClient.post('http://localhost:8081/calculate',
                                 post_data.to_json,
                                 content_type: 'application/json')
      results = JSON.parse(response)

      # add back the failed patients, TODO: discuss this strategy
      results["patients"].push(*failed_patients)
      
      return results
    rescue RestClient::Exception => e
      raise self::RestException.new(e.http_code)
    rescue JSON::ParserError
      raise self::ResponseException.new("JSON parse error")
    end
  end

  # Generic Backend Calculator related exception.
  class BackendCalculatorError < StandardError
  end
  # Error represnting a problem with the rest call
  class RestException < BackendCalculatorError
    def initialize(http_code)
      super("Problem with the rest call to the calculation microservice; http code #{http_code}.")
    end
  end
  # Problem with the response from the calculation service
  class ResponseException < BackendCalculatorError
    def initialize(problem_description)
      super("Problem with the response from the calculation microservice: #{problem_description}.")
    end
  end
end
