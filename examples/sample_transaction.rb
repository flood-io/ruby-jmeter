$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    # this will let you sample 1 in every N (e.g. 100) transactions on Flood IO
    get name: 'Home Page', sample: 100, url: 'http://google.com/'

    post name: 'create session', url: '/api/oauth', sample: 100,
      fill_in: {
        username: 'Michel Rosen',
        password: 4141414141
      } do
        extract json: '.access_token', name: 'access_token'
      with_xhr
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
