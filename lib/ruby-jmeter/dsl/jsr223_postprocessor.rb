module RubyJmeter
  class DSL
    def jsr223_postprocessor(params={}, &block)
      node = RubyJmeter::Jsr223Postprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class Jsr223Postprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'Jsr223Postprocessor'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223PostProcessor guiclass="TestBeanGUI" testclass="JSR223PostProcessor" testname="#{params[:name]}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223PostProcessor>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
