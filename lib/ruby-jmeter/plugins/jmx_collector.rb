module RubyJmeter
  module Plugins
    class JMXCollector
      attr_accessor :doc
      include Helper
      def initialize(params={})

        params[:name] ||= 'JMX Collector'
        params[:jtl] ||= ''
        params[:attribute_key] ||= ''

        @doc = Nokogiri::XML(<<-XML.strip_heredoc)
        <kg.apc.jmeter.jmxmon.JMXMonCollector guiclass="kg.apc.jmeter.vizualizers.JMXMonGui" testclass="kg.apc.jmeter.jmxmon.JMXMonCollector" testname="#{params[:name]}" enabled="true">
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
              <xml>false</xml>
              <fieldNames>true</fieldNames>
              <responseHeaders>false</responseHeaders>
              <requestHeaders>false</requestHeaders>
              <responseDataOnError>false</responseDataOnError>
              <saveAssertionResultsFailureMessage>true</saveAssertionResultsFailureMessage>
              <assertionsResultsToSave>0</assertionsResultsToSave>
              <bytes>true</bytes>
              <threadCounts>true</threadCounts>
              <idleTime>true</idleTime>
            </value>
          </objProp>
          <stringProp name="filename">#{params[:jtl]}</stringProp>
          <longProp name="interval_grouping">1000</longProp
          <boolProp name="graph_aggregated">false</boolProp>
          <stringProp name="include_sample_labels"></stringProp>
          <stringProp name="exclude_sample_labels"></stringProp>
          <stringProp name="start_offset"></stringProp>
          <stringProp name="end_offset"></stringProp>
          <boolProp name="include_checkbox_state">false</boolProp>
          <boolProp name="exclude_checkbox_state">false</boolProp>
          <collectionProp name="samplers">
            <collectionProp name="311458936">
              <stringProp name="label"></stringProp>
              <stringProp name="service_endpoint">service:jmx:rmi:///jndi/rmi://#{params[:host]}:#{params[:port]}/jmxrmi</stringProp>
              <stringProp name="username"></stringProp>
              <stringProp name="password"></stringProp>
              <stringProp name="object_name">#{params[:object_name]}</stringProp>
              <stringProp name="attribute_name">#{params[:attribute_name]}</stringProp>
              <stringProp name="attribute_key">#{params[:attribute_key]}</stringProp>
              <stringProp name="delta">false</stringProp>
              <stringProp name="retry">true</stringProp>
            </collectionProp>
          </collectionProp>
        </kg.apc.jmeter.jmxmon.JMXMonCollector>
        XML
      end
    end
  end
end


