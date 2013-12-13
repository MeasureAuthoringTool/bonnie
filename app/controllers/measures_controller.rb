class MeasuresController < ApplicationController

  respond_to :json

  def show
    @measure = Measure.by_user(current_user).without(:map_fns).find(params[:id])
    if stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
      respond_with @measure do |format|
        format.json { render json: @measure.to_json(except: [:map_fns, :record_ids], methods: [:value_sets]) }
      end
    end
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
