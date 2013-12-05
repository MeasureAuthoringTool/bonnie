class HomeController < ApplicationController

  def index
    @measures = Measure.by_user(current_user).asc(:measure_id)
    @patients = Record.by_user(current_user).asc(:last, :first)
    if Rails.env.development?
      # FIXME: At least for now, for development, let us see all the measures and patients
      @measures = Measure.asc(:measure_id) if @measures.blank?
      @patients = Record.asc(:last, :first) if @patients.blank?
    end
  end

end
