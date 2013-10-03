class Measure
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_EFFECTIVE_DATE = Time.gm(2012,12,31,23,59).to_i
  MP_START_DATE = Time.gm(2012,1,1,0,0).to_i
  TYPES = ["ep", "eh"]

  store_in collection: 'draft_measures'

  field :id, type: String
  field :endorser, type: String
  field :measure_id, type: String
  field :hqmf_id, type: String # should be using this one as primary id!!
  field :hqmf_set_id, type: String
  field :hqmf_version_number, type: Integer
  field :cms_id, type: String
  field :title, type: String
  field :description, type: String
  field :type, type: String
  field :category, type: String
  field :steward, type: String    # organization who's writing the measure
  field :episode_of_care, type: Boolean
  field :continuous_variable, type: Boolean
  field :episode_ids, type: Array # of String ids
  field :custom_functions, type: Hash # stores a custom function for a population criteria (used only in ADE_TTR for observation)
  field :force_sources, type: Array # stores a list of source data criteria to force method creation for (used only in ADE_TTR for LaboratoryTestResultInr)

  field :published, type: Boolean
  field :publish_date, type: Date
  field :version, type: Integer

  field :population_criteria, type: Hash
  field :data_criteria, type: Hash, default: {}
  field :source_data_criteria, type: Hash, default: {}
  field :measure_period, type: Hash
  field :measure_attributes, type: Hash
  field :populations, type: Array
  field :preconditions, type: Hash

  field :value_set_oids, type: Array, default: []

  field :map_fns, type: Array, default: []

  # Cache the generated JS code
  def map_fn(population_index)
    # FIXME: If we'll be updating measures we'll want some sort of cache clearing mechanism
    self.map_fns[population_index] ||= HQMF2JS::Generator::Execution.logic(self, population_index, true, false)
    save if changed?
    self.map_fns[population_index]
  end

  belongs_to :user
  embeds_many :publishings
  has_many :records

  scope :by_measure_id, ->(id) { where({'measure_id'=>id }) }
  scope :by_user, ->(user) { where({'user_id'=>user.id}) }
  scope :by_type, ->(type) { where({'type'=>type}) }

  TYPE_MAP = {
    'problem' => 'conditions',
    'encounter' => 'encounters',
    'labresults' => 'results',
    'procedure' => 'procedures',
    'medication' => 'medications',
    'rx' => 'medications',
    'demographics' => 'characteristic',
    'derived' => 'derived'
  }

  # Returns the hqmf-parser's ruby implementation of an HQMF document.
  # Rebuild from population_criteria, data_criteria, and measure_period JSON
  def as_hqmf_model
    json = {
      "id" => self.measure_id,
      "title" => self.title,
      "description" => self.description,
      "population_criteria" => self.population_criteria,
      "data_criteria" => self.data_criteria,
      "source_data_criteria" => self.source_data_criteria,
      "measure_period" => self.measure_period,
      "attributes" => self.measure_attributes,
      "populations" => self.populations,
      "hqmf_id" => self.hqmf_id,
      "hqmf_set_id" => self.hqmf_set_id,
      "hqmf_version_number" => self.hqmf_version_number,
      "cms_id" => self.cms_id
    }

    HQMF::Document.from_json(json)
  end

  def value_sets
    @value_sets ||= HealthDataStandards::SVS::ValueSet.in(oid: value_set_oids)
    @value_sets
  end

end
