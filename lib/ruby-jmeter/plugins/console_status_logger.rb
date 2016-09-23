module RubyJmeter
  module Plugins
    class ConsoleStatusLogger
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'ConsoleStatusLogger' : (params[:name] || 'ConsoleStatusLogger')
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <kg.apc.jmeter.reporters.ConsoleStatusLogger guiclass="kg.apc.jmeter.reporters.ConsoleStatusLoggerGui" testclass="kg.apc.jmeter.reporters.ConsoleStatusLogger" testname="#{testname}" enabled="true"/>
        EOF
        update params
      end
    end
  end
end
