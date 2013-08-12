module RubyJmeter
  class DSL
    def simple_controller(params={}, &block)
      node = RubyJmeter::SimpleController.new(params)
      attach_node(node, &block)
    end
  end

  class SimpleController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'SimpleController' : (params[:name] || 'SimpleController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<GenericController guiclass="LogicControllerGui" testclass="GenericController" testname="#{testname}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
