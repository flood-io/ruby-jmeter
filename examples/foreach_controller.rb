$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

test do
  threads 1, {
                rampup: 1,
                scheduler: true,
                duration: 60,
                continue_forever: true
              } do

    defaults  domain: 'altentee.com'

    random_timer 1000, 2000

    transaction '01_GET_home' do
      visit '/' do
        extract regex: 'href="(.+?)"', name: 'links', match_number: -1
      end
    end

    foreach_controller inputVal: 'links', returnVal: 'link' do
      transaction '02_GET_random_link' do
        visit '${link}'
      end
    end
  end

end.run(path: '/usr/share/jmeter/bin/', gui: true)
