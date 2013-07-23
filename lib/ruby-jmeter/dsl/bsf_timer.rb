module RubyJmeter
  class DSL
    def bsf_timer(params={}, &block)
      node = RubyJmeter::BsfTimer.new(params)
      attach_node(node, &block)
    end
  end

  class BsfTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'BsfTimer'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFTimer guiclass="TestBeanGUI" testclass="BSFTimer" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFTimer>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
