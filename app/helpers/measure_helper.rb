module MeasureHelper
	
  def self.get_measure_by_nqf(nqf_ids)
    # measures = []
    # nqf_ids.each do |nqf|
    #   measures << Measure.where('nqf_id' => '0384').first
    # end
    # return measures

    return *Measure.where({'measure_id' => {'$in' => nqf_ids || []}}).map(&:to_a).flatten

  end

end