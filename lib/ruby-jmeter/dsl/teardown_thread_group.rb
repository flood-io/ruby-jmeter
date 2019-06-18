module RubyJmeter
  class DSL
    def teardown_thread_group(params={}, &block)
      node = RubyJmeter::TeardownThreadGroup.new(params)
      attach_node(node, &block)
    end
  end

  class TeardownThreadGroup
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'TeardownThreadGroup' : (params[:name] || 'TeardownThreadGroup')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<PostThreadGroup guiclass="PostThreadGroupGui" testclass="PostThreadGroup" testname="#{testname}" enabled="true">
  <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
  <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="#{testname}" enabled="true">
    <boolProp name="LoopController.continue_forever">false</boolProp>
    <stringProp name="LoopController.loops">-1</stringProp>
  </elementProp>
  <stringProp name="ThreadGroup.num_threads">1</stringProp>
  <stringProp name="ThreadGroup.ramp_time">1</stringProp>
  <longProp name="ThreadGroup.start_time">1442954623000</longProp>
  <longProp name="ThreadGroup.end_time">1442954623000</longProp>
  <boolProp name="ThreadGroup.scheduler">true</boolProp>
  <stringProp name="ThreadGroup.duration"></stringProp>
  <stringProp name="ThreadGroup.delay"></stringProp>
</PostThreadGroup>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
