class HomeController < ApplicationController
  # before_action :authenticate_user!, :except => [:show]

  def index
    @measures = CQM::Measure.by_user(current_user).only(:id)
    @patients = CQM::Patient.by_user(current_user)
  end

  def show
    render :show, layout: false
  end

end
