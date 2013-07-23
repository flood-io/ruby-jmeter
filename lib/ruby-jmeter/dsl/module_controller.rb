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
      params[:name] ||= 'ModuleController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ModuleController guiclass="ModuleControllerGui" testclass="ModuleController" testname="#{params[:name]}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
