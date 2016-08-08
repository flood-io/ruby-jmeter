$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do

  test_fragment name: 'anonymous_user', enabled: false do
    get name: 'Home Page', url: 'http://google.com'
  end

  threads count: 1 do
    module_controller test_fragment: 'WorkBench/TestPlan/anonymous_user'
  end

end.run(path: '/usr/share/jmeter/bin/', gui: true)
