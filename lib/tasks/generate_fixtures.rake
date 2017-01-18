namespace :HDS do
  namespace :test do

    def get_measure(user, cms_hqmf, measure_id)
      if (cms_hqmf.downcase  == 'cms')  
        measure = user.measures.find_by(cms_id: measure_id)
      elsif (cms_hqmf == 'hqmf')
        measure = user.measures.find_by(hqmf_id: measure_id)
      else
        throw('Argument: "' + cms_hqmf + '" does not match expected: cms or hqmf') 
      end
      measure
    end

    def create_fixture_file(file_path, fixture_json)
      FileUtils.mkdir_p(File.dirname(file_path)) unless Dir.exists? File.dirname(file_path)
      File.new(file_path, "w+")
      File.write(file_path, fixture_json)
    end

    ###
    # cms_hqmf: Use cms or hqmf id.
    #   values: cms, hqmf
    # path: Fixture path.
    # test_name: Name of the test the fixture is for.
    # user_email: email of user to export
    # measure_id: id of measuer to export
    # bundle exec rake HDS:test:generate_fixtures[cms,test/CMSFakevFake,initialLoad,fake@fake,CMSFakevFake]
    ###
    task :generate_frontend_fixture, [:cms_hqmf, :path, :test_name, :user_email, :measure_id] => [:environment] do |t, args|
      user = User.find_by email: args[:user_email]
      measure = get_measure(user, args[:cms_hqmf], args[:measure_id])
      
      cms_dir = File.join(args[:test_name], args[:measure_id])
      
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).first
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      
      fixtures_path = File.join('spec', 'javascripts', 'fixtures', 'json')
      
      measure_file = File.join(fixtures_path, 'measure_data', args[:path], cms_dir, 'measures.json')
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse([measure].to_json)))

      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      record_file = File.join(fixtures_path, 'records', args[:path], cms_dir, "patients.json")
      create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(records.to_json)))
      
      oid_to_vs_map = {}
      
      value_sets = measure.value_sets.each do |vs|
        oid_to_vs_map[vs.oid] = vs
      end
      value_sets_file = File.join(fixtures_path, 'measure_data', args[:path], cms_dir, 'value_sets.json')
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(oid_to_vs_map.to_json)))
    
      us_filename = "#{args[:test_name]}.json"
      upload_summaries_file = File.join(fixtures_path, 'upload_summaries', args[:path], us_filename)
      create_fixture_file(upload_summaries_file, JSON.pretty_generate(JSON.parse(measure_summaries.to_json)))
    
      archived_measures_file = File.join(fixtures_path, 'archived_measures', args[:path], cms_dir, "archived_measures.json")
      arc_measures = []
      archived_measures.each do |am|
        arc_measures.push(am)
      end
      create_fixture_file(archived_measures_file, JSON.pretty_generate(JSON.parse(archived_measures.to_json)))
    end

    #Usage
    # cms_hqmf: Use cms or hqmf id.
    #   values: cms, hqmf
    # path: Fixture path.
    # user_email: email of user to export
    # measure_id: id of measuer to export
    # bundle exec rake HDS:test:generate_fixtures[cms,test/CMSFakevFake,fake@fake,CMSFakevFake]
    desc "Exports a set of fixtures that can be loaded for testing purposes"
    task :generate_fixtures, [:cms_hqmf, :path, :user_email, :measure_id] => [:environment] do |t, args|
      user = User.find_by email: args[:user_email]
      measure = get_measure(user, args[:cms_hqmf], args[:measure_id])
      
      measure_summaries = UploadSummary::MeasureSummary.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      archived_measures = ArchivedMeasure.by_user_and_hqmf_set_id(user, measure.hqmf_set_id)
      
      fixtures_path = File.join('test', 'fixtures')
      
      measure_name = measure.cms_id + ".json"
      measure_file = File.join(fixtures_path, 'draft_measures', args[:path], measure_name)
      create_fixture_file(measure_file, JSON.pretty_generate(JSON.parse(measure.to_json)))

      records = Record.by_user_and_hqmf_set_id(user, measure.hqmf_set_id).each do |rec|
        rec_name = rec.first + "_" + rec.last + ".json"
        record_file = File.join(fixtures_path, 'records', args[:path], rec_name)
        create_fixture_file(record_file, JSON.pretty_generate(JSON.parse(rec.to_json)))
      end
      
      value_sets_file = File.join(fixtures_path, 'health_data_standards_svs_value_sets', args[:path], 'value_sets.json')
      create_fixture_file(value_sets_file, JSON.pretty_generate(JSON.parse(measure.value_sets.to_json)))
    
      upload_summaries_file = File.join(fixtures_path, 'upload_summaries', args[:path], "upload_summaries.json")
      create_fixture_file(upload_summaries_file, JSON.pretty_generate(JSON.parse(measure_summaries.to_json)))
    
      archived_measures_file = File.join(fixtures_path, 'archived_measures', args[:path], "archived_measures.json")
      arc_measures = []
      archived_measures.each do |am|
        arc_measures.push(am)
      end
      create_fixture_file(archived_measures_file, JSON.pretty_generate(JSON.parse(archived_measures.to_json)))
    end
    
    desc "Generates oid to valueset dictonary from directory"
    task :generate_oid_to_valuesets => [:environment] do 
      fileset_dir = File.join("test", "fixtures", "health_data_standards_svs_value_sets", ENV['fileset_dir'])
      output_dir = File.join("spec", "javascripts", "fixtures", "json", "measure_data", ENV['output_dir'])
      dict = {}
      Dir.glob(File.join(fileset_dir, "*.json")).each do |file|
        vs = JSON.parse(File.read(file))
        dict[vs['oid']] = vs
      end
      output = File.join(output_dir, "value_sets.json")
      File.new(output, "w+")
      File.write(output, JSON.pretty_generate(dict))
    end
    
  end
end
