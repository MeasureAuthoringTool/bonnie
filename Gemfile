source 'https://rubygems.org'

gem 'rails', '7.0.8.1'

gem 'sprockets', '>= 3.7.3'

# Need to require sprockets-rails expicitly to get asset pipeline, at least untill we move to SASS
# Pinning sprockets-rails to 2.3.3 so that everything doesn't blow up. It might be time to start thinking about webpack.
gem 'sprockets-rails', '3.0.0'
# We need less-rails outside of the assets group so that assets will build in production
gem 'less-rails'
# We want non-digest versions of our assets for font-awesome
gem "non-stupid-digest-assets", ">= 1.0.10"

# gem 'cqm-parsers', :path => '../cqm-parsers'
# gem 'fhir-mongoid-models', :path => '../fhir-mongoid-models'
gem 'cqm-parsers', :git => 'https://github.com/projecttacoma/cqm-parsers.git', :branch => 'bonnie-on-fhir'
gem 'fhir-mongoid-models', '~> 0.0.4'

# needed for HDS
gem 'rubyzip', '>= 1.3.0'
gem 'zip-zip'


gem 'axlsx', git: 'https://github.com/randym/axlsx', branch: 'master'
gem 'mongoid', '~> 7.1'
gem 'devise', '>= 4.8.1'
gem 'systemu'
gem 'multi_json'
gem 'rest-client'
# needed for parsing value sets (we need to use roo rather than rubyxl because the value sets are in xls rather than xlsx)
gem 'roo', '~> 2.9', '>= 2.9.0'


gem 'oj' # Faster JSON
gem 'apipie-rails', '>= 0.5.19'
gem 'maruku' # enable Markup for API documentation
gem 'doorkeeper', '~> 5.0.0'
gem "doorkeeper-mongodb", "~> 5.0.0"

group :test, :development, :ci do
  gem 'pry'
  # Pinning teaspoon to 1.1.5 because of sprockets-rails 2.3.3
  gem 'teaspoon', '1.2.0'
  gem "overcommit"
  gem 'rubocop'
  gem 'teaspoon-jasmine', '>= 2.4.1'
  gem 'simplecov', :require => false
  gem 'minitest'
  gem 'rails_best_practices'
  gem 'webmock', '~> 3.11.3'
  gem 'vcr'
  gem 'bundler-audit'
  gem 'colorize'
  gem 'brakeman'
  gem 'selenium-webdriver'
  gem 'codecov', :require => false
  gem 'rails-controller-testing'
  gem 'rails-html-sanitizer', '>= 1.4.4'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'thin', '~> 1.8.2'
  gem 'capistrano-rails'
  gem 'capistrano-npm'
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

  gem 'uglifier', '~> 4.1.20'
end

gem 'foreman'

gem 'handlebars_assets', '0.17'
gem 'jquery-rails', '>= 4.5.0'

# Browser Detection
gem 'browser'

gem "reverse_markdown", "~> 2.1", ">= 2.1.1"
gem "tinymce-rails", ">= 5.8.2"

gem "devise_saml_authenticatable", ">= 1.7.0"
