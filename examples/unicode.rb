$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit 'https://flood.io/?unicode=åß∂˙∆¬¬'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
