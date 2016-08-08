$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  defaults domain: 'example.com',
      protocol: 'https',
      download_resources: true,
      use_concurrent_pool: 5,
      urls_must_match: 'http.+?example.com',
      md5: true
end.run(path: '/usr/share/jmeter/bin/', gui: true)
