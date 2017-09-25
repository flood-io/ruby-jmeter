$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  # user parameters with multiple values
  post name: 'oauth', url: 'https://flooded.io/api/oauth',  raw_body: '${token}' do
    user_parameters names: ['token'],
    thread_values: {
      user_1: [
        '<xml>fidget widget</xml>'
      ]
    }

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
end.run(path: '/usr/local/share/jmeter-3.1/bin/', gui: true)
