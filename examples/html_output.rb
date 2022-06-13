$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads duration: 1 do
    visit name: 'HTML Output', url: 'http://google.com/' do
    end
  end
end.run(html_output: 'jmeter_output')
