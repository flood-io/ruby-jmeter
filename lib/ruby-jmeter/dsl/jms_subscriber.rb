module RubyJmeter
  class DSL
    def jms_subscriber(params={}, &block)
      node = RubyJmeter::JmsSubscriber.new(params)
      attach_node(node, &block)
    end
  end

  class JmsSubscriber
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'JmsSubscriber' : (params[:name] || 'JmsSubscriber')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SubscriberSampler guiclass="JMSSubscriberGui" testclass="SubscriberSampler" testname="#{testname}" enabled="true">
  <stringProp name="jms.jndi_properties">false</stringProp>
  <stringProp name="jms.initial_context_factory"/>
  <stringProp name="jms.provider_url"/>
  <stringProp name="jms.connection_factory"/>
  <stringProp name="jms.topic"/>
  <stringProp name="jms.security_principle"/>
  <stringProp name="jms.security_credentials"/>
  <boolProp name="jms.authenticate">false</boolProp>
  <stringProp name="jms.iterations">1</stringProp>
  <stringProp name="jms.read_response">true</stringProp>
  <stringProp name="jms.client_choice">jms_subscriber_receive</stringProp>
</SubscriberSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
