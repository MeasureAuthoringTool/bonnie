module MeasureHelper
	
  def self.get_measure_by_nqf(nqf_ids)

    # return *Measure.where({'measure_id' => {'$in' => nqf_ids || []}}).map(&:to_a).flatten
    return Measure.where('measure_id' => {"$in" => nqf_ids}).all
  end

end