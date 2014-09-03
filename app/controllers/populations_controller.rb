class PopulationsController < ApplicationController

  def calculate_code
    measure = Measure.by_user(current_user).find(params[:measure_id])
    if stale? last_modified: measure.updated_at.try(:utc), etag: measure.cache_key
      render js: BonnieMeasureJavascript.generate_for_population(measure, params[:id].to_i)
    end
  end

  def update_population_titles
    measure = Measure.by_user(current_user).find(params[:id])
    measure.populations.at(params[:index])['title'] = params[:name]
    measure.save
    render :json => measure
  end

end
