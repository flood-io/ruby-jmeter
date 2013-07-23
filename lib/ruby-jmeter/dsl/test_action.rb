module RubyJmeter
  class DSL
    def test_action(params={}, &block)
      node = RubyJmeter::TestAction.new(params)
      attach_node(node, &block)
    end
  end

  class TestAction
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'TestAction'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TestAction guiclass="TestActionGui" testclass="TestAction" testname="#{params[:name]}" enabled="true">
  <intProp name="ActionProcessor.action">1</intProp>
  <intProp name="ActionProcessor.target">0</intProp>
  <stringProp name="ActionProcessor.duration"/>
</TestAction>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
