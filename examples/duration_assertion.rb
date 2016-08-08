$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 10 do
    visit name: 'Google Search', url: 'http://google.com/?hl=en&tbo=d&sclient=psy-ab&q=flood.io&oq=flood.io' do
      duration_assertion duration: 1000
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
