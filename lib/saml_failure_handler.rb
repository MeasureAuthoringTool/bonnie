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

      redirect_to link_user(email, harp_id, flash)
    else
      super
    end
  end

  def link_user(email, harp_id, flash)
    user = find_user_case_insensitive(email, harp_id)
    if user.nil?
      title = 'No Bonnie Account'
      msg = 'You don\'t currently have a Bonnie account with this HARP Account. '\
      'Please register for a new Bonnie account or reach out to the help desk for assistance with linking an existing Bonnie account with this HARP Account.'
      flash[:msg] = {title: title,
                     summary: title,
                     body: msg}
      "/users/sign_up"
    else
      if user.is_approved?
        user.harp_id = harp_id
        user.save
        title = 'HARP Account Linked'
        msg = 'Your HARP Account with %{harp_id} and Bonnie account with %{email} have been automatically linked. '\
        'If you need further assistance please reach out to the Bonnie Help Desk.' % {harp_id: harp_id, email: email}
        flash[:msg] = {title: title,
                       summary: title,
                       body: msg}
        "/users/saml/sign_in"
      else
        # Redirect to the post register page
        "/user/registered_not_active"
      end
    end
  end

  def find_user_case_insensitive(email, harp_id)
    user = User.find_by email: /email/i
    # Find by harp_id case insensitive
    case_mismatch = false
    if user.nil?
      user = User.find_by(harp_id: /^#{harp_id}$/i)
      case_mismatch = true unless user.nil?
    end
    # Find by email case insensitive
    if user.nil?
      user = User.find_by(email: /^#{email}$/i)
      case_mismatch = true unless user.nil?
    end
    # HARP is the source of truth, update email and harp_id
    if case_mismatch
      # Update harp ID only if it's already approved
      # Otherwise an unapproved user will get linked
      user.harp_id = harp_id if user.is_approved?
      user.email = email
      user.save
    end
    user
  end

end
