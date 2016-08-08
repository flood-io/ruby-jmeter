# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-jmeter/version'

Gem::Specification.new do |gem|
  gem.name          = 'ruby-jmeter'
  gem.version       = RubyJmeter::VERSION
  gem.authors       = ['Tim Koopmans']
  gem.email         = ['support@flood.io']
  gem.description   = %q{Ruby based DSL for writing JMeter test plans}
  gem.summary       = %q{Ruby based DSL for writing JMeter test plans}
  gem.homepage      = 'http://flood-io.github.io/ruby-jmeter/'
  gem.add_dependency('rest-client')
  gem.add_dependency('nokogiri')
  gem.add_runtime_dependency('json-jruby') if RUBY_PLATFORM == 'java'

  gem.files         = `git ls-files`.split($/)
  gem.executables   << 'flood'
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.require_paths = ['lib']

  gem.license       = 'MIT'
end
