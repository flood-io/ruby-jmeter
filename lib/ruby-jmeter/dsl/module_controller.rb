module RubyJmeter
  class DSL
    def module_controller(params={}, &block)
      node = RubyJmeter::ModuleController.new(params)
      attach_node(node, &block)
    end
  end

  class ModuleController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'ModuleController' : (params[:name] || 'ModuleController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ModuleController guiclass="ModuleControllerGui" testclass="ModuleController" testname="#{testname}" enabled="true">
  <collectionProp name="ModuleController.node_path"/>
</ModuleController>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
