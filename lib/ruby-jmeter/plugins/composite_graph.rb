module RubyJmeter
  module Plugins
    class CompositeGraph
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'CompositeGraph' : (params[:name] || 'CompositeGraph')
        graphNodes = params.collect { |g| "<stringProp name=\"\">#{g[:graph]}</stringProp>"}
        metricNodes = params.collect { |m| "<stringProp name=\"\">#{m[:metric]}</stringProp>"}

        composite_collections = Nokogiri::XML(<<-XML.strip_heredoc)
          <collectionProp name="COMPOSITE_CFG">
            <collectionProp name="">
                #{graphNodes.join "\n"}
            </collectionProp>
            <collectionProp name="">
                #{metricNodes.join "\n"}
            </collectionProp>
          </collectionProp>
        XML

        @doc = Nokogiri::XML(<<-XML.strip_heredoc)
        <kg.apc.jmeter.vizualizers.CompositeResultCollector guiclass="kg.apc.jmeter.vizualizers.CompositeGraphGui" testclass="kg.apc.jmeter.vizualizers.CompositeResultCollector" testname="#{testname}" enabled="true">
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
          #{composite_collections.root.to_s}
        </kg.apc.jmeter.vizualizers.CompositeResultCollector>
        XML
        update params
      end
    end
  end
end

