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
      params[:name] ||= 'SimpleController'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<GenericController guiclass="LogicControllerGui" testclass="GenericController" testname="#{params[:name]}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
