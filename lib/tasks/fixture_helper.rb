
def collection_fixtures(*collection_names)
  collection_names.each do |collection|
    collection_name = collection.split(File::SEPARATOR)[0]
    Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
      fixture_json = JSON.parse(File.read(json_fixture_file))
      next if fixture_json.empty?
      convert_times(fixture_json)
      insert_mongoid_ids(fixture_json)
      # The first directory layer after test/fixtures is used to determine what type of fixtures they are.
      # The directory name is used as the name of the collection being inserted into.
      Mongoid.default_client[collection_name].insert_one(fixture_json)
    end
  end
end

def add_collection(collection)
  Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
    fixture_json = JSON.parse(File.read(json_fixture_file))
    next if fixture_json.empty?
    convert_times(fixture_json)
    insert_mongoid_ids(fixture_json)
    fix_binary_data(fixture_json)
    # Mongoid names collections based off of the default_client argument.
    # With nested folders,the collection name is "records/X" (for example).
    # To ensure we have consistent collection names in Mongoid, we need to take the file directory as the collection name.
    collection = collection.split(File::SEPARATOR)[0]
    Mongoid.default_client[collection].insert_one(fixture_json)
  end
end

# JSON.parse doesn't catch time fields, so this converts fields ending in _at
# to a Time object.
def convert_times(json)
  return nil unless json.is_a?(Hash)
  json.each_pair do |k,v|
    json[k] = Time.parse(v) if k.ends_with?("_at")
  end
end

def insert_mongoid_ids(json)
  return nil unless json.is_a?(Hash)
  json.each_pair do |k,v|
    if v && v.is_a?(Hash)
      if v["$oid"]
        json[k] = BSON::ObjectId.from_string(v["$oid"])
      else
        insert_mongoid_ids(v)
      end
    elsif %w[_id bundle_id user_id].include?(k)
      json[k] = BSON::ObjectId.from_string(v)
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

# each .json file contains an array of value sets, add each item individually
def add_value_sets_collection(collection)
  Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
    fixture_json = JSON.parse(File.read(json_fixture_file))
    next if fixture_json.empty?
    fixture_json.each do |entry|
      vs = HealthDataStandards::SVS::ValueSet.new(entry)
      HealthDataStandards::SVS::ValueSet.collection.insert_one(vs.as_document)
    end
  end
end

def associate_user_with_measures(user,measures)
  measures.each do |m|
    m.user = user
    m.save
  end
end

def associate_user_with_patients(user,patients)
  patients.each do |p|
    p.user = user
    p.save
  end
end

def associate_measure_with_patients(measure,patients)
  patients.each do |p|
    p.measure_ids = [measure.hqmf_set_id]
    p.save
  end
end

def associate_measures_with_patients(measures,patients)
  measure_ids = measures.map(&:hqmf_set_id)
  patients.each do |p|
    p.measure_ids = measure_ids
    p.save
  end
end
