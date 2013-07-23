module RubyJmeter
  class DSL
    def ldap_request_defaults(params={}, &block)
      node = RubyJmeter::LdapRequestDefaults.new(params)
      attach_node(node, &block)
    end
  end

  class LdapRequestDefaults
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'LdapRequestDefaults'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="LdapConfigGui" testclass="ConfigTestElement" testname="#{params[:name]}" enabled="true">
  <stringProp name="servername"/>
  <stringProp name="port"/>
  <stringProp name="rootdn"/>
  <boolProp name="user_defined">false</boolProp>
  <stringProp name="test">add</stringProp>
  <stringProp name="base_entry_dn"/>
  <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{params[:name]}" enabled="true">
    <collectionProp name="Arguments.arguments">
      <elementProp name="testguid" elementType="Argument">
        <stringProp name="Argument.name"/>
        <stringProp name="Argument.value"/>
        <stringProp name="Argument.metadata">=</stringProp>
      </elementProp>
    </collectionProp>
    <stringProp name="TestPlan.comments"/>
  </elementProp>
</ConfigTestElement>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
