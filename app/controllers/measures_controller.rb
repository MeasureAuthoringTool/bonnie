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
      value_sets = Mongoid::Sessions.default[HealthDataStandards::SVS::ValueSet.collection_name].find(oid: { '$in' => value_set_oids }, user_id: current_user.id)
      value_sets = value_sets.select('concepts.code_system' => 0, 'concepts.code_system_version' => 0)
      @value_sets_by_oid_json = MultiJson.encode value_sets.index_by { |vs| vs['oid'] }

      respond_with @value_sets_by_oid_json do |format|
        format.json { render json: @value_sets_by_oid_json }
      end
    end
  end

  def create
    measure_details = {
     'type'=>params[:measure_type],
     'episode_of_care'=>params[:calculation_type] == 'episode'
    }

    extension = File.extname(params[:measure_file].original_filename).downcase if params[:measure_file]
    if extension && !['.zip', '.xml'].include?(extension)
        flash[:error] = {title: "Error Loading Measure", summary: "Incorrect Upload Format.", body: "The file you have uploaded does not appear to be a Measure Authoring Tool zip export of a measure or HQMF XML measure file. Please re-export your measure from the MAT and select the 'eMeasure Package' option, or select the correct HQMF XML file."}
        redirect_to "#{root_path}##{params[:redirect_route]}"
        return
    elsif extension == '.zip'
      if !Measures::MATLoader.mat_export?(params[:measure_file])
        flash[:error] = {title: "Error Uploading Measure", summary: "The uploaded zip file is not a Measure Authoring Tool export.", body: "You have uploaded a zip file that does not appear to be a Measure Authoring Tool zip file. If the zip file contains HQMF XML, please unzip the file and upload the HQMF XML file instead of the zip file. Otherwise, please re-export your measure from the MAT and select the 'eMeasure Package' option"}
        redirect_to "#{root_path}##{params[:redirect_route]}"
        return
      end
    end
    begin
      # Default to valid set of values for vsac request.
      effectiveDate = nil
      includeDraft = true
      # All measure uploads require vsac credentials, except certain test cases.
      # Added a check for vsac_username before checking for include draft and vsac_date.
      if params[:vsac_username]
        # If the measure is published (includesDraft = false)
        # EffectiveDate is specified to determine a value set version.
        includeDraft = params[:include_draft] == 'true'
        unless includeDraft
          effectiveDate = Date.strptime(params[:vsac_date],'%m/%d/%Y').strftime('%Y%m%d')
        end
      end
      # If file extension is a zip and a CQL MAT export
      is_cql = false
      if extension == '.zip' && Measures::CqlLoader.mat_cql_export?(params[:measure_file])
        is_cql = true

        measure = Measures::MATLoader.load(params[:measure_file], current_user, measure_details, params[:vsac_username], params[:vsac_password], true, false, effectiveDate, includeDraft, get_ticket_granting_ticket) # Note: overwrite_valuesets=true, cache=false
        existing = CqlMeasure.by_user(current_user).where(hqmf_set_id: measure.hqmf_set_id)
        # Check if there is already a CQL measure with the given hqmf_set_id, this is intentionally different than checking if qdm based is already uploaded (>0 vs >1)
        # TODO: Duplication checks should be more smoothly managed before CQL is fully incorperated
        if existing.count > 0
          flash[:error] = {title: "Error Loading Measure", summary: "A version of this measure is already loaded.", body: "You have a version of this measure loaded already.  Try deleting that measure and re-uploading it."}
          redirect_to "#{root_path}##{params[:redirect_route]}"
          return
        end
      else
        is_update = false
        if (params[:hqmf_set_id] && !params[:hqmf_set_id].empty?)
          is_update = true
          existing = Measure.by_user(current_user).where(hqmf_set_id: params[:hqmf_set_id]).first
          measure_details['type'] = existing.type
          measure_details['episode_of_care'] = existing.episode_of_care
          if measure_details['episode_of_care']
            episodes = params["eoc_#{existing.hqmf_set_id}"]
            if episodes && episodes['episode_ids'] && !episodes['episode_ids'].empty?
              measure_details['episode_ids'] = episodes['episode_ids']
            else
              measure_details['episode_ids'] = existing.episode_ids
            end
          end

          measure_details['population_titles'] = existing.populations.map {|p| p['title']} if existing.populations.length > 1
        end

        if extension == '.xml'
          measure = Measures::SourcesLoader.load_measure_xml(params[:measure_file].tempfile.path, current_user, params[:vsac_username], params[:vsac_password], measure_details, true, false, effectiveDate, includeDraft, get_ticket_granting_ticket) # overwrite_valuesets=true, cache=false, includeDraft=true
        else
          measure = Measures::MATLoader.load(params[:measure_file], current_user, measure_details)
        end

        if (!is_update)
          existing = Measure.by_user(current_user).where(hqmf_set_id: measure.hqmf_set_id)
          if existing.count > 1
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

        if measure_details['episode_of_care'] && measure.data_criteria.values.select {|d| d['specific_occurrence']}.empty?
          measure.delete
          flash[:error] = {title: "Error Loading Measure", summary: "An episode of care measure requires at least one specific occurrence for the episode of care.", body: "You have loaded the measure as an episode of care measure.  Episode of care measures require at lease one data element that is a specific occurrence.  Please add a specific occurrence data element to the measure logic."}
          redirect_to "#{root_path}##{params[:redirect_route]}"
          return
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
      end
    rescue Exception => e
      if params[:measure_file]
        measure.delete if measure
        errors_dir = Rails.root.join('log', 'load_errors')
        FileUtils.mkdir_p(errors_dir)
        clean_email = File.basename(current_user.email) # Prevent path traversal
        filename = "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}#{extension}"

        operator_error = false # certain types of errors are operator errors and do not need to be emailed out.
        FileUtils.cp(params[:measure_file].tempfile, File.join(errors_dir, filename))
        File.chmod(0644, File.join(errors_dir, filename))
        File.open(File.join(errors_dir, "#{clean_email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.error"), 'w') {|f| f.write(e.to_s + "\n" + e.backtrace.join("\n")) }
        if e.is_a? Measures::ValueSetException
          operator_error = true
          flash[:error] = {title: "Error Loading Measure", summary: "The measure value sets could not be found.", body: "Please re-package the measure in the MAT and make sure &quot;VSAC Value Sets&quot; are included in the package, then re-export the MAT Measure bundle."}
        elsif e.is_a? Measures::HQMFException
          operator_error = true
          flash[:error] = {title: "Error Loading Measure", summary: "Error loading XML file.", body: "There was an error loading the XML file you selected.  Please verify that the file you are uploading is an HQMF XML or SimpleXML file.  Message: #{e.message}"}
        elsif e.is_a? Measures::VSACException
          operator_error = true
          flash[:error] = {title: "Error Loading VSAC Value Sets", summary: "VSAC value sets could not be loaded.", body: "Please verify that you are using the correct VSAC username and password. #{e.message}"}
        elsif e.is_a? Measures::MeasureLoadingException
          operator_error = true
          flash[:error] = {title: "Error Loading Measure", summary: "The measure could not be loaded. There may be an error in the CQL logic."}
        else
          flash[:error] = {title: "Error Loading Measure", summary: "The measure could not be loaded.", body: "Bonnie has encountered an error while trying to load the measure."}
        end
      else
        operator_error = true
        flash[:error] = {title: "Error Loading Measure", body: "You must specify a Measure Authoring tool measure export to use."}
      end

      # email the error
      if !operator_error && defined? ExceptionNotifier::Notifier
        params[:error_file] = filename
        ExceptionNotifier::Notifier.exception_notification(env, e).deliver
      end

      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    end
    current_user.measures << measure
    current_user.save!

    # TODO: See story https://jira.mitre.org/browse/BONNIE-476
    # this below logic needs to be updated not to check the episode ids for CQL-based measures
    if (is_update)
      measure.episode_ids = measure_details['episode_ids']
      measure.populations.each_with_index do |population, population_index|
        population['title'] = measure_details['population_titles'][population_index] if (measure_details['population_titles'])
      end
      # check if episode ids have changed
      if (measure.episode_of_care?)
        keys = measure.data_criteria.values.map {|d| d['source_data_criteria'] if d['specific_occurrence']}.compact.uniq
        measure.needs_finalize = (measure.episode_ids & keys).length != measure.episode_ids.length
        if measure.needs_finalize
          measure.episode_ids = []
          params[:redirect_route] = ''
        end
      end
    else
      measure.needs_finalize = (!is_cql && measure_details['episode_of_care']) || measure.populations.size > 1
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

    unless is_cql
      Measures::ADEHelper.update_if_ade(measure)

      measure.generate_js
    end

    measure.save!

    # rebuild the users patients if set to do so
    if params[:rebuild_patients] == "true"
      Record.by_user(current_user).each do |r|
        Measures::PatientBuilder.rebuild_patient(r)
        r.save!
      end
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
    render :nothing => true
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
      # try to access non cql-based measure
      measure = Measure.by_user(current_user).where(hqmf_id: data['hqmf_id']).first
      # if measure wasn't found, it must be a cql-based measure
      is_cql = measure == nil
      if is_cql
        measure = CqlMeasure.by_user(current_user).where(hqmf_id: data['hqmf_id']).first
      end
      measure['needs_finalize'] = false
      measure.populations.each_with_index do |population, population_index|
        population['title'] = data['titles']["#{population_index}"] if (data['titles'])
      end
      # CQL-based measures don't have episode_ids field
      unless is_cql
        measure['episode_ids'] = data['episode_ids']
        measure.generate_js(clear_db_cache: true)
      end
      measure.save!
    end
    redirect_to root_path
  end

  def debug
    @measure = Measure.by_user(current_user).without(:map_fns, :record_ids).find(params[:id])
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
