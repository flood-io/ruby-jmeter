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
      params[:name] ||= 'ConstantThroughputTimer'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConstantThroughputTimer guiclass="TestBeanGUI" testclass="ConstantThroughputTimer" testname="#{params[:name]}" enabled="true">
  <stringProp name="calcMode">this thread only</stringProp>
  <doubleProp>
    <name>throughput</name>
    <value>0.0</value>
    <savedValue>0.0</savedValue>
  </doubleProp>
</ConstantThroughputTimer>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
