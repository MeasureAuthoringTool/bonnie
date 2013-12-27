class PopulationsController < ApplicationController

  def calculate_code
    # FIXME: Could be faster if only load the required attr
    measure = Measure.by_user(current_user).find(params[:measure_id])
    if stale? last_modified: measure.updated_at.try(:utc), etag: measure.cache_key
      # FIXME: Ensure that this is considered JS in IE
      render text: BonnieMeasureJavascript.generate_for_population(measure, params[:id].to_i)
    end
  end

end
