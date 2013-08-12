module RubyJmeter
  class DSL
    def bsf_assertion(params={}, &block)
      node = RubyJmeter::BsfAssertion.new(params)
      attach_node(node, &block)
    end
  end

  class BsfAssertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'BsfAssertion' : (params[:name] || 'BsfAssertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFAssertion guiclass="TestBeanGUI" testclass="BSFAssertion" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFAssertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
