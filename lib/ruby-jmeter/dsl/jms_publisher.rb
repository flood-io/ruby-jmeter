module RubyJmeter
  class DSL
    def jms_publisher(params={}, &block)
      node = RubyJmeter::JmsPublisher.new(params)
      attach_node(node, &block)
    end
  end

  class JmsPublisher
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'JmsPublisher' : (params[:name] || 'JmsPublisher')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<PublisherSampler guiclass="JMSPublisherGui" testclass="PublisherSampler" testname="#{testname}" enabled="true">
  <stringProp name="jms.jndi_properties">false</stringProp>
  <stringProp name="jms.initial_context_factory"/>
  <stringProp name="jms.provider_url"/>
  <stringProp name="jms.connection_factory"/>
  <stringProp name="jms.topic"/>
  <stringProp name="jms.security_principle"/>
  <stringProp name="jms.security_credentials"/>
  <stringProp name="jms.text_message"/>
  <stringProp name="jms.input_file"/>
  <stringProp name="jms.random_path"/>
  <stringProp name="jms.config_choice">jms_use_text</stringProp>
  <stringProp name="jms.config_msg_type">jms_text_message</stringProp>
  <stringProp name="jms.iterations">1</stringProp>
  <boolProp name="jms.authenticate">false</boolProp>
  <elementProp name="arguments" elementType="JMSProperties">
    <collectionProp name="JMSProperties.properties"/>
  </elementProp>
  <stringProp name="jms.expiration"/>
  <stringProp name="jms.priority"/>
</PublisherSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
