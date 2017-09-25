module RubyJmeter
  module Plugins
    class JsonPathAssertion
      attr_accessor :doc
      include Helper
      def initialize(params={})
        @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
          <com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion guiclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.gui.JSONPathAssertionGui" testclass="com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion" testname="jp@gc - JSON Path Assertion" enabled="true">
            <stringProp name="EXPECTED_VALUE"></stringProp>
            <stringProp name="JSON_PATH"></stringProp>
            <boolProp name="JSONVALIDATION">true</boolProp>
            <boolProp name="INVERT">false</boolProp>
          </com.atlantbh.jmeter.plugins.jsonutils.jsonpathassertion.JSONPathAssertion>
        EOF
        update params
      end
    end
  end
end
