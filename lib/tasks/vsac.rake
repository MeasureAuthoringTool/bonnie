namespace :bonnie do
  namespace :vsac do

    desc 'Look up a value set in VSAC using the API'
    task :lookup_oid => :environment do
      raise "No OID supplied" unless ENV['OID']
      raise "No USERNAME supplied" unless ENV['USERNAME']
      raise "No PASSWORD supplied" unless ENV['PASSWORD']
      effective_date = Date.parse(ENV['DATE']).strftime('%Y%m%d') if ENV['DATE']
      include_draft = false
      config = APP_CONFIG["nlm"]
      
      # This would be for V1 API:
      #config['api_url'] = 'https://vsac.nlm.nih.gov/vsac/ws/RetrieveValueSet'
      #api = HealthDataStandards::Util::VSApi.new(config["ticket_url"], config["api_url"], ENV['USERNAME'], ENV['PASSWORD'])
      #result = api.get_valueset(ENV['OID'], effective_date, include_draft)
      
      # We are using V2 API:
      api = HealthDataStandards::Util::VSApiV2.new(config["ticket_url"], config["api_url"], ENV['USERNAME'], ENV['PASSWORD'])
      result = api.get_valueset(ENV['OID'], effective_date: effective_date)
      doc = Nokogiri::XML(result)
      doc.root.add_namespace_definition("vs","urn:ihe:iti:svs:2008")
      vs_element = doc.at_xpath("/vs:RetrieveValueSetResponse/vs:ValueSet|/vs:RetrieveMultipleValueSetsResponse/vs:DescribedValueSet")
      raise "OID not found" unless vs_element
      puts "Value set #{vs_element['ID']} codes"
      vs_element.xpath("//vs:Concept").each do |concept|
        puts "  #{concept['codeSystemName']} #{concept['code']} (#{concept['codeSystemVersion']})"
      end
    end
  end
end
