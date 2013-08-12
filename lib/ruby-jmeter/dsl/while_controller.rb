module RubyJmeter
  class DSL
    def while_controller(params={}, &block)
      node = RubyJmeter::WhileController.new(params)
      attach_node(node, &block)
    end
  end

  class WhileController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'WhileController' : (params[:name] || 'WhileController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<WhileController guiclass="WhileControllerGui" testclass="WhileController" testname="#{testname}" enabled="true">
  <stringProp name="WhileController.condition"/>
</WhileController>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
