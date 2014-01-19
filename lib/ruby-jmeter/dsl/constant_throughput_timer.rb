module RubyJmeter
  class DSL
    def constant_throughput_timer(params={}, &block)
      node = RubyJmeter::ConstantThroughputTimer.new(params)
      attach_node(node, &block)
    end
  end

  class ConstantThroughputTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'ConstantThroughputTimer' : (params[:name] || 'ConstantThroughputTimer')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConstantThroughputTimer guiclass="TestBeanGUI" testclass="ConstantThroughputTimer" testname="#{testname}" enabled="true">
  <intProp name="calcMode">0</intProp>
  <doubleProp>
    <name>throughput</name>
    <value>#{params[:throughput] || 0.0}</value>
    <savedValue>0.0</savedValue>
  </doubleProp>
</ConstantThroughputTimer>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
