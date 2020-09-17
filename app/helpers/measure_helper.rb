module MeasureHelper
  class SharedError < StandardError
    attr_reader :front_end_version, :back_end_version, :operator_error
    def initialize(msg: nil, front_end_version:, back_end_version:, operator_error: false)
      msg ||= front_end_version[:summary] || "Error"
      @front_end_version = front_end_version
      @back_end_version = back_end_version
      @operator_error = operator_error
      super(msg)
    end
  end

  class MeasureUpdateMeasureNotFound < SharedError
    def initialize
      front_end_version = {
        title: "Error Loading Measure",
        summary: "Update requested, but measure does not exist.",
        body: "You have attempted to update a measure that does not exist."
      }
      back_end_version = {
        json: {status: "error", messages: "No measure found for this Set ID."},
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingMeasureAlreadyExists < SharedError
    def initialize(measure_set_id)
      front_end_version = {
        title: "Error Loading Measure",
        summary: "A version of this measure is already loaded.",
        body: "You have a version of this measure loaded already. Either update that measure with the update button, or delete that measure and re-upload it."
      }
      back_end_version = {
        json: {status: "error", messages: "A measure with this Set ID already exists.", url: "/api_v1/measures/#{measure_set_id}"},
        status: :conflict
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingUnsupportedDataElement < SharedError
    def initialize(data_element_name)
      front_end_version = {
        title: "Error Loading Measure",
        summary: "Unsupported Data Element Used In Measure.",
        body: "Bonnie does not support the " + data_element_name + " QDM Data Element used in this measure."
      }
      back_end_version = {
        json: {status: "error", messages: "Bonnie does not support the " + data_element_name + " QDM Data Element used in this measure."},
        status: :conflict
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingUpdatingWithMismatchedMeasure < SharedError
    def initialize
      front_end_version = {
        title: "Error Updating Measure",
        summary: "The update file does not match the measure.",
        body: "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure."
      }
      back_end_version = {
        json: {status: "error", messages: "The update file does not have a matching Set ID to the measure trying to update with. Please update the correct measure or upload the file as a new measure."},
        status: :not_found
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingBadPackage < SharedError
    def initialize(loading_exception_message)
      front_end_version = {
        title: "Error Uploading Measure",
        summary: "The uploaded file is not a valid Measure Authoring Tool (MAT) export of a FHIR Based Measure.",
        body: "#{loading_exception_message.sub(/^#<.*Error: /, '').sub(/>$/, '')}<br />"\
              "Please re-package and re-export your FHIR based measure from the MAT and try again.".html_safe
      }
      back_end_version = {
        json: {status: "error", messages: "Measure loading process encountered error: #{loading_exception_message}"},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingOther < SharedError
    def initialize(details = nil)
      front_end_version = {
        title: "Error Loading Measure",
        summary: "The measure could not be loaded.",
        body: "Bonnie has encountered an error while trying to load the measure."
      }
      back_end_version = {
        json: {status: "error", messages: "The measure could not be loaded, Bonnie has encountered an error while trying to load the measure."},
        status: :internal_server_error
      }
      if details.present?
        back_end_version[:json][:details] = details
        # Strip off the <#RuntimeError: ... > from the details because it causes issues in html
        front_end_version[:body] += " Details: #{details.sub(/^#<.*Error: /, '').sub(/>$/, '')}"
      end
      super(front_end_version: front_end_version, back_end_version: back_end_version)
    end
  end

  class VSACVSLoadingError < SharedError
    def initialize(oid)
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC value set (#{oid}) not found or is empty.",
        body: "Please verify that you are using the correct profile or release and have VSAC authoring permissions if you are requesting draft value sets."
      }
      back_end_version = {
        json: {status: "error", messages: "VSAC value set (#{oid}) not found or is empty. Please verify that you are using the correct profile or release and have VSAC authoring permissions if you are requesting draft value sets."},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class VSACInvalidCredentialsError < SharedError
    def initialize
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC credentials were invalid.",
        body: "Please verify that you are using your valid VSAC API Key."
      }
      back_end_version = {
        json: {status: "error", messages: "VSAC credentials were invalid."},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class VSACTicketExpiredError < SharedError
    def initialize
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC session expired.",
        body: "Please re-enter VSAC API Key to try again."
      }
      back_end_version = {
        json: {status: "error", messages: "VSAC session expired. Please try again."},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class VSACNoCredentialsError < SharedError
    def initialize
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "No VSAC credentials provided.",
        body: "Please re-enter VSAC API Key to try again."
      }
      back_end_version = {
        json: {status: "error", messages: "No VSAC credentials provided."},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  class VSACError < SharedError
    def initialize(message)
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC value sets could not be loaded.",
        body: "#{message}<br/>This may be due to lack of VSAC authoring permissions if you are requesting draft value sets. Please confirm you have the appropriate authoring permissions."
      }
      back_end_version = {
        json: {status: "error", messages: "Error loading valuesets from VSAC: #{message}"},
        status: :bad_request
      }
      super(front_end_version: front_end_version, back_end_version: back_end_version, operator_error: true)
    end
  end

  def create_measure(uploaded_file:, measure_details:, value_set_loader:, user:)
    measure = extract_measure!(uploaded_file.tempfile, measure_details, value_set_loader)
    existing = CQM::Measure.by_user(user).where(set_id: measure.set_id).first
    raise MeasureLoadingMeasureAlreadyExists.new(measure.set_id) unless existing.nil?
    save_and_post_process(measure, user)
    measure
  rescue StandardError => e
    measure&.delete
    e = turn_exception_into_shared_error_if_needed(e)
    log_measure_loading_error(e, uploaded_file, user)
    raise e
  end

  def update_measure(uploaded_file:, target_id:, value_set_loader:, user:)
    existing = CQM::Measure.by_user(user).where({:set_id=> target_id}).first
    raise MeasureUpdateMeasureNotFound.new if existing.nil?
    measure_details = extract_measure_details_from_measure(existing)
    # original_year = existing.measure_period['low']['value'][0..3]

    measure = extract_measure!(uploaded_file.tempfile, measure_details, value_set_loader)
    raise MeasureLoadingUpdatingWithMismatchedMeasure.new if measure.set_id != existing.set_id
    # TODO: update this as while working on update measure story
    # Maintain the year shift if there was one
    # measure.measure_period[:low][:value] = original_year + '01010000' # Jan 1, 00:00
    # measure.measure_period[:high][:value] = original_year + '12312359' # Dec 31, 23:59
    existing.delete
    save_and_post_process(measure, user)
    measure
  rescue StandardError => e
    measure&.delete
    e = turn_exception_into_shared_error_if_needed(e)
    log_measure_loading_error(e, uploaded_file, user)
    raise e
  end

  def turn_exception_into_shared_error_if_needed(error)
    return error if error.is_a?(SharedError)
    return MeasureLoadingBadPackage.new(error.inspect) if error.inspect.include? 'Verify the QDM version of the measure package is correct.'
    return MeasureLoadingOther.new(Rails.env.development? ? error.inspect : nil)
  end

  def extract_measure_details_from_measure(measure)
    return {
      'episode_of_care' => measure.calculation_method == 'EPISODE_OF_CARE',
      'calculate_sdes' => measure.calculate_sdes,
      'population_titles' => '' # measure.population_sets.map(&:title) + measure.all_stratifications.map(&:title)
    }
  end

  def retrieve_vasc_options(params, get_defaults_from_vsac = false)
    vsac_options = {}
    api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'])
    # If query type is 'release' set the query_release to a value that is passed in, or set it using default
    # If query type is 'profile' (the default) set the query profile and include_draft options
    if params[:vsac_query_type] == 'release'
      vsac_options[:release] =
        if get_defaults_from_vsac
          params.fetch(:vsac_query_release, api.get_program_release_names(APP_CONFIG['vsac']['default_program']).first)
        else
          params[:vsac_query_release]
        end
    else
      vsac_options[:profile] =
        if get_defaults_from_vsac
          params.fetch(:vsac_query_profile, api.get_latest_profile_for_program(APP_CONFIG['vsac']['default_program']))
        else
          params[:vsac_query_profile]
        end
      vsac_options[:include_draft] = true if params.fetch(:vsac_query_include_draft, 'true') == 'true'
    end
    vsac_options[:measure_defined] = true if params.fetch(:vsac_query_measure_defined, 'false') == 'true'
    return vsac_options
  end

  def build_vs_loader(params, get_defaults_from_vsac)
    vsac_tgt_object = {ticket: params[:vsac_tgt], expires: Time.at(params[:vsac_tgt_expires_at].to_i)} if params[:vsac_tgt].present? && params[:vsac_tgt_expires_at].present?

    return Measures::VSACValueSetLoader.new(
      options: retrieve_vasc_options(params, get_defaults_from_vsac),
      ticket_granting_ticket: vsac_tgt_object
    )
  end

  # Helper method to build a flash error given a VSACError.
  def convert_vsac_error_into_shared_error(error)
    if error.is_a?(Util::VSAC::VSNotFoundError) || error.is_a?(Util::VSAC::VSEmptyError) # rubocop:disable Style/GuardClause
      return VSACVSLoadingError.new(error.oid)
    elsif error.is_a?(Util::VSAC::VSACInvalidCredentialsError)
      return VSACInvalidCredentialsError.new
    elsif error.is_a?(Util::VSAC::VSACTicketExpiredError)
      return VSACTicketExpiredError.new
    elsif error.is_a?(Util::VSAC::VSACNoCredentialsError)
      return VSACNoCredentialsError.new
    else
      return VSACError.new(error.message)
    end
  end

  def update_related_patient_records(measure, current_user)
    # Ensure expected values on patient match those in the measure's populations
    CQM::Patient.where(user_id: current_user.id, measure_ids: measure.set_id).each do |patient|
      patient.update_expected_value_structure!(measure)
    end
  end

  def delete_for_update(existing, user)
    existing.component_set_ids.each do |component_set_id|
      component_measure = CQM::Measure.by_user(user).where(set_id: component_set_id).first
      component_measure.delete
    end
    existing.delete
  end

  def extract_measure!(measure_file, measure_details, value_set_loader)
    loader = Measures::BundleLoader.new(measure_file, measure_details, value_set_loader)
    measure = loader.extract_measure
    measure
  rescue Measures::MeasureLoadingInvalidPackageException => e
    raise MeasureLoadingBadPackage.new(e.message)
  rescue Util::VSAC::VSACError => e
    raise convert_vsac_error_into_shared_error(e)
  end

  def save_and_post_process(measure, user)
    measure.user = user
    measure.save!
    # update_related_patient_records(measures, user)
  end

  def log_measure_loading_error(error, uploaded_file, user)
    errors_dir = Rails.root.join('log', 'load_errors')
    FileUtils.mkdir_p(errors_dir)
    clean_email = File.basename(user.email) # Prevent path traversal

    # Create the filename for the copied measure upload. We do not use the original extension to avoid malicious user
    # input being used in file system operations.
    filename = "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.xmlorzip"

    File.open(File.join(errors_dir, filename), 'w') do |errored_measure_file|
      uploaded_file.open
      errored_measure_file.write(uploaded_file.read)
      uploaded_file.close
    end
    File.chmod(0o644, File.join(errors_dir, filename))
    File.open(File.join(errors_dir, "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.error"), 'w') do |f|
      f.write("Original Filename was #{uploaded_file.original_filename}\n")
      f.write(error.to_s + "\n" + (error.backtrace||[]).join("\n"))
    end
  end
end
