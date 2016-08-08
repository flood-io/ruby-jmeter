$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit 'https://flood.io/d384673f64e3a3/result.json' do
      extract json: '.apdex.score', name: 'apdex'
     end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
