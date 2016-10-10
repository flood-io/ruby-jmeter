$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  cookies clear_each_iteration: false
  threads count: 1 do
    transaction name: 'Home' do
      visit name: 'Home Page', url: 'https://flooded.io/'
    end
  end

  #
  # You need jmeter-plugins at Google code
  #   http://code.google.com/p/jmeter-plugins
  #
  latencies_over_time 'Response Latencies Over Time'
  response_codes_per_second 'Response Codes per Second'
  response_times_distribution 'Response Times Distribution'
  response_times_over_time 'Response Times Over Time'
  response_times_percentiles 'Response Times Percentiles'
  transactions_per_second 'Transactions per Second'
end.run(path: '/usr/share/jmeter/bin/', gui: true)
