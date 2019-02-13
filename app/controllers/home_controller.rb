class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:show]

  def index
    @measures = Measure.by_user(current_user).only(:id) # Only using measure for JS URL generation, only need ID
    @measures += CQM::Measure.by_user(current_user).only(:id) # Add in CQL measures
    @patients = Record.by_user(current_user)
  end

  def show
    render :show, layout: false
  end

end
