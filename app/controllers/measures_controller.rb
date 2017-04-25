class MeasuresController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:show, :value_sets]

  respond_to :json, :js, :html
  
  ##
  # GET /measures/:id 
  # 
  # Returns a measure in JSON format. The :id path param is used to retrieve the
  # measure by database '_id'.
  def show
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    @measure = Measure.by_user(current_user).without(*skippable_fields).find(params[:id])
    if stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
      @measure_json = MultiJson.encode(@measure.as_json(except: skippable_fields))
      respond_with @measure do |format|
        format.json { render json: @measure_json }
      end
    end
  end
  
  ##
  # GET /measures/historic_diff
  #
  # Uses the diffy gem to build a diff of the measure logic between two
  # measures. Takes two query params 'new_id' and 'old_id'. The ID's can be
  # either of current versions or archived versions of measures.
  def historic_diff
    # get the two versions to diff
    @new_measure = Measure.by_user(current_user).where({:_id => params[:new_id]}).first
    unless @new_measure
      @new_measure = ArchivedMeasure.where({:measure_db_id => params[:new_id]}).first.to_measure
    end

    @old_measure = Measure.by_user(current_user).where({:_id => params[:old_id]}).first
    unless @old_measure
      @old_measure = ArchivedMeasure.where({:measure_db_id => params[:old_id]}).first.to_measure
    end

    results = {}
    results['diff'] = []
    results['pre_upload'] = { 
      'cms_id' => @old_measure.cms_id,
      'updateTime' => (@old_measure.updated_at.tv_sec * 1000),
      'hqmf_id' => @old_measure.hqmf_id,
      'hqmf_version_number' => @old_measure.hqmf_version_number }
    results['post_upload'] = { 
      'cms_id' => @new_measure.cms_id,
      'updateTime' => (@new_measure.updated_at.tv_sec * 1000),
      'hqmf_id' => @new_measure.hqmf_id,
      'hqmf_version_number' => @new_measure.hqmf_version_number }

    measure_logic_names = HQMF::Measure::LogicExtractor::POPULATION_MAP.clone
    measure_logic_names['VARIABLES'] = 'Variables'

    # Walk through the population sets and populations for the measure and create a
    # diffy for each populationm.
    @new_measure.populations.each_with_index do |new_population_set, population_set_index|
      old_population_set = @old_measure.populations[population_set_index]
      population_diff = []

      # For each population within the population set, get the population logic and
      # perform the diffy
      measure_logic_names.each_pair do |population_code, population_title|
        # if the code is for VARIABLE, leave it. If it's IPP, etc., then access the actual code name from the
        # population set (e.g. IPP_1).
        code = (population_code == 'VARIABLES') ? 'VARIABLES' : new_population_set[population_code]
        new_logic = @new_measure.measure_logic.find { |logic| logic['code'] == code }
        old_logic = @old_measure.measure_logic.find { |logic| logic['code'] == code }

        # skip if both are non existent
        next if !new_logic && !old_logic
        
        # Remove the first line of the measure logic, which is the the name of the population.
        old_logic_text = old_logic ? old_logic['lines'][1..-1].join() : ""
        new_logic_text = new_logic ? new_logic['lines'][1..-1].join() : ""

        logic_diff = Diffy::SplitDiff.new(old_logic_text, new_logic_text,
          format: :html, include_plus_and_minus_in_html: true, allow_empty_diff: false)

        population_diff << {code: population_code, title: population_title, pre_upload: logic_diff.left, post_upload: logic_diff.right}
      end

      results['diff'] << population_diff
    end

    render :json => results
  end

  ##
  # GET /measures/value_sets
  #
  def value_sets
    # Caching of value sets is (temporarily?) disabled to correctly handle cases where users use multiple accounts
    # if stale? last_modified: Measure.by_user(current_user).max(:updated_at).try(:utc)
    if true
      value_set_oids = Measure.by_user(current_user).only(:value_set_oids).pluck(:value_set_oids).flatten.uniq

      # Not the cleanest code, but we get a many second performance improvement by going directly to Moped
      # (The two commented lines are functionally equivalent to the following three uncommented lines, if slower)
      # value_sets_by_oid = HealthDataStandards::SVS::ValueSet.in(oid: value_set_oids).index_by(&:oid)
      # @value_sets_by_oid_json = MultiJson.encode(value_sets_by_oid.as_json(except: [:_id, :code_system, :code_system_version]))
      value_sets = Mongoid::Clients.default[HealthDataStandards::SVS::ValueSet.collection_name].find({oid: { '$in' => value_set_oids }, user_id: current_user.id}, {'concepts.code_system' => 0, 'concepts.code_system_version' => 0})
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

    begin
      if extension == '.xml'
        includeDraft = params[:include_draft] == 'true'
        effectiveDate = nil
        unless includeDraft
          effectiveDate = Date.strptime(params[:vsac_date],'%m/%d/%Y').strftime('%Y%m%d')
        end
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

      archived_measure = nil
      # if a measure is being updated, save out the pre-existing measure as an archived measure.
      if (existing && is_update)
        archived_measure = ArchivedMeasure.from_measure(existing)
        archived_measure.save
        existing.delete
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
        else
          flash[:error] = {title: "Error Loading Measure", summary: "The measure could not be loaded.", body: "Please re-package the measure in the MAT, then re-download the MAT Measure Export.  If the measure has QDM elements without a VSAC Value Set defined the measure will not load."}
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
      measure.needs_finalize = (measure_details['episode_of_care'] || measure.populations.size > 1)
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


    Measures::ADEHelper.update_if_ade(measure)

    measure.generate_js
    measure.save!

    # create the measure upload summary only if the measure doesn't need finalization. If it
    # does, this will get run in the finalize step.
    # TODO Eventually enable for portfolio users
    if !measure.needs_finalize && !current_user.is_portfolio?
      measure_summary = UploadSummary::MeasureSummary.create_measure_upload_summary(measure, archived_measure)
      flash[:uploaded_summary_id] = measure_summary.id
      flash[:uploaded_hqmf_set_id] = measure.hqmf_set_id
    end

    # rebuild the user's patients for the given measure
    Record.by_user_and_hqmf_set_id(current_user, measure.hqmf_set_id).each do |r|
      Measures::PatientBuilder.rebuild_patient(r)
      r.save!
    end

    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  ##
  # GET /measures/vsac_auth_valid
  #
  def vsac_auth_valid
    # If VSAC TGT is still valid, return its expiration date/time
    tgt = session[:tgt]
    if tgt.nil? || tgt.empty? || tgt[:expires] < Time.now
      render :json => {valid: false}
    else
      render :json => {valid: true, expires: tgt[:expires]}
    end
  end

  ##
  # GET /measures/vsac_auth_expire
  #
  def vsac_auth_expire
    # Force expire the VSAC session
    session[:tgt] = nil
    render :json => {}
  end

  def destroy
    measure = Measure.by_user(current_user).find(params[:id])

    archived_measure = ArchivedMeasure.from_measure(measure)
    archived_measure.save

    Measure.by_user(current_user).find(params[:id]).destroy

    render :json => measure
  end

  ##
  # GET /measures/finalize
  #
  def finalize
    measure_finalize_data = params.values.select {|p| p['hqmf_id']}.uniq
    measure_finalize_data.each do |data|
      measure = Measure.by_user(current_user).where(hqmf_id: data['hqmf_id']).first
      measure.update_attributes({needs_finalize: false, episode_ids: data['episode_ids']})
      measure.populations.each_with_index do |population, population_index|
        population['title'] = data['titles']["#{population_index}"] if (data['titles'])
      end
      measure.generate_js(clear_db_cache: true)
      measure.save!

      # TODO Enable for portfolio users
      unless current_user.is_portfolio?
        # get the latest archived measure (the measure that the current upload is replacing)
        archived_measure = ArchivedMeasure.by_user(current_user).where(hqmf_set_id: measure.hqmf_set_id).desc(:uploaded_at).first
        measure_summary = UploadSummary::MeasureSummary.create_measure_upload_summary(measure, archived_measure)
        # Make UI show upload summary
        flash[:uploaded_summary_id] = measure_summary.id
        flash[:uploaded_hqmf_set_id] = measure.hqmf_set_id
      end

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
