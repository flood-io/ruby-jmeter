$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  auth url: '/', username: 'tim', password: 'secret', domain: 'altentee.com'
  threads count: 1 do
    transaction name: 'Google Search' do
      visit name: 'Home Page', url: 'http://google.com/'
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
