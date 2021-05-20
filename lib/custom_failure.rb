class CustomFailure < Devise::FailureApp
  def respond
    if warden_options[:attempted_path] == "/users/saml/auth"
      encoded_saml = params['SAMLResponse']
      saml_xml = Base64.decode64(encoded_saml)
      xml_doc = Nokogiri::XML(saml_xml)
      harp_id = xml_doc.xpath('//saml2:NameID/text()', 'saml2' => 'urn:oasis:names:tc:SAML:2.0:assertion').to_s
      email = xml_doc.xpath('//saml2:Attribute[@Name="email"]/saml2:AttributeValue/text()', 'saml2' => 'urn:oasis:names:tc:SAML:2.0:assertion').to_s
      puts '-------------------------------------'
      puts 'HARP ID: ' + harp_id
      puts 'Email: ' + email
      puts '-------------------------------------'

      redirect_to "/saml_error"
    else
      super
    end
  end
end
