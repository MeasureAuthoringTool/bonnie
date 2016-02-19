class UploadSummariesController < ApplicationController
  
  skip_before_action :verify_authenticity_token, only: [:show, :value_sets]
  
  respond_to :json, :js, :html
  
  def index
    begin
      @measure = Measure.by_user(current_user).only(:hqmf_set_id).find(params[:measure_id])
      @upload_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(current_user, @measure.hqmf_set_id).only([:_id, :created_at]).desc(:created_at)
      
      respond_with @upload_summaries do |format|
        format.json { render json: @upload_summaries }
      end
    rescue Mongoid::Errors::DocumentNotFound
      render json: { error: "Could not find measure." }, status: :not_found
    end
  end
  
  
  def show
    @upload_summary = UploadSummary::MeasureSummary.by_user(current_user).find(params[:id])
    
    respond_with @upload_summary do |format|
      format.json { render json: @upload_summary }
    end
  end
  
end
