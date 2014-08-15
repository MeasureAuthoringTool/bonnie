class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:show]

  def index
    @measures = Measure.by_user(current_user).only(:id) # Only using measure for JS URL generation, only need ID
    @patients = Record.by_user(current_user)
    render :show, layout: true
  end

  def show
    render :show, layout: false
  end

end
