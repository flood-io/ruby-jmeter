module RubyJmeter
  class DSL
    def if_controller(params={}, &block)
      node = RubyJmeter::IfController.new(params)
      attach_node(node, &block)
    end
  end

  class IfController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'IfController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<IfController guiclass="IfControllerPanel" testclass="IfController" testname="#{params[:name]}" enabled="true">
  <stringProp name="IfController.condition"/>
  <boolProp name="IfController.evaluateAll">false</boolProp>
  <boolProp name="IfController.useExpression">false</boolProp>
</IfController>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
