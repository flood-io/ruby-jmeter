module RubyJmeter
  class DSL
    def soapxmlrpc_request(params={}, &block)
      node = RubyJmeter::SoapxmlrpcRequest.new(params)
      attach_node(node, &block)
    end
  end

  class SoapxmlrpcRequest
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'SoapxmlrpcRequest' : (params[:name] || 'SoapxmlrpcRequest')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SoapSampler guiclass="SoapSamplerGui" testclass="SoapSampler" testname="#{testname}" enabled="true">
  <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="SoapSampler.URL_DATA"/>
  <stringProp name="HTTPSamper.xml_data"/>
  <stringProp name="SoapSampler.xml_data_file"/>
  <stringProp name="SoapSampler.SOAP_ACTION"/>
  <stringProp name="SoapSampler.SEND_SOAP_ACTION">true</stringProp>
  <boolProp name="HTTPSampler.use_keepalive">false</boolProp>
</SoapSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
