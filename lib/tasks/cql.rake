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
          user = User.find_by('_id': measure[:user_id])
          if measure[:cql].instance_of?(Array) # Newer version of the CqlMeasure model
            # NOTE: The following three lines are adapted from the functionality
            # of the 'load_mat_cql_exports' method in the cql_loader.rb in bonnie_bundler
            elms, elm_annotations = Measures::CqlLoader.translate_cql_to_elm(measure[:cql])
            cql_definition_dependency_structure = Measures::CqlLoader.populate_cql_definition_dependency_structure(measure[:main_cql_library], elms, measure[:populations_cql_map])
            cql_definition_dependency_structure = Measures::CqlLoader.populate_used_library_dependencies(cql_definition_dependency_structure, measure[:main_cql_library], elms)
            measure.update(elm: elms, cql_statement_dependencies: cql_definition_dependency_structure)
            measure.save!
            update_passes += 1
            puts '[Success] Measure ' + measure[:cms_id] + ': "' + measure[:title] + '" with id ' + measure[:id] + ' in account ' + user[:email] + ' successfully updated ELM!'
          elsif measure[:cql].instance_of?(String) # Older version of the CqlMeasure model
            response = RestClient.post('http://localhost:8080/cql/translator',
                                       measure[:cql],
                                       content_type: 'application/cql',
                                       accept: 'application/elm+json')
            # Since the model changed from the original version, save elm as an array
            measure.update(elm: [JSON.parse(response.body)]) if response.code == 200
            measure.save!
            update_passes += 1
            puts '[Success] Measure ' + measure[:cms_id] + ': "' + measure[:title] + '" with id ' + measure[:id] + ' in account ' + user[:email] + ' successfully updated ELM!'
          end
        rescue RestClient::BadRequest => e
          update_fails += 1
          puts '[Error] Measure ' + measure[:cms_id] + ': "' + measure[:title] + '" with id ' + measure[:id] + ' in account ' + user[:email] + ' failed to update ELM!'
        rescue Mongoid::Errors::DocumentNotFound => e
          orphans += 1
          puts '[Error] Measure ' + measure[:cms_id] + ': "' + measure[:title] + '" with id ' + measure[:id] + ' belongs to a user that doesn\'t exist!'
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
