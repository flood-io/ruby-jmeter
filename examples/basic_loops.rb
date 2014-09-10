$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    Loop count:10 do
      visit name: 'Home Page', url: 'http://google.com/'
    end
  end
end.run(path: '/usr/share/jmeter-2.11/bin/', gui: true)
