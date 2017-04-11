namespace :bonnie do
  namespace :vsac do

    desc 'Look up a value set in VSAC using the API'
    task :lookup_oid => :environment do
      raise "No OID supplied" unless ENV['OID']
      raise "No USERNAME supplied" unless ENV['USERNAME']
      raise "No PASSWORD supplied" unless ENV['PASSWORD']
      effective_date = Date.parse(ENV['DATE']).strftime('%Y%m%d') if ENV['DATE']
      include_draft = !!ENV['DRAFT']
      config = APP_CONFIG["nlm"]
      config["profile"] = ENV['PROFILE'] if ENV['PROFILE']
      
      # We are using V2 API:
      api = HealthDataStandards::Util::VSApiV2.new(config["ticket_url"], config["api_url"], ENV['USERNAME'], ENV['PASSWORD'])
      result = api.get_valueset(ENV['OID'], effective_date: effective_date, include_draft: include_draft, profile: config["profile"])
      doc = Nokogiri::XML(result)
      doc.root.add_namespace_definition("vs","urn:ihe:iti:svs:2008")
      vs_element = doc.at_xpath("/vs:RetrieveValueSetResponse/vs:ValueSet|/vs:RetrieveMultipleValueSetsResponse/vs:DescribedValueSet")
      raise "OID not found" unless vs_element
      puts "Value set #{vs_element['ID']} codes"
      vs_element.xpath("//vs:Concept").each do |concept|
        puts "  #{concept['codeSystemName']} #{concept['code']} (#{concept['codeSystemVersion']})"
      end
    end
    
    
    desc 'Retrieve list of VSAC Profiles'
    task :get_profiles => :environment do
      raise "No USERNAME supplied" unless ENV['USERNAME']
      raise "No PASSWORD supplied" unless ENV['PASSWORD']
      config = APP_CONFIG["nlm"].clone
      
      # TODO: This is a temporary thing we should make it so HDS VSApiV2 has a call to get profiles and 
      # so it can be configued with profiles_url
      config["api_url"] = APP_CONFIG["nlm"]["profiles_url"]
      
      # We are using V2 API:
      api = HealthDataStandards::Util::VSApiV2.new(config["ticket_url"], config["api_url"], ENV['USERNAME'], ENV['PASSWORD'])
      
      # TODO: This is a temporary thing. This call is actually calling the profiles url. HDS VSApiV2 
      # should have a get_profiles call added.
      result = api.get_valueset("0")
      
      doc = Nokogiri::XML(result)
      profile_list_element = doc.at_xpath("/ProfileList")
      
      profile_list_element.xpath("//profile").each do |profile|
        puts "  #{profile.text}"
      end
    end
  end
end
