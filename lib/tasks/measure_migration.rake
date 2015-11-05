namespace :bonnie do
  namespace :measures do
    desc "Migrates measures and value_sets away from User versioning"
    task :migrate_measures_value_sets => :environment do
      user_oid_to_version = Hash.new
      oid_to_content = Hash.new
      HealthDataStandards::SVS::ValueSet.each do |vs|
        user_oid_to_version[[vs.oid, vs.user]] = vs.version
        if (oid_to_content[[vs.oid, vs.version]] != nil)
          if (vs.concepts == oid_to_content[[vs.oid, vs.version]].concepts)
            vs.delete
          else
            
          end
        else
          oid_to_content[[vs.oid, vs.version]] = vs
          vs.versioned_oid = vs.oid + ":::" + vs.version
          vs.unset(:user)
          vs.save!
        end
      end

      Measure.each do |m|
        m.oid_to_version = []
        m.value_set_oids.each do |oid|
          m.oid_to_version.push(oid + ":::" + user_oid_to_version[[oid, m.user]])
        end
        m.save!
      end
    end

    task :check_sets => :environment do
      HealthDataStandards::SVS::ValueSet.each do |vs|
        puts "#{vs.user}, #{vs.versioned_oid}"
      end
      Measure.each do |m|
        puts m.oid_to_version
      end
    end
  end
end
