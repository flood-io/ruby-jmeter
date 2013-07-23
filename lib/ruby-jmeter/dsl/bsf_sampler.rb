module RubyJmeter
  class DSL
    def bsf_sampler(params={}, &block)
      node = RubyJmeter::BsfSampler.new(params)
      attach_node(node, &block)
    end
  end

  class BsfSampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'BsfSampler'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFSampler guiclass="TestBeanGUI" testclass="BSFSampler" testname="#{params[:name]}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFSampler>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
