$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  fragment name: 'Fragment - Google' do
    visit name: 'Home Page', url: 'http://google.com/'
  end
  threads count: 1 do
    module_controller name: 'google', node_path: [
      'WorkBench', # first entry is always WorkBench
      'TestPlan', # name of the test, default is TestPlan
      'Fragment - Google' # name of the fragment.
    ]
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
