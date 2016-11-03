module RubyJmeter
  module Plugins
    class JsonPathAssertion
      attr_accessor :doc
      include Helper
      def initialize(params={})
        testname = params.kind_of?(Array) ? 'jp@gc - JSON Path Assertion' : (params[:name] || 'jp@gc - JSON Path Assertion')
        testname = CGI.escapeHTML(testname.to_s)
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion guiclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.gui.JSONPathAssertionGui" testclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion" testname="#{testname}" enabled="true">
            <stringProp name="EXPECTED_VALUE"></stringProp>
            <stringProp name="JSON_PATH"></stringProp>
            <boolProp name="JSONVALIDATION">true</boolProp>
          </com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion>
        EOF
        update params
      end
    end
  end
end
