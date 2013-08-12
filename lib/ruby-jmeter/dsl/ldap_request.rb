module RubyJmeter
  class DSL
    def ldap_request(params={}, &block)
      node = RubyJmeter::LdapRequest.new(params)
      attach_node(node, &block)
    end
  end

  class LdapRequest
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'LdapRequest' : (params[:name] || 'LdapRequest')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<LDAPSampler guiclass="LdapTestSamplerGui" testclass="LDAPSampler" testname="#{testname}" enabled="true">
  <stringProp name="servername"/>
  <stringProp name="port"/>
  <stringProp name="rootdn"/>
  <boolProp name="user_defined">false</boolProp>
  <stringProp name="test">add</stringProp>
  <stringProp name="base_entry_dn"/>
  <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="ConfigTestElement.username"/>
  <stringProp name="ConfigTestElement.password"/>
</LDAPSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
