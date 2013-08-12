module RubyJmeter
  class DSL
    def beanshell_preprocessor(params={}, &block)
      node = RubyJmeter::BeanshellPreprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class BeanshellPreprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'BeanshellPreprocessor' : (params[:name] || 'BeanshellPreprocessor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellPreProcessor guiclass="TestBeanGUI" testclass="BeanShellPreProcessor" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellPreProcessor>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
