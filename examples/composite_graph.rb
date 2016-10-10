$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  cookies clear_each_iteration: false
  threads count: 5, rampup: 10 do
    transaction name: 'Home' do
      visit name: 'Home Page', url: 'https://flooded.io/'
    end
  end

  #
  # You need jmeter-plugins at Google code
  #   http://code.google.com/p/jmeter-plugins
  #
  latencies_over_time 'Response Latencies Over Time'
  active_threads 'Active Threads'

  composite 'Composite Graph', [
    {
      graph: 'Response Latencies Over Time',
      metric: 'Home Page'
    },
    {
        graph: 'Active Threads',
        metric: 'Overall Active Threads'
    }
  ]
end.run(path: '/usr/share/jmeter/bin/', gui: true)
