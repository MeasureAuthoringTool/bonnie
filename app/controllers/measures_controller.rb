class MeasuresController < ApplicationController
  include MeasureHelper

  skip_before_action :verify_authenticity_token, only: [:show]

  respond_to :json, :js, :html

  def show
    # TODO: I think skippable_fields can be removed with the 'without(*skippable_fields)' below
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    @measure = CQM::Measure.by_user(current_user).without(*skippable_fields).where(id: params[:id]).first
    raise Mongoid::Errors::DocumentNotFound unless @measure
    if stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
      raw_json = @measure.as_document.as_json(except: skippable_fields)
      value_sets = @measure.value_sets
      raw_json['value_sets'] = value_sets.as_json
      @measure_json = MultiJson.encode(raw_json)
      respond_with @measure do |format|
        format.json { render json: @measure_json }
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
