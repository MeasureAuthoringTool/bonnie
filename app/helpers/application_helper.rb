module ApplicationHelper

  def measure_json(measure, population, population_count)
    # For use in client code we set the ID to be of the form 0004a
    sub_id = if population_count > 1 then ('a'..'z').to_a[population] else '' end
    # FIXME: Skipping record IDs at the moment (as_json causes changed? to be set true, blowing cache), will want to reconsider approach
    measure.as_json(except: [:map_fns, :record_ids]).merge(id: "#{measure.measure_id}#{sub_id}").to_json
  end

  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :info then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-warning"
    end
  end

end
