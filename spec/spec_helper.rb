require 'rubygems'
require 'rspec'

test_dir = File.dirname(__FILE__)
$LOAD_PATH.unshift test_dir unless $LOAD_PATH.include?(test_dir)

lib_dir = File.join(File.dirname(test_dir), 'lib')
$LOAD_PATH.unshift lib_dir unless $LOAD_PATH.include?(lib_dir)

require 'ruby-jmeter'
