$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit name: 'Home', url: 'https://flooded.io' do
      regex pattern: "content='(.+?)' name='csrf-token'", name: 'csrf-token', match_number: 1, default: '424242'
      regex pattern: 'pattern', name: 'jmeter_variable_regex', variable: 'test'
      regex pattern: 'pattern', name: 'jmeter_headers_regex', useHeaders: true
    end
  end
end.run(path: '/usr/local/share/jmeter-3.1/bin/', gui: true)
