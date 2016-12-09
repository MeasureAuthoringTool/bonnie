##
# This controller provides access to the UploadSumamries. Backbone accesses these functions to lazy
# load UploadSummaries.

class UploadSummariesController < ApplicationController
  
  respond_to :json, :js, :html
  
  ##
  # GET /measures/:measure_id/upload_summaries
  #
  # Lists the _id and created_at fields for every upload summary for a measure ordered by created_at in a descending
  # order.
  
  def index
    begin
      # Fetch only hqmf_set_id of the measure so we can use it to grab the upload summaries for that hqmf_set_id.
      @measure = Measure.by_user(current_user).only(:hqmf_set_id, :_id).find(params[:measure_id])
      
      # Fetch only the _id and created_at fields of the upload summaries that have the given hqmf_set_id.
      @upload_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(current_user, @measure.hqmf_set_id).only([:_id, :created_at]).desc(:created_at)
      
      respond_with @upload_summaries do |format|
        format.json { render json: @upload_summaries }
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: "Could not find measure." }, status: :not_found
    end
  end
  
  ##
  # GET /measures/:measure_id/upload_summaries/:id
  #
  # Gets a specific UploadSummary by its _id.
  def show
    @upload_summary = UploadSummary::MeasureSummary.by_user(current_user).find(params[:id])
    
    respond_with @upload_summary do |format|
      format.json { render json: @upload_summary }
    end
  end
  
end
