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
      params[:name] ||= 'Jsr223Assertion'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Assertion guiclass="TestBeanGUI" testclass="JSR223Assertion" testname="#{params[:name]}" enabled="true">
  <stringProp name="scriptLanguage"/>
  <stringProp name="parameters"/>
  <stringProp name="filename"/>
  <stringProp name="cacheKey"/>
  <stringProp name="script"/>
</JSR223Assertion>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
