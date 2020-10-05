require 'vcr'
# VCR records HTTP interactions to cassettes that can be replayed during unit tests
# allowing for faster, more predictible web interactions
VCR.configure do |c|
  # This is where the various cassettes will be recorded to
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock

  # To avoid storing plain text VSAC credentials or requiring the VSAC credentials
  # be provided at every run of the rake tests, provide the VSAC_API_KEY
  # whenever you need to record a cassette that requires valid credentials
  ENV['VSAC_API_KEY'] = "vcrpass" unless ENV['VSAC_API_KEY']

  # Ensure plain text passwords do not show up during logging
  c.filter_sensitive_data('<VSAC_API_KEY>') {URI.escape(ENV['VSAC_API_KEY'])}
  c.default_cassette_options = {record: :once }

end
