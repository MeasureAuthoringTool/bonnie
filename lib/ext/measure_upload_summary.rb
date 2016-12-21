module UploadSummary
  # The measure summary contains information about the state of a measure just before and just after
  # an upload.
  # The measure summary contains hqmf id information, the database ids, the cms ids, the hqmf version
  # numbers, the number of populations, the user information, and the population calculation summary
  # both before and after the measure upload.
  class MeasureSummary

    include Mongoid::Document
    include Mongoid::Timestamps
    store_in collection: 'upload_summaries'

    field :hqmf_id, type: String
    field :hqmf_set_id, type: String
    field :uploaded_at, type: Time, default: -> { Time.current }
    field :measure_db_id_pre_upload, type: BSON::ObjectId # The mongoid id of the measure before it is archived
    field :measure_db_id_post_upload, type: BSON::ObjectId # The mongoid id of the measure post_upload_results it is has been updated
    field :cms_id_pre_upload, type: String
    field :cms_id_post_upload, type: String
    field :hqmf_version_number_pre_upload, type: String
    field :hqmf_version_number_post_upload, type: String
    field :measure_population_set_count, type: Hash, default: {pre_upload: 0, post_upload: 0}
    belongs_to :user
    embeds_many :population_set_summaries, cascade_callbacks: true
    accepts_nested_attributes_for :population_set_summaries

    index "user_id" => 1
    scope :by_user, ->(user) { where({'user_id'=>user.id}) }
    scope :by_user_and_hqmf_set_id, ->(user, hqmf_set_id) { where({'user_id'=>user.id, 'hqmf_set_id'=>hqmf_set_id}) }

    # based on the current_measure (required) and archived_measure (optional), adds all of the
    # measure summary information to the object.
    def populate_measure_summary_information(current_measure, archived_measure)
      self.hqmf_id = current_measure.hqmf_id
      self.hqmf_set_id = current_measure.hqmf_set_id
      self.user_id = current_measure.user_id

      # get archive measure information for 'pre' upload
      if archived_measure
        self.measure_db_id_pre_upload = archived_measure.measure_db_id
        self.cms_id_pre_upload = archived_measure.measure_content['cms_id']
        self.hqmf_version_number_pre_upload = archived_measure.measure_content['hqmf_version_number']
        self.measure_population_set_count[:pre_upload] = archived_measure.measure_content['populations'].count
      end

      # get current measure information for 'post' upload
      self.measure_db_id_post_upload = current_measure.id
      self.cms_id_post_upload = current_measure.cms_id
      self.hqmf_version_number_post_upload = current_measure.hqmf_version_number
      self.measure_population_set_count[:post_upload] = current_measure.populations.count

      get_population_set_summaries(current_measure, archived_measure)
    end

    # goes through each population and calculates the population summary information.
    # NOTE: as part of this calculation, it recalculates the patient against the current_measure.
    # It assumes initially that the patient calculations are relevant to the archived_measure.
    def get_population_set_summaries(current_measure, archived_measure)
      patients = Record.where(user_id: current_measure.user_id, measure_ids: current_measure.hqmf_set_id)

      # if there is no archived_measure, set this to 0
      pre_upload_population_set_count = archived_measure ? archived_measure.measure_content['populations'].count : 0
      # there should always be a current_measure
      post_upload_population_set_count = current_measure.populations.count

      # store patient calculation information based on the archived_measure
      (0..pre_upload_population_set_count-1).each do |population_set_index|
        population_set_summary = PopulationSetSummary.new
        self.population_set_summaries << population_set_summary

        population_set_summary.store_patient_information(current_measure, patients, population_set_index, :pre_upload)
      end
      
      # clear out any existing calc_results so that all of the calc_results will be based on the new version of the measure
      # rework the expected value structure for the newly uploaded measure.
      patients.each do |patient|
        patient.clear_existing_calc_results!(current_measure)
        patient.update_expected_value_structure!(current_measure)
      end

      # recalculate the patient information for the newly uploaded measure and
      # note that the patient has measure history
      calculator = BonnieBackendCalculator.new
      current_measure.populations.each_with_index do |population, population_set_index|
        patients.each do |patient|
          patient.has_measure_history = true # update_calc_results does the patient save to persist this change
          begin
            patient.update_calc_results!(current_measure, population_set_index, calculator)
          rescue => e
            puts "\n\nThere has been an error calculating the patient in measure_upload_summary:get_population_set_summaries"
            puts "Error for #{current_measure.user.email} measure #{current_measure.cms_id} population set #{population_set_index} patient '#{patient.first} #{patient.last}' (_id: ObjectId('#{patient.id}'))"
            puts e.message
            puts e.backtrace.inspect
            puts "\n\n"
            raise e # want to re-raise the error so any internal handling continues
          end
        end
      end

      # store patient calculation information based on the newly uploaded measure
      (0..post_upload_population_set_count-1).each do |population_set_index|
        if population_set_index >= self.population_set_summaries.count
          population_set_summary = PopulationSetSummary.new
          self.population_set_summaries << population_set_summary
        else
          population_set_summary = self.population_set_summaries[population_set_index]
        end

        population_set_summary.store_patient_information(current_measure, patients, population_set_index, :post_upload)
      end
    end

    def self.create_measure_upload_summary(current_measure, archived_measure)
      measure_upload_summary = MeasureSummary.new
      measure_upload_summary.populate_measure_summary_information(current_measure, archived_measure)
      measure_upload_summary.save!
      measure_upload_summary
    end
  end

  # the population set summary information contains the number of patients that passed or failed
  # for that population both before and after the measure upload.
  # This is contained in the measure summary object.
  class PopulationSetSummary
    include Mongoid::Document
    include Mongoid::Timestamps

    field :patients, type: Hash, default: {}
    field :summary, type: Hash, default: { pass_before: 0, pass_after: 0, fail_before: 0, fail_after: 0 }
    embedded_in :measure_summaries

    ATTRIBUTE_FILTER = HQMF::PopulationCriteria::ALL_POPULATION_CODES + ['rationale', 'finalSpecifics']

    # stores the calculation summary information for a collection of patients in the population summary
    # object. The 'upload_timing' argument determines if the pre-upload calculation information is being
    # stored (used :pre_upload) or if the post-upload information is being stored (use :post_upload).
    def store_patient_information(current_measure, patients, population_set_index, upload_timing)
      patients.each do |patient|
        # TODO: results exceed storage doens't pay attention to multiple populations or to multipe measure inputs
        if patient.results_exceed_storage
          calc_results = patient.condensed_calc_results.find { |result| result[:measure_id] == current_measure.hqmf_set_id && result[:population_index] == population_set_index }
        else
          calc_results = patient.calc_results.find { |result| result[:measure_id] == current_measure.hqmf_set_id && result[:population_index] == population_set_index }
        end

        # calc_results could be nil if the population set counts don't align
        if calc_results
          expected_results = patient.expected_values.find { |value| value[:measure_id] == current_measure.hqmf_set_id && value[:population_index] == population_set_index }
          if upload_timing == :pre_upload
            store_pre_upload_patient_information(patient, expected_results, calc_results)
          elsif upload_timing == :post_upload
            store_post_upload_patient_information(patient, expected_results, calc_results)
          end
        end
      end

      save!
    end

    protected

    def store_pre_upload_patient_information(patient, expected_results, calc_results)
      status = calc_results[:status]
      if status == 'pass'
        self.summary[:pass_before] += 1
      else
        self.summary[:fail_before] += 1
      end

      patient_summary = {
        # TODO: why isn't this 'pre_expected'?
        expected: expected_results.slice(*ATTRIBUTE_FILTER),
        pre_upload_results: patient.results_exceed_storage ? nil : calc_results.slice(*ATTRIBUTE_FILTER),
        pre_upload_status: status,
        results_exceeds_storage_pre_upload: patient.results_exceed_storage
      }

      self.patients[patient.id.to_s] ||= {}
      self.patients[patient.id.to_s].merge!(patient_summary)
    end

    def store_post_upload_patient_information(patient, expected_results, calc_results)
      status = calc_results[:status]
      if status == 'pass'
        self.summary[:pass_after] += 1
      else
        self.summary[:fail_after] += 1
      end

      patient_summary = {
        post_upload_results: patient.results_exceed_storage ? nil : calc_results.slice(*ATTRIBUTE_FILTER),
        post_upload_status: status,
        results_exceeds_storage_post_upload: patient.results_exceed_storage,
        # TODO: why don't we have a pre-upload version?
        patient_version_after_upload: patient.version
      }

      self.patients[patient.id.to_s] ||= {}
      self.patients[patient.id.to_s].merge!(patient_summary)

      # if there's no expected result for the population set, that means the population set didn't previously
      # exist. This adds a zeroed set of expectations to the population set (it's zeroed because the
      # 'update_expected_value_structure' on the patient sets a new set of expected values to zeroes).
      unless self.patients[patient.id.to_s][:expected]
        self.patients[patient.id.to_s][:expected] = expected_results.slice(*ATTRIBUTE_FILTER)
      end
    end
  end
end
