$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do

  defaults domain: 'example.com'

  with_user_agent :chrome

  header [
    { name: 'Accept-Encoding', value: 'gzip,deflate,sdch' },
    { name: 'Accept', value: 'text/javascript, text/html, application/xml, text/xml, */*' }
  ]

  ultimate  name: 'ultimate thread group example',
            on_sample_error: 'startnextloop',
            threads: [
              {
                start_threads: 200,
                initial_delay: 0,
                start_time: 30,
                hold_time: 60,
                stop_time: 5
              },
              {
                start_threads: 200,
                initial_delay: 60,
                start_time: 30,
                hold_time: 60,
                stop_time: 5
              }
          ] do

    random_timer 1000, 3000

    get name: 'home', url: '/'

  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
