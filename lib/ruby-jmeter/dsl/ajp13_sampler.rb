module RubyJmeter
  class DSL
    def ajp13_sampler(params={}, &block)
      node = RubyJmeter::Ajp13Sampler.new(params)
      attach_node(node, &block)
    end
  end

  class Ajp13Sampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'Ajp13Sampler' : (params[:name] || 'Ajp13Sampler')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AjpSampler guiclass="AjpSamplerGui" testclass="AjpSampler" testname="#{testname}" enabled="true">
  <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="HTTPSampler.domain"/>
  <stringProp name="HTTPSampler.port"/>
  <stringProp name="HTTPSampler.connect_timeout"/>
  <stringProp name="HTTPSampler.response_timeout"/>
  <stringProp name="HTTPSampler.protocol"/>
  <stringProp name="HTTPSampler.contentEncoding"/>
  <stringProp name="HTTPSampler.path"/>
  <stringProp name="HTTPSampler.method">GET</stringProp>
  <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
  <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
  <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
  <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
  <boolProp name="HTTPSampler.monitor">false</boolProp>
  <stringProp name="HTTPSampler.embedded_url_re"/>
</AjpSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
