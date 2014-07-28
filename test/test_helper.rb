ENV["RAILS_ENV"] = "test"
require_relative "./simplecov"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require './lib/ext/record'

require 'turn'

class ActiveSupport::TestCase
 
  def dump_database
    Mongoid.default_session.collections.each do |c|
      c.drop()
    end
  end

  def collection_fixtures(*collection_names)
    collection_names.each do |collection|
      Mongoid.default_session[collection].drop
      Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
        fixture_json = JSON.parse(File.read(json_fixture_file))
        set_mongoid_ids(fixture_json)
        Mongoid.default_session[collection].insert(fixture_json)
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

