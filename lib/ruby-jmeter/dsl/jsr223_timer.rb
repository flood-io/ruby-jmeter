module RubyJmeter
  class DSL
    def jsr223_timer(params={}, &block)
      node = RubyJmeter::Jsr223Timer.new(params)
      attach_node(node, &block)
    end
  end

  class Jsr223Timer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'Jsr223Timer' : (params[:name] || 'Jsr223Timer')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Timer guiclass="TestBeanGUI" testclass="JSR223Timer" testname="#{testname}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223Timer>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
