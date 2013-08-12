module RubyJmeter
  class DSL
    def jsr223_listener(params={}, &block)
      node = RubyJmeter::Jsr223Listener.new(params)
      attach_node(node, &block)
    end
  end

  class Jsr223Listener
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'Jsr223Listener' : (params[:name] || 'Jsr223Listener')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Listener guiclass="TestBeanGUI" testclass="JSR223Listener" testname="#{testname}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223Listener>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
