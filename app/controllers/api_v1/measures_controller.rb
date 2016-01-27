class ApiV1::MeasuresController < ApplicationController

  MEASURE_WHITELIST = ["id", "cms_id", "complexity", "continuous_variable", "created_at", "description", "episode_of_care", "hqmf_id", "hqmf_set_id", "hqmf_version_number", "title", "type", "updated_at"]
  PATIENT_WHITELIST = ["_id", "birthdate", "created_at", "deathdate", "description", "ethnicity", "expected_values", "expired", "first", "gender", "insurance_providers", "last", "notes", "race", "updated_at"]
  INSURANCE_WHITELIST = ["member_id","payer"]
  POPULATION_TYPES = ['population_index','STRAT','IPP','DENOM','NUMER','DENEXCEP','DENEX','MSRPOPL','OBSERV','MSRPOPLEX']

  respond_to :json, :html
  rescue_from ActionController::ParameterMissing, :with => :error_parameter_missing

  resource_description do
    formats [:json]
    api_versions '1'
    error :code => 401, :desc => 'Unauthorized'
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
    @api_v1_measures = Measure.by_user(current_user)
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
      @api_v1_measure = Measure.by_user(current_user).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
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
      @api_v1_measure = Measure.by_user(current_user).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
      # Extract out the HQMF set id, which we'll use to get related patients
      hqmf_set_id = @api_v1_measure.hqmf_set_id
      # Get the patients for this measure
      @api_v1_patients = Record.by_user(current_user).where({:measure_ids.in => [ hqmf_set_id ]})
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
  def calculated_results
    http_status = 200
    response = {}

    begin
      # Get the measure
      @api_v1_measure = Measure.by_user(current_user).where({:hqmf_set_id=> params[:id]}).sort_by{|x|x.updated_at}.first
       # Extract out the HQMF set id, which we'll use to get related patients
      hqmf_set_id = @api_v1_measure.hqmf_set_id
      # Get the patients for this measure
      @api_v1_patients = Record.by_user(current_user).where({:measure_ids.in => [ hqmf_set_id ]})
    rescue
      http_status = 404
    end

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
  end

  api :POST, '/api_v1/measures', 'Create a New Measure'
  description 'Creating a new measure.'
  def create
    # ensure required params exist
    params.require(:measure_file)
    params.require(:measure_type)
    params.require(:calculation_type)
    
    # ensure other required params have valid values
    if !['eh', 'ep'].include?(params[:measure_type])
      render json: {status: "error", messages: "Invalid value: measure_type must be 'eh' or 'ep'."},
             status: :bad_request
      return
    end
    
    if !['episode', 'patient'].include?(params[:calculation_type])
      render json: {status: "error", messages: "Invalid value: calculation_type must be 'patient' or 'episode'."},
             status: :bad_request
      return
    end
    
    # Ensure that measure_file is indeed a file
    if !params[:measure_file].respond_to?('original_filename')
      # return with an error and 400 status
      render json: {status: "error", messages: "Invalid parameter: measure_file must be a file" },
             status: :bad_request
      return
    end
    measure_file = params[:measure_file]
    
    # Understand which sort of measure_file we are retrieving
    extension = File.extname(params[:measure_file].original_filename).downcase if params[:measure_file]
    
    begin
      # See if it is a MAT Export and try loading it.
      if extension == '.zip'
        if !Measures::MATLoader.mat_export?(params[:measure_file])
          render json: {status: "error", messages: "measure_file does not appear to be a MAT export." },
                 status: :bad_request
          return
        else
          measure = load_mat_export(params)
        end
        
      # If it is a measure file.
      elsif extension == '.xml'
        # VSAC info is required
        params.require(:vsac_username)
        params.require(:vsac_password)
        include_draft = params.fetch(:include_draft, true)
        params.require(:vsac_date) unless include_draft
        
        
      else
        render json: {status: "error", messages: "Incorrect measure_file format." },
               status: :bad_request
        return
      end

    rescue Exception => e
      render json: {status: "error", messages: e }
      return
    end
    
    render json: {status: "success", url: "/api_v1/measures/#{measure.hqmf_set_id}"}, status: :ok
  end

  api :PUT, '/api_v1/measures/:id', 'Update an Existing Measure'
  description 'Updating an existing measure. This is a full update (e.g. no partial updates allowed).'
  param_group :measure
  def update
    # TODO
    # TODO: update test/controllers/api_v1/measures_controller_test.rb::test "should update api_v1_measure"
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
  
  def load_mat_export(params)
    measure_details = {
      'type' => params[:measure_type],
      'episode_of_care' => params[:calculation_type]
    }
    measure = Measures::MATLoader.load(params[:measure_file], current_user, measure_details)
  end
  
  def error_parameter_missing(exception)
    render json: {status: "error", messages: "Missing parameter: #{exception.param}" },
           status: :bad_request
  end

end
