class MeasuresController < ApplicationController

  def index
    @measures = Measure.asc(:measure_id)
    @my_measures = current_user.measures
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

end
