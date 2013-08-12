module RubyJmeter
  class DSL
    def throughput_controller(params={}, &block)
      node = RubyJmeter::ThroughputController.new(params)
      attach_node(node, &block)
    end
  end

  class ThroughputController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'ThroughputController' : (params[:name] || 'ThroughputController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ThroughputController guiclass="ThroughputControllerGui" testclass="ThroughputController" testname="#{testname}" enabled="true">
  <intProp name="ThroughputController.style">0</intProp>
  <boolProp name="ThroughputController.perThread">false</boolProp>
  <intProp name="ThroughputController.maxThroughput">1</intProp>
  <FloatProperty>
    <name>ThroughputController.percentThroughput</name>
    <value>100.0</value>
    <savedValue>0.0</savedValue>
  </FloatProperty>
</ThroughputController>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
