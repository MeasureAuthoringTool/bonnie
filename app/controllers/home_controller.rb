class HomeController < ApplicationController
  def index
    @measures = Measure.asc(:measure_id)
    @patients = Record.asc(:last, :first)
  end
end
