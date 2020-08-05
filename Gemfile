source 'https://rubygems.org'

gem 'rails', '5.2.1'

gem 'sprockets'

# Need to require sprockets-rails expicitly to get asset pipeline, at least untill we move to SASS
# Pinning sprockets-rails to 2.3.3 so that everything doesn't blow up. It might be time to start thinking about webpack.
gem 'sprockets-rails', '2.3.3'
# We need less-rails outside of the assets group so that assets will build in production
gem 'less-rails'
# We want non-digest versions of our assets for font-awesome
gem "non-stupid-digest-assets"

# <<<<<<< HEAD
# gem 'cqm-models', '~> 3.0.0'
# gem 'cqm-parsers', '~> 0.2.1'
# gem 'cqm-reports', '~> 3.0.0.pre.alpha.1'

# gem 'cqm-parsers', :git => 'https://github.com/projecttacoma/cqm-parsers', :branch => 'bonnie_version'
# gem 'cqm-models', :git => 'https://github.com/projecttacoma/cqm-models', :branch => 'master'
# gem 'cqm-reports', :git => 'https://github.com/projecttacoma/cqm-reports', :branch => 'master'

 # gem 'cqm-parsers', :path => '../cqm-parsers'
 gem 'fhir-mongoid-models', :git => 'https://github.com/MeasureAuthoringTool/fhir-mongoid-models', :branch => 'develop'
 # gem 'fhir-mongoid-models', :path => '../fhir-mongoid-models'
# gem 'cqm-reports', :path => '../cqm-reports'
# =======
# gem 'cqm-models', '~> 3.0.0'
# gem 'cqm-reports', '~> 3.1.1'

# The cqm-parsers branch can be changed to bonnie_version once https://github.com/projecttacoma/cqm-parsers/pull/87
# is merged, and then again to bonnie-on-fhir once https://github.com/projecttacoma/cqm-parsers/pull/88 is merged
# and the rest of the development on that branch has been finished.
# gem 'cqm-parsers', :git => 'https://github.com/projecttacoma/cqm-parsers', :branch => 'bonnie_version'
gem 'cqm-parsers', :git => 'https://github.com/projecttacoma/cqm-parsers', :branch => 'MAT1385_rails_upgrade_bof'
# >>>>>>> MAT1385_rails_upgrade

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
  gem 'rubocop'
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
end

group :test, :development do
  gem 'pry-byebug'
  gem 'thin', '~> 1.7.2'
  gem 'capistrano-rails'
  gem 'capistrano-yarn'
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
