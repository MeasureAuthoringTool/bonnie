class HomeController < ApplicationController

  def index
    @measure_attributes = [:_id, :hqmf_set_id, :title, :populations, :population_criteria]
    @measures = Measure.by_user(current_user).only(@measure_attributes)
    @patients = Record.by_user(current_user)
  end

end
