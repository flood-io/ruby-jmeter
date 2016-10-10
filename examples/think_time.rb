$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 100 do

    think_time 5000, 5000

    transaction name: 'Google Search' do
      visit name: 'Home Page', url: 'https://flooded.io/'
      random_timer 3000
    end

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
