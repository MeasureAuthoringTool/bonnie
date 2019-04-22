loadMeasureWithValueSets = function(measurePath, valueSetsPath) {
  // Assumes measure.json and value_sets.json are both in fixturePath
  measure = new Thorax.Models.Measure(getJSONFixture(measurePath), {parse: true});
  measure.set('cqmValueSets', getJSONFixture(valueSetsPath)[measure.get('cqmMeasure').hqmf_set_id]);
  return measure;
}