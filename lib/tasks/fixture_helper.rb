def collection_fixtures(*collection_names)
  collection_names.each do |collection|
    Mongoid.default_client[collection].drop # I think this rarely drops anything since collection_name hasnt been split out of the file name -Cole
    add_collection(collection)
  end
end

def collection_fixtures_with_user(collection_names, user)
  collection_names.each do |collection|
    Mongoid.default_client[collection].drop # I think this rarely drops anything since collection_name hasnt been split out of the file name -Cole
    add_collection(collection, user)
  end
end

def load_measure_fixtures_from_folder(fixture_path, user = nil)
  path = File.join(Rails.root, 'test', 'fixtures', fixture_path)
  measure_id, measure_package_id = nil
  Pathname.new(path).children.select(&:directory?).each do |sub_folder|
    mongo_collection_name = sub_folder.basename.to_s
    sub_folder.children.select { |f| f.extname == '.json' }.each do |fixture_file|
      loaded_ids = load_fixture_file(fixture_file, mongo_collection_name, user)
      if mongo_collection_name == 'cqm_measure_packages'
        measure_package_id = loaded_ids[0]
      elsif mongo_collection_name == 'cqm_measures'
        measure_id = loaded_ids[0]
      end
    end
  end
end

def load_fhir_measure_from_json_fixture(fixture_path, user)
  measure_hash = JSON.parse File.read(File.join(Rails.root, fixture_path))
  measure = CQM::Measure.transform_json(measure_hash)
  measure.group = user
  measure.save!
  measure
end

def load_patient_from_json_fixture(fixture_path, user)
  patient = JSON.parse File.read(File.join(Rails.root, fixture_path))
  cqm_patient = CQM::Patient.transform_json(patient)
  cqm_patient.group = user.current_group
  cqm_patient.save!
  cqm_patient
end

def add_collection(collection, user = nil)
  # Mongoid names collections based off of the default_client argument.
  # With nested folders,the collection name is "records/X" (for example).
  # To ensure we have consistent collection names in Mongoid, we need to take the file directory as the collection name.
  collection_name = collection.split(File::SEPARATOR)[0]

  Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
    load_fixture_file(json_fixture_file, collection_name, user)
  end
end

def load_fixture_file(file, collection_name, user = nil)
  loaded_ids = []
  fixture_json = JSON.parse(File.read(file))
  return loaded_ids if fixture_json.empty?
  # Value_sets are arrays of objects, unlike measures etc, so we need to iterate in that case.
  fixture_json = [fixture_json] unless fixture_json.is_a?(Array)
  fixture_json.each do |fj|
    convert_times(fj)
    convert_mongoid_ids(fj)
    fix_binary_data(fj)
    fj["user_id"] = user.id if user.present?
    begin
      Mongoid.default_client[collection_name].insert_one(fj)
      loaded_ids << fj["_id"]
    rescue Mongo::Error::OperationFailure => e
      # ignore duplicate key errors for valuesets, could just be inserting the same valueset twice from different fixtures
      raise unless (collection_name == 'health_data_standards_svs_value_sets') && e.message.starts_with?('E11000 duplicate key error')
    end
  end
  return loaded_ids
end

# JSON.parse doesn't catch time fields, so this converts all times to a
# DateTime object before getting imported into a mongoid Document
# Some date fields can be nested so that is why there is recursion
def convert_times(json)
  return nil unless json.is_a?(Hash)
  json.each_pair do |k,v|
    if v.is_a?(Array)
      v.each do |val|
        if val.is_a?(Hash) || val.is_a?(Array)
          convert_times(val)
        elsif val.is_a?(String)
          val.to_datetime if val.match?(/\d{4}-\d{2}-\d{2}T/)
        end
      end
      json[k] = v
    elsif v.is_a?(Hash)
      vals = [v]
      vals.each { |val| convert_times(val) }
    elsif v.is_a?(String)
      json[k] = v.to_datetime if v.match?(/\d{4}-\d{2}-\d{2}T/)
    end
  end
end

def convert_mongoid_ids(json)
  if json.is_a?(Array)
    json.each { |val| convert_mongoid_ids(val) }
  elsif json.is_a?(Hash)
    json.each_pair do |k,v|
      if v.is_a?(Hash) && v['$oid']
        json[k] = BSON::ObjectId.from_string(v['$oid'])
      else
        convert_mongoid_ids(v)
      end
    end
  end
end

def fix_binary_data(json)
  return nil unless json.is_a?(Hash)
  json.each_pair do |k,v|
    if v.is_a?(Hash)
      if v.key?('$binary')
        json[k] = BSON::Binary.new(Base64.decode64(v['$binary']), v['$type'].to_sym)
      else
        fix_binary_data(v)
      end
    end
  end
end

def associate_user_with_measures(user,measures)
  measures.each do |m|
    m.group = user.current_group
    m.save
  end
end

def associate_user_with_patients(user,patients)
  patients.each do |p|
    p.group = user.current_group
    p.save
  end
end

def associate_user_with_value_sets(user,value_sets)
  value_sets.each do |vs|
    vs.group = user.current_group
    vs.save
  end
end

def associate_measure_with_patients(measure,patients)
  patients.each do |p|
    p.measure_ids = [measure.set_id]
    p.save
  end
end

def associate_measures_with_patients(measures,patients)
  measure_ids = measures.map(&:set_id)
  patients.each do |p|
    p.measure_ids = measure_ids
    p.save
  end
end
