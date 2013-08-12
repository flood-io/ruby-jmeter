module RubyJmeter
  class DSL
    def simple_config_element(params={}, &block)
      node = RubyJmeter::SimpleConfigElement.new(params)
      attach_node(node, &block)
    end
  end

  class SimpleConfigElement
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'SimpleConfigElement' : (params[:name] || 'SimpleConfigElement')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="SimpleConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true"/>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
