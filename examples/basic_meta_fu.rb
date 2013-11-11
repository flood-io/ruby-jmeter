$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

class Test
  def initialize options = {}
    @users    = options[:users]
    @ramp     = options[:ramp]
    @duration = options[:duration]
    @region   = options[:region] || 'ap-southeast-2'
    @name     = options[:name]
  end

  def flood domain
    @domain = domain
    test_plan.grid ENV['FLOOD_IO_KEY'], region: @region, name: @name
  end

  def jmeter domain
    @domain = domain
    test_plan.run path: '/usr/share/jmeter/bin/', gui:true
  end

  def test_plan
    test do
      grab_dsl self
      defaults domain: @domain,
        protocol: 'http',
        image_parser: true,
        concurrentDwn: true,
        concurrentPool: 4

      cookies

      plan
    end
  end

  def plan
    threads @users, {ramp_time: @ramp, duration: @duration, scheduler: true, continue_forever: true} do
      random_timer 5000, 10000

      transaction '01_GET_home_page' do
        visit '/'
      end
    end
  end

  def grab_dsl dsl
    @dsl = dsl
  end

  def method_missing method, *args, &block
    @dsl.__send__ method, *args, &block
  end
end

test = Test.new users:10, ramp: 30, duration: 30, name: 'Test Number 1'

# test locally with JMeter
test.jmeter 'google.com'

# test distributed with flood
# test.flood 'google.com'