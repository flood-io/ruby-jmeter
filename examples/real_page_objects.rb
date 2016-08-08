$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

module RubyJmeter
  class ExtendedDSL < DSL
    def test_method_here
      puts "here be dragons"
    end
  end
end

# Define your page objects
class HomePage
  def initialize(dsl)
    @dsl = dsl
  end

  def test_method_unreachable
    puts "I can never be reached from ExtendedDSL"
  end

  def visit
    get name: 'home', url: '/' do
      test_method_here
    end
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
end.run(path: '/usr/share/jmeter/bin/', gui: true)
