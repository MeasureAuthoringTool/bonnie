# TODO: need to figure out something better for measures.yml
# APP_CONFIG.merge! YAML.load_file(Rails.root.join('config', 'measures.yml'))

Dir[Rails.root + 'lib/**/*.rb'].each do |file|
  require file
end
