module ApiV1
  class MeasuresController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!
    before_action :doorkeeper_authorize! # Require access token for all actions

    include MeasureHelper

    class IntegerValidator < Apipie::Validator::BaseValidator
      def initialize(param_description, argument)
        super(param_description)
        @type = argument
      end

      def validate(value)
        return false if value.nil?
        !(value.to_s =~ /^[-+]?[0-9]+$/).nil?
      end

      def self.build(param_description, argument, options, block)
        new(param_description, argument) if [Integer].include? argument
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
        return false unless value.is_a?(Rack::Test::UploadedFile) || value.is_a?(ActionDispatch::Http::UploadedFile)
        # Understand which sort of measure_file we are retrieving
        extension = File.extname(value.original_filename).downcase if value
        return Measures::MATMeasureFiles.valid_zip?(value) if extension == '.zip'
        false
      end

      def self.build(param_description, argument, options, block)
        new(param_description, argument) if argument == File
      end

      def description
        'Must be a valid MAT Export.'
      end
    end

    MEASURE_WHITELIST = %w[id cms_id continuous_variable created_at description episode_of_care hqmf_id hqmf_set_id hqmf_version_number title type updated_at].freeze
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
      param :measure_type, %w[eh ep], :required => false, :desc => "The type of the measure."
      param :calculation_type, %w[episode patient], :required => true, :desc => "The type of calculation."
      param :population_titles, Array, of: String, :required => false, :desc => "The titles of the populations. If this is not included, populations will assume default values. i.e. \"Population 1\", \"Population 2\", etc."
      param :calculate_sdes, %w[true false], :required => false, :desc => "Should Supplemental Data Elements be included in calculations. Defaults to 'false' if not supplied."

      param :vsac_tgt, String, :required => true, :desc => "VSAC ticket granting ticket. See https://www.nlm.nih.gov/vsac/support/"
      param :vsac_tgt_expires_at, Integer, :required => true, :desc => "VSAC ticket granting ticket expiration time in seconds since epoch."
      param :vsac_query_type, %w[release profile], :required => false, :desc => "The type of VSAC query, either 'release', or 'profile'. Default to 'profile' if not supplied."
      param :vsac_query_include_draft, %w[true false], :required => false, :desc => "If VSAC should fetch draft value sets. Defaults to 'true' if not supplied."
      param :vsac_query_release, String, :required => false, :desc => "The program release used to retrieve value sets. Defaults to latest release for the eCQM program."
      param :vsac_query_profile, String, :required => false, :desc => "The expansion profile used to retrieve value sets. Defaults to latest profile for the eCQM program."
      param :vsac_query_measure_defined, %w[true false], :required => false, :desc => "Option to override value sets with value sets defined in the measure. Default to 'false' if not supplied."
    end

    api :GET, '/measures', 'List of Measures'
    description 'Retrieve the list of measures for the authorized user.'
    formats [:json, :html]
    def index
      # TODO: filter by search parameters, for example an NQF ID or partial description
      @api_v1_measures = CQM::Measure.by_user(current_resource_owner).only(MEASURE_WHITELIST)
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

    api :GET, '/measures/:id', 'Read a Specific Measure'
    description 'Retrieve the details of a specific measure by HQMF Set ID.'
    param_group :measure
    def show
      hash = {}
      http_status = 200
      begin
        @api_v1_measure = CQM::Measure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).min_by { |m| m[:updated_at] }
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
        @api_v1_measure = CQM::Measure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).min_by(&:updated_at)
        # Extract out the HQMF set id, which we'll use to get related patients
        hqmf_set_id = @api_v1_measure.hqmf_set_id
        # Get the patients for this measure
        @api_v1_patients = CQM::Patient.by_user(current_resource_owner).where({:measure_ids.in => [hqmf_set_id]})
        @api_v1_patients = process_patients(@api_v1_patients)
      rescue StandardError
        http_status = 404
        @api_v1_patients = []
      end
      render json: @api_v1_patients, status: http_status
    end

    api :GET, '/measures/:id/calculated_results', 'Calculated Results for a Specific Measure'
    description 'Retrieve the calculated results of the measure logic for each patient.'
    param_group :measure
    error :code => 404, :desc => 'No measure found for this HQMF Set ID.'
    error :code => 406, :desc => 'Request response type is not acceptable.'
    error :code => 500, :desc => 'Error gathering the measure and associated patients and value sets.'
    error :code => 500, :desc => 'Error with the calculation service.'
    error :code => 500, :desc => 'Error generating the excel export.'
    formats [:xlsx]
    def calculated_results
      if request.headers['Accept'] != Mime::Type.lookup_by_extension(:xlsx)
        render json: {status: "error", messages: "Requested response type is not acceptable. Only #{Mime::Type.lookup_by_extension(:xlsx)} is accepted at this time."}, status: :not_acceptable
        return
      end

      begin
        @api_v1_measure = CQM::Measure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).min_by(&:updated_at)
        if @api_v1_measure.nil?
          render json: {status: "error", messages: "No measure found for this HQMF Set ID."}, status: :not_found
          return
        end
        hqmf_set_id = @api_v1_measure.hqmf_set_id
        @api_v1_patients = CQM::Patient.by_user(current_resource_owner).where({:measure_ids.in => [hqmf_set_id]})
      rescue StandardError => e
        # Email the error so we can see more details on what went wrong with the patient load.
        ExceptionNotifier::Notifier.exception_notification(env, e).deliver_now if defined? ExceptionNotifier::Notifier
        render json: {status: "error", messages: "Error gathering the measure and associated patients and value sets."}, status: :internal_server_error
        return
      end

      @calculator_options = { doPretty: true }
      begin
        calculated_results = BonnieBackendCalculator.calculate(@api_v1_measure, @api_v1_patients, @calculator_options)
      rescue StandardError => e
        # Email the error so we can see more details on what went wrong with the service.
        ExceptionNotifier::Notifier.exception_notification(env, e).deliver_now if defined? ExceptionNotifier::Notifier
        render json: {status: "error", messages: "Error with the calculation service."}, status: :internal_server_error
        return
      end

      begin
        converted_results = ExcelExportHelper.convert_results_for_excel_export(calculated_results, @api_v1_measure, @api_v1_patients)
        patient_details = ExcelExportHelper.get_patient_details(@api_v1_patients)
        population_details = ExcelExportHelper.get_population_details_from_measure(@api_v1_measure, calculated_results)
        statement_details = ExcelExportHelper.get_statement_details_from_measure(@api_v1_measure)
        filename = "#{@api_v1_measure.cms_id}.xlsx"
        excel_package = PatientExport.export_excel_cql_file(converted_results, patient_details, population_details, statement_details, hqmf_set_id)
        send_data excel_package.to_stream.read, type: Mime::Type.lookup_by_extension(:xlsx), filename: ERB::Util.url_encode(filename)
      rescue StandardError => e
        # Email the error so we can see more details on what went wrong with the excel creation.
        ExceptionNotifier::Notifier.exception_notification(env, e).deliver_now if defined? ExceptionNotifier::Notifier
        render json: {status: "error", messages: "Error generating the excel export."}, status: :internal_server_error
        return
      end
    end

    api :POST, '/measures', 'Upload a New Measure'
    description 'Uploading a new measure.'
    formats ["multipart/form-data"]
    error :code => 400, :desc => "Client sent bad parameters. Response contains explanation."
    error :code => 409, :desc => "Measure with this HQMF Set ID already exists."
    error :code => 500, :desc => "A server error occured."
    param_group :measure_upload
    def create
      permitted_params = params.permit!.to_h
      measures, main_hqmf_set_id = create_measure(uploaded_file: params[:measure_file],
                                                  measure_details: retrieve_measure_details(permitted_params),
                                                  value_set_loader: build_vs_loader(permitted_params, true),
                                                  user: current_resource_owner)

      render json: {status: "success", url: "/api_v1/measures/#{main_hqmf_set_id}"}, status: :ok
    rescue StandardError => e
      render turn_exception_into_shared_error_if_needed(e).back_end_version
    end

    api :PUT, '/measures/:id', 'Update an Existing Measure'
    description 'Updating an existing measure. This is a full update (e.g. no partial updates allowed).'
    formats ["multipart/form-data"]
    error :code => 400, :desc => "Client sent bad parameters. Response contains explanation."
    error :code => 404, :desc => "Measure with this HQMF Set ID does not exist."
    error :code => 500, :desc => "A server error occurred."
    param_group :measure_upload
    def update
      measures, main_hqmf_set_id = update_measure(uploaded_file: params[:measure_file],
                                                  target_id: params[:id],
                                                  value_set_loader: build_vs_loader(params.permit!.to_h, true),
                                                  user: current_resource_owner)

      render json: {status: "success", url: "/api_v1/measures/#{main_hqmf_set_id}"}, status: :ok
    rescue StandardError => e
      render turn_exception_into_shared_error_if_needed(e).back_end_version
    end

    private

    def retrieve_measure_details(params)
      return {
        'episode_of_care' => params[:calculation_type] == 'episode',
        'calculate_sdes' => params[:calculate_sdes].to_s == 'true',
        'population_titles' => params[:population_titles]
      }
    end

    def process_patients(selector)
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

    def error_parameter_missing(exception)
      param_name = exception.is_a?(Apipie::ParamMissing) ? exception.param.name : exception.param
      render json: {status: "error", messages: "Missing parameter: #{param_name}" }, status: :bad_request
    end

    def error_parameter_invalid(exception)
      render json: {status: "error", messages: "Invalid parameter '#{exception.param}': #{exception.error.gsub(%r{/<\/?code>/}, '')}" },
             status: :bad_request
    end

    def current_resource_owner
      return @current_resource_owner if @current_resource_owner.present?
      @current_resource_owner = User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      return @current_resource_owner
    end

  end
end
