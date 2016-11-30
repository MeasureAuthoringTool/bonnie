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
    field :measure_cms_id_pre_upload, type: String
    field :measure_cms_id_post_upload, type: String
    field :measure_hqmf_version_number_pre_upload, type: String
    field :measure_hqmf_version_number_post_upload, type: String
    field :measure_population_set_count, type: Hash, default: {pre_upload: 0, post_upload: 0}
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

  def self.collect_before_upload_state(measure, archived_measure, measure_patients)

    # We need to iterate over the population sets in the archived_measure (aka the old version) of the measure
    # because the new version of the measure may change the number of population sets.
    # If archived_measure is nil then it means that we are dealing with the first upload of the measure after
    # its initial load. In this state there is archived_measure yet.
    if archived_measure
      before_upload_population_sets = archived_measure.measure_content['populations']
    else
      before_upload_population_sets = measure.populations
    end

    measure_upload_summary = MeasureSummary.new
    before_upload_population_sets.each_index do |populaton_set_index|
      population_set_summary = PopulationSetSummary.new
      measure_patients.each do |patient|
        population_set_summary.before_measure_load_compare(patient, populaton_set_index, measure.hqmf_set_id)
      end
      measure_upload_summary.population_set_summaries << population_set_summary
    end
    measure_upload_summary.hqmf_id = measure.hqmf_id
    measure_upload_summary.hqmf_set_id = measure.hqmf_set_id
    measure_upload_summary.user_id = measure.user_id
    if archived_measure
      measure_upload_summary.measure_db_id_pre_upload = archived_measure.measure_db_id
      measure_upload_summary.measure_cms_id_pre_upload = archived_measure.measure_content['cms_id']
      measure_upload_summary.hqmf_version_number_pre_upload = archived_measure.measure_content['hqmf_version_number']
    end
    measure_upload_summary.measure_db_id_post_upload = measure.id
    measure_upload_summary.measure_cms_id_post_upload = measure.cms_id
    measure_upload_summary.measure_hqmf_version_number_post_upload = measure.hqmf_version_number
    measure_upload_summary.measure_population_set_count[:pre_upload] = before_upload_population_sets.count
    measure_upload_summary.measure_population_set_count[:post_upload] = measure.populations.count
    measure_upload_summary.save!
    measure_upload_summary.id
  end

  def self.collect_after_upload_state(measure, upload_summary_id, measure_patients)
    measure_upload_summary = MeasureSummary.where(id: upload_summary_id).first
    if measure_upload_summary.measure_population_set_count[:pre_upload] < measure_upload_summary.measure_population_set_count[:post_upload]
      
      population_sets_to_add = measure_upload_summary.measure_population_set_count[:post_upload] - measure_upload_summary.measure_population_set_count[:pre_upload]
      # Add the missing population sets
      # Using downto so that the population sets can be added from where they are missing.
      # It needs to be done this way as the order of the population sets is their population_index.
      population_sets_to_add.downto(1) do |i|
        new_population_set = PopulationSetSummary.new
        missing_expected_values = {}
        # Get the populations 
        (measure.populations[-i].keys.to_a - ['id', 'title']).each { |population| missing_expected_values[population] = 0 }
        # Add all of the patients with their expected values
        measure_patients.each { |patient| new_population_set['patients'][patient.id.to_s] = {:expected => missing_expected_values} }
        measure_upload_summary.population_set_summaries << new_population_set 
      end # downto
    end

    measure_upload_summary.population_set_summaries.each_with_index do |population_set, population_set_index|
      # Only work on the population sets that exist.  It is possible that in the new version of the meausre
      # there are few population sets than in the previous version.
      break if population_set_index >= measure.populations.count
        measure_patients.each do |patient|

        status = 'fail'
        if !patient.results_exceed_storage
          post_upload_filtered_calc_results = (patient.calc_results.find { |result| result[:measure_id] == measure.hqmf_set_id && result[:population_index] == population_set_index }).slice(*ATTRIBUTE_FILTER)
          status = 'pass' if (patient.calc_results.find{ |result| result[:measure_id] == measure.hqmf_set_id && result[:population_index] == population_set_index })['status'] == 'pass'
        else
          status = 'pass' if (patient.condensed_bc_of_size_results.find{ |result| result[:measure_id] == measure.hqmf_set_id && result[:population_index] == population_set_index })['status'] == 'pass'
        end

        if status == 'pass'
          population_set.summary[:pass_after] += 1
        else
          population_set.summary[:fail_after] += 1
        end

        population_set.patients[patient.id.to_s].merge!(post_upload_results: post_upload_filtered_calc_results, 
            post_upload_status: status,
            results_exceeds_storage_post_upload: patient.results_exceed_storage,
            patient_version_after_upload: patient.version)
      end # patient_snapshot_population_sets[:patients].keys.each
    end
    measure_upload_summary.save!
  end

  def self.calculate_updated_actuals(measure, measure_patients)
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
      measure_patients.each do |patient|
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
