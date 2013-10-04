class MeasuresController < ApplicationController

  def index

    # if we want to show measures for a given patient id
    if (params.include? :pid)

      # grab the patient and reset the measures lists
      @patient = Record.find(params[:pid])
      @measures = []
      @my_measures = []
      
      # first find all of the corresponding measures
      begin
        @measures << Measure.find(@patient.measure_id)
        MeasureHelper.get_measure_by_nqf(@patient.measure_ids).each do |mh|
          @measures << mh
        end
      rescue Mongoid::Errors::DocumentNotFound, Mongoid::Errors::InvalidFind
        @measures = []
        if (@patient.measure_id.nil?)
          @patient.measure_id = 'missing_hqmf_id'
        end
      end

      # then find the matching current_user's measures
      begin
        @measures.each do |m|
          if (current_user.measures.include? m)
            @my_measures << m
          end
        end
      rescue Mongoid::Errors::DocumentNotFound, Mongoid::Errors::InvalidFind
        @my_measures = []
        if (@patient.measure_ids.nil?)
          @patient.measure_ids = []
        end
      end

      # show a simple flash indicating the selected patient info
      flash.now[:info] = "Showing measures for Patient [ " + @patient.id.to_s() + " : " + @patient.last.to_s() + ", " + @patient.first.to_s() + ", measures(HQMF): " + @patient.measure_id.to_s() + " , measures(NQF): " + @patient.measure_ids.count.to_s() + " ]!"

    # else just show all the measures and the user's measures
    else
      @measures = Measure.asc(:measure_id)
      @my_measures = current_user.measures.asc(:measure_id)
    end
  end

  def show
    @measure = Measure.find(params[:id])
    @populations = params[:population] ? [params[:population].to_i] : (0...@measure.populations.length).to_a
    @patients = Record.asc(:last, :first)
    stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
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
