module TestCaseMeasureHistory
  
  # 
  class MeasureUploadPatientSummary

    include Mongoid::Document
    include Mongoid::Timestamps

    field :hqmf_id, type: String
    field :hqmf_set_id, type: String
    field :upload_dtm, type: Time, default: -> { Time.current }
    field :measure_db_id_before, type: BSON::ObjectId # The mongoid id of the measure before it is archived
    field :measure_db_id_after, type: BSON::ObjectId # The mongoid id of the measure after it is has been updateed
    belongs_to :user
    embeds_many :measure_upload_population_summaries, cascade_callbacks: true
    accepts_nested_attributes_for :measure_upload_population_summaries
  end
  
  # 
  class MeasureUploadPopulationSummary
    include Mongoid::Document
    include Mongoid::Timestamps
    field :patients, type: Hash, default: {}
    field :summary, type: Hash, default: { pass_before: 0, pass_after: 0, fail_before: 0, fail_after: 0 }
    embedded_in :measure_upload_patient_summaries
    # attr_accessor :patients, :summary

    def before_measure_load(patient, pop_idx, m_id)
      trim_before = patient.actual_values.find(measure_id: m_id, popluation_index: pop_idx).first.reject { |k, _v| k.include?('_') }
      trim_expected = patient.expected_values.find(measure_id: m_id, popluation_index: pop_idx).first.reject { |k, _v| k.include?('_') }
      cat = (trim_before.to_a - trim_expected.to_a).to_h
      if cat.size == 0 || !cat.has_value?(1)
        status = 'pass'
        self[:summary][:pass_before] += 1
      else
        status = 'fail'
        self[:summary][:fail_before] += 1
      end
      self[:patients][patient.id.to_s] = {
        expected: trim_expected,
        before: trim_before,
        before_status: status
    end

  end
  
  def self.something(measure)
    patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
    if patients.count > 0
      blah = MeasureUploadPatientSummary.new
      measure.populations.each_with_index do |m, index|
        moo = MeasureUploadPopulationSummary.new
        patients.each do |patient|
          moo.before_measure_load(patient, index, measure.hqmf_set_id)
        end
        blah.measure_upload_population_summaries << moo
      end
      blah.hqmf_id = measure.hqmf_id
      blah.hqmf_set_id = measure.hqmf_set_id
      blah.user_id = measure.user_id
      blah.save!
      blah.id
    end
  end

  def self.something_else(measure, upl_id)
    the_befores = MeasureUploadPatientSummary.where(id: upl_id).first
    the_befores.measure_upload_population_summaries.each_index do |pop_idx|
      fish = the_befores.measure_upload_population_summaries[pop_idx]
      fish[:patients].keys.each do |patient|
        ptt = Record.where(id: patient).first
        trim_after = ptt.actual_values.find(measure_id: measure.hqmf_set_id, population_index: pop_idx).first.reject { |k, _v| k.include?('_') }
        cat = (trim_after.to_a - fish[:patients][patient][:expected].to_a).to_h
        if cat.size == 0 || !cat.has_value?(1)
          status = 'pass'
          fish.summary[:pass_after] += 1
        else
          status = 'fail'
          fish.summary[:fail_after] += 1
        end
        fish.patients[patient].merge!(after: trim_after, after_status: status)
      end
      fish.save!
    end
  end

    calculator = BonnieBackendCalculator.new
    # query = {}
    # query[:user_id] = User.where(email: options[:user_email]).first.try(:id) if options[:user_email]
    # query[:cms_id] = options[:cms_id] if options[:cms_id]
    # measures = Measure.where(query)
    # measures.each do |measure|
    measure.populations.each_with_index do |population, population_index|
      # Set up calculator for this measure and population, making sure we regenerate the javascript
      begin
        calculator.set_measure_and_population(measure, population_index, clear_db_cache: true)
      rescue => e
        setup_exception = "Measure setup exception: #{e.message}"
      end
      patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
      patients.each do |patient|
        unless setup_exception
          begin
            result = calculator.calculate(patient).slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES)
          rescue => e
            calculation_exception = "Measure calculation exception: #{e.message}"
          end
        end
        res = []
        result.merge!('measure_id',measure.hqmf_set_id, 'population_index', population_index)
        res << result
        if !patient.actual_values.present?
          patient.write_attribute(:actual_values, res)
        else
          patient.actual_values << result
        end
        patient.save!
        yield measure, population_index, patient, result, setup_exception || calculation_exception
      end
    end
  end
  
end
