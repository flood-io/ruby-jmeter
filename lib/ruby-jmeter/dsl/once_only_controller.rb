module RubyJmeter
  class DSL
    def once_only_controller(params={}, &block)
      node = RubyJmeter::OnceOnlyController.new(params)
      attach_node(node, &block)
    end
  end

  class OnceOnlyController
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'OnceOnlyController' : (params[:name] || 'OnceOnlyController')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<OnceOnlyController guiclass="OnceOnlyControllerGui" testclass="OnceOnlyController" testname="#{testname}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
