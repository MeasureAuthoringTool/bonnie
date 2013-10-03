class MeasuresController < ApplicationController

  def index
    @measures = Measure.asc(:measure_id)
    @my_measures = current_user.measures.asc(:measure_id)
    @show_all = false
  end

  def show
    @measure = Measure.find(params[:id])
    @populations = params[:population] ? [params[:population].to_i] : (0...@measure.populations.length).to_a
    @patients = Record.asc(:last, :first)
  end

  def matrix
    @measures = Measure.asc(:measure_id)
    @patients = Record.asc(:last, :first)
  end

  def libraries
    @javascript = HQMF2JS::Generator::JS.map_reduce_utils
    @javascript += HQMF2JS::Generator::JS.library_functions(false, false) # Don't include crosswalk or underscore
    render :content_type => "application/javascript"
  end

  def add
    @measure = Measure.find(params[:id])
    unless current_user.measures.include?(@measure)
      current_user.measures << @measure
      flash[:success] = "Added " + @measure.title.to_s() + " to your list!"
    end
    redirect_to measures_path
  end

  def remove
    @measure = Measure.find(params[:id])
    if current_user.measures.include?(@measure)
      current_user.measures.delete(@measure)
      flash[:alert] = "Removed " + @measure.title.to_s() + " from your list!"
    end
    redirect_to measures_path
  end

end
