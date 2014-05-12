$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

# Define your page objects
class HomePage
  def initialize(dsl)
    @dsl = dsl
  end

  def visit
    get name: 'home', url: '/'
  end

  private

  def method_missing method, *args, &block
    @dsl.__send__ method, *args, &block
  end
end

test do
  threads count: 1 do
    # then re-use your page objects in your test plan
    home = HomePage.new(self)
    home.visit
  end
end.run(path: '/usr/share/jmeter-2.11/bin/', gui: true)
