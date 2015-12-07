namespace :bonnie do
  namespace :measures do

    desc "Migrates measures and value_sets away from User versioning"
    task :apply_hash => :environment do
      user_oid_to_version = Hash.new
      seen_hashes = Set.new
      to_delete = []
      to_save = []
      size = HealthDataStandards::SVS::ValueSet.count()
      progress = 0


      HealthDataStandards::SVS::ValueSet.each do |vs|
        progress += 1
        if (progress % 500 == 0)
          puts "\n#{progress} / #{size}"
        end
        
        vs.bonnie_hash = HealthDataStandards::SVS::ValueSet.gen_bonnie_hash(vs)
        user_oid_to_version[[vs.oid, vs.user_id]] = vs.bonnie_hash
        
        if (seen_hashes.add?(vs.bonnie_hash).nil?)
          to_delete.push(vs)
          print "!"
        else
          to_save.push(vs)
          print "."
        end
        $stdout.flush()
      end
      
      size = Measure.count()      
      progress = 0

      Measure.each do |m|
        progress += 1
        if (progress % 500 == 0)
          puts "#{progress} / #{size}"
        end
        
        m.oid_to_version = []
        m.value_set_oids.each do |oid|
          m.oid_to_version.push(user_oid_to_version[[oid, m.user_id]])
        end
        m.save!
      end

      size = to_delete.count()      
      progress = 0
      
      to_delete.each do |vs|
        progress += 1
        if (progress % 500 == 0)
          puts "#{progress} / #{size}"
        end
        vs.delete
      end

      size = to_save.count()      
      progress = 0
      
      to_save.each do |vs|
        progress += 1
        if (progress % 500 == 0)
          puts "#{progress} / #{size}"
        end
        vs.save!
      end
    end

    desc "Updates versions on value sets"
    task :enrich_vs_versions => :environment do
      api = HealthDataStandards::Util::VSApiV2.new("https://vsac.nlm.nih.gov/vsac/ws/Ticket", "https://vsac.nlm.nih.gov/vsac/svs/RetrieveValueSet", "https://vsac.nlm.nih.gov/vsac/oid", "", "") #need to get this to run with config
      to_save = []
      size = HealthDataStandards::SVS::ValueSet.count()
      progress = 0
      oid_version_to_content = Hash.new
      to_proc = []

      HealthDataStandards::SVS::ValueSet.each do |vs|
        to_proc.push(vs)
      end

      to_proc.each do |vs|
        progress += 1
        if (progress % 50 == 0)
          puts "\n#{progress} / #{size}"
        end

        version_doc = Nokogiri::XML(api.get_versions(vs.oid))

        version_doc.xpath("//version").each do |node|
          begin
            to_check = nil
            retrieved_value = api.get_valueset(vs.oid, {version: node.content})
            retrieved_doc = Nokogiri::XML(retrieved_value)
            to_check = HealthDataStandards::SVS::ValueSet.load_from_xml(retrieved_doc)
            to_check.bonnie_hash = HealthDataStandards::SVS::ValueSet.gen_bonnie_hash(to_check)

            if (to_check.bonnie_hash == vs.bonnie_hash)
              vs.version = node.content
              to_save.push(vs)
              break
            end
          rescue Exception => e
            puts e.message
            puts "Ya broke it!"
          end
        end
      end
      to_save.each do |vs|
        vs.save!
      end
      
    end

    task :check_sets => :environment do
      unique_vs = Set.new
      HealthDataStandards::SVS::ValueSet.each do |vs|
        unique_vs.add([vs.oid, vs.version])
      end
      puts unique_vs.length
    end
  end
end