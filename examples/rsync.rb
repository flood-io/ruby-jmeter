$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads count: 10 do
    visit name: 'Home Page', url: 'https://flooded.io'
  end
end.rsync(
  remote_host: 'xxx.xxx.xxx.xxx',
  remote_user: 'user',
  remote_path: '/path/to/remote',
  rsync_bin_path: '/usr/bin/rsync',
  rsync_params: '-az -e "ssh -i /path/to/key.pem"',
  file: './jmx/' + File.basename(__FILE__, ".rb") + '.jmx',
  debug: true
)
