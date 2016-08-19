namespace :bonnie do
  namespace :measures do
    
    desc "Delete Value Set indexes that are not needed in Bonnie"
    task :delete_unnecessary_value_set_indexes => :environment do
      HealthDataStandards::SVS::ValueSet.collection.indexes.drop({"concepts.code"=>1})
      HealthDataStandards::SVS::ValueSet.collection.indexes.drop({"concepts.code_system"=>1})
      HealthDataStandards::SVS::ValueSet.collection.indexes.drop({"concepts.code_system_name"=>1})
      HealthDataStandards::SVS::ValueSet.collection.indexes.drop({"concepts.display_name"=>1})
    end

    desc "Migrates measures and value_sets away from User versioning"
    task :consolidate_value_sets => :environment do

      user_oid_to_version = Hash.new
      bonnie_hash_to_bundles = Hash.new
      seen_hashes = Set.new
      to_delete = []
      to_save = []
      size = HealthDataStandards::SVS::ValueSet.count()
      progress = 0

      start_time = Time.now
      puts "Looking for duplicate Value Sets"

      HealthDataStandards::SVS::ValueSet.each do |vs|
        progress += 1
        if (progress % 500 == 0)
          puts "\n#{progress} / #{size}"
        end

        vs.bonnie_version_hash = HealthDataStandards::SVS::ValueSet.generate_bonnie_hash(vs)
        user_oid_to_version[[vs.oid, vs.user_id]] = vs.bonnie_version_hash
        
        if bonnie_hash_to_bundles[vs.bonnie_version_hash].nil?
          bonnie_hash_to_bundles[vs.bonnie_version_hash] = []
        end
        bonnie_hash_to_bundles[vs.bonnie_version_hash].push(vs.bundle_id)
        
        if (seen_hashes.add?(vs.bonnie_version_hash).nil?)
          to_delete.push(vs)
          print "!"
        else
          to_save.push(vs)
          print "."
        end
        $stdout.flush()
      end

      puts "\nFinished looking for duplicate Value Sets (elapsed time: #{Time.now - start_time})"
      
      start_time = Time.now
      puts "Updating measures with new value set versions"

      size = Measure.count()
      progress = 0

      Measure.each do |m|
        progress += 1
        if (progress % 500 == 0)
          puts "#{progress} / #{size}"
        end

        m.bonnie_hashes = []
        m.value_set_oids.each do |oid|
          m.bonnie_hashes.push(user_oid_to_version[[oid, m.user_id]])
        end
        m.save!
      end

      puts "\nFinished updating measures with new value set versions (elapsed time: #{Time.now - start_time})"


      start_time = Time.now
      puts "Deleting #{to_delete.size} duplicate value sets"

      HealthDataStandards::SVS::ValueSet.where(:_id.in => to_delete.map(&:id)).delete_all

      puts "\nFinished deleting duplicate value sets (elapsed time: #{Time.now - start_time})"
      
      start_time = Time.now

      puts "Saving value sets with hash information"
      size = to_save.count()
      progress = 0

      to_save.each do |vs|
        progress += 1
        if (progress % 500 == 0)
          puts "#{progress} / #{size}"
        end
        vs.bundle_ids = bonnie_hash_to_bundles[vs.bonnie_version_hash]
        vs.unset(:bundle_id)
        bundles = HealthDataStandards::CQM::Bundle.where(_id: {'$in' => bonnie_hash_to_bundles[vs.bonnie_version_hash]})
        bundles.each do |b|
          if (vs.bundle_ids.nil?)
            vs.bundle_ids = []
          end
          vs.bundle_ids.push(b._id)
          if (b.value_set_ids.nil?) 
            b.value_set_ids = []
          end
          b.value_set_ids.push(vs._id)
          b.save!
        end
        vs.save!
      end
      puts "\nFinished saving value sets (elapsed time: #{Time.now - start_time})"

    end

    task :check_sets => :environment do
      HealthDataStandards::SVS::ValueSet.each do |vs|
        puts vs.bonnie_version_hash
      end

      Measure.each do |m|
        puts m.bonnie_hashes
      end
    end
  end
end
