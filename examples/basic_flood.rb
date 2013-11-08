$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 20 do
    visit name: 'Home Page', url: 'http://google.com/'
  end
end.flood('sd9XyrxN5yTcp1CsXU2f', {
  name: 'Demo using flood.io',
  region: 'us-west-2',
  endpoint: 'dev.api.flood.io:3000'
})
