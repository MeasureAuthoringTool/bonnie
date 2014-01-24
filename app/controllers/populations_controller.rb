class PopulationsController < ApplicationController

  def calculate_code
    measure = Measure.by_user(current_user).only(:updated_at, :data_criteria, :source_data_criteria, :map_fns).find(params[:measure_id])
    if stale? last_modified: measure.updated_at.try(:utc), etag: measure.cache_key
      # FIXME: Ensure that this is considered JS in IE
      render js: BonnieMeasureJavascript.generate_for_population(measure, params[:id].to_i,{check_crosswalk: current_user.crosswalk_enabled})
    end
  end

end
