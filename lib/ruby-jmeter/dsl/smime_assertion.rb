module RubyJmeter
  class DSL
    def smime_assertion(params={}, &block)
      node = RubyJmeter::SmimeAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class SmimeAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'SmimeAssertion'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SMIMEAssertion guiclass="SMIMEAssertionGui" testclass="SMIMEAssertion" testname="#{params[:name]}" enabled="true">
  <boolProp name="SMIMEAssert.verifySignature">false</boolProp>
  <boolProp name="SMIMEAssert.notSigned">false</boolProp>
  <stringProp name="SMIMEAssert.issuerDn"/>
  <stringProp name="SMIMEAssert.signerDn"/>
  <stringProp name="SMIMEAssert.signerSerial"/>
  <stringProp name="SMIMEAssert.signerEmail"/>
  <stringProp name="SMIMEAssert.signerCertFile"/>
  <boolProp name="SMIMEAssert.signerNoCheck">false</boolProp>
  <boolProp name="SMIMEAssert.signerCheckConstraints">false</boolProp>
  <boolProp name="SMIMEAssert.signerCheckByFile">false</boolProp>
  <stringProp name="SMIMEAssert.messagePosition"/>
</SMIMEAssertion>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
