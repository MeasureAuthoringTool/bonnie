class MeasuresController < ApplicationController

  def index

    if (params.include? :show_all)
      @show_all = params[:show_all].to_i
    else
      @show_all = 0
    end

    # if we want to show measures for a given patient id
    if (params.include? :pid)

      # grab the patient and reset the measures lists
      @patient = Record.find(params[:pid])
      @measures = []
      @my_measures = []
      
      # first find all of the corresponding measures
      begin
        unless @patient.measure_id.nil?
          @measures << Measure.find(@patient.measure_id)
        end
        unless @patient.measure_ids.nil?
          MeasureHelper.get_measure_by_nqf(@patient.measure_ids).each do |mh|
            @measures << mh
          end
        end
      rescue Mongoid::Errors::DocumentNotFound, Mongoid::Errors::InvalidFind
        @measures = []
        if (@patient.measure_id.nil?)
          @patient.measure_id = 'missing_hqmf_id'
        end
      end

      @measures = @measures.uniq{ |ms| ms.hqmf_id }

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
    @measure = Measure.by_user(current_user).find(params[:id])
    stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
  end

  def matrix
    @measures = Measure.by_user(current_user).asc(:measure_id)
    @patients = Record.by_user(current_user).asc(:last, :first)
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

  def create
    measure_details = {
     'type'=>params[:measure_type],
     'episode_of_care'=>params[:calculation_type] == 'episode'
    }

    is_update = false
    if (params[:hqmf_set_id] && !params[:hqmf_set_id].empty?)
      is_update = true
      existing = Measure.by_user(current_user).where(hqmf_set_id: params[:hqmf_set_id]).first
      measure_details['type'] = existing.type
      measure_details['episode_of_care'] = existing.episode_of_care
      measure_details['episode_ids'] = existing.episode_ids
      measure_details['population_titles'] = existing.populations.map {|p| p['title']} if existing.populations.length > 1
      existing.delete
    end

    measure = Measures::MATLoader.load(params[:measure_file], current_user, measure_details)
    current_user.measures << measure
    current_user.save!


    if (is_update)
      measure.episode_ids = measure_details['episode_ids']
      measure.populations.each_with_index do |population, population_index|
        population['title'] = measure_details['population_titles']["#{population_index}"] if (measure_details['population_titles'])
      end
    else
      measure.needs_finalize = (measure_details['episode_of_care'] || measure.populations.size > 1)
    end


    Measures::ADEHelper.update_if_ade(measure)

    measure.pregenerate_js

    measure.save!

    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  def destroy
    measure = Measure.by_user(current_user).find(params[:id])
    Measure.by_user(current_user).find(params[:id]).destroy
    render :json => measure
  end

  def finalize
    measure_finalize_data = params.values.select {|p| p['hqmf_id']}.uniq
    measure_finalize_data.each do |data|
      measure = Measure.by_user(current_user).where(hqmf_id: data['hqmf_id']).first
      measure.update_attributes({needs_finalize: false, episode_ids: data['episode_ids']})
      measure.populations.each_with_index do |population, population_index|
        population['title'] = data['titles']["#{population_index}"] if (data['titles'])
      end
      measure.pregenerate_js
      measure.save!
    end
    redirect_to root_path
  end

end
