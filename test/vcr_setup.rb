require 'vcr'
# VCR records HTTP interactions to cassettes that can be replayed during unit tests
# allowing for faster, more predictible web interactions
VCR.configure do |c|
  # This is where the various cassettes will be recorded to
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
  
  # To avoid storing plain text VSAC credentials or requiring the VSAC credentials
  # be provided at every run of the rake tests, provide the VSAC_USERNAME and VSAC_PASSWORD
  # whenever you need to record a cassette that requires valid credentials
  ENV['VSAC_USERNAME'] = "vcrtest" unless ENV['VSAC_USERNAME']
  ENV['VSAC_PASSWORD'] = "vcrpass" unless ENV['VSAC_PASSWORD']

  # Ensure plain text passwords do not show up during logging
  c.filter_sensitive_data('<VSAC_USERNAME>') {ENV['VSAC_USERNAME']}
  c.filter_sensitive_data('<VSAC_PASSWORD>') {URI.escape(ENV['VSAC_PASSWORD'])}
  c.default_cassette_options = {record: :once }

  # Add a custom matcher for use with the bulk request by typheous, so we can ignore service ticket
  c.register_request_matcher :uri_no_st do |req1, req2|
    remove_service_ticket_from_uri(req1.uri) == remove_service_ticket_from_uri(req2.uri)
  end
end

def remove_service_ticket_from_uri(uri)
  uri = String.new(uri)
  service_ticket = uri[/(&ticket=.*)&|(&ticket=.*)$/,0]
  if service_ticket.present?
    service_ticket.chop! if service_ticket.end_with? '&'
    uri[service_ticket] = ''
  end
  return uri
end
