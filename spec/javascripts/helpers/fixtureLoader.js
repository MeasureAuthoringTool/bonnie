loadMeasureWithValueSets = function(measurePath, valueSetsPath) {
  // Assumes measure.json and value_sets.json are both in fixturePath
  // Need to load value sets before measure, because measure.parse uses the
  // value set descriptions to alter the source_data_criteria from the measure
  // stored in the database

  measureJSON = getJSONFixture(measurePath);
  valuesetsJSON = getJSONFixture(valueSetsPath)[measureJSON.hqmf_set_id];
  measureJSON.value_sets = valuesetsJSON;
  measure = new Thorax.Models.Measure(measureJSON, {parse: true});
  return measure;
}