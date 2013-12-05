source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'hqmf2js', :git => 'https://github.com/pophealth/hqmf2js.git', :branch => 'optional_underscore'
#gem 'hqmf2js', path: '../hqmf2js'
gem 'hquery-patient-api', :git => 'https://github.com/pophealth/patientapi.git', :branch => 'develop'
#gem 'hquery-patient-api', :path => '../patientapi'
gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'master'
#gem 'health-data-standards', :path => '../health-data-standards'
# needed for HDS
gem 'rubyzip', '< 1.0.0'

# bonnie_bundler depends on QME, but currently on an unreleased version, so it's not in the gemspec now, so must be here
gem 'quality-measure-engine', :git => 'https://github.com/pophealth/quality-measure-engine.git', :branch => 'mongoid_refactor'
#gem 'quality-measure-engine', :path => '../quality-measure-engine'

# gem 'bonnie_bundler', :git => 'https://github.com/projecttacoma/bonnie_bundler.git', :branch => 'develop'
gem 'bonnie_bundler', :path => '../bonnie_bundler'

gem 'mongoid', '~> 3.1.0'

gem 'devise'

# needed for parsing value sets (we need to use roo rather than rubyxl because the value sets are in xls rather than xlsx)
gem 'roo'

group :test, :development, :ci do
  gem 'pry'
  gem 'jasmine'
  gem 'turn', :require => false
  gem 'simplecov', :require => false
  gem 'minitest', '~> 4.0'
end

group :test, :development do
  gem 'pry-debugger'
  gem 'thin'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'less-rails'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end
gem 'sprockets', '2.2.2.backport1'
gem 'foreman'

gem 'handlebars_assets'
gem 'jquery-rails'
