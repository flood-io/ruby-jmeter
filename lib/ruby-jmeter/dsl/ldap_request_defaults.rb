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
      testname = params.kind_of?(Array) ? 'LdapRequestDefaults' : (params[:name] || 'LdapRequestDefaults')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="LdapConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
  <stringProp name="servername"/>
  <stringProp name="port"/>
  <stringProp name="rootdn"/>
  <boolProp name="user_defined">true</boolProp>
  <stringProp name="test">add</stringProp>
  <stringProp name="base_entry_dn"/>
  <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
    <collectionProp name="Arguments.arguments">
      <elementProp name=" " elementType="Argument">
        <stringProp name="Argument.name"> </stringProp>
        <stringProp name="Argument.value"> </stringProp>
        <stringProp name="Argument.metadata">=</stringProp>
      </elementProp>
    </collectionProp>
  </elementProp>
</ConfigTestElement>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
