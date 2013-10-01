module ApplicationHelper

  def measure_js(measure, population_index)
    HQMF2JS::Generator::Execution.logic(measure, population_index, true, false)
  end

  def measure_json(measure, population, population_count)
    # For use in client code we set the ID to be of the form 0004a
    sub_id = if population_count > 1 then ('a'..'z').to_a[population] else '' end
    measure.as_json.merge(id: "#{measure.measure_id}#{sub_id}").to_json
  end

end
