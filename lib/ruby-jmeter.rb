require 'nokogiri'
require 'rest_client'
require 'json'
require 'cgi'
require 'open3'

require 'ruby-jmeter/version'
require 'ruby-jmeter/aliases'
require 'ruby-jmeter/api'
require 'ruby-jmeter/helpers/helper'
require 'ruby-jmeter/helpers/parser'
require 'ruby-jmeter/helpers/fallback_content_proxy'
require 'ruby-jmeter/helpers/logger-colors'
require 'ruby-jmeter/helpers/strip-heredoc'
require 'ruby-jmeter/helpers/user-agents'

lib = File.dirname(File.absolute_path(__FILE__))

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
