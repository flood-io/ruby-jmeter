module RubyJmeter
  class DSL
    def bsf_preprocessor(params={}, &block)
      node = RubyJmeter::BsfPreprocessor.new(params)
      attach_node(node, &block)
    end
  end

  class BsfPreprocessor
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'BsfPreprocessor'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFPreProcessor guiclass="TestBeanGUI" testclass="BSFPreProcessor" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFPreProcessor>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
