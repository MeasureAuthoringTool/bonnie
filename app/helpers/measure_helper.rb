module MeasureHelper


  class SharedError < StandardError
    attr_reader :front_end_version, :back_end_version, :operator_error
    def initialize(msg: "Error", front_end_version:, back_end_version:, operator_error: false)
      @front_end_version = front_end_version
      @back_end_version = back_end_version
      super(msg)
    end
  end

  class MeasureUpdateMeasureNotFound < SharedError
    def initialize()
      front_end_version = {
        title: "Error Loading Measure",
        summary: "Update requested, but measure does not exist.",
        body: "You have attempted to update a measure that does not exist."
      }
      back_end_version = {
        json: {status: "error", messages: "No measure found for this HQMF Set ID."},
        status: :not_found
      }
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingMeasureAlreadyExists < SharedError
    def initialize(measure_hqmf_set_id)
      front_end_version = {
        title: "Error Loading Measure",
        summary: "A version of this measure is already loaded.", 
        body: "You have a version of this measure loaded already.  Either update that measure with the update button, or delete that measure and re-upload it."
      }
      back_end_version = {
        json: {status: "error", messages: "A measure with this HQMF Set ID already exists.", url: "/api_v1/measures/#{measure_hqmf_set_id}"},
        status: :conflict
      }
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingUpdatingWithMismatchedMeasure < SharedError
    def initialize()
      front_end_version = {
        title: "Error Updating Measure",
        summary: "The update file does not match the measure.",
        body: "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure."
      }
      back_end_version = {
        json: {status: "error", messages: "The update file does not have a matching HQMF Set ID to the measure trying to update with. Please update the correct measure or upload the file as a new measure."},
        status: :not_found
      }
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
    end
  end

  class MeasureLoadingBadPackage < SharedError
    def initialize(loading_exception_message)
      front_end_version = {
        title: "Error Uploading Measure",
        summary: "The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.",
        body: "Measure loading process encountered error: #{loading_exception_message} Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href='https://bonnie-qdm.healthit.gov'>Bonnie-QDM</a>.".html_safe
      }
      back_end_version = {
        json: {status: "error", messages: "Measure loading process encountered error: #{loading_exception_message}"},
        status: :bad_request
      }
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
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
        front_end_version[:body] += " Details: #{details}"
      end
      super(front_end_version:front_end_version, back_end_version:back_end_version)
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
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
    end
  end

  class VSACInvalidCredentialsError < SharedError
    def initialize()
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC credentials were invalid.",
        body: "Please verify that you are using the correct VSAC username and password."
      }
      back_end_version = {
        json: {status: "error", messages: "VSAC credentials were invalid."},
        status: :bad_request
      }
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
    end
  end

  class VSACTicketExpiredError < SharedError
    def initialize()
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC session expired.",
        body: "Please re-enter VSAC username and password to try again."
      }
      back_end_version = {
        json: {status: "error", messages: "VSAC session expired. Please try again."},
        status: :bad_request
      }
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
    end
  end

  class VSACNoCredentialsError < SharedError
    def initialize()
      front_end_version = {
        title: "Error Loading VSAC Value Sets",
        summary: "No VSAC credentials provided.",
        body: "Please re-enter VSAC username and password to try again."
      }
      back_end_version = {
        json: {status: "error", messages: "No VSAC credentials provided."},
        status: :bad_request
      }
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
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
      super(front_end_version:front_end_version, back_end_version:back_end_version, operator_error: true)
    end
  end




  def create_measure(measure_file:, measure_details:, value_set_loader:, user:)
    measures, main_hqmf_set_id = extract_measures!(measure_file, measure_details, value_set_loader)
    existing = CQM::Measure.by_user(user).where(hqmf_set_id: main_hqmf_set_id).first
    raise MeasureLoadingMeasureAlreadyExists.new(main_hqmf_set_id) unless existing.nil?
    save_and_post_process(measures, user)
    return main_hqmf_set_id
  rescue StandardError => e
    delete_measures_array_with_package_and_valuesets(measures) if measures
    e = turn_exception_into_shared_error_if_needed(e)
    log_measure_loading_error(e, params[:measure_file], user)
    raise e
  end

  def update_measure(measure_file:, target_id:, value_set_loader:, user:)
    existing = CQM::Measure.by_user(user).where({:hqmf_set_id=> target_id}).first
    raise MeasureUpdateMeasureNotFound.new() if existing.nil?
    measure_details = extract_measure_details_from_measure(existing)

    measures, main_hqmf_set_id = extract_measures!(measure_file, measure_details, value_set_loader)
    raise MeasureLoadingUpdatingWithMismatchedMeasure.new() if main_hqmf_set_id != existing.hqmf_set_id
    delete_for_update(existing, user)
    save_and_post_process(measures, user)
    return main_hqmf_set_id
  rescue StandardError => e
    delete_measures_array_with_package_and_valuesets(measures) if defined?(measures)
    e = turn_exception_into_shared_error_if_needed(e)
    log_measure_loading_error(e, measure_file, user)
    raise e
  end

  def turn_exception_into_shared_error_if_needed(e)
    return e if e.is_a?(SharedError)
    return MeasureLoadingOther.new(Rails.env.development? ? e.inspect : nil)
  end

  def extract_measure_details_from_measure(measure)
    return {
      'episode_of_care' => measure.calculation_method == 'EPISODE_OF_CARE',
      'calculate_sdes'=> measure.calculate_sdes,
      'population_titles' => measure.population_sets.map(&:title) + measure.population_sets.flat_map{|ps| ps.stratifications.map(&:title)}
    }
  end

  def retrieve_vasc_options(params, get_defaults_from_vsac = false)
    vsac_options = {}
    api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'])
    # If query type is 'release' set the query_release to a value that is passed in, or set it using default
    # If query type is 'profile' (the default) set the query profile and include_draft options
    if params[:vsac_query_type] == 'release'
      if get_defaults_from_vsac
        vsac_options[:release] = params.fetch(:vsac_query_release, api.get_program_release_names(APP_CONFIG['vsac']['default_program']).first)
      else
        vsac_options[:release] = params[:vsac_query_release]
      end
    else
      if get_defaults_from_vsac
        vsac_options[:profile] = params.fetch(:vsac_query_profile, api.get_latest_profile_for_program(APP_CONFIG['vsac']['default_program']))
      else
        vsac_options[:profile] = params[:vsac_query_profile]
      end
      vsac_options[:include_draft] = true if params.fetch(:vsac_query_include_draft, 'true') == 'true'
    end
    vsac_options[:measure_defined] = true if params.fetch(:vsac_query_measure_defined, 'false') == 'true'
    return vsac_options
  end

  def build_vs_loader(params, get_defaults_from_vsac)
    if params[:vsac_tgt].present? && params[:vsac_tgt_expires_at].present?
      vsac_tgt_object = {ticket: params[:vsac_tgt], expires: Time.at(params[:vsac_tgt_expires_at].to_i)}
    else
      vsac_tgt_object = nil
    end

    return Measures::VSACValueSetLoader.new(
      options: retrieve_vasc_options(params, get_defaults_from_vsac),
      username: params[:vsac_username],
      password: params[:vsac_password],
      ticket_granting_ticket: vsac_tgt_object
    )
  end

  # Helper method to build a flash error given a VSACError.
  def convert_vsac_error_into_shared_error(e)
    if e.is_a?(Util::VSAC::VSNotFoundError) || e.is_a?(Util::VSAC::VSEmptyError)
      return VSACVSLoadingError.new(e.oid)
    elsif e.is_a?(Util::VSAC::VSACInvalidCredentialsError)
      return VSACInvalidCredentialsError.new()
    elsif e.is_a?(Util::VSAC::VSACTicketExpiredError)
      return VSACTicketExpiredError.new()
    elsif e.is_a?(Util::VSAC::VSACNoCredentialsError)
      return VSACNoCredentialsError.new()
    else
      return VSACError.new(e.message)
    end
  end

  def update_related_patient_records(measures, current_user)
    measures.each do |measure|
      # Rebuild the user's patients for the given measure
      Record.by_user_and_hqmf_set_id(current_user, measure.hqmf_set_id).each do |r|
        Measures::PatientBuilder.rebuild_patient(r)
        r.save!
      end

      # Ensure expected values on patient match those in the measure's populations
      Record.where(user_id: current_user.id, measure_ids: measure.hqmf_set_id).each do |patient|
        patient.update_expected_value_structure!(measure)
      end
    end
  end

  def add_measures_to_user(measures, current_user)
    # what is this for?
    measures.each{ |measure| current_user.measures << measure }
    current_user.save!
  end

  def delete_for_update(existing, user)
    #TODO: make sure this is good.
    existing.component_hqmf_set_ids.each do |component_hqmf_set_id|
      component_measure = CQM::Measure.by_user(user).where(hqmf_set_id: component_hqmf_set_id).first
      component_measure.delete
    end
    existing.delete
  end

  def extract_measures!(measure_file, measure_details, value_set_loader)
    loader = Measures::CqlLoader.new(measure_file, measure_details, value_set_loader)
    measures = loader.extract_measures
    main_hqmf_set_id = measures.last.hqmf_set_id
    return measures, main_hqmf_set_id
  rescue Measures::MeasureLoadingInvalidPackageException => e
    raise MeasureLoadingBadPackage.new(e.message)
  rescue Util::VSAC::VSACError => e
    raise convert_vsac_error_into_shared_error(e)
  end

  def save_and_post_process(measures, user)
    save_measures_array_with_package_and_valuesets_to_user(measures, user)
    update_related_patient_records(measures, user)
    add_measures_to_user(measures, user)
  end

  def log_measure_loading_error(e, measure_file, user)
    errors_dir = Rails.root.join('log', 'load_errors')
    FileUtils.mkdir_p(errors_dir)
    clean_email = File.basename(user.email) # Prevent path traversal

    # Create the filename for the copied measure upload. We do not use the original extension to avoid malicious user
    # input being used in file system operations.
    filename = "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.xmlorzip"

    File.open(File.join(errors_dir, filename), 'w') do |errored_measure_file|
      uploaded_file = measure_file.tempfile.open
      errored_measure_file.write(uploaded_file.read)
      uploaded_file.close
    end
    File.chmod(0644, File.join(errors_dir, filename))
    File.open(File.join(errors_dir, "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.error"), 'w') do |f|
      f.write("Original Filename was #{measure_file.original_filename}\n")
      f.write(e.to_s + "\n" + (e.backtrace||[]).join("\n"))
    end
    # email the error
    if e.respond_to?(:operator_error) && e.operator_error && defined? ExceptionNotifier::Notifier
      # params[:error_file] = filename  #TODO what is this
      ExceptionNotifier::Notifier.exception_notification(env, e).deliver_now
    end
  end

  def save_measures_array_with_package_and_valuesets_to_user(measures, user)
    measures.each do |measure|
      measure.user = user
      measure.save!
      if measure.package.present?
        measure.package.user = user
        measure.package.save!
      end
      measure.value_sets.each do |valueset|
        valueset.user = user
        valueset.save!
      end
    end
  end

  def delete_measures_array_with_package_and_valuesets(measures)
    return if measures.nil?
    measures.each do |measure|
      measure.delete
      measure.package.delete if measure.package.present?
      measure.value_sets.each { |valueset| valueset.delete }
    end
  end

end