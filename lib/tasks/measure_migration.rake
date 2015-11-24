namespace :bonnie do
  namespace :measures do
    desc "Migrates measures and value_sets away from User versioning"
    task :migrate_measures_value_sets => :environment do
      user_oid_to_version = Hash.new

      oid_to_content = Hash.new
      duplicates = 0
      clashes = 0
      concepts_to_oid_version = Hash.new
      oid_version_concepts_to_version = Hash.new
      to_delete = []
      
      size = HealthDataStandards::SVS::ValueSet.count()
      progress = 0
      prev_time = Time.now()
      HealthDataStandards::SVS::ValueSet.each do |vs|
        progress += 1
        if (progress % 500 == 0)
          cur_time = Time.now()
          elapsed = cur_time - prev_time
          prev_time = cur_time
          puts "#{progress} / #{size}: #{elapsed} : #{vs.user}"
        end
        
        user_oid_to_version[[vs.oid, vs.user_id]] = vs.version
        if (oid_to_content[[vs.oid, vs.version]] != nil)
          if (vs.concepts.sort == oid_to_content[[vs.oid, vs.version]].concepts.sort)
            to_delete.push(vs)
          else
            if (vs.concepts.length > oid_to_content[[vs.oid, vs.version]].concepts.length)
              oid_to_content[[vs.oid, vs.version]].concepts = vs.concepts
              oid_to_content[[vs.oid, vs.version]].save!
            end
            to_delete.push(vs)
          end
        else
          oid_to_content[[vs.oid, vs.version]] = vs
          vs.versioned_oid = vs.oid + ":::" + vs.version
          vs.save!
        end
      end
      
      Measure.each do |m|
        m.oid_to_version = []
        m.value_set_oids.each do |oid|
          m.oid_to_version.push(oid + ":::" + user_oid_to_version[[oid, m.user_id]])
        end
        m.save!
      end
      
      to_delete.each do |vs|
        vs.delete
      end      
      
    end

    task :check_sets => :environment do
      Measure.each do |m|
        if (m.user.nil?) 
          m.delete
          puts "Deleting Measure with no User"
        end
      end
    end
  end
end