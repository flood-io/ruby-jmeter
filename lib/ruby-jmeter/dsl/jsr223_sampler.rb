module RubyJmeter
  class DSL
    def jsr223_sampler(params={}, &block)
      node = RubyJmeter::Jsr223Sampler.new(params)
      attach_node(node, &block)
    end
  end

  class Jsr223Sampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'Jsr223Sampler' : (params[:name] || 'Jsr223Sampler')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JSR223Sampler guiclass="TestBeanGUI" testclass="JSR223Sampler" testname="#{testname}" enabled="true">
  <stringProp name="cacheKey"/>
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</JSR223Sampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
