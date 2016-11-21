$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 10 do
    post name: 'Oauth Token', url: 'https://flooded.io/api/oauth?username=Michael&authType=token'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
