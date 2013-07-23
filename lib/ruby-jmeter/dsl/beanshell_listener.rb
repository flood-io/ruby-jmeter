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
      params[:name] ||= 'BeanshellListener'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellListener guiclass="TestBeanGUI" testclass="BeanShellListener" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellListener>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
