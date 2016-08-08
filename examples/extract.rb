$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 100 do
    visit name: 'Home', url: 'http://altentee.com' do
      extract regex: "content='(.+?)' name='csrf-token'", name: 'csrf-token', match_number: 1
      extract regex: 'pattern', name: 'jmeter_variable_regex', variable: 'test'
      extract css: 'span#blog', name: 'blog'
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
