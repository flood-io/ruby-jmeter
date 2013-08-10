require 'ruby-jmeter'

test do
  threads 10 do
    visit name: 'Home Page', url: 'http://google.com/'
  end
end.flood(ENV['FLOOD_API_TOKEN'], {region: 'us-west-2'})
