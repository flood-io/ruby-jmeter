$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ruby-jmeter'

module RubyJmeter
  class ExtendedDSL < DSL
    def test_method_here
      puts "here be dragons"
    end
  end
end


test do
  threads count: 1 do
    test_fragment name: 'RegisterResponseToSentMail', enabled: 'false' do
      test_method_here
    end
  end
end.run(path: '/usr/local/share/jmeter-3.1/bin/', gui: true)
