$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit name: 'Home Page', url: 'http://google.com/'
  end
end.grid('6CnGKgaTRU62LspdTFbr', {region: 'us-west-2', endpoint: '127.0.0.1:3000'})
