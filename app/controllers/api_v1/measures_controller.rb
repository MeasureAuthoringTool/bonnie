module ApiV1
  class MeasuresController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_filter :authenticate_user!
    before_action :doorkeeper_authorize! # Require access token for all actions

    class IntegerValidator < Apipie::Validator::BaseValidator
      def initialize(param_description, argument)
        super(param_description)
        @type = argument
      end

      def validate(value)
        return false if value.nil?
        !!(value.to_s =~ /^[-+]?[0-9]+$/)
      end

      def self.build(param_description, argument, options, block)
        if argument == Integer || argument == Fixnum
          self.new(param_description, argument)
        end
      end

      def description
        "Must be #{@type}."
      end
    end

    class MeasureFileValidator < Apipie::Validator::BaseValidator
      def initialize(param_description, argument)
        super(param_description)
        @type = argument
      end

      def validate(value)
        if !(value.is_a?(Rack::Test::UploadedFile) || value.is_a?(ActionDispatch::Http::UploadedFile))
          return false
        end

        # Understand which sort of measure_file we are retrieving
        extension = File.extname(value.original_filename).downcase if value
        if extension == '.zip'
          return Measures::CqlLoader.mat_cql_export?(value)
        else
          return false
        end
      end

      def self.build(param_description, argument, options, block)
        self.new(param_description, argument) if argument == File
      end

      def description
        'Must be a valid MAT Export.'
      end
    end


    MEASURE_WHITELIST = %w[id cms_id complexity continuous_variable created_at description episode_of_care hqmf_id hqmf_set_id hqmf_version_number title type updated_at].freeze
    PATIENT_WHITELIST = %w[_id birthdate created_at deathdate description ethnicity expected_values expired first gender insurance_providers last notes race updated_at].freeze
    INSURANCE_WHITELIST = %w[member_id payer].freeze
    POPULATION_TYPES = %w[population_index STRAT IPP DENOM NUMER DENEXCEP DENEX MSRPOPL OBSERV MSRPOPLEX].freeze

    respond_to :json, :html, :xlsx
    rescue_from Apipie::ParamMissing, :with => :error_parameter_missing
    rescue_from ActionController::ParameterMissing, :with => :error_parameter_missing
    rescue_from Apipie::ParamInvalid, :with => :error_parameter_invalid

    resource_description do
      formats [:json]
      api_versions '1'
      error :code => 401, :desc => 'Unauthorized'
      description <<-DESCRIPTION
        This resource allows access to `Measures`, `Patients`, and calculated
        results for a given user.
      DESCRIPTION
    end

    def_param_group :measure do
      param :id, String, :required => true, :desc => 'The HQMF Set ID of the Measure.'
      error :code => 404, :desc => 'Not Found'
    end

    def_param_group :measure_upload do
      param :measure_file, File, :required => true, :desc => "The measure file."
      param :measure_type, %w[eh ep], :required => true, :desc => "The type of the measure."
      param :calculation_type, %w[episode patient], :required => true, :desc => "The type of calculation."
      param :population_titles, Array, of: String, :required => false, :desc => "The titles of the populations. If this is not included, populations will assume default values. i.e. \"Population 1\", \"Population 2\", etc."
      param :calc_sde, %w[true false], :required => false, :default_value => false, :desc => "Should Supplemental Data Elements be included in calculations. Defaults to 'false' if not supplied."

      param :vsac_tgt, String, :required => true, :desc => "VSAC ticket granting ticket."
      param :vsac_tgt_expires_at, Integer, :required => true, :desc => "VSAC ticket granting ticket expiration time in seconds since epoch."
      param :vsac_query_type, %w[release profile], :required => false, :desc => "The type of VSAC query, either 'release', or 'profile'. Default to 'profile' if not supplied."
      param :vsac_query_include_draft, %w[true false], :required => false, :desc => "If VSAC should fetch draft value sets. Defaults to 'true' if not supplied."
      param :vsac_query_release, String, :required => false, :desc => "The program release used to retrieve value sets. Defaults to 'Latest eCQM'."
      param :vsac_query_profile, String, :required => false, :desc => "The expansion profile used to retrieve value sets. Defaults to 'Latest eCQM'."
      param :vsac_query_measure_defined, %w[true false], :required => false, :desc => "Option to override value sets with value sets defined in the measure. Default to 'false' if not supplied."
    end

    api :GET, '/api_v1/measures', 'List of Measures'
    description 'Retrieve the list of measures for the authorized user.'
    formats [:json, :html]
    def index
      # TODO: filter by search parameters, for example an NQF ID or partial description
      @api_v1_measures = CqlMeasure.by_user(current_resource_owner).only(MEASURE_WHITELIST)
      respond_with @api_v1_measures do |format|
        format.json do
          render json: MultiJson.encode(
            @api_v1_measures.map do |x|
              h = x
              h[:id] = x.hqmf_set_id
              h
            end
          )
        end
        format.html { render :layout => false }
      end
    end

    api :GET, '/api_v1/measures/:id', 'Read a Specific Measure'
    description 'Retrieve the details of a specific measure by HQMF Set ID.'
    param_group :measure
    def show
      hash = {}
      http_status = 200
      begin
        @api_v1_measure = CqlMeasure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by { :updated_at }.first
        hash = @api_v1_measure.as_json
        hash[:id] = @api_v1_measure.hqmf_set_id
        hash.select! { |key,value| MEASURE_WHITELIST.include?(key)&&!value.nil? }
      rescue StandardError
        http_status = 404
        hash = {}
      end
      render json: hash, status: http_status
    end

    api :GET, '/api_v1/measures/:id/patients', 'List of Patients for a Specific Measure'
    description 'Get all the patients associated with a measure.'
    param_group :measure
    def patients
      @api_v1_patients = []
      http_status = 200
      begin
        # Get the measure
        @api_v1_measure = CqlMeasure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by(&:updated_at).first
        # Extract out the HQMF set id, which we'll use to get related patients
        hqmf_set_id = @api_v1_measure.hqmf_set_id
        # Get the patients for this measure
        @api_v1_patients = Record.by_user(current_resource_owner).where({:measure_ids.in => [hqmf_set_id]})
        @api_v1_patients = process_patient_records(@api_v1_patients)
      rescue StandardError
        http_status = 404
        @api_v1_patients = []
      end
      render json: @api_v1_patients, status: http_status
    end

    api :GET, '/api_v1/measures/:id/calculated_results', 'Calculated Results for a Specific Measure'
    description 'Retrieve the calculated results of the measure logic for each patient.'
    param_group :measure
    error :code => 500, :desc => 'Server-side Error Calculating the HQMF Measure Logic'
    formats [:json, :xlsx]
    def calculated_results
      begin
        http_status = 200
        # Get the measure
        @api_v1_measure = CqlMeasure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by(&:updated_at).first
        # Extract out the HQMF set id, which we'll use to get related patients
        hqmf_set_id = @api_v1_measure.hqmf_set_id
        # Get the patients for this measure
        @api_v1_patients = Record.by_user(current_resource_owner).where({:measure_ids.in => [hqmf_set_id]})
      rescue StandardError
        http_status = 404
      end

      if request.headers['Accept'] == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        if http_status != 404
          filename = 'Sample_Excel_Export(CMS52v6).xlsx'
          send_file "#{Rails.root}/public/resource/#{filename}", type: :xlsx, status: http_status, filename: ERB::Util.url_encode(filename)
        end
      else
        render json: {status: "error", messages: "Unimplemented functionality"}, status: :bad_request
      end
    end

    api :POST, '/api_v1/measures', 'Create a New Measure'
    description 'Creating a new measure.'
    formats ["multipart/form-data"]
    error :code => 400, :desc => "Client sent bad parameters. Response contains explanation."
    error :code => 409, :desc => "Measure with this HQMF Set ID already exists."
    error :code => 500, :desc => "A server error occured."
    param_group :measure_upload
    def create
      load_measure(params, false)
    end

    api :PUT, '/api_v1/measures/:id', 'Update an Existing Measure'
    description 'Updating an existing measure. This is a full update (e.g. no partial updates allowed).'
    formats ["multipart/form-data"]
    error :code => 400, :desc => "Client sent bad parameters. Response contains explanation."
    error :code => 404, :desc => "Measure with this HQMF Set ID does not exist."
    error :code => 500, :desc => "A server error occured."
    param_group :measure_upload
    def update
      existing = CqlMeasure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]})
      if existing.count == 0
        render json: {status: "error", messages: "No measure found for this HQMF Set ID."},
               status: :not_found
        return
      end
      load_measure(params, true)
    end


    private

    def process_patient_records(selector)
      patients = selector.map(&:as_json)
      patients.each do |p|
        p.select! { |key,value| PATIENT_WHITELIST.include?(key) && !value.nil? }
        unless p["insurance_providers"].nil?
          p["insurance_providers"].map! do |hash|
            hash.select! { |k,v| INSURANCE_WHITELIST.include?(k) && !v.nil? }
            hash["payer"] = hash["payer"]["name"] if hash["payer"]
            hash
          end
        end
        unless p["expected_values"].nil?
          p["expected_values"].map! do |hash|
            hash.select! { |k,v| POPULATION_TYPES.include?(k) && !v.nil? }
          end
        end
        p["birthdate"] = Time.at(p["birthdate"]).iso8601 if p["birthdate"]
        p["deathdate"] = Time.at(p["deathdate"]).iso8601 if p["deathdate"]
      end
      patients
    end

    def load_measure(params, is_update)
      measure_details = {
        'type'=>params[:measure_type],
        'episode_of_care'=>params[:calculation_type] == 'episode',
        'calculate_sdes'=>params[:calc_sde]
      }
      # If we get to this point, then the measure that is being uploaded is a MAT export of CQL
      begin
        # parse VSAC options using helper and get ticket_granting_ticket which is always needed
        vsac_options = MeasureHelper.parse_vsac_parameters(params)

        # Build ticket_granting_ticket object that VSAC util library expects
        vsac_tgt_object = {ticket: params[:vsac_tgt], expires: Time.at(params[:vsac_tgt_expires_at].to_i)}

        if (is_update && !params[:id].empty?)
          existing = CqlMeasure.by_user(current_resource_owner).where(hqmf_set_id: params[:id]).first
          measure_details['type'] = existing.type
          measure_details['episode_of_care'] = existing.episode_of_care
          if measure_details['episode_of_care']
            episodes = params["eoc_#{existing.hqmf_set_id}"]
          end
          measure_details['calculate_sdes'] = existing.calculate_sdes
          measure_details['population_titles'] = existing.populations.map {|p| p['title']} if existing.populations.length > 1
        end

        measure = Measures::CqlLoader.load(params[:measure_file], current_resource_owner, measure_details, vsac_options, vsac_tgt_object)

        if (!is_update)
          existing = CqlMeasure.by_user(current_resource_owner).where(hqmf_set_id: measure.hqmf_set_id).first
          if !existing.nil?
            measure.delete
            render json: {status: "error", messages: "A measure with this HQMF Set ID already exists.", url: "/api_v1/measures/#{measure.hqmf_set_id}"},
                   status: :conflict
            return
          end
        else
          if existing.hqmf_set_id != measure.hqmf_set_id
            measure.delete
            render json: {status: "error", messages: "The update file does not have a matching HQMF Set ID to the measure trying to update with"},
                   status: :conflict
            return
          end
        end

        # exclude patient birthdate and expired OIDs used by SimpleXML parser for AGE_AT handling and bad oid protection in missing VS check
        missing_value_sets = (measure.as_hqmf_model.all_code_set_oids - measure.value_set_oids - ['2.16.840.1.113883.3.117.1.7.1.70', '2.16.840.1.113883.3.117.1.7.1.309'])
        if missing_value_sets.length > 0
          measure.delete
          render json: {status: "error", messages: "The measure is missing value sets. The following value sets are missing: [#{missing_value_sets.join(', ')}]"},
                 status: :bad_request
          return
        end
        existing.delete if (existing && is_update)
      rescue Exception => e
        measure.delete if measure
        errors_dir = Rails.root.join('log', 'load_errors')
        FileUtils.mkdir_p(errors_dir)
        clean_email = File.basename(current_resource_owner.email) # Prevent path traversal

        # Create the filename for the copied measure upload. We do not use the original extension to avoid malicious user
        # input being used in file system operations.
        filename = "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.xmlorzip"

        operator_error = false # certain types of errors are operator errors and do not need to be emailed out.
        File.open(File.join(errors_dir, filename), 'w') do |errored_measure_file|
          uploaded_file = params[:measure_file].tempfile.open()
          errored_measure_file.write(uploaded_file.read());
          uploaded_file.close()
        end

        File.chmod(0644, File.join(errors_dir, filename))
        File.open(File.join(errors_dir, "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.error"), 'w') do |f|
          f.write("Original Filename was #{params[:measure_file].original_filename}\n")
          f.write(e.to_s + "\n" + e.backtrace.join("\n"))
        end
        if e.is_a?(Util::VSAC::VSACError)
          vsac_message = MeasureHelper.build_vsac_error_message(e)
          error_message = vsac_message[:title] + '. ' + vsac_message[:summary] + ' ' + vsac_message[:body]
          operator_error = true
          render json: {status: "error", messages: MeasureHelper.build_vsac_error_message(e)},
                 status: :bad_request

        elsif e.is_a? Measures::MeasureLoadingException
          operator_error = true
          render json: {status: "error", messages: "The measure could not be loaded, there may be an error in the CQL logic."},
                 status: :bad_request
        else
          render json: {status: "error", messages: "The measure could not be loaded, Bonnie has encountered an error while trying to load the measure."},
                 status: :bad_request
        end

        # email the error
        if !operator_error && defined? ExceptionNotifier::Notifier
          params[:error_file] = filename
          ExceptionNotifier::Notifier.exception_notification(env, e).deliver_now
        end

        return
      end

      current_resource_owner.measures << measure
      current_resource_owner.save!

      if (is_update)
        measure.populations.each_with_index do |population, population_index|
          population['title'] = measure_details['population_titles'][population_index] if (measure_details['population_titles'])
        end
        # check if episode ids have changed
        if (measure.episode_of_care?)
          keys = measure.data_criteria.values.map {|d| d['source_data_criteria'] if d['specific_occurrence']}.compact.uniq
        end
      else
        measure.needs_finalize = measure.populations.size > 1
        if measure.populations.size > 1
          strat_index = 1
          measure.populations.each do |population|
            if (population[HQMF::PopulationCriteria::STRAT])
              population['title'] = "Stratification #{strat_index}"
              strat_index += 1
            end
          end
        end

      end
      measure.save!

      # rebuild the user's patients for the given measure
      Record.by_user_and_hqmf_set_id(current_resource_owner, measure.hqmf_set_id).each do |r|
        Measures::PatientBuilder.rebuild_patient(r)
        r.save!
      end

      # ensure expected values on patient match those in the measure's populations
      Record.where(user_id: current_resource_owner.id, measure_ids: measure.hqmf_set_id).each do |patient|
        patient.update_expected_value_structure!(measure)
      end

      render json: {status: "success", url: "/api_v1/measures/#{measure.hqmf_set_id}"},
             status: :ok
    end

    def error_parameter_missing(exception)
      param_name = exception.is_a?(Apipie::ParamMissing) ? exception.param.name : exception.param
      render json: {status: "error", messages: "Missing parameter: #{param_name}" }, status: :bad_request
    end

    def error_parameter_invalid(exception)
      render json: {status: "error", messages: "Invalid parameter '#{exception.param}': #{exception.error.gsub(%r{/<\/?code>/}, '')}" },
             status: :bad_request
    end

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

  end
end
