module RubyJmeter
  class DSL
    def jms_pointtopoint(params={}, &block)
      node = RubyJmeter::JmsPointtopoint.new(params)
      attach_node(node, &block)
    end
  end

  class JmsPointtopoint
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'JmsPointtopoint'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JMSSampler guiclass="JMSSamplerGui" testclass="JMSSampler" testname="#{params[:name]}" enabled="true">
  <stringProp name="JMSSampler.queueconnectionfactory"/>
  <stringProp name="JMSSampler.SendQueue"/>
  <stringProp name="JMSSampler.ReceiveQueue"/>
  <boolProp name="JMSSampler.isFireAndForget">true</boolProp>
  <boolProp name="JMSSampler.isNonPersistent">false</boolProp>
  <boolProp name="JMSSampler.useReqMsgIdAsCorrelId">false</boolProp>
  <stringProp name="JMSSampler.timeout"/>
  <stringProp name="HTTPSamper.xml_data"/>
  <stringProp name="JMSSampler.initialContextFactory"/>
  <stringProp name="JMSSampler.contextProviderUrl"/>
  <elementProp name="JMSSampler.jndiProperties" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{params[:name]}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <elementProp name="arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{params[:name]}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
</JMSSampler>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
