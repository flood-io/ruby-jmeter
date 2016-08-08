$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  # user parameters with multiple values
  visit name: 'Home Page', url: 'http://google.com/' do
    user_parameters names: ['name1', 'name2'],
      thread_values: {
        user_1: [
          'user1_value1',
          'user1_value2'
        ],

        user_2: [
          'user2_value1',
          'user2_value2'
        ]
      },
      per_iteration: true
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
