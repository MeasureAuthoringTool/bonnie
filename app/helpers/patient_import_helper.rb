module PatientImportHelper
  TITLE = "Error Importing Patients".freeze

  class UploadedFileNotZip < MeasureHelper::SharedError
    def initialize
      message = "Import Patients file must be in a zip file."

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

  class MissingZipEntry < MeasureHelper::SharedError
    def initialize(missing_files = 'Patients JSON, Patients Meta JSON')
      message = "Unable to Import Patients"

      front_end_version = {
        title: TITLE,
        summary: message,
        body: "The file you are trying to be uploaded cannot be uploaded at this time. Please re-export your patients and try to import them again."
      }
      back_end_version = {
        json: { status: "error", messages: "Patient Import zip missing #{missing_files}" },
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class IncompatibleQdmVersion < MeasureHelper::SharedError
    def initialize
      message = "The uploaded file does not contain QDM #{APP_CONFIG['support_qdm_version']} patients."

      front_end_version = {
        title: TITLE,
        summary: message,
        body: "Only exported files containing QDM #{APP_CONFIG['support_qdm_version']} patients may be uploaded at this time."
      }
      back_end_version = {
        json: { status: "error", messages: message },
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class PatientsModified < MeasureHelper::SharedError
    def initialize
      message = "Unable to Import Patients"

      front_end_version = {
        title: TITLE,
        summary: message,
        body: "The file you are trying to be uploaded can not be uploaded at this time. Please re-export your patients and try to import them again."
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
      message = "Import Patient(s) did not pass validation."

      validation_messages =
        if !message_array.empty?
          message_array.join(",")
        else
          "Patient(s) are invalid."
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
