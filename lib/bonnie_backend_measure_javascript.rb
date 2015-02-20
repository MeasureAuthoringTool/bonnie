# For running calculations on the backend
module BonnieBackendMeasureJavascript

  # Load template from ERB file; do it at file parse time so it only happens once per instantiation
  JAVASCRIPT_TEMPLATE = ERB.new File.read(__FILE__.gsub(/.rb$/, '.erb'))

  # Generate Bonnie JavaScript that sets up the logic to calculate one population of a measure

  def self.generate_for_population(measure, population_index, options)
    rationale = !!options[:rationale]
    population_javascript = measure.map_fn(population_index)
    JAVASCRIPT_TEMPLATE.result binding
  end

end
