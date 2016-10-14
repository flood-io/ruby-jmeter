$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 1, loop: 1 do
    visit 'https://api.github.com/orgs/flood-io/repos' do
      assert json: '.name', value: '.*'
      assert json: '.id', value: '\d+'
    end
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
