module RubyJmeter
  class DSL
    def include_controller(params={}, &block)
      node = RubyJmeter::IncludeController.new(params)
      attach_node(node, &block)
    end
  end

  class IncludeController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'IncludeController' : (params[:name] || 'IncludeController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<IncludeController guiclass="IncludeControllerGui" testclass="IncludeController" testname="#{testname}" enabled="true">
  <stringProp name="IncludeController.includepath"/>
</IncludeController>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
