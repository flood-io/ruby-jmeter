$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do

  defaults domain: 'example.com'

  with_user_agent :chrome

  header [
    { name: 'Accept-Encoding', value: 'gzip,deflate,sdch' },
    { name: 'Accept', value: 'text/javascript, text/html, application/xml, text/xml, */*' }
  ]

  teardown  name: 'teardown thread group example',
        count: 1,
        rampup: 1,
        loops: 5,
        duration: 5 do

    get name: 'home', url: '/'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
