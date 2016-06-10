source 'https://rubygems.org'

gem 'rails', '~> 4.2.7'

# There's an issue with capistrano-rails related to the asset pipeline, which needs older sprockets
# https://github.com/capistrano/rails/issues/111
gem 'sprockets', '~> 2.8'

# Need to require sprockets-rails expicitly to get asset pipeline, at least untill we move to SASS
gem 'sprockets-rails'
# We need less-rails outside of the assets group so that assets will build in production
gem 'less-rails'
# We want non-digest versions of our assets for font-awesome
gem "non-stupid-digest-assets"

gem 'cql_qdm_patientapi', :git => 'https://github.com/projecttacoma/cql_qdm_patientapi.git', :branch => 'master'
gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'mongoid5'
gem 'simplexml_parser', :git => 'https://github.com/projecttacoma/simplexml_parser.git', :branch => 'master'
gem 'hqmf2js', :git => 'https://github.com/projecttacoma/hqmf2js.git', :branch => 'master'
gem 'bonnie_bundler', :git => 'https://github.com/projecttacoma/bonnie_bundler.git', :branch => 'master'
gem 'quality-measure-engine', :git => 'https://github.com/projectcypress/quality-measure-engine.git', :branch => 'bump_mongoid'
gem 'hquery-patient-api', :git => 'https://github.com/projecttacoma/patientapi.git', :branch => 'master'

#gem 'hquery-patient-api', '1.0.4'

# gem 'health-data-standards', :path => '../health-data-standards'
# gem 'cql_qdm_patientapi', :path => '../cql_qdm_patientapi'
# gem 'hqmf2js', path: '../hqmf2js'
# gem 'bonnie_bundler', :path => '../bonnie_bundler'
# gem 'quality-measure-engine', :path => '../quality-measure-engine'
# gem 'hquery-patient-api', :path => '../patientapi'
# gem 'simplexml_parser', :path => '../simplexml_parser'

# needed for HDS
gem 'rubyzip', '>= 1.2.1'
gem 'zip-zip'

gem 'axlsx', git: 'https://github.com/randym/axlsx', branch: 'master'
gem 'mongoid'
gem 'protected_attributes'
gem 'devise'
gem 'systemu'
gem 'diffy', '~> 3.1.0'
gem 'multi_json'

# needed for parsing value sets (we need to use roo rather than rubyxl because the value sets are in xls rather than xlsx)
gem 'roo'

gem 'oj' # Faster JSON

gem 'mongoid-history'
gem 'apipie-rails', :git => 'https://github.com/hossenlopp/apipie-rails', :branch => 'master'  # API documentation generation
gem 'maruku' # enable Markup for API documentation
gem 'doorkeeper', '=3.0.0'
gem "doorkeeper-mongodb", :git => 'https://github.com/doorkeeper-gem/doorkeeper-mongodb', :branch => 'master'

group :test, :development, :ci do
  gem 'pry'
  gem 'teaspoon'
  gem 'teaspoon-jasmine'
  gem 'simplecov', :require => false
  gem 'minitest'
  gem 'webmock'
  gem 'vcr'
  gem 'bundler-audit'
  gem 'brakeman'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'thin'
  gem 'capistrano-rails'
  gem 'rvm1-capistrano3', require: false
  gem 'phantomjs'
#  gem 'selenium-webdriver'
end

group :production do
  gem 'exception_notification', :git => 'https://github.com/smartinez87/exception_notification.git', :branch => 'master'
  gem 'newrelic_rpm'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '~> 2.7.2'
end

gem 'foreman'

gem 'handlebars_assets', '0.16'
gem 'jquery-rails'
