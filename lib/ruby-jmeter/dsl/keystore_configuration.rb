module RubyJmeter
  class DSL
    def keystore_configuration(params={}, &block)
      node = RubyJmeter::KeystoreConfiguration.new(params)
      attach_node(node, &block)
    end
  end

  class KeystoreConfiguration
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'KeystoreConfiguration' : (params[:name] || 'KeystoreConfiguration')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<KeystoreConfig guiclass="TestBeanGUI" testclass="KeystoreConfig" testname="#{testname}" enabled="true">
  <stringProp name="endIndex"/>
  <stringProp name="preload">True</stringProp>
  <stringProp name="startIndex"/>
  <stringProp name="clientCertAliasVarName"/>
</KeystoreConfig>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
