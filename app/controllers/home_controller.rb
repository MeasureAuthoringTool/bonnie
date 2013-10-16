class HomeController < ApplicationController

  def index
    @measures = current_user.measures.asc(:measure_id)
    if Rails.env.development?
      # FIXME: At least for now, for development, let us see all the measures
      @measures = Measure.asc(:measure_id) if @measures.blank?
    end
    @patients = Record.asc(:last, :first)
  end

end
