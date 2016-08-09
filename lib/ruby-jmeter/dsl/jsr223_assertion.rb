module RubyJmeter
  class DSL
    def jsr223_assertion(params={}, &block)
      node = RubyJmeter::Jsr223Assertion.new(params)
      attach_node(node, &block)
    end
  end

  class Jsr223Assertion
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'Jsr223Assertion' : (params[:name] || 'Jsr223Assertion')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Assertion guiclass="TestBeanGUI" testclass="JSR223Assertion" testname="#{testname}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223Assertion>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
