Apipie.configure do |config|
  config.app_name                = "Bonnie MAT Integration API"
  config.app_info["1"]           = "
    Bonnie MAT Integration API v1
    ===
    This API provides access to `Measure` resources, the `Patient` resources
    associated with each `Measure`, and calculated results for each `Measure`
    by _authorized applications and users_.
    Prerequisite: Application Authorization
    ---
    * Applications must be authorized by an Administrator.
    * Application authorization is a one-time process, per application.
    * The application is then issued a `client_id` and `secret` that it can
      use to access this API, along with the `username` and `password` of a 
      valid user.
    * Administrators can add applications on the [Bonnie OAuth2 Application page](/oauth/applications).
    * Information about the user can be accessed using the token info endpoint at `/oauth/token/info`.
    * Tokens may be revoked by the client application using the [OAuth 2.0 Token Revocation](https://tools.ietf.org/html/rfc7009) endpoint at `/oauth/revoke`.
    
    Example Code:
    ---
    The following sample code is written in Ruby, but any modern language
    with an OAuth2 library will work similarly.
    
        require 'oauth2'
        client_id = \"CLIENT_ID_GOES_HERE\"
        secret = \"CLIENT_SECRET_GOES_HERE\"
        username = \"bonnie@example.com\"
        password = \"USER_PASSWORD_GOES_HERE\"
        options = {
          :site => \"http://bonnie.org\",
          :authorize_url => \"http://bonnie.org/oauth/authorize\",
          :token_url => \"http://bonnie.org/oauth/token\",
          :raise_errors => true
        }
        client = OAuth2::Client.new(client_id,secret,options)
        token = client.password.get_token(username,password)
        response = token.get(\"http://bonnie.org/api_v1/measures\")
        puts response.status
        puts response.body
    
    
    Example Token Revocation Request:
    ---
    Note that the `client_id` and `client_secret` are in the body to authorize the client.

        POST /oauth/revoke HTTP/1.1
        Host: bonnie.healthit.gov
        Content-Type: application/x-www-form-urlencoded
        Cache-Control: no-cache

        token=edb292cb0e04a06f72c85d46&token_type_hint=access_token&client_id=dd9589310584&client_secret=3d4a47c7e927d75da

    
    Example Token Info Response:
    ---
    This JSON response body gives info about the token, refresh token and associated user.
      
        {
          \"user_email\": \"bonnie@example.com\",
          \"user_first_name\": \"Bonnie\",
          \"user_last_name\": \"User\",
          \"scopes\": [],
          \"expires_in_seconds\": 900,
          \"created_at\": 1532112013,
          \"refresh_expires_in_seconds\": 431999
        }
  "
  config.markup                  = Apipie::Markup::Markdown.new
  config.api_base_url["1"]       = "/api_v1"
  config.doc_base_url            = "/api"
  config.default_version         = "1"
  config.show_all_examples       = true
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api_v1/*.rb"
  config.ignored_by_recorder     = ["MeasuresController"]
end
