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
  field :condensed_bc_of_size_results, type: Array
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

  track_history :on => [:source_data_criteria, :birthdate, :gender, :deathdate, :race, :ethnicity, :expected_values, :expired, :deathdate, :results_exceed_storage, :results_size], changes_method: :my_changes,
                :modifier_field => :modifier,
                :version_field => :version,   # adds "field :version, :type => Integer" to track current version, default is :version
                :track_create   =>  true,   # track document creation, default is true
                :track_update   =>  true,   # track document updates, default is true
                :track_destroy  =>  true    # track document destruction, default is true

  def my_changes
    sdc_changes
  end

  def sdc_changes
    return changes if changes['source_data_criteria'].nil?

    original_dc = changes['source_data_criteria'][0].index_by { |sdc| sdc['criteria_id'] }
    modified_dc = changes['source_data_criteria'][1].index_by { |sdc| sdc['criteria_id'] }

    # We want to return two sets of data, one with criteria that have been deleted and criteria that have been
    # changed, and another with criteria that have been added and criteria that have been changed
    original = []
    modified = []

    original_dc.each do |id, odc|
      mdc = modified_dc[id]
      # The coded_entry_id always changes on a save, so exclude it from comparisons
      if mdc && mdc.except('coded_entry_id') != odc.except('coded_entry_id')
        # Changed
        original << odc
        modified << mdc
      end
      # Deleted
      original << odc unless mdc
    end

    modified_dc.each do |id, mdc|
      odc = original_dc[id]
      # Added
      modified << mdc unless odc
    end

    # We don't need to track the MeasurePeriod changes
    modified.reject! { |dc| dc['id'] == 'MeasurePeriod' }

    # Set the retrun value
    # return source_data_criteria only if there are changes to it that we are interested in
    if !original.empty? || !modified.empty?
      changes.merge('source_data_criteria' => [original, modified])
    else
      changes.reject! { |k| k == 'source_data_criteria' }
    end
  end # def

  protected
  # Centralized place for determining if a test case/patient passes or fails.
  # The number of populations and the expected vales for those populations is determined when the measure
  #   is loaded or updated.
  def calc_status
    expected_values.each_index do |pop_idx|
      # indexes are zero based
      # TODO: fix the expected values on the patient based on what the measure has
      break if (calc_results.empty? || (pop_idx == calc_results.length && calc_results.length != 0))
      calc_results[pop_idx][:status] = (expected_values[pop_idx].to_a - calc_results[pop_idx].to_a).empty? ? 'pass' : 'fail'
    end
  end

  def size_check
    self.results_size = calc_results.to_json.size
    if self.results_size > 12000000
      self.results_exceed_storage = true
      calc_results.each do |cr|
        cr.delete('rationale')
        cr.delete('finalSpecifics')
      end
      self.condensed_bc_of_size_results = calc_results
      unset(:calc_results)
    else
      self.results_exceed_storage = false
      unset(:condensed_bc_of_size_results)
    end 
  end

end