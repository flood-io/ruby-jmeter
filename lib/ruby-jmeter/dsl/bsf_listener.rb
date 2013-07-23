module RubyJmeter
  class DSL
    def bsf_listener(params={}, &block)
      node = RubyJmeter::BsfListener.new(params)
      attach_node(node, &block)
    end
  end

  class BsfListener
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'BsfListener'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFListener guiclass="TestBeanGUI" testclass="BSFListener" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFListener>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
