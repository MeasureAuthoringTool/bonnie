# Extensions to the Record model in health-data-standards to add needed functionality for test patient generation
class Record

  include Mongoid::History::Trackable

  field :type, type: String
  field :measure_ids, type: Array
  field :source_data_criteria, type: Array
  field :expected_values, type: Array
  field :notes, type: String
  field :is_shared, :type => Boolean
  field :origin_data, type: Array
  field :calc_results, type: Array, default: []
  field :has_measure_history, type: Boolean, default: false # has the record gone through an update to the measure
  field :results_exceed_storage, type: Boolean, default: false # True when the size of calc_results > 12000000
  field :condensed_calc_results, type: Array
  field :results_size, type: Integer

  belongs_to :user
  belongs_to :bundle, class_name: "HealthDataStandards::CQM::Bundle"
  scope :by_user, ->(user) { where({'user_id'=>user.id}) }
  scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where ({'user_id'=>user.id, 'measure_ids'=>{'$in'=>[hqmf_set_id]} }) }

  before_save :calc_status
  before_save :size_check

  # User email or measure CMS ID can be prepopulated (to solve 1+N performance issue) or just retrieved
  attr_writer :user_email
  def user_email
    @user_email || user.try(:email)
  end

  attr_writer :cms_id
  def cms_id
    @cms_id || begin
                 measure_id = measure_ids.first # gets the primary measure ID
                 measure = Measure.where(hqmf_set_id: measure_id, user_id: user_id).first # gets corresponding measure, for this user
                 measure.try(:cms_id)
               end
  end

  def rebuild!(payer=nil)
    Measures::PatientBuilder.rebuild_patient(self)
    if payer
      insurance_provider = InsuranceProvider.new
      insurance_provider.type = payer
      insurance_provider.member_id = '1234567890'
      insurance_provider.name = Measures::PatientBuilder::INSURANCE_TYPES[payer]
      insurance_provider.financial_responsibility_type = {'code' => 'SELF', 'codeSystem' => 'HL7 Relationship Code'}
      insurance_provider.start_time = Time.new(2008,1,1).to_i
      insurance_provider.payer = Organization.new
      insurance_provider.payer.name = insurance_provider.name
      insurance_provider.codes["SOP"] = [Measures::PatientBuilder::INSURANCE_CODES[payer]]
      self.insurance_providers.clear << insurance_provider
    end
  end

  # Supports the exporting of the expected values in the QRDA export of the patients
  # Note: There is logic in health-data-standards _measures.cat1.erb for further formatting.
  # The special handling of the key 'DENEX' is do to the fact that the description of this population
  #  stored in many of the measures is incorrect (it is often just 'Denominator' instead of
  #  'Denominator Exclusion').
  def expected_values_for_qrda_export(measure)
    qrda_expected_values = []
    expected_pop_names = HQMF::PopulationCriteria::ALL_POPULATION_CODES - %w{STRAT OBSERV}
    measure.populations.each_with_index do |pop, idx|
      pop.each do |pkey, pvalue|
        next unless expected_pop_names.include?(pkey)
        this_ev = {}
        this_ev[:hqmf_id] = measure.population_criteria[pvalue.to_s]['hqmf_id']
        if pkey == 'DENEX'
          this_ev[:display_name] = 'Denominator Exclusions'
        else
          this_ev[:display_name] = measure.population_criteria[pvalue.to_s]['title']
        end
        this_ev[:code] = pkey
        this_ev[:expected_value] = self.expected_values[idx][pkey].to_s
        qrda_expected_values << this_ev
      end
    end
    qrda_expected_values
  end

  ##############################
  #    History Tracking
  ##############################

  track_history :on => [:source_data_criteria, :birthdate, :gender, :deathdate, :race, :ethnicity, :expected_values, :expired, :deathdate, :results_exceed_storage, :results_size], changes_method: :source_data_criteria_changes,
                :modifier_field => :modifier,
                :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                :track_create   =>  true,   # track document creation, default is true
                :track_update   =>  true,   # track document updates, default is true
                :track_destroy  =>  true    # track document destruction, default is true

  # This function goes deeper into the source data criteria to look for changes.
  # Each time the record is materialized on the the front end, a new coded_entry_id is genereated.
  # When the record is saved, this new coded_entry_id is also saved.  For the sake of 
  # tracking differences the coded_entry_id is not of interest.
  def source_data_criteria_changes
    return changes if changes['source_data_criteria'].nil? || changes['source_data_criteria'][0].nil?

    original_data_criteria = changes['source_data_criteria'][0].index_by { |source_data_criterium| source_data_criterium['criteria_id'] }
    modified_data_criteria = changes['source_data_criteria'][1].index_by { |source_data_criterium| source_data_criterium['criteria_id'] }

    # We are going to overwrite the original 'original' and 'modified' arrays from the
    # history_tracker with new versions.  The reason for this is to exclude changes
    # that happened to coded_entry_id or MeasurePeriod.
    original = []
    modified = []

    original_data_criteria.each do |id, odc|
      mdc = modified_data_criteria[id]
      # The coded_entry_id always changes on a save, so exclude it from comparisons
      if mdc && mdc.except('coded_entry_id') != odc.except('coded_entry_id')
        # Changed
        original << odc
        modified << mdc
      end
      # Deleted
      original << odc unless mdc
    end

    modified_data_criteria.each do |id, mdc|
      odc = original_data_criteria[id]
      # Added
      modified << mdc unless odc
    end

    # We don't need to track the MeasurePeriod changes
    # Only need to remove from 'modified'. History tracking gem will ignore if not in 'modified'.
    modified.reject! { |dc| dc['id'] == 'MeasurePeriod' }

    # Set the return value
    # return source_data_criteria only if there are changes to it that we are interested in
    if !original.empty? || !modified.empty?
      changes.merge('source_data_criteria' => [original, modified])
    else
      changes.reject! { |k| k == 'source_data_criteria' }
    end
  end # def

  # Updates the population set structure of the expected values to match the population set structure
  # on the measure.
  # If the measure has more population sets than the patient, the new population set is added to the
  # patient with zero values for each population.
  # If the measure has less population sets than the patient, extra population sets on the patient are
  # removed.
  # if a population set has additional populations in a measure, those populations are added to the
  # patient's population set with a value of zero.
  # if a population set has fewer populations in a measure, any additional populations in the patient's
  # population set are removed.
  def update_expected_value_structure!(measure)
    # ensure there's the correct number of population sets
    patient_population_count = self.expected_values.count { |expected_value_set| expected_value_set[:measure_id] == measure.hqmf_set_id }
    measure_population_count = measure.populations.count
    # add new population sets. the rest of the data gets added below.
    if patient_population_count < measure_population_count
      (patient_population_count..measure_population_count-1).each do |index|
        self.expected_values << {measure_id: measure.hqmf_set_id, population_index: index}
      end
    end
    # delete population sets present on the patient but not in the measure
    self.expected_values.reject! do |expected_value_set|
      matches_measure = expected_value_set[:measure_id] ? expected_value_set[:measure_id] == measure.hqmf_set_id : false
      is_extra_population = expected_value_set[:population_index] ? expected_value_set[:population_index] >= measure_population_count : false
      matches_measure && is_extra_population
    end

    # ensure there's the correct number of populations for each population set
    self.expected_values.each do |expected_value_set|
      # ignore if it's not related to the measure (can happen for portfolio users)
      next unless expected_value_set[:measure_id] == measure.hqmf_set_id

      expected_value_population_set = expected_value_set.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).keys
      measure_population_set = measure.populations[expected_value_set[:population_index]].slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).keys

      # add population sets that didn't exist (populations in the measure that don't exist in the expected values)
      added_populations = measure_population_set - expected_value_population_set
      added_populations.each do |population|
        expected_value_set[population] = 0
      end

      # delete populations that no longer exist (populations in the expected values that don't exist in the measure)
      removed_populations = expected_value_population_set - measure_population_set
      expected_value_set.except!(*removed_populations)
    end
    self.save!
  end

  # recalculates the patient and stores the information for the given measure and
  # population within the patient model.
  def update_calc_results!(measure, population_set_index, calculator=nil)
    unless calculator
      calculator = BonnieBackendCalculator.new
    end
    calculator.set_measure_and_population(measure, population_set_index, clear_db_cache: true, rationale: true)

    populations_to_process = HQMF::PopulationCriteria::ALL_POPULATION_CODES + ['rationale', 'finalSpecifics']

    result = calculator.calculate(self).slice(*populations_to_process)

    result[:measure_id] = measure.hqmf_set_id
    result[:population_index] = population_set_index
    if self.calc_results.nil?
      self.calc_results = [result]
    else
      self.calc_results << result
    end

    self.has_measure_history = true
    save!
  end

  # clears out the existing calculated results on the patient record for the provided measure
  def clear_existing_calc_results!(measure)
    self.calc_results.reject! { |result| result['measure_id'] == measure.hqmf_set_id } if self.calc_results
    self.condensed_calc_results.reject! { |result| result['measure_id'] == measure.hqmf_set_id } if self.condensed_calc_results
    self.results_exceed_storage = false
    self.results_size = 0
    self.save!
  end

  protected

  # Centralized place for determining if a test case/patient passes or fails.
  # The number of populations and the expected vales for those populations is determined when the measure
  #   is loaded or updated.
  def calc_status
    return if calc_results.blank?
    expected_values.each do |expected_value|
      population_set_index = expected_value[:population_index]
      calc_result = calc_results.find { |result| result[:measure_id] == expected_value[:measure_id] && result[:population_index] == population_set_index }

      # stop if the expected value result can't be found in the calculated values
      break unless calc_result

      filtered_expected_values = expected_value.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES)
      filtered_calc_results = calc_result.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES)

      status = (filtered_expected_values.to_a - filtered_calc_results.to_a).empty?

      calc_result[:status] = status ? 'pass' : 'fail'
    end
  end

  def size_check
    self.results_size = calc_results.to_json.size
    if self.results_size > APP_CONFIG['record']['max_size_in_bytes']
      self.results_exceed_storage = true
      calc_results.each do |cr|
        cr.delete('rationale')
        cr.delete('finalSpecifics')
      end
      self.condensed_calc_results = calc_results
      unset(:calc_results)
    else
      self.results_exceed_storage = false
      unset(:condensed_calc_results)
    end
  end

end
