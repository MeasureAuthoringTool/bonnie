// @valueSets = getJSONFixture('cqm_measure_data/core_measures/CMS158/value_sets.json')
//         @measure = new Thorax.Models.Measure getJSONFixture('cqm_measure_data/core_measures/CMS158/CMS158v6.json'), parse: true
//         @measure.set('cqmValueSets', @valueSets)

loadMeasureWithValueSets = function(measurePath, valueSetsPath) {
  // Assumes measure.json and value_sets.json are both in fixturePath
  measure = new Thorax.Models.Measure(getJSONFixture(measurePath), {parse: true});
  measure.set('cqmValueSets', getJSONFixture(valueSetsPath));
  return measure;
}