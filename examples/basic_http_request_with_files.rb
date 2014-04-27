$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads do
    transaction name: "TC_03", parent: true, include_timers: true do
      submit url: "/", fill_in: { username: 'tim', password: 'password' },
             files: [{path: '/tmp/foo', paramname: 'fileup', mimetype: 'text/plain'},
                     {path: '/tmp/bar', paramname: 'otherfileup'}]
    end
  end
end
