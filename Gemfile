source 'https://rubygems.org'

gem 'rails', '3.2.14'

gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'master'
# gem 'hqmf2js', '1.3.0'
gem 'hqmf2js', :git => 'https://github.com/pophealth/hqmf2js.git', :branch => 'master'
gem 'bonnie_bundler', :git => 'https://github.com/projecttacoma/bonnie_bundler.git', :branch => 'master'
gem 'quality-measure-engine', '3.0.0'
gem 'hquery-patient-api', '1.0.4'

#gem 'health-data-standards', :path => '../health-data-standards'
#gem 'hqmf2js', path: '../hqmf2js'
#gem 'bonnie_bundler', :path => '../bonnie_bundler'
#gem 'quality-measure-engine', :path => '../quality-measure-engine'
#gem 'hquery-patient-api', :path => '../patientapi'

# needed for HDS
gem 'rubyzip', '< 1.0.0'

gem 'mongoid', '~> 3.1.0'

gem 'devise'
gem 'systemu'

# needed for parsing value sets (we need to use roo rather than rubyxl because the value sets are in xls rather than xlsx)
gem 'roo'

gem 'oj' # Faster JSON

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
  gem 'capistrano-rails'
  gem 'rvm1-capistrano3', require: false
end

group :production do
  gem 'exception_notification'
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
