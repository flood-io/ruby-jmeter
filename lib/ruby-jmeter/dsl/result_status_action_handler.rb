module RubyJmeter
  class DSL
    def result_status_action_handler(params={}, &block)
      node = RubyJmeter::ResultStatusActionHandler.new(params)
      attach_node(node, &block)
    end
  end

  class ResultStatusActionHandler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'ResultStatusActionHandler'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ResultAction guiclass="ResultActionGui" testclass="ResultAction" testname="#{params[:name]}" enabled="true">
  <intProp name="OnError.action">0</intProp>
</ResultAction>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
