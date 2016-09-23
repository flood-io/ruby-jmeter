module RubyJmeter
  module Plugins
    class ActiveThreadsOverTime
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'ActiveThreadsOverTime' : (params[:name] || 'ActiveThreadsOverTime')
        @doc = Nokogiri::XML(<<-XML.strip_heredoc)
          <kg.apc.jmeter.vizualizers.CorrectedResultCollector guiclass="kg.apc.jmeter.vizualizers.ThreadsStateOverTimeGui" testclass="kg.apc.jmeter.vizualizers.CorrectedResultCollector" testname="#{testname}" enabled="true">
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
            <stringProp name="filename"></stringProp>
            <longProp name="interval_grouping">500</longProp>
            <boolProp name="graph_aggregated">false</boolProp>
            <stringProp name="include_sample_labels"></stringProp>
            <stringProp name="exclude_sample_labels"></stringProp>
            <stringProp name="start_offset"></stringProp>
            <stringProp name="end_offset"></stringProp>
            <boolProp name="include_checkbox_state">false</boolProp>
            <boolProp name="exclude_checkbox_state">false</boolProp>
          </kg.apc.jmeter.vizualizers.CorrectedResultCollector>
        XML
        update params
      end
    end
  end
end


