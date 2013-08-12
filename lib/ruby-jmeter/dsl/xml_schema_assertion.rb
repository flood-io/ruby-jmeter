module RubyJmeter
  class DSL
    def xml_schema_assertion(params={}, &block)
      node = RubyJmeter::XmlSchemaAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class XmlSchemaAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'XmlSchemaAssertion' : (params[:name] || 'XmlSchemaAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLSchemaAssertion guiclass="XMLSchemaAssertionGUI" testclass="XMLSchemaAssertion" testname="#{testname}" enabled="true">
  <stringProp name="xmlschema_assertion_filename"/>
</XMLSchemaAssertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
