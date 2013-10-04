module PatientHelper

  def html_for_patient(patient)
    patient_exporter = HealthDataStandards::Export::HTML.new
    patient_exporter.export(patient)
  end

  def self.get_patients_by_measure_hqmf_and_nqf(measure)

  	# Record.where('measure_ids' => {"$in" => ['0384']}).first

  	nqf = []
  	nqf << measure.measure_id
  	
  	hqmfs = Record.where('measure_id' => measure.hqmf_id).all
  	nqfs = Record.where('measure_ids' => {"$in" => nqf}).all
  	# ary.uniq{|x| x.user_id}
  	return (hqmfs + nqfs).uniq{|p| p._id }

  end

end