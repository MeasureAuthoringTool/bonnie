require 'json' # TODO: remove when no longer loading results from json
class ApiV1::MeasuresController < ApplicationController
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
        return Measures::MATLoader.mat_export?(value)
      elsif extension == '.xml'
        return true
      else
        return false
      end
    end

    def self.build(param_description, argument, options, block)
      self.new(param_description, argument) if argument == File
    end

    def description
      'Must be a valid MAT Export or HQMF File.'
    end
  end
  
  class DateValidator < Apipie::Validator::BaseValidator
    def initialize(param_description, argument)
      super(param_description)
      @type = argument
    end
      
    def validate(value)
      Date.strptime(value,'%m/%d/%Y') rescue return false
      return true
    end

    def self.build(param_description, argument, options, block)
      self.new(param_description, argument) if argument == Date
    end

    def description
      'Must be a date in the form mm/dd/yyyy.'
    end
  end

  MEASURE_WHITELIST = ["id", "cms_id", "complexity", "continuous_variable", "created_at", "description", "episode_of_care", "hqmf_id", "hqmf_set_id", "hqmf_version_number", "title", "type", "updated_at"]
  PATIENT_WHITELIST = ["_id", "birthdate", "created_at", "deathdate", "description", "ethnicity", "expected_values", "expired", "first", "gender", "insurance_providers", "last", "notes", "race", "updated_at"]
  INSURANCE_WHITELIST = ["member_id","payer"]
  POPULATION_TYPES = ['population_index','STRAT','IPP','DENOM','NUMER','DENEXCEP','DENEX','MSRPOPL','OBSERV','MSRPOPLEX']

  respond_to :json, :html, :xlsx
  rescue_from Apipie::ParamMissing, :with => :error_parameter_missing
  rescue_from ActionController::ParameterMissing, :with => :error_parameter_missing
  rescue_from Apipie::ParamInvalid, :with => :error_parameter_invalid

  resource_description do
    formats [:json]
    api_versions '1'
    error :code => 401, :desc => 'Unauthorized'
    description <<-EOS
      This resource allows access to `Measures`, `Patients`, and calculated
      results for a given user.
    EOS
  end

  def_param_group :measure do
    param :id, String, :required => true, :desc => 'The HQMF Set ID of the Measure.'
    error :code => 404, :desc => 'Not Found'
  end
  
  def_param_group :measure_upload do
    param :measure_file, File, :required => true, :desc => "The measure file."
    param :measure_type, ["eh", "ep"], :required => true, :desc => "The type of the measure."
    param :calculation_type, ["episode", "patient"], :required => true, :desc => "The type of calculation."
    param :episode_of_care, Integer, :required => false, :desc => "The index of the episode of care. Defaults to 0. This means that the first specific occurence in the logic will be used for the episode of care calculation."
    param :population_titles, Array, of: String, :required => false, :desc => "The titles of the populations. If this is not included, populations will assume default values. i.e. \"Population 1\", \"Population 2\", etc."
    param :vsac_tgt, String, :required => false, :desc => "VSAC ticket granting ticket. Required when uploading a HQMF .xml measure."
    param :vsac_tgt_expires_at, Integer, :required => false, :desc => "VSAC ticket granting ticket expiration time in seconds since epoch. Required when uploading a HQMF .xml measure."
    param :include_draft, Boolean, :required => false, :desc => "If VSAC should fetch draft value sets. Defaults to 'true' if not supplied."
    param :vsac_date, Date, :required => false, :desc => "The lastest effective date for published value sets to retrieve. Required when include_draft is false."
  end

  api :GET, '/api_v1/measures', 'List of Measures'
  description 'Retrieve the list of measures for the authorized user.'
  formats [:json, :html]
  def index
    # TODO filter by search parameters, for example an NQF ID or partial description
    skippable_fields = [:map_fn, :hqmf_document, :oids, :population_ids]
    @api_v1_measures = Measure.by_user(current_resource_owner)
    respond_with @api_v1_measures do |format|
      format.json{ 
        render json: MultiJson.encode(
          @api_v1_measures.map do |x|
            h = x.measure_json
            h[:id] = x.hqmf_set_id
            skippable_fields.each{|f|h.delete(f)}
            h
          end
        )
      }
      format.html{ render :layout => false }
    end
  end

  api :GET, '/api_v1/measures/:id', 'Read a Specific Measure'
  description 'Retrieve the details of a specific measure by HQMF Set ID.'
  param_group :measure
  def show
    hash = {}
    http_status = 200
    begin
      @api_v1_measure = Measure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
      hash = @api_v1_measure.as_json
      hash[:id] = @api_v1_measure.hqmf_set_id
      hash.select!{|key,value|MEASURE_WHITELIST.include?(key)&&!value.nil?}
    rescue
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
      @api_v1_measure = Measure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
      # Extract out the HQMF set id, which we'll use to get related patients
      hqmf_set_id = @api_v1_measure.hqmf_set_id
      # Get the patients for this measure
      @api_v1_patients = Record.by_user(current_resource_owner).where({:measure_ids.in => [ hqmf_set_id ]})
      @api_v1_patients = process_patient_records(@api_v1_patients)
    rescue
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
      @api_v1_measure = Measure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
       # Extract out the HQMF set id, which we'll use to get related patients
      hqmf_set_id = @api_v1_measure.hqmf_set_id
      # Get the patients for this measure
      @api_v1_patients = Record.by_user(current_resource_owner).where({:measure_ids.in => [ hqmf_set_id ]})
    rescue
      http_status = 404
    end

    respond_with @api_v1_measure do |format|
      format.xlsx {
        if http_status != 404
          filename = 'Sample_Excel_Export(CMS52v6).xlsx'
          send_file "#{Rails.root}/public/resource/#{filename}", type: :xlsx, status: http_status, filename: URI.encode(filename)
        end
      }
      format.json {
        response = {}
        if http_status != 404

          response['status'] = 'complete'
          response['messages'] = []
          response['measure_id'] = params[:id]
          response['summary'] = []
          response['patient_count'] = @api_v1_patients.size
          response['patients'] = process_patient_records(@api_v1_patients)
          response['patients'].each{|p|p['actual_values']=[]}

          calculator = BonnieBackendCalculator.new

          @api_v1_measure.populations.each_with_index do |population,population_index|

            population_response = {}

            begin
              calculator.set_measure_and_population(@api_v1_measure, population_index, rationale: true)
            rescue => e
              response['status'] = 'error'
              response['messages'] << "Measure setup exception: #{e.message}"
            end

            if response['status']!='error'
              @api_v1_patients.each do |patient|
                # Generate the calculated rationale for each patient against the measure.
                begin
                  patient_result = calculator.calculate(patient)
                  patient_hash = response['patients'].select{|i|i['_id']==patient.id}.first
                  actual_values = patient_result.select{|k,v|POPULATION_TYPES.include?(k)}
                  patient_hash['actual_values'] << actual_values
                  population_response.merge!(actual_values){|k,i,j|i+j}
                rescue Exception => e
                  response['status'] = 'error'
                  response['messages'] << "Measure calculation exception: #{e.message}"
                end
              end
              population_response.delete('measure_id')
              response['summary'] << population_response
            end
          end

          http_status = 500 if response['status'] == 'error'
        end

        response.delete('messages') if !response['messages'].nil? && response['messages'].empty?
        render json: response, status: http_status

      }
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
    existing = Measure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]})
    if existing.count == 0
      render json: {status: "error", messages: "No measure found for this HQMF Set ID."},
           status: :not_found
      return
    end
    
    load_measure(params, true)
  end

  private 
  def process_patient_records(selector)
    patients = selector.map{|p|p.as_json}
    patients.each do |p|
      p.select!{|key,value|PATIENT_WHITELIST.include?(key)&&!value.nil?}
      if !p["insurance_providers"].nil?
        p["insurance_providers"].map! do |hash|
          hash.select!{|k,v|INSURANCE_WHITELIST.include?(k) && !v.nil?}
          hash["payer"] = hash["payer"]["name"] if hash["payer"]
          hash
        end
      end
      if !p["expected_values"].nil?
        p["expected_values"].map! do |hash|
          hash.select!{|k,v|POPULATION_TYPES.include?(k) && !v.nil?}
        end
      end
      p["birthdate"] = Time.at(p["birthdate"]).iso8601 if p["birthdate"]
      p["deathdate"] = Time.at(p["deathdate"]).iso8601 if p["deathdate"]
    end
    patients
  end
  
  def load_measure(params, is_update)
    # Understand which sort of measure_file we are retrieving
    extension = File.extname(params[:measure_file].original_filename).downcase if params[:measure_file]
    
    begin
      
      measure_details = {
        'type' => params[:measure_type],
        'episode_of_care' => params[:calculation_type] == 'episode'
      }
      # If it is a MAT export
      if extension == '.zip'
        measure = load_mat_export(params, measure_details)
        
      # If it is a measure file.
      elsif extension == '.xml'
        measure = load_hqmf_xml(params, measure_details)
      end
      
      #if its an update make sure we are actually updating the proper one
      if is_update && measure.hqmf_set_id != params[:id]
        render json: {status: "error", messages: "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure."},
             status: :bad_request
        return
      end
      
      # Handle episode of care measurements.
      if params['calculation_type'] == 'episode'
        specific_occurrences = measure.source_data_criteria.values.select {|d| d['specific_occurrence']}
        
        # if there are no specific_occurrences then episode of care cannot be measured.
        if specific_occurrences.empty?
          measure.delete
          render json: {status: "error", messages: "Episode of care calculation was specified. Episode of care measures require at lease one data element that is a specific occurrence.  Please add a specific occurrence data element to the measure logic."},
               status: :bad_request
          return
        else
          eocIndex = params.fetch('episode_of_care', '0').to_i
          if eocIndex >= specific_occurrences.length
            render json: {status: "error", messages: "The episode_of_care index is out of bounds of the set of specific occurrences found in the mesasure."},
                 status: :bad_request
            return
          end
          measure.update_attributes({episode_ids: [specific_occurrences[eocIndex]["source_data_criteria"]]})
        end
      end
      
      # exclude patient birthdate and expired OIDs used by SimpleXML parser for AGE_AT handling and bad oid protection in missing VS check
      missing_value_sets = (measure.as_hqmf_model.all_code_set_oids - measure.value_set_oids - ['2.16.840.1.113883.3.117.1.7.1.70', '2.16.840.1.113883.3.117.1.7.1.309'])
      if missing_value_sets.length > 0
        measure.delete
        render json: {status: "error", messages: "The measure you have tried to load is missing value sets. Try re-packaging and re-exporting the measure from the Measure Authoring Tool.  The following value sets are missing: [#{missing_value_sets.join(', ')}]"},
             status: :bad_request
        return
      end
      
      # Handle population naming. Make default names if none or not enough were provided.
      if measure.populations.size > 1
        pop_titles = params.fetch('population_titles', [])
        strat_index = 0
        measure.populations.each.with_index do |population, index|
          if (population[HQMF::PopulationCriteria::STRAT])
            population['title'] = pop_titles.fetch(index, "Stratification #{strat_index + 1}")
            strat_index += 1
          elsif index < pop_titles.size
            population['title'] = pop_titles.fetch(index)
          end
        end
      end
      
    rescue Measures::ValueSetException
      render json: {status: "error", messages: "The measure value sets could not be found. Please re-package the measure in the MAT and make sure &quot;VSAC Value Sets&quot; are included in the package, then re-export the MAT Measure bundle." },
           status: :bad_request
      return
    rescue Measures::VSACException => e
      render json: {status: "error", messages: e.message },
           status: :internal_server_error
      return
    rescue Exception => e
      raise e
      #render json: {status: "error", messages: e }, status: :error
      #return
    end
    
    existing = Measure.by_user(current_resource_owner).where(hqmf_set_id: measure.hqmf_set_id)
    if is_update
      existing_measure = existing.first
      existing_measure.delete
    else
      # Make sure we didn't create a duplicate measure
      if existing.count > 1
        measure.delete
        render json: {status: "error", messages: "A measure with this HQMF Set ID already exists.", url: "/api_v1/measures/#{measure.hqmf_set_id}"},
               status: :conflict
        return
      end
    end
    Measures::ADEHelper.update_if_ade(measure)
    measure.generate_js
    measure.save!

    render json: {status: "success", url: "/api_v1/measures/#{measure.hqmf_set_id}"},
           status: :ok

  end
  
  def load_mat_export(params, measure_details)
    measure = Measures::MATLoader.load(params[:measure_file], current_resource_owner, measure_details)
  end
  
  def load_hqmf_xml(params, measure_details)
    # VSAC info is required
    params.require(:vsac_tgt)
    params.require(:vsac_tgt_expires_at)
    tgt_expires_at = Time.at(params[:vsac_tgt_expires_at].to_i)
    if tgt_expires_at < Time.now
      raise Measures::VSACException.new("VSAC ticket granting ticket appears to have expired.")
    end

    includeDraft = params.fetch(:include_draft, true)
    params.require(:vsac_date) unless includeDraft
    effectiveDate = nil
    unless includeDraft
      effectiveDate = Date.strptime(params[:vsac_date],'%m/%d/%Y').strftime('%Y%m%d')
    end
    
    measure = Measures::SourcesLoader.load_measure_xml(params[:measure_file].tempfile.path, current_resource_owner, nil, nil, measure_details, true, false, effectiveDate, includeDraft, params[:vsac_tgt])
  end
  
  def error_parameter_missing(exception)
    param_name = exception.is_a?(Apipie::ParamMissing) ? exception.param.name : exception.param
    
    render json: {status: "error", messages: "Missing parameter: #{param_name}" },
           status: :bad_request
  end
  
  def error_parameter_invalid(exception)
    render json: {status: "error", messages: "Invalid parameter '#{exception.param}': #{exception.error.gsub(/<\/?code>/, '')}" },
           status: :bad_request
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

end
