module RubyJmeter
  module Plugins
    class PerfmonCollector
      attr_accessor :doc
      include Helper
      def initialize(name, params={}, filename="perfMon.jtl", xml=true)
        metricNodes = params.collect do |m|
          "
            <collectionProp name=\"\">
              <stringProp name=\"\">#{m[:server]}</stringProp>
              <stringProp name=\"\">#{m[:port]}</stringProp>
              <stringProp name=\"\">#{m[:metric]}</stringProp>
              <stringProp name=\"\">#{m[:parameters]}</stringProp>
            </collectionProp>
          "
        end

        metricConnections = Nokogiri::XML(<<-XML.strip_heredoc)
          <collectionProp name="metricConnections">
              #{metricNodes.join "\n"}
          </collectionProp>
        XML

        @doc = Nokogiri::XML(<<-XML.strip_heredoc)
          <kg.apc.jmeter.perfmon.PerfMonCollector guiclass="kg.apc.jmeter.vizualizers.PerfMonGui" testclass="kg.apc.jmeter.perfmon.PerfMonCollector" testname="#{name}" enabled="true">
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
                <xml>#{xml}</xml>
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
            <stringProp name="filename">#{filename}</stringProp>
            <longProp name="interval_grouping">1000</longProp>
            <boolProp name="graph_aggregated">false</boolProp>
            <stringProp name="include_sample_labels"></stringProp>
            <stringProp name="exclude_sample_labels"></stringProp>
            <stringProp name="start_offset"></stringProp>
            <stringProp name="end_offset"></stringProp>
            <boolProp name="include_checkbox_state">false</boolProp>
            <boolProp name="exclude_checkbox_state">false</boolProp>
            #{metricConnections.root.to_s}
          </kg.apc.jmeter.perfmon.PerfMonCollector>
        XML
        update params
      end
    end
  end
end
