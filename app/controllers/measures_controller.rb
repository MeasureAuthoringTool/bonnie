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
      @measure_json = MultiJson.encode(@measure.as_json(except: skippable_fields))
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
     'episode_of_care'=>params[:calculation_type] == 'episode'
    }

    extension = File.extname(params[:measure_file].original_filename).downcase if params[:measure_file]
    if !extension || extension != '.zip'
        flash[:error] = {title: "Error Loading Measure", summary: "Incorrect Upload Format.", body: "The file you have uploaded does not appear to be a Measure Authoring Tool zip export of a measure. Please re-export your measure from the MAT and select the 'eMeasure Package'."}
        redirect_to "#{root_path}##{params[:redirect_route]}"
        return
    else
      if !Measures::CqlLoader.mat_cql_export?(params[:measure_file])
        flash[:error] = {title: "Error Uploading Measure", summary: "The uploaded zip file is not a valid Measure Authoring Tool export of a CQL Based Measure.", body: "You have uploaded a zip file that does not appear to be a Measure Authoring Tool CQL zip file please re-export your measure from the MAT and select the 'eMeasure Package' option. Please use https://bonnie.healthit.gov/ for QDM-Logic Based measures."}
        redirect_to "#{root_path}##{params[:redirect_route]}"
        return
      elsif !Measures::CqlLoader.mat_cql_export?(params[:measure_file])
        flash[:error] = {title: "Error Uploading Measure", summary: "The uploaded zip file is not a Measure Authoring Tool export.", body: "You have uploaded a zip file that does not appear to be a Measure Authoring Tool zip file please re-export your measure from the MAT and select the 'eMeasure Package' option"}
        redirect_to "#{root_path}##{params[:redirect_route]}"
        return
      end
    end
    #If we get to this point, then the measure that is being uploaded is a MAT export of CQL
    begin
      # Default to valid set of values for vsac request.
      includeDraft = true
      # All measure uploads require vsac credentials, except certain test cases.
      # Added a check for vsac_username before checking for include draft and vsac_date.
      if params[:vsac_username]
        # If the measure is published (includesDraft = false)
        # EffectiveDate is specified to determine a value set version.
        includeDraft = params[:include_draft] == 'true'
      end

      is_update = false
      if (params[:hqmf_set_id] && !params[:hqmf_set_id].empty?)
        existing = CqlMeasure.by_user(current_user).where(hqmf_set_id: params[:hqmf_set_id]).first
        is_update = true
        measure_details['type'] = existing.type
        measure_details['episode_of_care'] = existing.episode_of_care
        if measure_details['episode_of_care']
          episodes = params["eoc_#{existing.hqmf_set_id}"]
        end
        measure_details['population_titles'] = existing.populations.map {|p| p['title']} if existing.populations.length > 1
      end

      measure = Measures::CqlLoader.load(params[:measure_file], current_user, measure_details, params[:vsac_username], params[:vsac_password], false, false, includeDraft, get_ticket_granting_ticket) # Note: overwrite_valuesets=false cache=false

      if (!is_update)
        existing = CqlMeasure.by_user(current_user).where(hqmf_set_id: measure.hqmf_set_id).first
        if !existing.nil?
          measure.delete
          flash[:error] = {title: "Error Loading Measure", summary: "A version of this measure is already loaded.", body: "You have a version of this measure loaded already.  Either update that measure with the update button, or delete that measure and re-upload it."}
          redirect_to "#{root_path}##{params[:redirect_route]}"
          return
        end
      else
        if existing.hqmf_set_id != measure.hqmf_set_id
          measure.delete
          flash[:error] = {title: "Error Updating Measure", summary: "The update file does not match the measure.", body: "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure."}
          redirect_to "#{root_path}##{params[:redirect_route]}"
          return
        end
      end

      # exclude patient birthdate and expired OIDs used by SimpleXML parser for AGE_AT handling and bad oid protection in missing VS check
      missing_value_sets = (measure.as_hqmf_model.all_code_set_oids - measure.value_set_oids - ['2.16.840.1.113883.3.117.1.7.1.70', '2.16.840.1.113883.3.117.1.7.1.309'])
      if missing_value_sets.length > 0
        measure.delete
        flash[:error] = {title: "Measure is missing value sets", summary: "The measure you have tried to load is missing value sets.", body: "The measure you are trying to load is missing value sets.  Try re-packaging and re-exporting the measure from the Measure Authoring Tool.  The following value sets are missing: [#{missing_value_sets.join(', ')}]"}
        redirect_to "#{root_path}##{params[:redirect_route]}"
        return
      end
      existing.delete if (existing && is_update)
    rescue Exception => e
      measure.delete if measure
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
      if e.is_a? Measures::VSACException
        operator_error = true
        flash[:error] = {title: "Error Loading VSAC Value Sets", summary: "VSAC value sets could not be loaded.", body: "Please verify that you are using the correct VSAC username and password. #{e.message}"}
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

    current_user.measures << measure
    current_user.save!

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

    # rebuild the users patients if set to do so
    if params[:rebuild_patients] == "true"
      Record.by_user(current_user).each do |r|
        Measures::PatientBuilder.rebuild_patient(r)
        r.save!
      end
    end

    # ensure expected values on patient match those in the measure's populations
    Record.where(user_id: current_user.id, measure_ids: measure.hqmf_set_id).each do |patient|
      patient.update_expected_value_structure!(measure)
    end

    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  def vsac_auth_valid
    # If VSAC TGT is still valid, return its expiration date/time
    tgt = session[:tgt]
    if tgt.nil? || tgt.empty? || tgt[:expires] < Time.now
      render :json => {valid: false}
    else
      render :json => {valid: true, expires: tgt[:expires]}
    end
  end

  def vsac_auth_expire
    # Force expire the VSAC session
    session[:tgt] = nil
    render :json => {}
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
    tgt = session[:tgt]

    # If the ticket granting ticket doesn't exist (or has expired), get a new one
    if tgt.nil? || tgt.empty? || tgt[:expires] < Time.now
      # Retrieve a new ticket granting ticket
      begin
        ticket = String.new(HealthDataStandards::Util::VSApi.get_tgt_using_credentials(
          params[:vsac_username],
          params[:vsac_password],
          APP_CONFIG['nlm']['ticket_url']
        ))
      rescue Exception
        # Given username and password are invalid, ticket cannot be created
        return nil
      end
      # Create a new ticket granting ticket session variable that expires
      # 7.5hrs from now
      if !ticket.nil? && !ticket.empty?
        session[:tgt] = {ticket: ticket, expires: Time.now + 27000}
        ticket
      end
    else
      tgt[:ticket]
    end
  end

end
