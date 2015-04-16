module RubyJmeter
  module Plugins
    class LoadosophiaUploader
      attr_accessor :doc
      include Helper
      def initialize(name="Loadosophia.org Uploader", params={})
	  params[:error_logging] ||= false;
	  params[:filename] ||= "";
	  params[:project] ||= "DEFAULT";
	  params[:uploadToken] ||= "Invalid Token";
	  params[:storeDir] ||= "/tmp";
	  params[:color] ||= "none";
	  params[:title] ||= "";
	  params[:useOnline] ||= false;

          @doc = Nokogiri::XML(<<-XML.strip_heredoc)
      <kg.apc.jmeter.reporters.LoadosophiaUploader guiclass="kg.apc.jmeter.reporters.LoadosophiaUploaderGui" testclass="kg.apc.jmeter.reporters.LoadosophiaUploader" testname="#{name}" enabled="#{enabled(params)}">
        <boolProp name="ResultCollector.error_logging">#{params[:error_logging].to_s}</boolProp>
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
        <stringProp name="filename">#{params[:filename]}</stringProp>
        <stringProp name="project">#{params[:project]}</stringProp>
        <stringProp name="uploadToken">#{params[:uploadToken]}</stringProp>
        <stringProp name="storeDir">#{params[:storeDir]}</stringProp>
        <stringProp name="color">#{params[:color]}</stringProp>
        <stringProp name="title">#{params[:title]}</stringProp>
        <boolProp name="useOnline">#{params[:useOnline].to_s}</boolProp>
      </kg.apc.jmeter.reporters.LoadosophiaUploader>
      XML

        #update params
      end
    end
  end
end

