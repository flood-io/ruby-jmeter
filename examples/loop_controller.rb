$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    loops count:10 do
      visit name: 'Home Page', url: 'https://flooded.io/'
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
