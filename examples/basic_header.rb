$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  header name: 'Accept', value: '*'

  with_user_agent :iphone

  threads count: 1 do
    visit name: 'Home Page', url: 'http://google.com/'
  end

  transaction name: 'Google Search via XHR' do
    visit name: 'Home Page', url: 'http://google.com/' do
      with_xhr
    end
  end
  
end.run(path: '/usr/share/jmeter/bin/', gui: true)
