module UploadSummary

  # A measure upload refers to a record of what happened to a measure at a specific
  #  moment in time.
  # An upload has 3 parts.
  # 1 - A copy of the existing measure content in Bonnie before anything happens.
  #   This is called the archived measure.
  # 2 - Pre upload state: what did the patients associated with this measure look like
  #  prior to the upload (in terms of pass/fail).
  # 3 - Post upload state: what the patients look like after the new measure content has
  #  been uploaded into Bonnie.
  # Parts 2 and 3 are stored in upload_summaries collection.

  # This will be used to filter the calc_results object down to just population codes
  # and rationale and finalSpecifics.
  ATTRIBUTE_FILTER = HQMF::PopulationCriteria::ALL_POPULATION_CODES + ['rationale', 'finalSpecifics']

  class MeasureSummary

    include Mongoid::Document
    include Mongoid::Timestamps

    store_in collection: 'upload_summaries'

    field :hqmf_id, type: String
    field :hqmf_set_id, type: String
    field :uploaded_at, type: Time, default: -> { Time.current }
    field :measure_db_id_pre_upload, type: BSON::ObjectId # The mongoid id of the measure before it is archived
    field :measure_db_id_post_upload, type: BSON::ObjectId # The mongoid id of the measure post_upload_results it is has been updated
    field :measure_cms_id_before, type: String
    field :measure_cms_id_after, type: String
    field :measure_hqmf_version_number_before, type: String
    field :measure_hqmf_version_number_after, type: String
    belongs_to :user
    embeds_many :population_set_summaries, cascade_callbacks: true
    accepts_nested_attributes_for :population_set_summaries

    index "user_id" => 1
    scope :by_user, ->(user) { where({'user_id'=>user.id}) }
    scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where({'user_id'=>user.id, 'hqmf_set_id'=>hqmf_set_id}) }
  end

  class PopulationSetSummary
    include Mongoid::Document
    include Mongoid::Timestamps
    field :patients, type: Hash, default: {}
    field :summary, type: Hash, default: { pass_before: 0, pass_after: 0, fail_before: 0, fail_after: 0 }
    embedded_in :measure_summaries

    def before_measure_load_compare(patient, population_set_index, hqmf_set_id)
      # Handle when measure has more populations
      patient_population_set_indexes = []
      patient.expected_values.each { |expected_value| patient_population_set_indexes << expected_value[:population_index] if expected_value[:measure_id] == hqmf_set_id }
      return if population_set_index > patient_population_set_indexes.max

      pre_upload_filtered_calc_results = (patient.calc_results.find { |result| result[:measure_id] == hqmf_set_id && result[:population_index] == population_set_index }).slice(*ATTRIBUTE_FILTER) unless patient.results_exceed_storage
      pre_upload_trimmed_expected_results = (patient.expected_values.find { |value| value[:measure_id] == hqmf_set_id && value[:population_index] == population_set_index }).slice(*ATTRIBUTE_FILTER)

      # TODO: Make sure this can handle continuous value measures.
      if !patient.results_exceed_storage
        if (patient.calc_results.find{ |result| result[:measure_id] == hqmf_set_id && result[:population_index] == population_set_index })['status'] == 'pass'
          status = 'pass'
          self.summary[:pass_before] += 1
        else
          status = 'fail'
          self.summary[:fail_before] += 1
        end
      else
        if (patient.condensed_calc_results.find{ |result| result[:measure_id] == hqmf_set_id && result[:population_index] == population_set_index })['status'] == 'pass'
          status = 'pass'
          self.summary[:pass_before] += 1
        else
          status = 'fail'
          self.summary[:fail_before] += 1
        end
      end
      self[:patients][patient.id.to_s] = {
        expected: pre_upload_trimmed_expected_results,
        pre_upload_results: pre_upload_filtered_calc_results,
        pre_upload_status: status,
        results_exceeds_storage_pre_upload: patient.results_exceed_storage }
      self[:patients][patient.id.to_s].merge!(patient_version_at_upload: patient.version) unless !patient.version
    end
  end

  def self.collect_before_upload_state(measure, arch_measure)
    patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)

    measure_upload_summary = MeasureSummary.new
    measure.populations.each_index do |populaton_set_index|
      population_set_summary = PopulationSetSummary.new
      patients.each do |patient|
        population_set_summary.before_measure_load_compare(patient, populaton_set_index, measure.hqmf_set_id)
      end
      measure_upload_summary.population_set_summaries << population_set_summary
    end
    measure_upload_summary.hqmf_id = measure.hqmf_id
    measure_upload_summary.hqmf_set_id = measure.hqmf_set_id
    measure_upload_summary.user_id = measure.user_id
    if arch_measure
      measure_upload_summary.measure_db_id_pre_upload = arch_measure.measure_db_id
      measure_upload_summary.measure_cms_id_before = arch_measure.measure_content['cms_id']
      measure_upload_summary.measure_hqmf_version_number_before = arch_measure.measure_content['hqmf_version_number']
    end
    measure_upload_summary.measure_db_id_post_upload = measure.id
    measure_upload_summary.measure_cms_id_after = measure.cms_id
    measure_upload_summary.measure_hqmf_version_number_after = measure.hqmf_version_number
    measure_upload_summary.save!
    measure_upload_summary.id
  end

  def self.collect_after_upload_state(measure, upload_summary_id)
    patient_snapshots_pre_measure_upload = MeasureSummary.where(id: upload_summary_id).first
    patient_snapshots_pre_measure_upload.population_set_summaries.each_index do |population_set_index|
      patient_snapshot_population_sets = patient_snapshots_pre_measure_upload.population_set_summaries[population_set_index]
      patient_snapshot_population_sets[:patients].keys.each do |patient|
        patient = Record.where(id: patient).first
        post_upload_filtered_calc_results = (patient.calc_results.find { |result| result[:measure_id] == measure.hqmf_set_id && result[:population_index] == population_set_index }).slice(*ATTRIBUTE_FILTER) unless patient.results_exceed_storage
        if !patient.results_exceed_storage
          if (patient.calc_results.find{ |result| result[:measure_id] == measure.hqmf_set_id && result[:population_index] == population_set_index })['status'] == 'pass'
            status = 'pass'
            patient_snapshot_population_sets.summary[:pass_after] += 1
          else
            status = 'fail'
            patient_snapshot_population_sets.summary[:fail_after] += 1
          end
        else
          if (patient.condensed_calc_results.find{ |result| result[:measure_id] == measure.hqmf_set_id && result[:population_index] == population_set_index })['status'] == 'pass'
            status = 'pass'
            patient_snapshot_population_sets.summary[:pass_after] += 1
          else
            status = 'fail'
            patient_snapshot_population_sets.summary[:fail_after] += 1
          end
        end
        patient_snapshot_population_sets.patients[patient.id.to_s].merge!(post_upload_results: post_upload_filtered_calc_results, post_upload_status: status, results_exceeds_storage_post_upload: patient.results_exceed_storage, patient_version_after_upload: patient.version)
      end
      patient_snapshot_population_sets.save!
    end
  end

  def self.calculate_updated_actuals(measure)
    calculator = BonnieBackendCalculator.new
    measure.populations.each_with_index do |population, population_index|
      # Set up calculator for this measure and population, making sure we regenerate the javascript
      populations_to_process = population.keys.reject { |k| k == 'id' || k == 'title' }
      populations_to_process.push('rationale', 'finalSpecifics')
      begin
        calculator.set_measure_and_population(measure, population_index, clear_db_cache: true, rationale: true)
      rescue => e
        setup_exception = "Measure setup exception: #{e.message}"
      end
      patients = Record.where(user_id: measure.user_id, measure_ids: measure.hqmf_set_id)
      patients.each do |patient|
        unless setup_exception
          begin
            result = calculator.calculate(patient).slice(*populations_to_process)
          rescue => e
            calculation_exception = "Measure calculation exception: #{e.message}"
          end
        end
        result[:measure_id] = measure.hqmf_set_id
        result[:population_index] = population_index
        if !patient.calc_results.nil?
          calc_results = patient.calc_results.dup
          # Clear any prior results for this measure to ensure a clean update, i.e. a change in the number of populations.
          calc_results.reject! { |av| av['measure_id'] == measure.hqmf_set_id && (av['population_index'] == population_index || av['population_index'] >= measure.populations.count) }
          calc_results << result
          patient.calc_results = calc_results
        else
          patient.calc_results = [result]
        end

        patient.has_measure_history = true
        patient.save!
      end
    end
  end

end
