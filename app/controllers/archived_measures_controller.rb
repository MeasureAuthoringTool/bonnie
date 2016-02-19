# Methods for handling archived measures
class ArchivedMeasuresController < ApplicationController
  
  skip_before_action :verify_authenticity_token, only: [:show, :value_sets]
  
  respond_to :json, :js, :html
  
  # List the measure_db_id for all of versions of a measure using the
  # hqmf_set_id as the measure identifier (so as to version agnostic)
  def index
    begin
      @measure = Measure.by_user(current_user).only(:hqmf_set_id).find(params[:measure_id])
      @archived_measures = ArchivedMeasure.by_user(current_user).only(:measure_db_id).where(hqmf_set_id: @measure.hqmf_set_id)
      
      respond_with @archived_measure do |format|
        format.json { render json: @archived_measures }
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: "Could not find measure." }, status: :not_found
    end
  end
  
  # Show the archived content of a measure at specific point in time
  def show
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    @archived_measure = ArchivedMeasure.by_user(current_user).where(measure_db_id: params[:id]).first
    
    @archived_measure_json = MultiJson.encode(@archived_measure.measure_content.as_json(except: skippable_fields))
    respond_with @archived_measure do |format|
      format.json { render json: @archived_measure_json }
    end
  end
  
end
