namespace :bonnie do
  namespace :measures do
    desc "Migrates measures and value_sets away from User versioning"
    task :migrate_measures_value_sets => :environment do
      user_oid_to_version = Hash.new
      oid_to_content = Hash.new
      duplicates = 0
      clashes = 0
      oid_version_to_clash = Hash.new
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
        
        user_oid_to_version[[vs.oid, vs.user]] = vs.version
        if (oid_to_content[[vs.oid, vs.version]] != nil)
          if (vs.concepts == oid_to_content[[vs.oid, vs.version]].concepts)
            to_delete.push(vs)
          else
            if (vs.concepts.length > oid_to_content[[vs.oid, vs.version]].concepts.length)
              to_delete.push(oid_to_content[[vs.oid, vs.version]])
              vs.versioned_oid = vs.oid + ":::" + vs.version
#              vs.unset(:user)
              oid_to_content[[vs.oid, vs.version]] = vs
              vs.save!
            else
              to_delete.push(vs)
            end
          end
        else
          oid_to_content[[vs.oid, vs.version]] = vs
          vs.versioned_oid = vs.oid + ":::" + vs.version
#          vs.unset(:user)
          vs.save!
        end
      end
      
      Measure.each do |m|
        puts m
        puts m.user
        m.oid_to_version = []
        m.value_set_oids.each do |oid|
          puts oid
          puts user_oid_to_version[[oid, m.user]]
          m.oid_to_version.push(oid + ":::" + user_oid_to_version[[oid, m.user]])
        end
        m.save!
      end
      
      to_delete.each do |vs|
        vs.delete
      end      
      
    end

    task :check_sets => :environment do
      Measure.each do |m|
        
      end
    end
  end
end