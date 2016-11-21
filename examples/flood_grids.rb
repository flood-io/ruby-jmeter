$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1 do
    visit name: 'Home', url: 'https://flooded.io'
  end
end.flood ENV['FLOOD_API_TOKEN'],
  privacy: 'public',
  name: ENV['FLOOD_NAME'] ||= 'Simple Demo',
  project: 'Workspace',
  override_parameters: '-Dsun.net.inetaddr.ttl=30',
  grids: [
    {
      infrastructure: 'demand',
      instance_type: 'm4.xlarge',
      instance_quantity: 1,
      region: 'us-west-2',
      stop_after: 60
    }
  ],
  debug: true
