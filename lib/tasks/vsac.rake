namespace :bonnie do
  namespace :vsac do

    desc %(Look up a value set in VSAC using the API.
      This task is intended to be used for debugging VSAC issues.)
    task :lookup_oid => :environment do
      raise "No OID supplied" unless ENV['OID']
      raise "No API Key supplied" unless ENV['VSAC_API_KEY']
      
      options = {}
      options[:release] = ENV['RELEASE'] if ENV.key?('RELEASE')
      options[:include_draft] = !!ENV['DRAFT'] if ENV.key?('DRAFT')
      options[:profile] = ENV['PROFILE'] if ENV.key?('PROFILE')

      puts "Using the following options to get OID #{ENV['OID']}"
      pp options

      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG["vsac"], api_key: ENV['VSAC_API_KEY'])
      result = api.get_valueset(ENV['OID'], options)

      doc = Nokogiri::XML(result)
      doc.root.add_namespace_definition("vs","urn:ihe:iti:svs:2008")
      vs_element = doc.at_xpath("/vs:RetrieveValueSetResponse/vs:ValueSet|/vs:RetrieveMultipleValueSetsResponse/vs:DescribedValueSet")
      raise "OID not found" unless vs_element
      puts "Value set #{vs_element['ID']} codes"
      vs_element.xpath("//vs:Concept").each do |concept|
        puts "  #{concept['codeSystemName']} #{concept['code']} (#{concept['codeSystemVersion']})"
      end
    end

    desc %(Retrieve list of VSAC Profiles.
      This task is intended to be used for debugging VSAC issues.)
    task :get_profile_names => :environment do
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG["vsac"])
      api.get_profile_names.each do |profile|
        puts "  #{profile}"
      end
    end

    desc %(Retrieve list of VSAC Programs.
      This task is intended to be used for debugging VSAC issues.)
    task :get_program_names => :environment do
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG["vsac"])
      api.get_program_names.each do |program|
        puts "  #{program}"
      end
    end

    desc %(Retrieve VSAC Program Details.
      This task is intended to be used for debugging VSAC issues.)
    task :get_program_details => :environment do
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG["vsac"])
      pp api.get_program_details(ENV['PROGRAM'])
    end

    desc %(Retrieve list of VSAC Releases.
      This task is intended to be used for debugging VSAC issues.)
    task :get_program_release_names => :environment do
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG["vsac"])
      api.get_program_release_names(ENV['PROGRAM']).each do |release|
        puts "  #{release}"
      end
    end
  end
end
