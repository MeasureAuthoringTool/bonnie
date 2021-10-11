source 'https://rubygems.org'

gem 'rails', '5.2.4.6'

gem 'sprockets'

# Need to require sprockets-rails expicitly to get asset pipeline, at least untill we move to SASS
# Pinning sprockets-rails to 2.3.3 so that everything doesn't blow up. It might be time to start thinking about webpack.
gem 'sprockets-rails', '2.3.3'
# We need less-rails outside of the assets group so that assets will build in production
gem 'less-rails'
# We want non-digest versions of our assets for font-awesome
gem "non-stupid-digest-assets"

gem 'cqm-models', '~>4.0.0'
# gem 'cqm-reports', '~> 3.1.2'

gem 'cqm-parsers', :git => 'https://github.com/projecttacoma/cqm-parsers.git', :branch => 'bonnie_version'

# needed for HDS
gem 'rubyzip', '>= 1.3.0'
gem 'zip-zip'

gem 'axlsx', git: 'https://github.com/randym/axlsx', branch: 'master'
gem 'mongoid', '~> 6.4.2'
gem 'devise'
gem 'systemu'
gem 'multi_json'
gem 'rest-client'
# needed for parsing value sets (we need to use roo rather than rubyxl because the value sets are in xls rather than xlsx)
gem 'roo', '~> 2.7'


gem 'oj' # Faster JSON
gem 'apipie-rails'
gem 'maruku' # enable Markup for API documentation
gem 'doorkeeper', '~> 4.4.0'
gem "doorkeeper-mongodb", '~> 4.1.0'

group :test, :development, :ci do
  gem 'pry'
  # Pinning teaspoon to 1.1.5 because of sprockets-rails 2.3.3
  gem 'teaspoon', '1.1.5'
  gem "overcommit"
  gem 'rubocop', '~> 0.88.0'
  gem 'rubocop-ast', '~> 0.3.0'
  gem 'teaspoon-jasmine'
  gem 'simplecov', :require => false
  gem 'minitest'
  gem 'rails_best_practices'
  gem 'webmock', '~> 2.3.1'
  gem 'vcr'
  gem 'bundler-audit'
  gem 'colorize'
  gem 'brakeman'
  gem 'selenium-webdriver'
  gem 'codecov', :require => false
  gem 'rails-controller-testing'
  gem 'debase'
  gem 'ruby-debug-ide', '~> 0.7.3'
end

group :test, :development do
  gem 'pry-byebug'
  gem 'thin', '~> 1.7.2'
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

gem 'handlebars_assets', '0.16'
gem 'jquery-rails'

# Browser Detection
gem 'browser'

gem "reverse_markdown", "~> 2.0"
gem "tinymce-rails"

gem "devise_saml_authenticatable"
