ENV["RAILS_ENV"] = "test"
require_relative "./simplecov_init"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require './lib/ext/record'
WebMock.enable!

class ActiveSupport::TestCase

  def dump_database
    Mongoid.default_client.collections.each do |c|
      c.drop()
    end
  end

  def collection_fixtures(*collection_names)
    collection_names.each do |collection|
      Mongoid.default_client[collection].drop
      Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
        fixture_json = JSON.parse(File.read(json_fixture_file))
        if fixture_json.length > 0
          convert_times(fixture_json)
          set_mongoid_ids(fixture_json)
          fix_binary_data(fixture_json)
          # Mongoid names collections based off of the default_client argument.
          # With nested folders,the collection name is “records/X” (for example).
          # To ensure we have consistent collection names in Mongoid, we need to take the file directory as the collection name.
          collection = collection.split(File::SEPARATOR)[0]
          Mongoid.default_client[collection].insert_one(fixture_json)
        end
      end
    end
  end

  # JSON.parse doesn't catch time fields, so this converts fields ending in _at
  # to a Time object.
  def convert_times(json)
    if json.kind_of?(Hash)
      json.each_pair do |k,v|
        if k.ends_with?("_at")
          json[k] = Time.parse(v)
        end
      end
    end
  end

  def set_mongoid_ids(json)
    if json.kind_of?( Hash)
      json.each_pair do |k,v|
        if v && v.kind_of?( Hash )
          if v["$oid"]
            json[k] = BSON::ObjectId.from_string(v["$oid"])
          else
            set_mongoid_ids(v)
          end
        end
      end
    end
  end

  def fix_binary_data(json)
    if json.kind_of?(Hash)
      json.each_pair do |k,v|
        if v.kind_of?(Hash)
          if v.has_key?('$binary')
            json[k] = BSON::Binary.new(Base64.decode64(v['$binary']), v['$type'].to_sym)
          else
            fix_binary_data(v)
          end
        end
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

end
