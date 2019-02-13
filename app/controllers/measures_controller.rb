class MeasuresController < ApplicationController
  include MeasureHelper

  skip_before_action :verify_authenticity_token, only: [:show, :value_sets]

  respond_to :json, :js, :html

  def show
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    # Lookup the measure both in the regular and CQL sets
    # TODO: Can we skip the elm if it's CQL?
    @measure = Measure.by_user(current_user).without(*skippable_fields).where(id: params[:id]).first
    @measure ||= CQM::Measure.by_user(current_user).without(*skippable_fields).where(id: params[:id]).first
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
      value_set_oids += CQM::Measure.by_user(current_user).only(:value_set_oids).pluck(:value_set_oids).flatten.uniq

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

    measure_file = params[:measure_file]
    measure_file = measure_file.tempfile if measure_file.is_a?(ActionDispatch::Http::UploadedFile)

    if params[:hqmf_set_id].present? # update
      main_hqmf_set_id = update_measure(measure_file: measure_file,
                                        target_id: params[:hqmf_set_id],
                                        value_set_loader: build_vs_loader(params, false),
                                        user: current_user)
    else
      main_hqmf_set_id = create_measure(measure_file: measure_file,
                                        measure_details: retrieve_measure_details(params),
                                        value_set_loader: build_vs_loader(params, false),
                                        user: current_user)
    end
    redirect_to "#{root_path}##{params[:redirect_route]}"
  rescue StandardError => e
    # also clear the ticket granting ticket in the session if it was a VSACTicketExpiredError
    session[:vsac_tgt] = nil if e.is_a?(VSACTicketExpiredError)
    flash[:error] = turn_exception_into_shared_error_if_needed(e).front_end_version
    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  def destroy
    qdm_measure = Measure.by_user(current_user).where(id: params[:id]).first
    cql_measure = CQM::Measure.by_user(current_user).where(id: params[:id]).first

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
          CQM::Measure.by_user(current_user).where(hqmf_set_id: component_hqmf_set_id).destroy
        end
      end
      CQM::Measure.by_user(current_user).find(params[:id]).destroy
    end
    render :json => measure
  end

  def finalize
    measure_finalize_data = params.values.select {|p| p['hqmf_id']}.uniq
    measure_finalize_data.each do |data|
      measure = CQM::Measure.by_user(current_user).where(hqmf_id: data['hqmf_id']).first
      begin
        measure.population_sets.each_with_index do |population, population_index|
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

  private

  def retrieve_measure_details(params)
    return {
      'episode_of_care'=>params[:calculation_type] == 'episode',
      'calculate_sdes'=>params[:calc_sde]
    }
  end

end
