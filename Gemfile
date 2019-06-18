source 'https://rubygems.org'

gem 'rails', '~> 4.2.11'

# There's an issue with capistrano-rails related to the asset pipeline, which needs older sprockets
# https://github.com/capistrano/rails/issues/111
gem 'sprockets', '~> 2.8'

# Need to require sprockets-rails expicitly to get asset pipeline, at least untill we move to SASS
gem 'sprockets-rails'
# We need less-rails outside of the assets group so that assets will build in production
gem 'less-rails'
# We want non-digest versions of our assets for font-awesome
gem "non-stupid-digest-assets"

gem 'health-data-standards', '~> 4.3.5'
# gem 'cql_qdm_patientapi', '~> 1.3.1'
gem 'simplexml_parser', '~> 1.0'
gem 'hqmf2js', '~> 1.4'
# gem 'bonnie_bundler', '~> 2.2.4'
gem 'quality-measure-engine', '~> 3.2'
gem 'hquery-patient-api', '~> 1.1'
# gem 'cqm-converter', '~> 1.0.3'
# gem 'cqm-parsers', '~> 0.2.1'

# gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'master_bonnie'
gem 'cql_qdm_patientapi', :git => 'https://github.com/projecttacoma/cql_qdm_patientapi.git', :branch => 'master'
# gem 'simplexml_parser', :git => 'https://github.com/projecttacoma/simplexml_parser.git', :branch => 'master'
# gem 'hqmf2js', :git => 'https://github.com/projecttacoma/hqmf2js.git', :branch => 'master'
gem 'bonnie_bundler', :git => 'https://github.com/projecttacoma/bonnie_bundler.git', :branch => 'cqm-integration'
# gem 'quality-measure-engine', :git => 'https://github.com/projectcypress/quality-measure-engine.git', :branch => 'master'
# gem 'hquery-patient-api', :git => 'https://github.com/projecttacoma/patientapi.git', :branch => 'master'
gem 'cqm-converter', :git => 'https://github.com/projecttacoma/cqm-converter', :branch => 'master'
gem 'cqm-parsers', :git => 'https://github.com/projecttacoma/cqm-parsers', :branch => 'bonnie_version'
gem 'cqm-models', :git => 'https://github.com/projecttacoma/cqm-models', :branch => 'nil_check'

# gem 'health-data-standards', :path => '../health-data-standards'
# gem 'cql_qdm_patientapi', :path => '../cql_qdm_patientapi'
# gem 'simplexml_parser', :path => '../simplexml_parser'
# gem 'hqmf2js', path: '../hqmf2js'
# gem 'bonnie_bundler', :path => '../bonnie_bundler'
# gem 'quality-measure-engine', :path => '../quality-measure-engine'
# gem 'hquery-patient-api', :path => '../patientapi'
# gem 'cqm-converter', :path => '../cqm-converter'
# gem 'cqm-parsers', :path => '../cqm-parsers'
# gem 'cqm-models', :path => '../cqm-models'
# gem 'cqm-reports', :path => '../cqm-reports'

# needed for HDS
gem 'rubyzip', '>= 1.2.1'
gem 'zip-zip'

gem 'axlsx', git: 'https://github.com/randym/axlsx', branch: 'master'
gem 'mongoid'
gem 'protected_attributes'
gem 'devise'
gem 'systemu'
gem 'multi_json'

# needed for parsing value sets (we need to use roo rather than rubyxl because the value sets are in xls rather than xlsx)
gem 'roo', '~> 2.7'


gem 'oj' # Faster JSON
gem 'apipie-rails', :git => 'https://github.com/hossenlopp/apipie-rails', :branch => 'master' # API documentation generation
gem 'maruku' # enable Markup for API documentation
gem 'doorkeeper', '~> 4.4.0'
gem "doorkeeper-mongodb", '~> 4.1.0'

group :test, :development, :ci do
  gem 'pry'
  gem 'teaspoon'
  gem "overcommit"
  gem 'rubocop'
  gem 'teaspoon-jasmine'
  gem 'simplecov', :require => false
  gem 'minitest'
  gem 'rails_best_practices'
  gem 'reek'
  gem 'webmock', '~> 2.3.1'
  gem 'vcr'
  gem 'bundler-audit'
  gem 'colorize'
  gem 'brakeman'
  gem 'selenium-webdriver'
  gem 'codecov', :require => false
end

group :test, :development do
  gem 'pry-byebug'
  gem 'thin', '~> 1.7.2'
  gem 'capistrano-rails'
  gem 'rvm1-capistrano3', require: false
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

# Browser Detection
gem 'browser'
