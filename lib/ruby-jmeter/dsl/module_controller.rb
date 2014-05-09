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
  <collectionProp name="ModuleController.node_path" />
</ModuleController>
      EOS
      node_path = params.kind_of?(Array) ? [] : (params[:node_path] || [])
      node_path.each_with_index do |node_name, index|
        @doc.at_xpath('//collectionProp') <<
        Nokogiri::XML(<<-EOS.strip_heredoc).children
          <stringProp name="node_#{index}">#{node_name}</stringProp>
        EOS
      end
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
