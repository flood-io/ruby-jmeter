$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 10, duration: 180, continue_forever: true do
    think_time 5_000
    visit name: 'Google Search', url: 'http://google.com'
  end
end.flood(
  ENV['FLOOD_API_TOKEN'],
  name: 'Demo',
  privacy_flag: 'public',
  grid: 'a3Hf9pIs30DX0pYfitU4AA' # UUID of the target grid
)
