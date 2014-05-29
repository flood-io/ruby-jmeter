module RubyJmeter
  module Plugins
    class JsonPathExtractor
      attr_accessor :doc
      include Helper
      def initialize(name, params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor guiclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.gui.JSONPathExtractorGui" testclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor" testname="jp@gc - JSON Path Extractor" enabled="true">
            <stringProp name="VAR"></stringProp>
            <stringProp name="JSONPATH"></stringProp>
          </com.atlantbh.jmeter.plugins.jsonutils.jsonpathextractor.JSONPathExtractor>
        EOF
        update params
      end
    end
  end
end

