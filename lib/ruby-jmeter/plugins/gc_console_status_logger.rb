module RubyJmeter

  class GCConsoleStatusLogger
    attr_accessor :doc
    include Helper
    def initialize(name, params={})
      @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
        <kg.apc.jmeter.reporters.ConsoleStatusLogger guiclass="kg.apc.jmeter.reporters.ConsoleStatusLoggerGui" testclass="kg.apc.jmeter.reporters.ConsoleStatusLogger" testname="#{name}" enabled="true"/>
      EOF
      update params
    end
  end  

end
