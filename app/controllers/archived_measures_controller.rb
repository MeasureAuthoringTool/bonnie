##
# This controller provides access to the ArchivedMeasures. Backbone accesses these functions to lazy
# load ArchivedMeasures.

class ArchivedMeasuresController < ApplicationController
  
  respond_to :json, :js, :html
  
  ##
  # GET /measures/:measure_id/archived_measures
  #
  # Lists the measure_db_id for all ArchivedMeasures for a specific measure. This is an index function that only returns
  # a list of measure_db_ids.
  
  def index
    begin
      # Fetch only hqmf_set_id and _id fields of the measure so we can use it to grab the archived measures for that 
      # hqmf_set_id.
      @measure = Measure.by_user(current_user).only(:hqmf_set_id, :_id).find(params[:measure_id])
      
      # Fetch only the measure_db_id and _id fields of the archived measures.
      @archived_measures = ArchivedMeasure.by_user(current_user).only(:measure_db_id, :_id).where(hqmf_set_id: @measure.hqmf_set_id)
      
      respond_with @archived_measure do |format|
        format.json { render json: @archived_measures }
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: "Could not find measure." }, status: :not_found
    end
  end
  
  ##
  # GET /measures/:measure_id/archived_measures/:id
  #
  # Gets a specific archived measure by its measure_db_id.
  
  def show
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    @archived_measure = ArchivedMeasure.by_user(current_user).where(measure_db_id: params[:id]).first
    
    @archived_measure_json = MultiJson.encode(@archived_measure.measure_content.as_json(except: skippable_fields))
    respond_with @archived_measure do |format|
      format.json { render json: @archived_measure_json }
    end
  end
  
end
