require 'nokogiri'
require 'rest_client'
require 'json'
require 'cgi'
require 'open3'

require 'ruby-jmeter/version'

lib = File.dirname(File.absolute_path(__FILE__))

Dir.glob(lib + '/ruby-jmeter/helpers/*').each do |file|
  require file
end

Dir.glob(lib + '/ruby-jmeter/dsl/*').each do |file|
  require file
end

Dir.glob(lib + '/ruby-jmeter/extensions/*').each do |file|
  require file
end

Dir.glob(lib + '/ruby-jmeter/plugins/*').each do |file|
  require file
end

require 'ruby-jmeter/dsl'
