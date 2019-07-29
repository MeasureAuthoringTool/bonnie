class PopulationsController < ApplicationController

  def update
    measure = CQM::Measure.by_user(current_user).find(params[:measure_id])

    pop_or_strat = measure.population_sets.select { |ps| ps.population_set_id == params[:population_set_id] }.first || measure.all_stratifications.select { |strat| strat.stratification_id == params[:population_set_id] }.first
    pop_or_strat.title = params[:title]
    measure.save!
    render :json => pop_or_strat
  end

end
