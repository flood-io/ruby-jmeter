$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1, loop: 1 do
    visit 'https://api.github.com/orgs/flood-io/repos' do
      json_path_postprocessor referenceNames: 'name', jsonPathExprs: '.name', match_numbers: 1
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
