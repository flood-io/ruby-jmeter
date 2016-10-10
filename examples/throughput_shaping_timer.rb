$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 100 do # threads = RPS * <max response time ms> / 1000

    throughput_shaper name: 'increasing load test', steps: [
      { :start_rps => 100, :end_rps => 100, :duration => 60 },
      { :start_rps => 200, :end_rps => 200, :duration => 60 },
      { :start_rps => 300, :end_rps => 300, :duration => 60 },
      { :start_rps => 400, :end_rps => 400, :duration => 60 },
      { :start_rps => 500, :end_rps => 500, :duration => 60 },
      { :start_rps => 600, :end_rps => 600, :duration => 60 }
    ]

    transaction name: 'Google Search' do
      visit name: 'Home Page', url: 'https://flooded.io/'
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
