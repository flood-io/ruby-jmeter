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
      params[:name] ||= 'IncludeController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<IncludeController guiclass="IncludeControllerGui" testclass="IncludeController" testname="#{params[:name]}" enabled="true">
  <stringProp name="IncludeController.includepath"/>
</IncludeController>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
