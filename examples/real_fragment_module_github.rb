$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

# This example shows how to assemble test scenarios as sequences of reusable steps.

test do

  fragment name: 'Fragment: Home Page' do
    visit name: 'home page', url: 'https://github.com'
  end

  fragment name: 'Fragment: Project Search' do
    visit name: 'search for project', url: 'https://github.com/search?q=ruby-jmeter&ref=cmdform'
  end

  fragment name: 'Fragment: Project Page' do
    visit name: 'project page', url: 'https://github.com/flood-io/ruby-jmeter'
  end

  threads 1, name: 'Search for project' do
    transaction name: 'Search for project' do
      think_time 10, 3
      module_controller name: 'visit home page', node_path: [ 'WorkBench', 'TestPlan', 'Fragment: Home Page' ]
      module_controller name: 'search for project', node_path: [ 'WorkBench', 'TestPlan', 'Fragment: Project Search' ]
      module_controller name: 'visit project page', node_path: [ 'WorkBench', 'TestPlan', 'Fragment: Project Page' ]
    end
  end

  threads 1, name: 'Go directly to project' do
    transaction name: 'Direct project page' do
      think_time 10, 3
      module_controller name: 'visit project page', node_path: [ 'WorkBench', 'TestPlan', 'Fragment: Project Page' ]
    end

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)

