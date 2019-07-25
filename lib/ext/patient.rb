module CQM
  class Patient
    RACE_NAME_MAP={'1002-5' => 'American Indian or Alaska Native','2028-9' => 'Asian','2054-5' => 'Black or African American','2076-8' => 'Native Hawaiian or Other Pacific Islander','2106-3' => 'White','2131-1' => 'Other'}.freeze
    ETHNICITY_NAME_MAP={'2186-5'=>'Not Hispanic or Latino', '2135-2'=>'Hispanic Or Latino'}.freeze

    belongs_to :user
    scope :by_user, ->(user) { where({'user_id'=>user.id}) }
    scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where({ 'user_id' => user.id, 'measure_ids' => hqmf_set_id }) }

    index 'user_id' => 1
    index 'user_id' => 1, 'measure_ids' => 1

    has_and_belongs_to_many :measures, class_name: 'CQM::Measure'

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
    # If this method is given a block it will yield when changes are made to the expectedValues structure. The things it
    # yields are as follows:
    #    change_type - A symbol describing the change made. e.x. :population_set_removal
    #    change_reason - A symbol describing reason the change was made. e.x. :dup_population
    #    expected_value_set - The set removed, added, or changed.
    def update_expected_value_structure!(measure)
      measure_population_count = measure.population_sets.count

      # keep track of the population indexes we have seen so we can reject duplicates
      population_indexes_found = Hash.new { |h, k| h[k] = [] } # make is so uninitialized keys are set to []
      # delete population sets present on the patient but not in the measure. also get rid of garbage and duplicate data.
      expectedValues.reject! do |expected_value_set|
        # if there is no measure_id then just clean this up
        if !expected_value_set.key?('measure_id')
          matches_measure = true
          is_garbage_data = true
        else # if there is a measure_id, do the rest of the checks
          matches_measure = expected_value_set[:measure_id] ? expected_value_set[:measure_id] == measure.hqmf_set_id : false
          # check if population_index or is non-existent, i.e. this is a set of garbage data
          is_garbage_data = !expected_value_set.key?('population_index')
          is_extra_population = expected_value_set[:population_index] ? expected_value_set[:population_index] >= measure_population_count : false

          is_duplicate_population = false
          # if it isn't garbage data or an extra population, check if it's a duplicate and/or add it to the list of seen populations
          if !is_garbage_data && !is_extra_population
            if population_indexes_found[expected_value_set[:measure_id]].include? expected_value_set[:population_index]
              is_duplicate_population = true
            else
              # add this population_index to the list of ones we have already seen
              population_indexes_found[expected_value_set[:measure_id]] << expected_value_set[:population_index]
            end
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
            # Yield this change being made, with change_type symbol, change_reason symbol and the structure being removed
            yield :population_set_removal, change_reason, expected_value_set.deep_dup
          end

          true
        else
          false
        end
      end

      # add missing population sets
      patient_population_count = expectedValues.count { |expected_value_set| expected_value_set[:measure_id] == measure.hqmf_set_id }
      # add new population sets. the rest of the data gets added below.
      if patient_population_count < measure_population_count
        (patient_population_count..measure_population_count-1).each do |index|
          new_expected_values = {'measure_id' => measure.hqmf_set_id, 'population_index' => index}
          # yield info about this addition
          yield :population_set_addition, :missing_population, new_expected_values.deep_dup if block_given?
          expectedValues << new_expected_values
        end
      end

      # ensure there's the correct number of populations for each population set
      expectedValues.each do |expected_value_set|
        # ignore if it's not related to the measure (can happen for portfolio users)
        next unless expected_value_set['measure_id'] == measure.hqmf_set_id

        pop_idx = expected_value_set['population_index']
        expected_value_population_set = expected_value_set.keys & CQM::Measure::ALL_POPULATION_CODES
        measure_population_set = measure.population_sets[pop_idx].bonnie_result_criteria_names

        # add population sets that didn't exist (populations in the measure that don't exist in the expected values)
        added_populations = measure_population_set - expected_value_population_set
        # create the structure to yield about these changes
        added_changes = {'measure_id' => measure.hqmf_set_id, 'population_index' => pop_idx}
        if added_populations.count.positive?
          added_populations.each do |population|
            if population == 'OBSERV'
              expected_value_set[population] = []
              added_changes[population] = []
            else
              expected_value_set[population] = 0
              added_changes[population] = 0
            end
          end
          # yield the info about things that are added.
          yield :population_addition, :missing_population, added_changes if block_given?
        end

        # delete populations that no longer exist (populations in the expected values that don't exist in the measure)
        removed_populations = expected_value_population_set - measure_population_set
        next unless removed_populations.count.positive?
        # create the structure to yield about these changes
        removed_changes = {'measure_id' => measure.hqmf_set_id, 'population_index' => pop_idx}
        removed_populations.each { |population| removed_changes[population] = expected_value_set[population] }

        expected_value_set.except!(*removed_populations)
        # yield the info about things removed
        yield :population_removal, :extra_population, removed_changes if block_given?

      end
      save!
    end
  end
end
