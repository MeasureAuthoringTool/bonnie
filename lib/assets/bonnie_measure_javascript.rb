module BonnieMeasureJavascript

  # Load template from ERB file; do it at file parse time so it only happens once per server instantiation
  JAVASCRIPT_TEMPLATE = ERB.new File.read(__FILE__.gsub(/.rb$/, '.erb'))

  # Generate Bonnie client-side JavaScript that instantiates a measure, attaches JavaScript for calculating
  # each population, and attaches the measure to the bonnie router object; this is used both on the front end
  # as well as within our tests

  # The options can be set to those expected by the measure JS code: clear_db_cache and cache_result_in_db

  def self.generate_from_measure(measure, options = {})
    measure_json = measure.to_json(except: [:map_fns, :record_ids], methods: [:value_sets])
    population_javascripts = measure.populations.each_with_index.map { |population, index| measure.map_fn(index, options) }
    JAVASCRIPT_TEMPLATE.result binding
  end

end
