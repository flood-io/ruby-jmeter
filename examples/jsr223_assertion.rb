$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit 'https://flood.io/d384673f64e3a3/result.json' do
      jsr223_assertion update_at_xpath: [
        { "//stringProp[@name='script']" => 'var foo = "cat";' },
        { "//stringProp[@name='scriptLanguage']" => 'javascript' }
      ]
     end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
