module RubyJmeter
  class DSL
    def thread_group(params={}, &block)
      node = RubyJmeter::ThreadGroup.new(params)
      attach_node(node, &block)
    end
  end

  class ThreadGroup
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'ThreadGroup' : (params[:name] || 'ThreadGroup')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="#{testname}" enabled="true">
  <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
  <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="#{testname}" enabled="true">
    <boolProp name="LoopController.continue_forever">false</boolProp>
    <intProp name="LoopController.loops">-1</intProp>
  </elementProp>
  <stringProp name="ThreadGroup.num_threads">1</stringProp>
  <stringProp name="ThreadGroup.ramp_time">1</stringProp>
  <longProp name="ThreadGroup.start_time">1366415241000</longProp>
  <longProp name="ThreadGroup.end_time">1366415241000</longProp>
  <boolProp name="ThreadGroup.scheduler">true</boolProp>
  <stringProp name="ThreadGroup.duration"/>
  <stringProp name="ThreadGroup.delay"/>
  <boolProp name="ThreadGroup.delayedStart">true</boolProp>
</ThreadGroup>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
