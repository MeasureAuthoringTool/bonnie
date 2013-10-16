class HomeController < ApplicationController

  def index
    @measures = current_user.measures.asc(:measure_id)
    @patients = Record.asc(:last, :first)
  end

end
