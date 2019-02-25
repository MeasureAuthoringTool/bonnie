# TODO: turn this into an actual rake task
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS134v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measures', 'CMS32v7', 'CMS32v7.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measures', 'CMS134v6', 'CMS134v6.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measures', 'CMS878v0', 'CMS878v0.zip'), 'application/xml')
#       measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measures', 'CMS879v0', 'CMS879v0.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measures', 'CMS72v7', 'CMS72v7.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'measures', 'CMS890_v5_6', 'CMS890_v5_6.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS158v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS177v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/xml')
#       # measure_file = fixture_file_upload(File.join('test', 'fixtures', 'cql_measure_exports', 'core_measures', 'CMS160v6_bonnie-fixtures@mitre.org_2018-01-11.zip'), 'application/xml')
#       post :create, {
#         vsac_query_type: 'profile',
#         vsac_query_profile: 'Latest eCQM',
#         vsac_query_include_draft: 'true',
#         vsac_query_measure_defined: 'true',
#         vsac_username: ENV['VSAC_USERNAME'], vsac_password: ENV['VSAC_PASSWORD'],
#         measure_file: measure_file,
#         measure_type: 'ep',
#         calculation_type: 'patient'
#       }
#       measure = CQM::Measure.first 
#       # measure = CQM::Measure.all[7]
#       binding.pry
#       fixture_exporter = BackendFixtureExporter.new(@user, measure: measure, records: nil)

#       # binding.pry
#       base_path = File.join('test', 'fixtures', 'measures', 'CMS879v0')
#       fixture_exporter.export_measure_and_any_components(File.join(base_path,'cqm_measures'))
#       fixture_exporter.export_value_sets(File.join(base_path,'cqm_value_sets'))
#       fixture_exporter.try_export_measure_package(File.join(base_path,'cqm_measure_packages'))
