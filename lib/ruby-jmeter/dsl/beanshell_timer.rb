module RubyJmeter
  class DSL
    def beanshell_timer(params={}, &block)
      node = RubyJmeter::BeanshellTimer.new(params)
      attach_node(node, &block)
    end
  end

  class BeanshellTimer
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'BeanshellTimer' : (params[:name] || 'BeanshellTimer')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellTimer guiclass="TestBeanGUI" testclass="BeanShellTimer" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <boolProp name="resetInterpreter">false</boolProp>
  <stringProp name="script"/>
</BeanShellTimer>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
