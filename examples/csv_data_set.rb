$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  csv_data_set_config filename: 'postcodes.csv',
    variableNames: 'postcode'

  threads count: 1 do
    visit name: 'Home', url: 'https://flooded.io?query=${postcode}'
  end
end.flood ENV['FLOOD_API_TOKEN'],
  privacy: 'public',
  name: ENV['FLOOD_NAME'] ||= 'Simple Demo',
  project: 'workspace',
  region: ENV['REGION'] ||= 'us-west-2',
  override_parameters: '-Dsun.net.inetaddr.ttl=30',
  files: [
    "#{Dir.pwd}/postcodes.csv"
  ]
