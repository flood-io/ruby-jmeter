module RubyJmeter
  class DSL
    def debug_sampler(params={}, &block)
      node = RubyJmeter::DebugSampler.new(params)
      attach_node(node, &block)
    end
  end

  class DebugSampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'DebugSampler'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<DebugSampler guiclass="TestBeanGUI" testclass="DebugSampler" testname="#{params[:name]}" enabled="true">
  <boolProp name="displayJMeterProperties">false</boolProp>
  <boolProp name="displayJMeterVariables">true</boolProp>
  <boolProp name="displaySystemProperties">false</boolProp>
</DebugSampler>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
