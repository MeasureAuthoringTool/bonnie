module PatientImportHelper
  TITLE = "Error Converting Patients"

  class UploadedFileNotZip < MeasureHelper::SharedError
    message = "Converted Patients file must be in a zip file."

    def initialize
      front_end_version = {
        title: TITLE,
        summary: message,
        body: "You have uploaded a file that is not a zip file."
      }
      back_end_version = {
        json: { status: "error", messages: message },
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class ZipEntryNotJson < MeasureHelper::SharedError
    message = "Converted Patients file must contain only one json file."

    def initialize
      front_end_version = {
        title: TITLE,
        summary: message,
        body: "You have uploaded a file that does not contain one FHIR-patients json file."
      }
      back_end_version = {
        json: { status: "error", messages: message },
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class PatientInvalid < MeasureHelper::SharedError
    message = "Converted Patient(s) did not pass validation."

    def initialize
      front_end_version = {
        title: TITLE,
        summary: message,
        body: "One or more of your FHIR-patients did not pass validation"
      }
      back_end_version = {
        json: { status: "error", messages: message },
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end
end
