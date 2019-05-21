#  -*- coding: utf-8 -*-

namespace :bonnie do

  namespace :cql do

    require 'colorize'

    desc %{Recreates the JSON elm stored on CQL measures using an instance of
      a locally running CQLTranslationService JAR.

    $ rake bonnie:cql:rebuild_elm}
    task :rebuild_elm => :environment do
      update_passes = 0
      update_fails = 0
      orphans = 0
      fields_diffs = Hash.new(0)
      CQM::Measure.all.each do |measure|
        begin
          # Grab the user, we need this to output the name of the user who owns
          # this measure. Also comes in handy when detecting measures uploaded
          # by accounts that have since been deleted.
          user = User.find_by(_id: measure[:user_id])
          if !user.nil?
            cql = nil
            cql_artifacts = nil
            # Grab the name of the main cql library
            main_cql_library = measure[:main_cql_library]

            # Grab a copy of all attributes that we will update the measure with.
            before_state = {}
            before_state[:measure_data_criteria] = measure[:data_criteria].deep_dup
            before_state[:measure_source_data_criteria] = measure[:source_data_criteria].deep_dup
            before_state[:measure_cql] = measure[:cql].deep_dup
            before_state[:measure_elm] = measure[:elm].deep_dup
            before_state[:measure_elm_annotations] = measure[:elm_annotations].deep_dup
            before_state[:measure_cql_statement_dependencies] = measure[:cql_statement_dependencies].deep_dup
            before_state[:measure_main_cql_library] = measure[:main_cql_library].deep_dup
            before_state[:measure_value_set_oids] = measure[:value_set_oids].deep_dup
            before_state[:measure_value_set_oid_version_objects] = measure[:value_set_oid_version_objects].deep_dup

            # Grab the existing data_criteria and source_data_criteria hashes. Must be a deep copy, due to how Mongo copies Hash and Array field types.
            data_criteria_object = {}
            data_criteria_object['data_criteria'] = measure[:data_criteria].deep_dup
            data_criteria_object['source_data_criteria'] = measure[:source_data_criteria].deep_dup

            # If measure has been uploaded more recently (we should have a copy of the MAT Package) we will use the actual MAT artifacts
            if !measure.package.nil?
              # Create a temporary directory
              Dir.mktmpdir do |dir|
                # Write the package to a temp directory
                File.open(File.join(dir, measure.measure_id + '.zip'), 'wb') do |zip_file|
                  # Write the package binary to a zip file.
                  zip_file.write(measure.package.file.data)
                  measure_dir = Measures::CqlLoader.unzip_measure_contents(zip_file, dir)
                  files = Measures::CqlLoader.get_files_from_directory(measure_dir)
                  cql_artifacts = Measures::CqlLoader.process_cql(files, main_cql_library, user, nil, nil, measure.hqmf_set_id)
                  data_criteria_object['source_data_criteria'], data_criteria_object['data_criteria'] = Measures::CqlLoader.set_data_criteria_code_list_ids(data_criteria_object, cql_artifacts)
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
              cql_artifacts = Measures::CqlLoader.process_cql(elms, main_cql_library, user, nil, nil, measure.hqmf_set_id)
              data_criteria_object['source_data_criteria'], data_criteria_object['data_criteria'] = Measures::CqlLoader.set_data_criteria_code_list_ids(data_criteria_object, cql_artifacts)
            end

            # Get a hash of differences from the original measure and the updated data
            differences = measure_update_diff(before_state, data_criteria_object, cql, cql_artifacts, main_cql_library)
            unless differences.empty?
              # Update the measure
              measure.update(data_criteria: data_criteria_object['data_criteria'], source_data_criteria: data_criteria_object['source_data_criteria'], cql: cql, elm: cql_artifacts[:elms], elm_annotations: cql_artifacts[:elm_annotations], cql_statement_dependencies: cql_artifacts[:cql_definition_dependency_structure],
                             main_cql_library: main_cql_library, value_set_oids: cql_artifacts[:all_value_set_oids], value_set_oid_version_objects: cql_artifacts[:value_set_oid_version_objects])
              measure.save!
              update_passes += 1
              print "\e[#{32}m#{"[Success]"}\e[0m"
              puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' in account ' + "\e[1m#{user[:email]}\e[22m" + ' successfully updated ELM!'
              differences.each_key do |key|
                fields_diffs[key] += 1
                puts "--- #{key} --- Has been modified"
              end
            end
          else
            orphans += 1
            print "\e[#{31}m#{"[Error]"}\e[0m"
            puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' belongs to a user that doesn\'t exist!'
          end
        rescue Exception => e
          update_fails += 1
          print "\e[#{31}m#{"[Error]"}\e[0m"
          puts ' Measure ' + "\e[1m#{measure[:cms_id]}\e[22m" + ': "' + measure[:title] + '" with id ' + "\e[1m#{measure[:id]}\e[22m" + ' in account ' + "\e[1m#{user[:email]}\e[22m" + ' failed to update ELM!'
        end
      end
      puts "#{update_passes} measures successfully updated."
      puts "#{update_fails} measures failed to update."
      puts "#{orphans} measures are orphaned, and were not updated."
      puts "Overall number of fields changed."
      fields_diffs.each do |key, value|
        puts "-- #{key}: #{value} --"
      end
    end

    # Builds a hash of differences between the existing measure data and the new data
    def self.measure_update_diff(before_state, data_criteria_object, cql, cql_artifacts, main_cql_library)
      differences = {}
      differences['Data Criteria'] = data_criteria_object['data_criteria'] if Digest::MD5.hexdigest(before_state[:measure_data_criteria].to_json) != Digest::MD5.hexdigest(data_criteria_object['data_criteria'].to_json)
      differences['Source Data Criteria'] = data_criteria_object['source_data_criteria'] if Digest::MD5.hexdigest(before_state[:measure_source_data_criteria].to_json) != Digest::MD5.hexdigest(data_criteria_object['source_data_criteria'].to_json)
      differences['CQL'] = cql if Digest::MD5.hexdigest(before_state[:measure_cql].to_json) != Digest::MD5.hexdigest(cql.to_json)
      differences['ELM'] = cql_artifacts[:elms] if Digest::MD5.hexdigest(before_state[:measure_elm].to_json) != Digest::MD5.hexdigest(cql_artifacts[:elms].to_json)
      differences['ELM Annotations'] = cql_artifacts[:elm_annotations] if Digest::MD5.hexdigest(before_state[:measure_elm_annotations].to_json) != Digest::MD5.hexdigest(cql_artifacts[:elm_annotations].to_json)
      differences['CQL Definition Statement Dependencies'] = cql_artifacts[:cql_definition_dependency_structure] if Digest::MD5.hexdigest(before_state[:measure_cql_statement_dependencies].to_json) != Digest::MD5.hexdigest(cql_artifacts[:cql_definition_dependency_structure].to_json)
      differences['Main CQL Library'] = main_cql_library if Digest::MD5.hexdigest(before_state[:measure_main_cql_library].to_json) != Digest::MD5.hexdigest(main_cql_library.to_json)
      differences['All Value Set Oids'] = cql_artifacts[:all_value_set_oids] if Digest::MD5.hexdigest(before_state[:measure_value_set_oids].to_json) != Digest::MD5.hexdigest(cql_artifacts[:all_value_set_oids].to_json)
      differences['Value Set Oid Version Objects'] = cql_artifacts[:value_set_oid_version_objects] if Digest::MD5.hexdigest(before_state[:measure_value_set_oid_version_objects].to_json) != Digest::MD5.hexdigest(cql_artifacts[:value_set_oid_version_objects].to_json)
      differences
    end

    desc %{Converts Bonnie measures to new CQM Measures
      user email is optional and can be passed in by EMAIL
      If no email is provided, rake task will run on all measures
    $ rake bonnie:cql:convert_measures EMAIL=xxx}
    task :convert_measures => :environment do
      user = User.find_by email: ENV["EMAIL"] if ENV["EMAIL"]
      raise StandardError.new("Could not find user #{ENV["EMAIL"]}.") if ENV["EMAIL"] && user.nil?
      bonnie_cql_measures = user ? CqlMeasure.by_user(user) : CqlMeasure.all

      fail_count = 0
      puts "**** Starting to convert measures! ****\n\n"
      bonnie_cql_measures.each do |measure|
        begin
          cqm_measure = CQM::Converter::BonnieMeasure.to_cqm(measure)
          cqm_measure.value_sets.map(&:save!)
          cqm_measure.user = measure.user
          cqm_measure.save!
          # Verify Measure was converted properly
          diff = measure_conversion_diff(measure, cqm_measure)
          if diff.empty?
            print ".".green
          else
            puts "\nConversion Difference".yellow
            measure_user = User.find_by(_id: measure[:user_id])
            puts "Measure #{measure.cms_id}: #{measure.title} with id #{measure._id} in account #{measure_user.email}".light_blue
            diff.each_entry do |element|
              puts "--- #{element} --- Is different from CQL measure".light_blue
            end
            fail_count += 1
          end
        rescue StandardError => e
          fail_count += 1
          puts "\nMeasure  #{measure.title} #{measure.cms_id} with id #{measure._id} failed with message: #{e.message}".red
        rescue ExecJS::ProgramError => e
          fail_count += 1
          # if there was a conversion failure we should record the resulting failure message with the measure
          puts "\nMeasure  #{measure.title} #{measure.cms_id} with id #{measure._id} failed with message: #{e.message}".red
        end
      end
      puts "\n**** Done converting ****"
      puts "Successful Conversions: #{bonnie_cql_measures.count - fail_count}"
      puts "Unsuccessful/Failed Conversions: #{fail_count}"
    end

    def self.measure_conversion_diff(cql_measure, cqm_measure)
      differences = []

      differences.push('user_id') if cql_measure.user_id != cqm_measure['user_id']
      differences.push('hqmf_id') if cql_measure.hqmf_id != cqm_measure['hqmf_id']
      differences.push('hqmf_set_id') if cql_measure[:hqmf_set_id] != cqm_measure['hqmf_set_id']
      differences.push('hqmf_version_number') if cql_measure[:hqmf_version_number].to_s != cqm_measure['hqmf_version_number']
      differences.push('cms_id') if cql_measure[:cms_id] != cqm_measure['cms_id']
      differences.push('title') if cql_measure[:title] != cqm_measure['title']
      differences.push('description') if cql_measure[:description] != cqm_measure['description']
      differences.push('calculate_sdes') if cql_measure[:calculate_sdes] != cqm_measure['calculate_sdes']
      differences.push('main_cql_library') if cql_measure[:main_cql_library] != cqm_measure['main_cql_library']
      differences.push('population_criteria') if cql_measure[:population_criteria] != cqm_measure['population_criteria']
      differences.push('measure_period') if cql_measure[:measure_period] != cqm_measure['measure_period']
      differences.push('measure_attributes') if cql_measure[:measure_attributes] != cqm_measure['measure_attributes']
      differences.push('cql libraries') if cql_measure[:cql_statement_dependencies].count != cqm_measure['cql_libraries'].count

      scoring = cql_measure[:continuous_variable] ? 'CONTINUOUS_VARIABLE' : 'PROPORTION'
      differences.push('measure_scoring') if scoring != cqm_measure['measure_scoring']
      calc_method = cql_measure[:episode_of_care] ? 'EPISODE_OF_CARE' : 'PATIENT'
      differences.push('calculation_method') if calc_method != cqm_measure['calculation_method']

      # Duplicate source data criteria are removed from the measure when converted, so this verification ensures that was done properly
      unique_sdc = cql_measure.source_data_criteria.values.index_by { |sdc| [sdc['code_list_id'], sdc['description']] }
      differences.push('source_data_criteria') if unique_sdc.length != cqm_measure.source_data_criteria.count

      if cql_measure[:composite]
        differences.push('composite') unless cqm_measure['composite']
        differences.push('component_hqmf_set_ids') if cql_measure[:component_hqmf_set_ids] != cqm_measure['component_hqmf_set_ids']
      end
      if cql_measure[:component]
        differences.push('component') unless cqm_measure['component']
        differences.push('composite_hqmf_set_id') if cql_measure.composite_hqmf_set_id != cqm_measure['composite_hqmf_set_id']
      end

      cql_measure[:value_set_oid_version_objects].each do |cql_val_set|
        if cql_val_set[:version] == "" && cqm_measure.value_sets.where(oid: cql_val_set[:oid], version: "").count < 1 && cqm_measure.value_sets.where(oid: cql_val_set[:oid], version: "N/A").count < 1
          differences.push('value_sets')
        elsif cqm_measure.value_sets.where(oid: cql_val_set[:oid], version: cql_val_set[:version]).count < 1
          differences.push('value_sets') 
        end
      end

      differences
    end

    desc %{Coverts Bonnie patients to new CQM/QDM Patients
      user email is optional and can be passed in by EMAIL
      If no email is provided, rake task will run on all patients
    $ rake bonnie:cql:convert_patients EMAIL=xxx}
    task :convert_patients => :environment do
      user = User.find_by email: ENV["EMAIL"] if ENV["EMAIL"]
      raise StandardError.new("Could not find user #{ENV["EMAIL"]}.") if ENV["EMAIL"] && user.nil?
      bonnie_patients = user ? Record.by_user(user) : Record.all
      count = 0
      bonnie_patients.no_timeout.each do |bonnie_patient|
        begin
          cqm_patient = CQMConverter.to_cqm(bonnie_patient)
          cqm_patient.user = bonnie_patient.user
          cqm_patient.save!
          count += 1
        rescue ExecJS::ProgramError, StandardError => e
          # if there was a conversion failure we should record the resulting failure message with the hds model in a
          # separate collection to return
          user = User.find_by _id: bonnie_patient.user_id
          if bonnie_patient.measure_ids.first.nil?
            puts "#{user.email}\n  Measure: N/A\n  Patient: #{bonnie_patient._id}\n  Conversion failed with message: #{e.message}".light_red
          elsif CQM::Measure.where(hqmf_set_id: bonnie_patient.measure_ids.first, user_id: bonnie_patient.user_id).first.nil?
            puts "#{user.email}\n  Measure (hqmf_set_id): #{bonnie_patient.measure_ids.first}\n  Patient: #{bonnie_patient._id}\n  Conversion failed with message: #{e.message}".light_red
          else
            measure = CQM::Measure.where(hqmf_set_id: bonnie_patient.measure_ids.first, user_id: bonnie_patient.user_id).first
            puts "#{user.email}\n  Measure: #{measure.title} #{measure.cms_id}\n  Patient: #{bonnie_patient._id}\n  Conversion failed with message: #{e.message}".light_red
          end
        end
      end
      puts count
    end

    desc %{Outputs user accounts that have cql measures and which measures are cql in their accounts.
      Example test@test.com
                CMS_ID: xxx   TITLE: Measure Title
    $ rake bonnie:cql:cql_measure_stats}
    task :cql_measure_stats => :environment do

      # Collect user info from CQL measures
      users = {}
      CQM::Measure.all.each do |m|
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
