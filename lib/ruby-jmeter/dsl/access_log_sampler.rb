module RubyJmeter
  class DSL
    def access_log_sampler(params={}, &block)
      node = RubyJmeter::AccessLogSampler.new(params)
      attach_node(node, &block)
    end
  end

  class AccessLogSampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'AccessLogSampler' : (params[:name] || 'AccessLogSampler')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<AccessLogSampler guiclass="TestBeanGUI" testclass="AccessLogSampler" testname="#{testname}" enabled="true">
  <elementProp name="HTTPsampler.Arguments" elementType="Arguments">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="domain"/>
  <boolProp name="imageParsing">false</boolProp>
  <stringProp name="logFile"/>
  <stringProp name="parserClassName">org.apache.jmeter.protocol.http.util.accesslog.TCLogParser</stringProp>
  <stringProp name="portString"/>
</AccessLogSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
