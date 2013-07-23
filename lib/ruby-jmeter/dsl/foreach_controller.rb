module RubyJmeter
  class DSL
    def foreach_controller(params={}, &block)
      node = RubyJmeter::ForeachController.new(params)
      attach_node(node, &block)
    end
  end

  class ForeachController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'ForeachController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ForeachController guiclass="ForeachControlPanel" testclass="ForeachController" testname="#{params[:name]}" enabled="true">
  <stringProp name="ForeachController.inputVal"/>
  <stringProp name="ForeachController.returnVal"/>
  <boolProp name="ForeachController.useSeparator">true</boolProp>
  <stringProp name="ForeachController.endIndex"/>
  <stringProp name="ForeachController.startIndex"/>
</ForeachController>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
