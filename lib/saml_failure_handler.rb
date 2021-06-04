class SamlFailureHandler < Devise::FailureApp
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

      user = User.find_by email: email
      if user.nil?
        redirect_to "/saml_error"
      else
        if user.is_approved?
          user.harp_id = harp_id
          user.save
          title = 'HARP Account Linked'
          msg = 'Your HARP Account with %{harp_id} and Bonnie account with %{email} have been automatically linked. If you need further assistance please reach out to the Bonnie Help Desk.' % {harp_id:harp_id, email:email}
          flash[:msg] = { title: title,
                          summary: title,
                          body: msg }
          redirect_to "/users/saml/sign_in##{params[:redirect_route]}"
        else
          # Redirect to the post register page (post register page)
          redirect_to "/user/registered_not_active"
        end
      end
    else
      super
    end
  end
end
