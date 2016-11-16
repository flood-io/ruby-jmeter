$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 100 do
    think_time 5000, 5000

    Once do
      post name: 'Home Page', url: 'https://flooded.io/api/oauth'
    end

    visit name: 'Home Page', url: 'https://flooded.io/'

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
