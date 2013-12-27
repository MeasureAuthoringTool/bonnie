class HomeController < ApplicationController

  def index
    @measures = Measure.by_user(current_user).only(:id) # Only using measure for JS URL generation, only need ID
    @patients = Record.by_user(current_user)
  end

end
