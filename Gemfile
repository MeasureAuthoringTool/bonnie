source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'hqmf2js', :git => 'https://github.com/pophealth/hqmf2js.git', :branch => 'optional_underscore'
#gem 'hqmf2js', path: '../hqmf2js'
gem 'hquery-patient-api', :git => 'https://github.com/pophealth/patientapi.git', :branch => 'develop'
#gem 'hquery-patient-api', :path => '../patientapi'
gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'master'
#gem 'health-data-standards', :path => '../health-data-standards'

gem 'bonnie_bundler', :git => 'https://github.com/projecttacoma/bonnie_bundler.git', :branch => 'develop'
#gem 'bonnie_bundler', :path => '../bonnie_bundler'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'mongoid', '~> 3.1.0'

gem 'devise'

# needed for HDS
gem 'rubyzip', '< 1.0.0'

# needed for parsing value sets (we need to use roo rather than rubyxl because the value sets are in xls rather than xlsx)
gem 'roo'

group :development do
  gem 'pry'
end

group :test, :development do
  gem 'pry'
  gem 'jasmine'
  gem 'turn', :require => false
  gem 'simplecov', :require => false
  gem 'minitest', '~> 4.0'
  gem 'thin'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'less-rails'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'handlebars_assets'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end
gem 'sprockets', '2.2.2.backport1'


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
