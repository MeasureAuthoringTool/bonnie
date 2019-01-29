# An abstract class that provides fixture exporting functionality
class FixtureExporter

  def initialize(user, measure: nil, records: nil)
    @user = user
    @measure = measure
    @records = records

    @component_measures = find_component_measures
    @measure_and_any_components = @measure.present? ? [@measure] + @component_measures : []
  end

  def export_measure_and_any_components(path)
    measure = as_transformed_hash(@measure)
    measure_name = @measure.cms_id + '.json'
    measure_file = File.join(path, measure_name)
    create_fixture_file(measure_file, measure)
    puts 'exported measure to ' + measure_file
    export_components(path) if @measure.composite
  end

  def export_records_as_array(path)
    records = @records.map { |r| as_transformed_hash(r) }
    record_file = File.join(path, 'patients.json')
    create_fixture_file(record_file, records)
    puts 'exported patient records to ' + record_file
  end

  def export_records_as_individual_files(path)
    @records.each do |r|
      record = as_transformed_hash(r)
      record_file = File.join(path, "#{r.first}_#{r.last}.json")
      create_fixture_file(record_file, record)
      puts 'exported a patient record to ' + record_file
    end
  end

  def export_components(path)
    components = @component_measures.map { |m| as_transformed_hash(m) }
    components_file = File.join(path, 'components.json')
    create_fixture_file(components_file, components)
    puts 'exported components to ' + components_file
  end

  def try_export_measure_package(path)
    return unless @measure.package
    package = as_transformed_hash(@measure.package)
    measure_package_file = File.join(path, @measure.cms_id + '.json')
    create_fixture_file(measure_package_file, package)
    puts 'exported measure package to ' + measure_package_file
  end

  def export_value_sets_as_array(path)
    vs_export = []
    @measure_and_any_components.each do |m|
      m.value_sets.each { |vs| vs_export << as_transformed_hash(vs) }
    end
    vs_export.uniq! { |vs| vs['oid'].to_s + vs['version'].to_s }
    value_sets_file = File.join(path, 'value_sets.json')
    create_fixture_file(value_sets_file, vs_export)
    puts 'exported value sets (as an array) to ' + value_sets_file
  end

  def export_value_sets_as_map(path)
    oid_to_vs_map = {}
    @measure_and_any_components.each do |m|
      add_relevant_value_sets_as_transformed_hash(oid_to_vs_map, m)
    end
    value_sets_file = File.join(path, 'value_sets.json')
    create_fixture_file(value_sets_file, oid_to_vs_map)
    puts 'exported value sets (as an oid to vs map) to ' + value_sets_file
  end

  def find_component_measures
    return [] unless @measure.composite
    component_measures = @measure.component_hqmf_set_ids.map do |component_hqmf_set_id|
      CqlMeasure.find_by(user_id: @user, hqmf_set_id: component_hqmf_set_id)
    end
    return component_measures
  end

  def as_transformed_hash(mongoid_doc)
    doc = make_hash_and_apply_any_transforms(mongoid_doc)
    doc['user_id'] = bonnie_fixtures_user_id if doc.key? 'user_id'
    return doc
  end

  def make_hash_and_apply_any_transforms(_mongoid_doc)
    raise 'this method should be overridden to return mongoid_doc as a hash, with needed transforms'
  end

  def create_fixture_file(file_path, fixture)
    fixture_json = JSON.pretty_generate(fixture)
    FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists? File.dirname(file_path)
    File.new(file_path, "w+")
    File.write(file_path, fixture_json)
  end

  def extract_relevant_value_sets(measure)
    oid_to_vs_map = {}
    relevant_vs_version = get_relevant_version_of_valuesets(measure)
    measure.value_sets.each do |vs|
      if oid_to_vs_map[vs.oid]
        # if there are multiple value sets with the same oid for this user, then keep the one with
        # the Draft- version corresponding to this measure for the fixture.
        oid_to_vs_map[vs.oid] = { vs.version => vs } if vs.version == relevant_vs_version
      else
        oid_to_vs_map[vs.oid] = { vs.version => vs }
      end
    end
    return oid_to_vs_map
  end

  def add_relevant_value_sets_as_transformed_hash(map_to_add_to, measure)
    extract_relevant_value_sets(measure).each do |oid, version_to_vs_map|
      version_to_vs_map.each do |version, valueset|
        if map_to_add_to[oid].present?
          map_to_add_to[oid][version] = as_transformed_hash(valueset)
        else
          map_to_add_to[oid] = { version => as_transformed_hash(valueset) }
        end
      end
    end
  end

  def get_relevant_version_of_valuesets(measure)
    return 'Draft-' + measure.hqmf_set_id.split('&')[1] if measure.component
    return 'Draft-' + measure.hqmf_set_id
  end

  def objectid_to_oids(input)
    if input.is_a? Array
      input.each { |val| objectid_to_oids(val) }
    elsif input.is_a? Hash
      input.each do |key, value|
        if value.is_a? BSON::ObjectId
          input[key] = { '$oid' => value.to_s }
        else
          objectid_to_oids(value)
        end
      end
    end
  end
end

# Used to export fixtures for use in frontend tests (where fixtures are not loaded in mongo)
class FrontendFixtureExporter < FixtureExporter
  alias export_value_sets export_value_sets_as_map

  def initialize(user, measure: nil, records: nil)
    super(user, measure: measure, records: records)
  end

  def export_records_as_array(path)
    @records = @records.map { |record| CQMConverter.to_cqm(record) }
    super(path)
  end

  # Alias must be placed after the export_records_as_array method so super method won't be called first
  alias export_records export_records_as_array

  def make_hash_and_apply_any_transforms(mongoid_doc)
    return JSON.parse(mongoid_doc.to_json, max_nesting: 1000)
  end

  def bonnie_fixtures_user_id
    # In order to avoid storing details of real users, a test-specific user fixture exists.
    # for front end tests this should be just a string
    '501fdba3044a111b98000001'
  end
end

# Used to export fixtures for use in backend tests (where fixtures are loaded into mongo)
class BackendFixtureExporter < FixtureExporter
  alias export_value_sets export_value_sets_as_array
  alias export_records export_records_as_individual_files

  def make_hash_and_apply_any_transforms(mongoid_doc)
    doc = mongoid_doc.as_json
    objectid_to_oids(doc)
    return JSON.parse(doc.to_json, max_nesting: 1000)
  end

  def bonnie_fixtures_user_id
    # In order to avoid storing details of real users, a test-specific user fixture exists.
    { '$oid': '501fdba3044a111b98000001' }
  end
end
