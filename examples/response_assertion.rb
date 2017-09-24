$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 2 do
    transaction name: 'Assertions' do
      visit name: 'Altentee', url: 'http://altentee.com/' do
        assert contains: 'We test, tune and secure your site'
        assert 'not-contains' => 'Something in frames', scope: 'children'
        assert 'substring' => 'Something in frames', variable: 'test'
        assert pattern: 'pattern', test_field: 'Assertion.response_headers'
      end
    end
  end
end.run(path: '/usr/local/share/jmeter-3.1/bin/', gui: true)
