module RubyJmeter
  module Plugins
    class SteppingThreadGroup
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'SteppingThreadGroup' : (params[:name] || 'SteppingThreadGroup')
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <kg.apc.jmeter.threads.SteppingThreadGroup guiclass="kg.apc.jmeter.threads.SteppingThreadGroupGui" testclass="kg.apc.jmeter.threads.SteppingThreadGroup" testname="#{testname}" enabled="true">
            <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
            <stringProp name="ThreadGroup.num_threads">#{params[:total_threads]}</stringProp>
            <stringProp name="Threads initial delay">#{params[:initial_delay]}</stringProp>
            <stringProp name="Start users count">#{params[:start_threads]}</stringProp>
            <stringProp name="Start users count burst">#{params[:add_threads]}</stringProp>
            <stringProp name="Start users period">#{params[:start_every]}</stringProp>
            <stringProp name="Stop users count">#{params[:stop_threads]}</stringProp>
            <stringProp name="Stop users period">#{params[:stop_every]}</stringProp>
            <stringProp name="flighttime">#{params[:flight_time]}</stringProp>
            <stringProp name="rampUp">#{params[:rampup]}</stringProp>
            <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
              <boolProp name="LoopController.continue_forever">false</boolProp>
              <intProp name="LoopController.loops">-1</intProp>
            </elementProp>
          </kg.apc.jmeter.threads.SteppingThreadGroup>
        EOF
        update params
      end
    end
  end
end
