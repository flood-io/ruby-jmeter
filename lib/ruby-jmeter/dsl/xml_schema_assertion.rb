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
      params[:name] ||= 'XmlSchemaAssertion'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XMLSchemaAssertion guiclass="XMLSchemaAssertionGUI" testclass="XMLSchemaAssertion" testname="#{params[:name]}" enabled="true">
  <stringProp name="xmlschema_assertion_filename"/>
</XMLSchemaAssertion>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
