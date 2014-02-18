class MeasuresController < ApplicationController

  respond_to :json, :js, :html

  def show
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    @measure = Measure.by_user(current_user).without(*skippable_fields).find(params[:id])
    if stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
      @measure_json = MultiJson.encode(@measure.as_json(except: skippable_fields))
      respond_with @measure do |format|
        format.json { render json: @measure_json }
      end
    end
  end

  def value_sets
    if stale? last_modified: Measure.by_user(current_user).max(:updated_at).try(:utc)
      value_set_oids = Measure.by_user(current_user).only(:value_set_oids).pluck(:value_set_oids).flatten.uniq
      value_sets_by_oid = HealthDataStandards::SVS::ValueSet.in(oid: value_set_oids).index_by(&:oid)
      @value_sets_by_oid_json = MultiJson.encode(value_sets_by_oid.as_json(except: [:_id, :code_system, :code_system_version]))
      respond_with @value_sets_by_oid_json do |format|
        format.json { render json: @value_sets_by_oid_json }
      end
    end
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
      if params["eoc_#{existing.hqmf_set_id}"]['episode_ids'] && !params["eoc_#{existing.hqmf_set_id}"]['episode_ids'].empty?
        measure_details['episode_ids'] = params["eoc_#{existing.hqmf_set_id}"]['episode_ids']
      else
        measure_details['episode_ids'] = existing.episode_ids
      end
      measure_details['population_titles'] = existing.populations.map {|p| p['title']} if existing.populations.length > 1
      existing.delete
    end

    begin
      measure = Measures::MATLoader.load(params[:measure_file], current_user, measure_details)
    rescue Exception => e
      errors_dir = File.join('tmp','load_errors')
      FileUtils.mkdir_p(errors_dir)
      if params[:measure_file]
        FileUtils.cp(params[:measure_file].tempfile, File.join(errors_dir, "#{current_user.email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.zip"))
        File.open(File.join(errors_dir, "#{current_user.email}_#{Time.now.strftime('%Y-%m-%dT%H%M%S')}.error"), 'w') {|f| f.write(e.to_s + "\n" + e.backtrace.join("\n")) }
        if e.is_a? Measures::ValueSetException
          flash[:error] = {title: "Error Loading Measure", summary: "The measure value sets could not be found.", body: "Please re-package the measure in the MAT and make sure &quot;VSAC Value Sets&quot; are included in the package, then re-export the MAT Measure bundle."}
        else
          flash[:error] = {title: "Error Loading Measure", summary: "The measure could not be loaded.", body: "Please re-package the measure in the MAT, then re-download the MAT Measure Export.  If the measure has QDM elements without a VSAC Value Set defined the measure will not load."}
        end
      else
        flash[:error] = {title: "Error Loading Measure", body: "You must specify a Measure Authoring tool measusre export to use."}
      end
      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    end
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

    measure.generate_js

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
      measure.generate_js(clear_db_cache: true)
      measure.save!
    end
    redirect_to root_path
  end

  def debug
    @measure = Measure.by_user(current_user).without(:map_fns, :record_ids).find(params[:id])
    @patients = Record.by_user(current_user).asc(:last, :first)
    render layout: 'debug'
  end

  def clear_cached_javascript
    measure = Measure.by_user(current_user).find(params[:id])
    measure.generate_js clear_db_cache: true
    redirect_to :back
  end

end
