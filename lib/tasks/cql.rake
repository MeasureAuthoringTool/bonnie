#  -*- coding: utf-8 -*-
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
          cql = nil
          cql_artifacts = nil
          # Grab the name of the main cql library
          main_cql_library = measure[:main_cql_library]

          # If measure has been uploaded more recently (we should have a copy of the MAT Package) we will use the actual MAT artifacts
          if !measure.package.nil?
            # Create a temporary directory
            Dir.mktmpdir do |dir|
              # Write the package to a temp directory
              File.open(File.join(dir, measure.measure_id + '.zip'), 'wb') do |zip_file|
                # Write the package binary to a zip file.
                zip_file.write(measure.package.file.data)
                files = Measures::CqlLoader.get_files_from_zip(zip_file, dir)
                cql_artifacts = Measures::CqlLoader.process_cql(files, main_cql_library, user)
                cql = files[:CQL]
              end
            end
          # If the measure does not have a MAT package stored, continue as we have in the past using the cql to elm service
          else
            # Grab the measure cql
            cql = measure[:cql]
             # Use the CQL-TO-ELM Translation Service to regenerate elm for older measures.
            elm_json, elm_xml = CqlElm::CqlToElmHelper.translate_cql_to_elm(cql)
            elms = {:ELM_JSON => elm_json,
                    :ELM_XML => elm_xml}
            cql_artifacts = Measures::CqlLoader.process_cql(elms, main_cql_library, user)
          end
          # Update the measure
          measure.update(cql: cql, elm: cql_artifacts[:elms], elm_annotations: cql_artifacts[:elm_annotations], cql_statement_dependencies: cql_artifacts[:cql_definition_dependency_structure],
                         main_cql_library: main_cql_library, value_set_oids: cql_artifacts[:all_value_set_oids], value_set_oid_version_objects: cql_artifacts[:value_set_oid_version_objects])
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
  end
end
