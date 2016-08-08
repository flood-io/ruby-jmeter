$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 100, rampup: 3600, loops: 10, scheduler: false do
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
