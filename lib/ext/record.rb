# Extensions to the Record model in health-data-standards to add needed functionality for test patient generation
class Record
  field :type, type: String
  field :measure_ids, type: Array
  field :source_data_criteria, type: Array
  field :expected_values, type: Array
  field :notes, type: String
  field :is_shared, :type => Boolean
  field :origin_data, type: Array

  belongs_to :user
  belongs_to :bundle, class_name: "HealthDataStandards::CQM::Bundle"
  scope :by_user, ->(user) { where({'user_id'=>user.id}) }
  scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where ({'user_id'=>user.id, 'measure_ids'=>{'$in'=>[hqmf_set_id]} }) }

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
  #
  # If this method is given a block it will yield when changes are made to the expected_values structure. The things it
  # yields are as follows:
  #    change_type - A symbol describing the change made. e.x. :population_set_removal
  #    change_reason - A symbol describing reason the change was made. e.x. :dup_population
  #    expected_value_set - The set removed, added, or changed.
  def update_expected_value_structure!(measure)
    # ensure there's the correct number of population sets
    # TODO: FIX THIS: this will overcount if there is garbage data or duplicate population sets and make the code below
    #       fail to do it's job properly. This would be valid to do after the removal of garbage_data was the first thing done.
    patient_population_count = self.expected_values.count { |expected_value_set| expected_value_set[:measure_id] == measure.hqmf_set_id }
    measure_population_count = measure.populations.count
    # add new population sets. the rest of the data gets added below.
    if patient_population_count < measure_population_count
      (patient_population_count..measure_population_count-1).each do |index|
        new_expected_values = {measure_id: measure.hqmf_set_id, population_index: index}
        # yield info about this addition
        yield :population_set_addition, :missing_population, new_expected_values if block_given?
        self.expected_values << new_expected_values
      end
    end

    # keep track of the population indexes we have seen so we can reject duplicates
    population_indexes_found = []
    # delete population sets present on the patient but not in the measure. also get rid of garbage and duplicate data.
    self.expected_values.reject! do |expected_value_set|
      matches_measure = expected_value_set[:measure_id] ? expected_value_set[:measure_id] == measure.hqmf_set_id : false
      # check if population_index is non-existent, i.e. this is a set of garbage data
      is_garbage_data = !expected_value_set.has_key?('population_index')
      is_extra_population = expected_value_set[:population_index] ? expected_value_set[:population_index] >= measure_population_count : false

      is_duplicate_population = false
      # if it isn't garbage data or an extra population, check if it's a duplicate and/or add it to the list of seen populations
      if !is_garbage_data && !is_extra_population
        if population_indexes_found.include? expected_value_set[:population_index]
          is_duplicate_population = true
        else
          # add this population_index to the list of ones we have already seen
          population_indexes_found << expected_value_set[:population_index]
        end
      end

      # remove if it is part of this measure and has any of the three checked issues
      if matches_measure && (is_extra_population || is_garbage_data || is_duplicate_population)
        # if a block is given prepare some data and yield info about the removal
        if block_given?
          if is_extra_population
            change_reason = :extra_population
          elsif is_garbage_data
            change_reason = :garbage_data
          elsif is_duplicate_population
            change_reason = :dup_population
          end
          # Yield this change being made, with change_type symbol, change_reason symbol and the structure
          yield :population_set_removal, change_reason, expected_value_set
        end

        true
      else
        false
      end
    end


    # TODO: make this part of the code yield changes.
    # ensure there's the correct number of populations for each population set
    self.expected_values.each do |expected_value_set|
      # ignore if it's not related to the measure (can happen for portfolio users)
      next unless expected_value_set[:measure_id] == measure.hqmf_set_id

      expected_value_population_set = expected_value_set.slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).keys
      measure_population_set = measure.populations[expected_value_set[:population_index]].slice(*HQMF::PopulationCriteria::ALL_POPULATION_CODES).keys

      # add population sets that didn't exist (populations in the measure that don't exist in the expected values)
      added_populations = measure_population_set - expected_value_population_set
      added_populations.each do |population|
        if population == 'OBSERV'
          expected_value_set[population] = []
        else
          expected_value_set[population] = 0
        end
      end

      # delete populations that no longer exist (populations in the expected values that don't exist in the measure)
      removed_populations = expected_value_population_set - measure_population_set
      expected_value_set.except!(*removed_populations)
    end
    self.save!
  end

end
