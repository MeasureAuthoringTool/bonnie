ENV["RAILS_ENV"] = "test"
require_relative "./simplecov_init"
ENV["APIPIE_RECORD"] = "examples"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require './lib/ext/record'
require 'rake'
WebMock.enable!

# load_tasks needs to be called exactly one time, so it's in the header area
# of this file. Additionally, because tests get run twice for some reason, we
# need to put an extra check around it to ensure the tasks aren't already loaded.

Bonnie::Application.load_tasks if Rake::Task.tasks.empty?
class ActiveSupport::TestCase

  def dump_database
    Mongoid.default_client.collections.each do |c|
      c.drop()
    end
  end

  ###
  # Parses json object for id fields and converts them to bson objects
  #
  # json: The json object to parse
  def set_mongoid_ids(json)
    if json.kind_of?( Hash)
      json.each_pair do |k,v|
        if v && v.kind_of?( Hash )
          if v["$oid"]
            json[k] = BSON::ObjectId.from_string(v["$oid"])
          else
            set_mongoid_ids(v)
          end
        elsif k == '_id' || k == 'bundle_id' || k == 'user_id'
          json[k] = BSON::ObjectId.from_string(v)
        end
      end
    end
  end

  ##
  # Loads fixtures into the active database.
  #
  # collection_names: array of paths leading to the relevant collections.
  def collection_fixtures(*collection_names)
    collection_names.each do |collection|
      collection_name = collection.split(File::SEPARATOR)[0]
      Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
        fixture_json = JSON.parse(File.read(json_fixture_file))
        if fixture_json.length > 0
          convert_times(fixture_json)
          set_mongoid_ids(fixture_json)
          # The first directory layer after test/fixtures is used to determine what type of fixtures they are.
          # The directory name is used as the name of the collection being inserted into.
          Mongoid.default_client[collection_name].insert_one(fixture_json)
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

  def associate_user_with_measures(user,measures)
    measures.each do |m|
      m.user = user
      m.save
    end
  end
  
  def associate_archived_measures_with_measure(archived_measures, measure)
    archived_measures.each do |am|
      am.measure_db_id = measure._id
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
  
  def associate_upload_summary_with_user(summary,user)
    summary.user_id = user.id
  end

end
