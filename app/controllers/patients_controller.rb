class PatientsController < ApplicationController

  def index
    @patients = Record.all
  end

  def show
    @patient = Record.all.find(params[:id])
  end

end
