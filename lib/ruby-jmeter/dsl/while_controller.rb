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
      params[:name] ||= 'WhileController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<WhileController guiclass="WhileControllerGui" testclass="WhileController" testname="#{params[:name]}" enabled="true">
  <stringProp name="WhileController.condition"/>
</WhileController>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
