module RubyJmeter
  class DSL
    def bsf_postprocessor(params={}, &block)
      node = RubyJmeter::BsfPostprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class BsfPostprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'BsfPostprocessor'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFPostProcessor guiclass="TestBeanGUI" testclass="BSFPostProcessor" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFPostProcessor>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
