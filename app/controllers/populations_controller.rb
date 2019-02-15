class PopulationsController < ApplicationController

  def update
    # Added CQL Based Measure support for editing Population titles.
    # If Measure doesn't exist in Measures move on to CQM::Measures.
    measure = CQM::Measure.by_user(current_user).find(params[:measure_id])

    population_set = measure.population_sets.select{|ps| ps.population_set_id == params[:id]}[0]
    population_set.title = params[:title]
    measure.save!
    # Only return title to client side since that's all we're updating and all we want to overwrite
    render :json => population_set.title
  end

end
