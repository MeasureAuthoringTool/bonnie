class PopulationsController < ApplicationController

  def update
    # Added CQL Based Measure support for editing Population titles.
    # If Measure doesn't exist in Measures move on to CqlMeasures.
    if !Measure.by_user(current_user).where(id: params[:measure_id]).blank?
      measure = Measure.by_user(current_user).find(params[:measure_id])
    else
      measure = CqlMeasure.by_user(current_user).find(params[:measure_id])
    end
    measure.populations.at(params[:id].to_i)['title'] = params[:title]
    measure.save!
    # Only return title to client side since that's all we're updating and all we want to overwrite
    render :json => measure.populations.at(params[:id].to_i).slice('title')
  end

end
