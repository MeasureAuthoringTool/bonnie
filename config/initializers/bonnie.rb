# APP_CONFIG = YAML.load_file(Rails.root.join('config', 'bonnie.yml'))[Rails.env]
# APP_CONFIG.merge! YAML.load_file(Rails.root.join('config', 'measures.yml'))

Dir[Rails.root + 'lib/**/*.rb'].each do |file|
  require file
end