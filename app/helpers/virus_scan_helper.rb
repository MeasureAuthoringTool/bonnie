# Virus scanner helper
module VirusScanHelper
  def scan_for_viruses(file)
    logger = Rails.logger
    return unless APP_CONFIG['virus_scan']['enabled']
    start = Time.now
    original_filename = file.original_filename
    begin
      logger.info "VIRSCAN: scanning file #{original_filename}"
      headers = { apikey: APP_CONFIG['virus_scan']['api_key']}
      scan_url = APP_CONFIG['virus_scan']['scan_url']
      payload = { file_name: original_filename, file: File.new(file.tempfile, 'rb') }
      scan_timeout = APP_CONFIG['virus_scan']['timeout']
      RestClient::Request.execute(
        method: :post,
        url: scan_url,
        payload: payload,
        timeout: scan_timeout,
        headers: headers
      ) do |resp, _request, result, &_block|
        if resp.code == 200
          logger.info "VIRSCAN: scanner HTTP response code: #{resp.code}"
          json_response = JSON.parse(result.body)
          logger.info "VIRSCAN: scanner response body: #{result.body}"

          raise VirusFoundError.new if json_response['infectedFileCount'] != 0
        else
          logger.error "VIRSCAN: scanner HTTP response code: #{resp.code}"
          raise VirusScannerError.new
        end
      end
    rescue VirusFoundError, VirusScannerError => e
      # Re-throw the original exception, otherwise Virus Found Error event will be overridden by Virus Scanner Error.
      logger.error "VIRSCAN: error message: #{e.message}"
      raise
    rescue StandardError => e
      logger.error "VIRSCAN: error message: #{e.message}"
      raise VirusScannerError.new
    ensure
      duration = Time.now - start
      logger.info "VIRSCAN: scanning file #{original_filename} took: #{duration}s"
    end
  end

  # virus scan service internal server error
  class VirusScannerError < StandardError
  end

  # virus found in file error
  class VirusFoundError < StandardError
  end

  class MeasurePackageVirusScannerError < MeasureHelper::SharedError
    def initialize
      front_end_version = {
        title: "Error Loading Measure",
        summary: "The measure could not be loaded.",
        body: "Error: V101. Bonnie has encountered an error while trying to load the measure."
      }
      back_end_version = {
        json: {status: "error", messages: "Cannot perform virus scanning."},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class MeasurePackageVirusFoundError < MeasureHelper::SharedError
    def initialize
      front_end_version = {
        title: "Error Loading Measure",
        summary: "The uploaded file is not a valid Measure Authoring Tool (MAT) export of a FHIR Based Measure.",
        body: "Error: V100. Please re-package and re-export your FHIR based measure from the MAT and try again."
      }
      back_end_version = {
        json: {status: "error", messages: "Potential virus found in file"},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class PatientImportVirusScannerError < MeasureHelper::SharedError
    def initialize
      front_end_version = {
        title: "Error Importing Patients",
        summary: "The Patients could not be imported.",
        body: "Error: V101. Bonnie has encountered an error while trying to import the patients."
      }
      back_end_version = {
        json: {status: "error", messages: "Cannot perform virus scanning."},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class PatientImportVirusFoundError < MeasureHelper::SharedError
    def initialize
      front_end_version = {
        title: "Error Importing Patients",
        summary: "The uploaded file is not a valid Bonnie patient export.",
        body: "Error: V100. Please re-export patients from QDM bonnie and re-import in FHIR Bonnie."
      }
      back_end_version = {
        json: {status: "error", messages: "Potential virus found in file"},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end
end
