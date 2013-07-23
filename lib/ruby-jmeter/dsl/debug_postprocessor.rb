module RubyJmeter
  class DSL
    def debug_postprocessor(params={}, &block)
      node = RubyJmeter::DebugPostprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class DebugPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'DebugPostprocessor'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<DebugPostProcessor guiclass="TestBeanGUI" testclass="DebugPostProcessor" testname="#{params[:name]}" enabled="true">
  <boolProp name="displayJMeterProperties">false</boolProp>
  <boolProp name="displayJMeterVariables">true</boolProp>
  <boolProp name="displaySamplerProperties">true</boolProp>
  <boolProp name="displaySystemProperties">false</boolProp>
</DebugPostProcessor>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
