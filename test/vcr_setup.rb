require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
  
  ENV['VSAC_USERNAME'] = "vcrtest" unless ENV['VSAC_USERNAME']
  ENV['VSAC_PASSWORD'] = "vcrpass" unless ENV['VSAC_PASSWORD']
  
  c.filter_sensitive_data('<VSAC_USERNAME>') { ENV['VSAC_USERNAME'] }
  c.filter_sensitive_data('<VSAC_PASSWORD>') { ENV['VSAC_PASSWORD'] }
  c.default_cassette_options = { record: :once }
end
