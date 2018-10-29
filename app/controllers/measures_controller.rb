class MeasuresController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:show, :value_sets]

  respond_to :json, :js, :html

  def show
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    # Lookup the measure both in the regular and CQL sets
    # TODO: Can we skip the elm if it's CQL?
    @measure = Measure.by_user(current_user).without(*skippable_fields).where(id: params[:id]).first
    @measure ||= CqlMeasure.by_user(current_user).without(*skippable_fields).where(id: params[:id]).first
    raise Mongoid::Errors::DocumentNotFound unless @measure
    if stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
      raw_json = @measure.as_json(except: skippable_fields)
      # fix up statement names in cql_statement_dependencies to use original periods <<UNWRAP 1>>
      # this is matched with a WRAP in process_cql in the bonnie_bundler project
      Measures::MongoHashKeyWrapper::unwrapKeys raw_json['cql_statement_dependencies'] if raw_json.has_key?('cql_statement_dependencies')
      @measure_json = MultiJson.encode(raw_json)
      respond_with @measure do |format|
        format.json { render json: @measure_json }
      end
    end
  end

  def value_sets
    # Caching of value sets is (temporarily?) disabled to correctly handle cases where users use multiple accounts
    # if stale? last_modified: Measure.by_user(current_user).max(:updated_at).try(:utc)
    if true
      value_set_oids = Measure.by_user(current_user).only(:value_set_oids).pluck(:value_set_oids).flatten.uniq
      value_set_oids += CqlMeasure.by_user(current_user).only(:value_set_oids).pluck(:value_set_oids).flatten.uniq

      # Not the cleanest code, but we get a many second performance improvement by going directly to Moped
      # (The two commented lines are functionally equivalent to the following three uncommented lines, if slower)
      # value_sets_by_oid = HealthDataStandards::SVS::ValueSet.in(oid: value_set_oids).index_by(&:oid)
      # @value_sets_by_oid_json = MultiJson.encode(value_sets_by_oid.as_json(except: [:_id, :code_system, :code_system_version]))
      value_sets = Mongoid::Clients.default[HealthDataStandards::SVS::ValueSet.collection_name].find({oid: { '$in' => value_set_oids }, user_id: current_user.id}, {'concepts.code_system' => 0, 'concepts.code_system_version' => 0})

      value_set_map = {}
      value_sets.each do |vs|
        if !value_set_map.key?(vs['oid'])
          value_set_map[vs['oid']] = {}
        end
        value_set_map[vs['oid']][vs['version']] = vs
      end
      @value_sets_by_oid_json = MultiJson.encode value_set_map

      respond_with @value_sets_by_oid_json do |format|
        format.json { render json: @value_sets_by_oid_json }
      end
    end
  end

  def create
    if !params[:measure_file]
      flash[:error] = {title: "Error Loading Measure", body: "You must specify a Measure Authoring tool measure export to use."}
      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    end

    measure_details = {
     'type'=>params[:measure_type],
     'episode_of_care'=>params[:calculation_type] == 'episode',
     'calculate_sdes'=>params[:calc_sde]
    }

    extension = File.extname(params[:measure_file].original_filename).downcase if params[:measure_file]
    if !extension || extension != '.zip'
      flash[:error] = {title: "Error Loading Measure",
        summary: "Incorrect Upload Format.",
        body: 'The file you have uploaded does not appear to be a Measure Authoring Tool (MAT) zip export of a measure. Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href="https://bonnie-qdm.healthit.gov">Bonnie-QDM</a>.'.html_safe}
      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    elsif !Measures::CqlLoader.mat_cql_export?(params[:measure_file])
      flash[:error] = {title: "Error Uploading Measure",
        summary: "The uploaded zip file is not a valid Measure Authoring Tool (MAT) export of a CQL Based Measure.",
        body: 'Please re-package and re-export your measure from the MAT.<br/>If this is a QDM-Logic Based measure, please use <a href="https://bonnie-qdm.healthit.gov">Bonnie-QDM</a>.'.html_safe}
      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    end
    #If we get to this point, then the measure that is being uploaded is a MAT export of CQL
    begin
      # parse VSAC options using helper and get ticket_granting_ticket which is always needed
      vsac_options = MeasureHelper.parse_vsac_parameters(params)
      vsac_ticket_granting_ticket = get_ticket_granting_ticket

      is_update = false
      if (params[:hqmf_set_id] && !params[:hqmf_set_id].empty?)
        existing = CqlMeasure.by_user(current_user).where(hqmf_set_id: params[:hqmf_set_id]).first
        if !existing.nil?
          is_update = true
          measure_details['type'] = existing.type
          measure_details['episode_of_care'] = existing.episode_of_care
          if measure_details['episode_of_care']
            episodes = params["eoc_#{existing.hqmf_set_id}"]
          end
          measure_details['calculate_sdes'] = existing.calculate_sdes
          measure_details['population_titles'] = existing.populations.map {|p| p['title']} if existing.populations.length > 1    
        else
          raise Exception.new('Update requested, but measure does not exist.')
        end
      end
      # Extract measure(s) from zipfile
      measures = Measures::CqlLoader.extract_measures(params[:measure_file], current_user, measure_details, vsac_options, vsac_ticket_granting_ticket)
      update_error_message = MeasureHelper.update_measures(measures, current_user, is_update, existing)
      if (!update_error_message.nil?)
        flash[:error] = update_error_message
        redirect_to "#{root_path}##{params[:redirect_route]}"
        return
      end
    rescue Exception => e
      measures.each(&:delete) if measures
      errors_dir = Rails.root.join('log', 'load_errors')
      FileUtils.mkdir_p(errors_dir)
      clean_email = File.basename(current_user.email) # Prevent path traversal

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
        operator_error = true
        flash[:error] = MeasureHelper.build_vsac_error_message(e)

        # also clear the ticket granting ticket in the session if it was a VSACTicketExpiredError
        session[:vsac_tgt] = nil if e.is_a?(Util::VSAC::VSACTicketExpiredError)
      elsif e.is_a? Measures::MeasureLoadingException
        operator_error = true
        flash[:error] = {title: "Error Loading Measure", summary: "The measure could not be loaded", body:"There may be an error in the CQL logic."}
      else
        flash[:error] = {title: "Error Loading Measure", summary: "The measure could not be loaded.", body: "Bonnie has encountered an error while trying to load the measure."}
      end

      # email the error
      if !operator_error && defined? ExceptionNotifier::Notifier
        params[:error_file] = filename
        ExceptionNotifier::Notifier.exception_notification(env, e).deliver_now
      end

      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    end

    MeasureHelper.measures_population_update(measures, is_update, current_user, measure_details)

    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  def destroy
    qdm_measure = Measure.by_user(current_user).where(id: params[:id]).first
    cql_measure  = CqlMeasure.by_user(current_user).where(id: params[:id]).first

    if qdm_measure
      measure = qdm_measure
      Measure.by_user(current_user).find(params[:id]).destroy
    end
    if cql_measure
      measure = cql_measure
      if measure.component
        # Throw error since component can't be deleted individually
        render status: :bad_request, json: {error: "Component measures can't be deleted individually."}
        return
      elsif measure.composite
        # If the measure if a composite, delete all the associated components
        measure.component_hqmf_set_ids.each do |component_hqmf_set_id|
          CqlMeasure.by_user(current_user).where(hqmf_set_id: component_hqmf_set_id).destroy
        end
      end
      CqlMeasure.by_user(current_user).find(params[:id]).destroy
    end
    render :json => measure
  end

  def finalize
    measure_finalize_data = params.values.select {|p| p['hqmf_id']}.uniq
    measure_finalize_data.each do |data|
      measure = CqlMeasure.by_user(current_user).where(hqmf_id: data['hqmf_id']).first
      begin
        measure.populations.each_with_index do |population, population_index|
          population['title'] = data['titles']["#{population_index}"] if (data['titles'])
        end
      rescue Exception => e
        operator_error = true
        flash[:error] = {title: "Error Loading Measure", summary: "Error Finalizing Measure", body: "An unexpected error occurred while finalizing this measure.  Please delete the measure, re-package and re-export the measure from the MAT, and re-upload the measure."}
      ensure
        # These 2 steps need to be run even if there was an error, otherwise there will be an infinite loop with the finalize dialog
        measure['needs_finalize'] = false
        measure.save!
      end
    end
    redirect_to root_path
  end

  def debug
    @measure = Measure.by_user(current_user).without(:map_fns, :record_ids).find(BSON::ObjectId.from_string(ActionController::Base.helpers.escape_once(params[:id])))
    @patients = Record.by_user(current_user).asc(:last, :first)
    render layout: 'debug'
  end

  def clear_cached_javascript
    measure = Measure.by_user(current_user).find(params[:id])
    measure.generate_js clear_db_cache: true
    redirect_to :back
  end

  # This is a fairly simple passthrough to a back-end service, which we use to simplify server configuration
  def cql_to_elm
    begin
      render json: RestClient.post('http://localhost:8080/cql/translator',
                                   params[:cql],
                                   content_type: 'application/cql',
                                   accept: 'application/elm+json')
    rescue RestClient::BadRequest => e
      render json: e.response, :status => 400
    end
  end

  private

  def get_ticket_granting_ticket
    # Retreive a (possibly) existing ticket granting ticket
    ticket_granting_ticket = session[:vsac_tgt]

    # If the ticket granting ticket doesn't exist (or has expired), get a new one
    if ticket_granting_ticket.nil?
      # The user could open a second browser window and remove their ticket_granting_ticket in the session after they
      # prepeared a measure upload assuming ticket_granting_ticket in the session in the first tab

      # First make sure we have credentials to attempt getting a ticket with. Throw an error if there are no credentials.
      if params[:vsac_username].nil? || params[:vsac_password].nil?
        raise Util::VSAC::VSACNoCredentialsError.new
      end

      # Retrieve a new ticket granting ticket by creating the api class.
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], username: params[:vsac_username], password: params[:vsac_password])
      ticket_granting_ticket = api.ticket_granting_ticket

      # Create a new ticket granting ticket session variable
      session[:vsac_tgt] = ticket_granting_ticket
      return ticket_granting_ticket

    # If it does exist, let the api test it
    else
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], ticket_granting_ticket: ticket_granting_ticket)
      return api.ticket_granting_ticket
    end
  end

end
