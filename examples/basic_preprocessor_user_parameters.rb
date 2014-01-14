$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  # user parameters with multiple values
  visit name: 'Home Page', url: 'http://google.com/' do
    user_parameters names: ['name1', 'name2'],
      thread_values: {
        user_1: [
          'value1',
          'value2'
        ],

        user_2: [
          'value1',
          'value2'
        ]
      }
  end
# end.run(path: '/usr/share/jmeter/bin/', gui: true)
end.out
