$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  cookies clear_each_iteration: false
  threads count: 5, rampup: 10 do
    transaction name: 'Google Search' do
      visit name: 'Home Page', url: 'http://google.com/'
    end
  end

  #
  # You need jmeter-plugins at Google code
  #   http://code.google.com/p/jmeter-plugins
  #
  response_times_percentiles 'Response Times Percentiles',
                             { :filename => 'filename_example.xml' }
end.run(path: '/usr/share/jmeter-2.13/bin/', gui: false)
