# -*- coding: utf-8 -*-
namespace :bonnie do
  namespace :cql do

    desc %{Recreates the JSON elm stored on CQL measures using an instance of
      a locally running CQLTranslationService JAR.

    $ rake bonnie:cql:rebuild_elm}
    task :rebuild_elm => :environment do
      update_passes = 0
      update_fails = 0
      orphans = 0
      CqlMeasure.all.each do |measure|
        begin
          # Grab the user, we need this to output the name of the user who owns
          # this measure. Also comes in handy when detecting measures uploaded
          # by accounts that have since been deleted.
          user = User.find_by(_id: measure[:user_id])
          # Grab the measure cql
          if measure[:cql].instance_of?(Array) # New type of measure
            cql = measure[:cql]
          elsif measure[:cql].instance_of?(String) # Old type of measure
            cql = [measure[:cql]]
          end
          # Generate elm from the measure cql
          elms, elm_annotations = Measures::CqlLoader.translate_cql_to_elm(cql)
          elms = [elms] unless elms.instance_of?(Array)
          # Grab the name of the main cql library
          if measure[:main_cql_library].present?
            # Old measure! Grab the main_cql_library name from the ELM
            main_cql_library = measure[:main_cql_library]
          else
            main_cql_library = elms.first['library']['identifier']['id']
          end
          # Build the definition dependency structure for this measure
          cql_definition_dependency_structure = Measures::CqlLoader.populate_cql_definition_dependency_structure(main_cql_library, elms)
          cql_definition_dependency_structure = Measures::CqlLoader.populate_used_library_dependencies(cql_definition_dependency_structure, main_cql_library, elms)

          Measures::CqlLoader.replace_codesystem_oids_with_names(elms)
          Measures::CqlLoader.modify_value_set_versions(elms)

          # Update the measure
          measure.update(cql: cql, elm: elms, elm_annotations: elm_annotations, cql_statement_dependencies: cql_definition_dependency_structure, main_cql_library: main_cql_library)
          measure.save!
          update_passes += 1
          print "\e[#{32}m#{"[Success]"}\e[0m"
          puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' in account ' + "\e[1m#{user[:email]}\e[22m" + ' successfully updated ELM!'
        rescue Mongoid::Errors::DocumentNotFound => e
          orphans += 1
          print "\e[#{31}m#{"[Error]"}\e[0m"
          puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' belongs to a user that doesn\'t exist!'
        rescue Exception => e
          update_fails += 1
          print "\e[#{31}m#{"[Error]"}\e[0m"
          puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' in account ' + "\e[1m#{user[:email]}\e[22m" + ' failed to update ELM!'
        end
      end
      puts "#{update_passes} measures successfully updated."
      puts "#{update_fails} measures failed to update."
      puts "#{orphans} measures are orphaned, and were not updated."
    end

    desc %{Outputs user accounts that have cql measures and which measures are cql in their accounts.
      Example test@test.com  
                CMS_ID: xxx   TITLE: Measure Title
    $ rake bonnie:cql:cql_measure_stats}
    task :cql_measure_stats => :environment do

      # Collect user info from CQL measures
      users = {}
      CqlMeasure.all.each do |m|
        users[m.user_id.to_s] = [] unless users.key? m.user_id.to_s
        users[m.user_id.to_s].push({cms_id: m.cms_id, title: m.title})
      end

      # Print info
      users.each do |u, m_array|
        user = User.find_by(id: u)
        puts 'User: ' + user.email
        m_array.each do |m|
          puts "  CMS_ID: #{m[:cms_id]}  TITLE: #{m[:title]}"
        end
      end
      
    end
    
    task :update_value_set_versions => :environment do
      User.all.each do |user|
        puts "Updating value sets for user " + user.email
        begin
          measures = CqlMeasure.where(user_id: user.id)

          measures.each do |measure|
            elms = measure.elm

            Measures::CqlLoader.modify_value_set_versions(elms)

            elms.each do |elm|

              if elm['library'] && elm['library']['valueSets'] && elm['library']['valueSets']['def']
                elm['library']['valueSets']['def'].each do |value_set|
                  db_value_sets = HealthDataStandards::SVS::ValueSet.where(user_id: user.id, oid: value_set['id'])

                  db_value_sets.each do |db_value_set|
                    if value_set['version'] && db_value_set.version == "N/A"
                      puts "Setting " + db_value_set.version.to_s + " to " + value_set['version'].to_s
                      db_value_set.version = value_set['version']
                      db_value_set.save()
                    end
                  end
                end
              end
            end
          end
        rescue Mongoid::Errors::DocumentNotFound => e
          puts "\nNo CQL measures found for the user below"
          puts user.email
          puts user.id
        end
      end
    end

  end
end
