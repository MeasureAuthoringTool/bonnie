
def collection_fixtures(*collection_names)
  collection_names.each do |collection|
    Mongoid.default_client[collection].drop
    add_collection(collection)
  end
end

def add_collection(collection)
  # Mongoid names collections based off of the default_client argument.
  # With nested folders,the collection name is "records/X" (for example).
  # To ensure we have consistent collection names in Mongoid, we need to take the file directory as the collection name.
  collection_name = collection.split(File::SEPARATOR)[0]

  Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
    fixture_json = JSON.parse(File.read(json_fixture_file))
    next if fixture_json.empty?
    # Value_sets are arrays of objects, unlike measures etc, so we need to iterate in that case.
    fixture_json = [fixture_json] unless fixture_json.is_a? Array
    fixture_json.each do |fj|
      convert_times(fj)
      set_mongoid_ids(fj)
      fix_binary_data(fj)
      begin
        Mongoid.default_client[collection_name].insert_one(fj)
      rescue Mongo::Error::OperationFailure => e
        # ignore duplicate key errors for valuesets, could just be inserting the same valueset twice from different fixtures
        raise unless (collection_name == 'health_data_standards_svs_value_sets') && e.message.starts_with?('E11000 duplicate key error')
      end
    end
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

def set_mongoid_ids(json)
  if json.kind_of? Array
    json.each { |val| set_mongoid_ids(val) }
  elsif json.kind_of?( Hash)
    json.each_pair do |k,v|
      if v && v.kind_of?( Hash ) && v["$oid"]
        json[k] = BSON::ObjectId.from_string(v["$oid"])
      else
        set_mongoid_ids(v)
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

def associate_user_with_value_sets(user,value_sets)
  value_sets.each do |vs|
    vs.user = user
    vs.save
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
