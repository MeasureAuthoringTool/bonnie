class PopulationsController < ApplicationController

  def update
    measure = CQM::Measure.by_user(current_user).find(params[:measure_id])

    pop_or_strat = measure.population_sets.select { |ps| ps.population_set_id == params[:id] }.first || measure.all_stratifications.select { |strat| strat.stratification_id == params[:id] }.first
    pop_or_strat.title = params[:title]
    measure.save!
    # Only return title to client side since that's all we're updating and all we want to overwrite
    render :json => pop_or_strat.title
  end

end
