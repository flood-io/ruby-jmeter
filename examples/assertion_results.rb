$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit name: 'Home Page', url: 'http://altentee.com/' do
      duration_assertion duration: 10
    end

    # write to an assertion results listener, errors only
    assertion_results filename: '/var/log/flood/custom/assertion.log',
      error_logging: true,
      update_at_xpath: [
        { '//xml' => 'true' },
        { '//assertions' => 'true' }
      ]
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
