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

  api :GET, '/api_v1/measures', 'List of Measures'
  description 'Retrieve the list of measures for the authorized user.'
  formats [:json, :html]
  def index
    # TODO filter by search parameters, for example an NQF ID or partial description
    skippable_fields = [:map_fn, :hqmf_document, :oids, :population_ids]
    @api_v1_measures = CqlMeasure.by_user(current_resource_owner)
    respond_with @api_v1_measures do |format|
      format.json{ 
        render json: MultiJson.encode(
          @api_v1_measures.map do |x|
            h = x
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
      @api_v1_measure = CqlMeasure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
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
      @api_v1_measure = CqlMeasure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
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
      @api_v1_measure = CqlMeasure.by_user(current_resource_owner).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
       # Extract out the HQMF set id, which we'll use to get related patients
      hqmf_set_id = @api_v1_measure.hqmf_set_id
      # Get the patients for this measure
      @api_v1_patients = Record.by_user(current_resource_owner).where({:measure_ids.in => [ hqmf_set_id ]})
    rescue
      http_status = 404
    end

    if request.headers['Accept'] == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      if http_status != 404
        filename = 'Sample_Excel_Export(CMS52v6).xlsx'
        send_file "#{Rails.root}/public/resource/#{filename}", type: :xlsx, status: http_status, filename: URI.encode(filename)
      end
    end
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
