$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  defaults domain: 'example.com', 
      protocol: 'https', 
      image_parser: true,
      implementation: 'HttpClient3.1',
      concurrentDwn: true,
      concurrentPool: 4
end.run(path: '/usr/share/jmeter/bin/', gui: true)
