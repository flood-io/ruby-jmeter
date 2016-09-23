$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do

  defaults domain: 'example.com'

  with_user_agent :chrome

  header [
    { name: 'Accept-Encoding', value: 'gzip,deflate,sdch' },
    { name: 'Accept', value: 'text/javascript, text/html, application/xml, text/xml, */*' }
  ]

  step  name: 'stepping thread group example',
        total_threads: 200,
        initial_delay: 0,
        start_threads: 20,
        add_threads: 0,
        start_every: 30,
        stop_threads: 50,
        stop_every: 5,
        flight_time: 1800,
        rampup: 5 do

    random_timer 1000, 3000

    get name: 'home', url: '/'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
