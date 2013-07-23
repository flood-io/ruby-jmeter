module RubyJmeter
  class DSL
    def jsr223_preprocessor(params={}, &block)
      node = RubyJmeter::Jsr223Preprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class Jsr223Preprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'Jsr223Preprocessor'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223PreProcessor guiclass="TestBeanGUI" testclass="JSR223PreProcessor" testname="#{params[:name]}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223PreProcessor>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
