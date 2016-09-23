module RubyJmeter
  module Plugins
    class UltimateThreadGroup
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'UltimateThreadGroup' : (params[:name] || 'UltimateThreadGroup')
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <kg.apc.jmeter.threads.UltimateThreadGroup guiclass="kg.apc.jmeter.threads.UltimateThreadGroupGui" testclass="kg.apc.jmeter.threads.UltimateThreadGroup" testname="#{testname}" enabled="true">
           <collectionProp name="ultimatethreadgroupdata">
           </collectionProp>
           <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
             <boolProp name="LoopController.continue_forever">false</boolProp>
             <intProp name="LoopController.loops">-1</intProp>
           </elementProp>
           <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
         </kg.apc.jmeter.threads.UltimateThreadGroup>
        EOF
        update params
      end
    end
  end
end
