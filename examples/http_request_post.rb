$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    transaction name: 'Post with a Raw Body', parent: false do
      post name: 'Home Page', url: 'http://google.com',
        raw_body: '{"name":"Big Poncho","price":10,"vendor_attendance_id":24,"product_id":1}'
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
