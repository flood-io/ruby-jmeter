module RubyJmeter
  class DSL
    def mailer_visualizer(params={}, &block)
      node = RubyJmeter::MailerVisualizer.new(params)
      attach_node(node, &block)
    end
  end

  class MailerVisualizer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'MailerVisualizer' : (params[:name] || 'MailerVisualizer')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<MailerResultCollector guiclass="MailerVisualizer" testclass="MailerResultCollector" testname="#{testname}" enabled="true">
  <boolProp name="ResultCollector.error_logging">false</boolProp>
  <objProp>
    <name>saveConfig</name>
    <value class="SampleSaveConfiguration">
      <time>true</time>
      <latency>true</latency>
      <timestamp>true</timestamp>
      <success>true</success>
      <label>true</label>
      <code>true</code>
      <message>false</message>
      <threadName>true</threadName>
      <dataType>false</dataType>
      <encoding>false</encoding>
      <assertions>false</assertions>
      <subresults>false</subresults>
      <responseData>false</responseData>
      <samplerData>false</samplerData>
      <xml>false</xml>
      <fieldNames>false</fieldNames>
      <responseHeaders>false</responseHeaders>
      <requestHeaders>false</requestHeaders>
      <responseDataOnError>false</responseDataOnError>
      <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
      <assertionsResultsToSave>0</assertionsResultsToSave>
      <bytes>true</bytes>
      <threadCounts>true</threadCounts>
      <sampleCount>true</sampleCount>
    </value>
  </objProp>
  <elementProp name="MailerResultCollector.mailer_model" elementType="MailerModel">
    <stringProp name="MailerModel.successLimit">2</stringProp>
    <stringProp name="MailerModel.failureLimit">2</stringProp>
    <stringProp name="MailerModel.failureSubject"/>
    <stringProp name="MailerModel.fromAddress"/>
    <stringProp name="MailerModel.smtpHost"/>
    <stringProp name="MailerModel.successSubject"/>
    <stringProp name="MailerModel.addressie"/>
  </elementProp>
  <stringProp name="filename"/>
</MailerResultCollector>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
