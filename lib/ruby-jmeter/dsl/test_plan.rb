module RubyJmeter
  class DSL
    def test_plan(params={}, &block)
      node = RubyJmeter::TestPlan.new(params)
      attach_node(node, &block)
    end
  end

  class TestPlan
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'TestPlan' : (params[:name] || 'TestPlan')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="#{testname}" enabled="true">
  <stringProp name="TestPlan.comments"/>
  <boolProp name="TestPlan.functional_mode">false</boolProp>
  <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
  <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="TestPlan.user_define_classpath"/>
</TestPlan>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
