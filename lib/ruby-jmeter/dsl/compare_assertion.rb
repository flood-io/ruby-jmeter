module RubyJmeter
  class DSL
    def compare_assertion(params={}, &block)
      node = RubyJmeter::CompareAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class CompareAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'CompareAssertion' : (params[:name] || 'CompareAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CompareAssertion guiclass="TestBeanGUI" testclass="CompareAssertion" testname="#{testname}" enabled="true">
  <boolProp name="compareContent">true</boolProp>
  <longProp name="compareTime">-1</longProp>
  <collectionProp name="stringsToSkip"/>
</CompareAssertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
