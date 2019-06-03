require_relative '../util/cql_to_elm_helper'

namespace :bonnie do
  namespace :cql do
    desc %(Rebuilds the JSON and XML ELM for a MAT package or extracted directory. Saves as a new zip file with '_rebuilt' appened to
      the file name next to the input path.
      - DOES NOT work with composite measures
      - MUST have cql-to-elm cqlTranslationServer JAR running on local machine

      $ bundle exec rake bonnie:cql:rebuild_package[path/to/package.zip]
      or
      $ bundle exec rake bonnie:cql:rebuild_package[path/to/package_dir]

      If you are using a zsh terminal, you need to use 'noglob':
      $ noglob bundle exec rake bonnie:cql:rebuild_package[path/to/package.zip])
    task :rebuild_package, [:input_package_or_dir_path] => [:environment] do |_t, args|
      input_package_or_dir_path = Pathname.new(args[:input_package_or_dir_path])

      if input_package_or_dir_path.directory?
        puts "Rebuilding ELM of measure folder at #{args[:input_package_or_dir_path]}"
        measure_path = input_package_or_dir_path
      else
        puts "Rebuilding ELM of measure package at #{args[:input_package_or_dir_path]}"
        measure_path = Pathname.new(File.join('tmp', 'package_temp'))
        FileUtils.rm_rf(measure_path) if measure_path.exist?
        FileUtils.mkdir_p(measure_path)

        base_zip_directory = nil
        # extract human_readable and determine base directory name if there is one
        Zip::ZipFile.open(input_package_or_dir_path) do |zip_file|
          human_readable_path = zip_file.glob(File.join('**','**.html')).reject { |x| x.name.starts_with?('__MACOSX') }.first
          zip_file.extract(human_readable_path, File.join(measure_path, File.basename(human_readable_path.name)))

          # look at the human_readable to see if it has a directory it resides in
          base_zip_directory = File.dirname(human_readable_path.name) if File.dirname(human_readable_path.name) != "."

          # extract all other needed files
          zip_file.glob(File.join('**','**.cql')).reject { |x| x.name.starts_with?('__MACOSX') }.each do |cql_file_path|
            zip_file.extract(cql_file_path, File.join(measure_path, File.basename(cql_file_path.name)))
          end
          zip_file.glob(File.join('**','**.xml')).reject { |x| x.name.starts_with?('__MACOSX') }.each do |xml_file_path|
            zip_file.extract(xml_file_path, File.join(measure_path, File.basename(xml_file_path.name)))
          end
        end

      end

      # translate_cql_to_elm
      cql_files = Dir.glob(File.join(measure_path, '**.cql'))
      elm_jsons, elm_xmls = CqlToElmHelper.translate_cql_to_elm(cql_files.map { |cql_path| File.read(cql_path) })

      # find hqmf file
      hqmf_file_path = Dir.glob(File.join(measure_path, "*.xml")).find do |xml_file_path|
        doc = Nokogiri::XML.parse(File.read(xml_file_path))
        # Check if root node in xml file matches either the HQMF file or ELM file.
        doc.root.name == 'QualityMeasureDocument' # Root node for HQMF XML
      end

      # remove the old xml files
      old_elm_xml_filepaths = Dir.glob(File.join(measure_path, "*.xml")).reject { |x| x == hqmf_file_path }
      old_elm_xml_filepaths.each do |file|
        puts "deleting #{file}"
        File.unlink(file)
      end

      xml_filenames = []
      # save the versions from the service
      elm_xmls.each do |elm_xml|
        elm_doc = Nokogiri::XML.parse(elm_xml)
        library_identifier = elm_doc.at_xpath("//xmlns:library/xmlns:identifier")
        library_name = library_identifier.attribute('id').value
        library_version = library_identifier.attribute('version').value
        xml_path = "#{library_name}-#{library_version}.xml"
        xml_filenames << xml_path
        puts "creating #{xml_path}"
        File.write(File.join(measure_path, xml_path), elm_xml.force_encoding(Encoding.find("UTF-8")))
      end

      # remove the old json files
      old_elm_json_filepaths = Dir.glob(File.join(measure_path, "*.json"))
      old_elm_json_filepaths.each do |file|
        puts "deleting #{file}"
        File.unlink(file)
      end

      # save json files
      json_filenames = []
      elm_jsons.each do |elm_json|
        elm_json_hash = JSON.parse(elm_json, max_nesting: 1000)
        if elm_json_hash['library']['annotation']
          raise Exception.new("Translation server found error in #{elm_json_hash['library']['identifier']['id']}\n" +
            JSON.pretty_generate(elm_json_hash['library']['annotation']))
        end
        elm_library_version = "#{elm_json_hash['library']['identifier']['id']}-#{elm_json_hash['library']['identifier']['version']}"
        json_filenames << "#{elm_library_version}.json"
        json_path = File.join(measure_path, "#{elm_library_version}.json")
        puts "creating #{elm_library_version}.json"
        File.write(json_path, elm_json.force_encoding(Encoding.find("UTF-8")))
      end

      # edit hqmf xml - NOTE: this commented out code fixes entries in the HQMF. It is not needed with new packages. so it is commeneted out.
      # puts "Adding JSON ELM entries to HQMF"
      # doc = Nokogiri::XML.parse(File.read(hqmf_file_path))
      # # find cql each expressionDocument
      # doc.xpath("//xmlns:relatedDocument/xmlns:expressionDocument/xmlns:text").each do |cql_node|
      #   # guess at the library name and attempt to find a json file we created for it
      #   cql_filename = cql_node.at_xpath('xmlns:reference').attribute('value').value
      #   cql_libname = cql_filename.split(/[-,_]/)[0]
      #   json_filename = json_filenames.select { |filename| filename.start_with?(cql_libname)}
      #   raise Exception.new("Could not find JSON ELM file for #{cql_libname}") unless json_filename.length > 0

      #   # update reference to ELM XML files we replaced if that was needed
      #   xml_filename = xml_filenames.select { |filename| filename.start_with?(cql_libname)}
      #   raise Exception.new("Could not find XML ELM file for #{cql_libname}") unless xml_filename.length > 0
      #   cql_node.at_xpath('xmlns:translation/xmlns:reference').attribute('value').value = xml_filename[0]

      #   # clone the xml translation and modify it to reference the elm_json
      #   new_translation = cql_node.at_xpath('xmlns:translation').clone()
      #   new_translation.attribute('mediaType').value = "application/elm+json"
      #   new_translation.at_xpath('xmlns:reference').attribute('value').value = json_filename[0]
      #   cql_node.add_child(new_translation)
      # end
      # File.write(hqmf_file_path, doc.to_xml)

      # create new zip
      output_package_path = if input_package_or_dir_path.directory?
                              Pathname.new(File.join(input_package_or_dir_path.dirname,
                                                     input_package_or_dir_path.basename.to_s + "_rebuilt.zip"))
                            else
                              Pathname.new(File.join(input_package_or_dir_path.dirname,
                                                     input_package_or_dir_path.basename('.zip').to_s + "_rebuilt.zip"))
                            end

      # wipe out an existing one
      if File.exist?(output_package_path)
        File.unlink(output_package_path)
        puts "Deleted old zip file at #{output_package_path}"
      end

      puts "Creating new zip file at #{output_package_path}"
      Zip::ZipFile.open(output_package_path, Zip::File::CREATE) do |new_package_zip|
        measure_path.children.each do |path|
          target_path = if !base_zip_directory.nil?
                          File.join(base_zip_directory, path.basename)
                        else
                          path.basename
                        end
          puts "  + #{target_path}"
          new_package_zip.add(target_path, path)
        end
      end
    end
  end
end
