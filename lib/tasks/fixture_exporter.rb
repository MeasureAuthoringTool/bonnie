class FixtureExporter
  def initialize(user, measure: nil, records: nil, set_user_id_to: nil, preserve_oids: false)
    @user = user
    @measure = measure
    @records = records
    @set_user_id_to = set_user_id_to
    @preserve_oids = preserve_oids
    
    @component_measures = get_component_measures()
    @measure_and_any_components = @measure.present? ? [@measure] + @component_measures : []
  end

  def export_measure_and_any_components(path)
    measure = make_hash_and_apply_transforms(@measure)
    measure_name = @measure.cms_id + ".json"
    measure_file = File.join(path, measure_name)
    create_fixture_file(measure_file, JSON.pretty_generate(measure))
    puts 'exported measure to ' + measure_file
    export_components(path) if @measure.composite
  end

  def export_records_as_array(path)
    records = @records.map{ |r| make_hash_and_apply_transforms(r) }
    record_file = File.join(path, "patients.json")
    create_fixture_file(record_file, JSON.pretty_generate(records))
    puts 'exported patient records to ' + record_file
  end

  def export_records_as_individual_files(path)
    @records.each do |r|
      record = make_hash_and_apply_transforms(r)
      record_file = File.join(path, "#{r.first}_#{r.last}.json")
      create_fixture_file(record_file, JSON.pretty_generate(record))
      puts 'exported a patient record to ' + record_file
    end
  end

  def export_components(path)
    components = @component_measures.map{ |m| make_hash_and_apply_transforms(m) }
    components_file = File.join(path, 'components.json')
    create_fixture_file(components_file, JSON.pretty_generate(components))
    puts 'exported components to ' + components_file
  end

  def try_export_measure_package(path)
    return unless @measure.package
    package = make_hash_and_apply_transforms(@measure.package)
    measure_package_file = File.join(path, @measure.cms_id + ".json")
    create_fixture_file(measure_package_file, JSON.pretty_generate(package))
    puts 'exported measure package to ' + measure_package_file
  end

  def export_value_sets_as_array(path)
    vs_export = []
    for m in @measure_and_any_components
      m.value_sets.each {|vs| vs_export << make_hash_and_apply_transforms(vs)}
    end
    vs_export.uniq! {|vs| vs["oid"].to_s + vs["version"].to_s}
    value_sets_file = File.join(path, 'value_sets.json')
    create_fixture_file(value_sets_file, JSON.pretty_generate(vs_export))
    puts 'exported value sets (as an array) to ' + value_sets_file
  end

  def export_value_sets_as_map(path)
    oid_to_vs_map = {}
    for m in @measure_and_any_components
      add_relevant_value_sets_as_hash_with_transforms(oid_to_vs_map, m)
    end
    value_sets_file = File.join(path, 'value_sets.json')
    create_fixture_file(value_sets_file, JSON.pretty_generate(oid_to_vs_map))
    puts 'exported value sets (as an oid to vs map) to ' + value_sets_file
  end

  def get_component_measures()
    return [] unless @measure.composite
    component_measures = @measure.component_hqmf_set_ids.map do |component_hqmf_set_id|
      CqlMeasure.find_by(user_id: @user, hqmf_set_id: component_hqmf_set_id)
    end
    return component_measures
  end

  def make_hash_and_apply_transforms(mongoid_doc)
    if @preserve_oids
      mongoid_doc = mongoid_doc.as_json
      objectid_to_oids(mongoid_doc)
    end
    return with_transforms(JSON.parse(mongoid_doc.to_json, max_nesting: 1000))
  end

  def with_transforms(input)
    input['user_id'] = @set_user_id_to if input['user_id'].present? && @set_user_id_to.present?
    return input
  end

  def extract_relevant_value_sets(measure)
    oid_to_vs_map = {}
    relevant_vs_version = get_version_of_relevant_valuesets(measure)
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

  def add_relevant_value_sets_as_hash_with_transforms(map_to_add_to, measure)
    extract_relevant_value_sets(measure).each do |oid, versionToVsMap|
      versionToVsMap.each do |version, valueset|
        if map_to_add_to[oid]
          map_to_add_to[oid][version] = make_hash_and_apply_transforms(valueset)
        else
          map_to_add_to[oid] = { version => make_hash_and_apply_transforms(valueset) }
        end
      end
    end
  end

  def get_version_of_relevant_valuesets(measure)
    return 'Draft-' + measure.hqmf_set_id.split('&')[1] if measure.component
    return 'Draft-' + measure.hqmf_set_id
  end
	
  def objectid_to_oids(input)
    if input.is_a? Array
      input.each {|val| objectid_to_oids(val)} 
    elsif input.is_a? Hash
      input.each do |key, value|
        if value.is_a? BSON::ObjectId
          input[key] = { '$oid' => value.to_s}
        else
          objectid_to_oids(value)
        end
      end
    end
  end
  
end