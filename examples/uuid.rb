$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1, loops: 5, scheduler: false do
    uuid

    dummy_sample name: '${__threadNum} - ${UUID}'

    view_results
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
