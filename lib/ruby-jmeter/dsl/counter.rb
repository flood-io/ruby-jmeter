module RubyJmeter
  class DSL
    def counter(params={}, &block)
      node = RubyJmeter::Counter.new(params)
      attach_node(node, &block)
    end
  end

  class Counter
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'Counter' : (params[:name] || 'Counter')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CounterConfig guiclass="CounterConfigGui" testclass="CounterConfig" testname="#{testname}" enabled="true">
  <stringProp name="CounterConfig.start"/>
  <stringProp name="CounterConfig.end"/>
  <stringProp name="CounterConfig.incr"/>
  <stringProp name="CounterConfig.name"/>
  <stringProp name="CounterConfig.format"/>
  <boolProp name="CounterConfig.per_user">true</boolProp>
  <boolProp name="CounterConfig.reset_on_tg_iteration">true</boolProp>
</CounterConfig>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
