module RubyJmeter
  class DSL
    def xpath_assertion(params={}, &block)
      node = RubyJmeter::XpathAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class XpathAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'XpathAssertion' : (params[:name] || 'XpathAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XPathAssertion guiclass="XPathAssertionGui" testclass="XPathAssertion" testname="#{testname}" enabled="true">
  <boolProp name="XPath.negate">false</boolProp>
  <stringProp name="XPath.xpath">/</stringProp>
  <boolProp name="XPath.validate">false</boolProp>
  <boolProp name="XPath.whitespace">false</boolProp>
  <boolProp name="XPath.tolerant">false</boolProp>
  <boolProp name="XPath.namespace">false</boolProp>
  <stringProp name="Assertion.scope">all</stringProp>
</XPathAssertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
