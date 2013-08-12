module RubyJmeter
  class DSL
    def beanshell_assertion(params={}, &block)
      node = RubyJmeter::BeanshellAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class BeanshellAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'BeanshellAssertion' : (params[:name] || 'BeanshellAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellAssertion guiclass="BeanShellAssertionGui" testclass="BeanShellAssertion" testname="#{testname}" enabled="true">
  <stringProp name="BeanShellAssertion.query"/>
  <stringProp name="BeanShellAssertion.filename"/>
  <stringProp name="BeanShellAssertion.parameters"/>
  <boolProp name="BeanShellAssertion.resetInterpreter">false</boolProp>
</BeanShellAssertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
