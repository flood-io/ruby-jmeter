module RubyJmeter
  module Plugins
    class ResponseTimesPercentiles
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'ResponseTimesPercentiles' : (params[:name] || 'ResponseTimesPercentiles')
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <kg.apc.jmeter.vizualizers.CorrectedResultCollector guiclass="kg.apc.jmeter.vizualizers.ResponseTimesPercentilesGui" testclass="kg.apc.jmeter.vizualizers.CorrectedResultCollector" testname="#{testname}" enabled="#{enabled(params)}">
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
                <message>true</message>
                <threadName>true</threadName>
                <dataType>true</dataType>
                <encoding>false</encoding>
                <assertions>true</assertions>
                <subresults>true</subresults>
                <responseData>false</responseData>
                <samplerData>false</samplerData>
                <xml>true</xml>
                <fieldNames>false</fieldNames>
                <responseHeaders>false</responseHeaders>
                <requestHeaders>false</requestHeaders>
                <responseDataOnError>false</responseDataOnError>
                <saveAssertionResultsFailureMessage>false</saveAssertionResultsFailureMessage>
                <assertionsResultsToSave>0</assertionsResultsToSave>
                <bytes>true</bytes>
              </value>
            </objProp>
            <stringProp name="filename"></stringProp>
            <longProp name="interval_grouping">500</longProp>
            <boolProp name="graph_aggregated">false</boolProp>
            <stringProp name="include_sample_labels"></stringProp>
            <stringProp name="exclude_sample_labels"></stringProp>
          </kg.apc.jmeter.vizualizers.CorrectedResultCollector>
        EOF
        update params
        update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
      end
    end
  end
end

