module RubyJmeter
  class DSL
    def synchronizing_timer(params={}, &block)
      node = RubyJmeter::SynchronizingTimer.new(params)
      attach_node(node, &block)
    end
  end

  class SynchronizingTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'SynchronizingTimer' : (params[:name] || 'SynchronizingTimer')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SyncTimer guiclass="TestBeanGUI" testclass="SyncTimer" testname="#{testname}" enabled="true">
  <intProp name="groupSize">0</intProp>
  <longProp name="timeoutInMs">0</longProp>
</SyncTimer>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
