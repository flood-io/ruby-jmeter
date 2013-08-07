$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit name: 'Home Page', url: 'http://google.com/'
  end
end.flood('qCL6dv7qzqeBB7LYSR2x', {
  name: 'Demo using flood.io',
  region: 'us-west-2', 
  endpoint: 'dev.api.flood.io:3000'
})
