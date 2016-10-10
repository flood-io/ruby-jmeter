$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit name: 'Home Page', url: 'https://flooded.io/'

    # write errors to a simple data writer with the log alias
    log filename: '/var/log/flood/custom.log', error_logging: true
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
