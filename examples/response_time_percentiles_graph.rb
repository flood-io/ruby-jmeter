$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 100 do
    response_times_percentiles 'Response Times Percentiles', filename: '/path/to/output', update_at_xpath: [
      { '//value/xml' => 'false' }
    ]

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
