
# Do the measure calculation using the restful calculation microservice,
# will convert patients to QDM model prior to calculation.
module BonnieBackendCalculator
  CALCULATION_SERVICE_URL = 'http://localhost:8081/calculate'.freeze

  def self.calculate(measure, patients, value_sets_by_oid, options)
    # convert patients to QDM, note that once we switch to the QDM model this will become unnecessary (or maybe optional)
    cqm_patients, failed_patients = PatientHelper.convert_patient_models(patients)
    qdm_patients = []
    qdm_patients = cqm_patients.map {|cqm_patient| cqm_patient.qdmPatient }
    post_data = {
      patients: qdm_patients,
      measure: measure,
      valueSetsByOid: value_sets_by_oid,
      options: options
    }
    begin
      response = RestClient::Request.execute(:method => :post, :url => CALCULATION_SERVICE_URL, :timeout => 120, 
                                             :payload => post_data.to_json(methods: :_type), 
                                             :headers => {content_type: 'application/json'})

      results = JSON.parse(response)

      # add back the failed patients
      results["failed_patients"].push(*failed_patients) if failed_patients.nil?

      return results
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
