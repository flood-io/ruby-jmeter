require 'ruby-jmeter'

test do
  threads 1 do
    get name: '__testdata', url: 'http://54.252.206.143:8080/SRANDMEMBER/postcodes?type=text' do 
      extract name: 'postcode', regex: '^.+?"(\d+)"'
    end
    visit name: 'Search Post Code', url: 'http://google.com/?q=${postcode}'
  end
# end.flood(ENV['FLOOD_API_TOKEN'], {region: 'us-west-2'})
end.run(path: '/usr/share/jmeter/bin/', gui: true)
