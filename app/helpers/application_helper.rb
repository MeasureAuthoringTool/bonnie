module ApplicationHelper

  def measure_js(measure, population_index)
    HQMF2JS::Generator::Execution.logic(measure, population_index, true, false)
  end

end
