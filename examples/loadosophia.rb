$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do

  # You need to either add the project name and upload token from Loadosophia.org here,
  # or use a property file (-q flag when running jmeter).
  loadosophia('Loadosophia Uploader', {
	project: "${__P(loadosophia.project,DEFAULT)}",
	uploadToken: "${__P(loadosophia.uploadToken,No Token specified)}",
	useOnline: "true",
	title: "HLS Load test ${__time(yyyy-MM-dd HH:mm)}"
  })

  threads count: 1 do
    visit name: 'Home Page', url: 'https://flooded.io/'
  end
end.run(path: '/usr/share/jmeter/bin/', gui: true)
