class PopulationsController < ApplicationController

  def calculate_code
    measure = Measure.by_user(current_user).find(params[:measure_id])
    if stale? last_modified: measure.updated_at.try(:utc), etag: measure.cache_key
      render js: BonnieMeasureJavascript.generate_for_population(measure, params[:id].to_i)
    end
  end

  def update
    measure = Measure.by_user(current_user).find(params[:measure_id])
    measure.populations.at(params[:id].to_i)['title'] = params[:title]
    measure.save!
    render :json => measure.populations.at(params[:id].to_i)
  end

end
