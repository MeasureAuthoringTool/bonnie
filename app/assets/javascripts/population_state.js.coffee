window.Bonnie ||= {}
Bonnie.State ||= {}
Bonnie.setPopulationForMeasure ||= (population) ->
  Bonnie.State[population.measure().id] ||= {}
  Bonnie.State[population.measure().id].population = population
Bonnie.getPopulationForMeasure ||= (measure, base) ->
  Bonnie.State[measure.id].population || base