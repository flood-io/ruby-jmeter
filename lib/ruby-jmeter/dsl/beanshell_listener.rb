module RubyJmeter
  class DSL
    def beanshell_listener(params={}, &block)
      node = RubyJmeter::BeanshellListener.new(params)
      attach_node(node, &block)
    end
  end

  class BeanshellListener
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'BeanshellListener' : (params[:name] || 'BeanshellListener')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellListener guiclass="TestBeanGUI" testclass="BeanShellListener" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellListener>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
