$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  os_process_sampler 'SystemSampler.command' => 'git', command_args: ['push', 'origin', 'master']

end.run(path: '/usr/share/jmeter/bin/', gui: true)
