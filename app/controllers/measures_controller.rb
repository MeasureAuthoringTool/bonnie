class MeasuresController < ApplicationController
  include MeasureHelper

  skip_before_action :verify_authenticity_token, only: [:show, :value_sets]

  respond_to :json, :js, :html

  def show
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    @measure = CQM::Measure.by_user(current_user).without(*skippable_fields).where(id: params[:id]).first
    raise Mongoid::Errors::DocumentNotFound unless @measure
    if stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
      raw_json = @measure.as_json(except: skippable_fields)
      @measure_json = MultiJson.encode(raw_json)
      respond_with @measure do |format|
        format.json { render json: @measure_json }
      end
    end
  end

  def value_sets
    # Caching of value sets is (temporarily?) disabled to correctly handle cases where users use multiple accounts
    # if stale? last_modified: Measure.by_user(current_user).max(:updated_at).try(:utc)
    if true # Used to reduce indentation diffs while line above is disabled
      cqm_measures = CQM::Measure.where(user_id: current_user.id)
      @value_sets_by_measure_id_json = {}
      cqm_measures.each do |cqm_measure|
        @value_sets_by_measure_id_json[cqm_measure.hqmf_set_id] = cqm_measure.value_sets.as_json(:except => :_id)
      end

      @value_sets_final = MultiJson.encode @value_sets_by_measure_id_json
      respond_with @value_sets_final do |format|
        format.json { render json: @value_sets_final }
      end
    end
  end

  def create
    if !params[:measure_file]
      flash[:error] = {title: "Error Loading Measure", body: "You must specify a Measure Authoring tool measure export to use."}
      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    end

    measures, main_hqmf_set_id = persist_measure(params[:measure_file], params, current_user)
    redirect_to "#{root_path}##{params[:redirect_route]}"
  rescue StandardError => e
    # also clear the ticket granting ticket in the session if it was a VSACTicketExpiredError
    session[:vsac_tgt] = nil if e.is_a?(VSACTicketExpiredError)
    flash[:error] = turn_exception_into_shared_error_if_needed(e).front_end_version
    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  def destroy
    measure = CQM::Measure.by_user(current_user).where(id: params[:id]).first

    if measure.component
      render status: :bad_request, json: {error: "Component measures can't be deleted individually."}
      return
    elsif measure.composite
      # If the measure if a composite, delete all the associated components
      measure.component_hqmf_set_ids.each do |component_hqmf_set_id|
        CQM::Measure.by_user(current_user).where(hqmf_set_id: component_hqmf_set_id).first.destroy_self_and_child_docs
      end
    end
    measure.destroy_self_and_child_docs

    render :json => measure
  end

  def finalize
    measure_finalize_data = params.values.select {|p| p['hqmf_id']}.uniq
    measure_finalize_data.each do |data|
      measure = CQM::Measure.by_user(current_user).where(hqmf_id: data['hqmf_id']).first
      begin
        # TODO: should this do the same for component measures?
        Measures::CqlLoader.update_population_set_and_strat_titles(measure, data['titles'])
        measure.save!
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

  def to_cqm
    cql_measure = CqlMeasure.by_user(current_user).where(id: params[:id]).first
    cqm_measure = CQM::Converter::BonnieMeasure.to_cqm(cql_measure)
    respond_with cqm_measure do |format|
      format.json { render json: { measure: cqm_measure, value_sets: cqm_measure.value_sets } }
    end
  end

  private

  def persist_measure(uploaded_file, params, user)
    measures, main_hqmf_set_id =
      if params[:hqmf_set_id].present?
        update_measure(uploaded_file: uploaded_file,
                      target_id: params[:hqmf_set_id],
                      value_set_loader: build_vs_loader(params, false),
                      user: user)
      else
        create_measure(uploaded_file: uploaded_file,
                      measure_details: retrieve_measure_details(params),
                      value_set_loader: build_vs_loader(params, false),
                      user: user)
      end
    return measures, main_hqmf_set_id
  end

  def retrieve_measure_details(params)
    return {
      'episode_of_care'=>params[:calculation_type] == 'episode',
      'calculate_sdes'=>params[:calc_sde]
    }
  end
end
