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
  field :actual_values, type: Array

  belongs_to :user
  belongs_to :bundle, class_name: "HealthDataStandards::CQM::Bundle"
  scope :by_user, ->(user) { where({'user_id'=>user.id}) }

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

  ##############################
  #    History Tracking
  ##############################

  track_history :on => [:source_data_criteria, :birthdate, :gender, :deathdate, :race, :ethnicity, :expected_values, :expired, :deathdate, :actual_values], changes_method: :my_changes,
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

end