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
      testname = params.kind_of?(Array) ? 'BsfSampler' : (params[:name] || 'BsfSampler')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BSFSampler guiclass="TestBeanGUI" testclass="BSFSampler" testname="#{testname}" enabled="true">
  <stringProp name="filename"/>
  <stringProp name="parameters"/>
  <stringProp name="script"/>
  <stringProp name="scriptLanguage"/>
</BSFSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
