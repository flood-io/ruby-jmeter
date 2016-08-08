$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  # Simulate user agent, accept and accept-encodings of typical browsers
  with_browser :ie9
end.run(path: '/usr/share/jmeter/bin/', gui: true)
