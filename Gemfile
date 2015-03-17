source 'http://rubygems.org'

# Specify your gem's dependencies in ruby-jmeter.gemspec
gemspec

gem 'nokogiri'
gem 'rest-client'
gem 'json'

platforms :jruby do
  gem 'json-jruby'
end

group :development do
  gem 'pry', :require => 'pry'
end

group :test do
  gem 'rake'
  gem 'rspec'
  gem 'sinatra'
  gem 'haml'
end
