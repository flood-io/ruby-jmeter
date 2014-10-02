$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  csv_data_set_config filename: 'demo.csv',
    variableNames: 'fruit'

  threads count: 1 do
    visit name: 'Home Page', url: 'http://127.0.0.1/?fruit=${fruit}'
  end
end.flood('fyxequ4bsLhjgvGqQnD1', {
  name: 'Fruity demo with additional CSV',
  region: 'us-west-2',
  endpoint: 'dev.api.flood.io:8000',
  files: ["#{Dir.pwd}/examples/demo.csv"]
})
