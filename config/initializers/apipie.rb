Apipie.configure do |config|
  config.app_name                = "Bonnie MAT Integration API"
  config.app_info["1"]           = "Bonnie MAT Integration API"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/api"
  config.default_version         = "1"
  config.show_all_examples       = true
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api_v1/*.rb"
end
