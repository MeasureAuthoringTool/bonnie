module PatientImportHelper
  TITLE = "Error Converting Patients".freeze

  class UploadedFileNotZip < MeasureHelper::SharedError
    def initialize
      message = "Converted Patients file must be in a zip file."

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
    def initialize
      message = "Converted Patients file must contain only one json file."

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
    def initialize(message_array)
      message = "Converted Patient(s) did not pass validation."

      validation_messages =
        if message_array.length > 0
          message_array.join(",")
        else
          "Patient(s) are invalid_"
        end

      front_end_version = {
        title: TITLE,
        summary: message,
        body: validation_messages
      }
      back_end_version = {
        json: { status: "error", messages: validation_messages },
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end
end
