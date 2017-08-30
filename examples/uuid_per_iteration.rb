$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1, loops: 5, scheduler: false do
    # Helper method to generate a single UUID per iteration
    uuid_per_iteration

    dummy_sampler name: '${__threadNum} - ${UUID}'
    dummy_sampler name: '${__threadNum} - ${UUID}'
    dummy_sampler name: '${__threadNum} - ${UUID}'

    view_results
  end
end.run(path: '/usr/local/share/jmeter-3.1/bin', gui: true)
