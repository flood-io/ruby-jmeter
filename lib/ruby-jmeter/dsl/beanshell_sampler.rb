module RubyJmeter
  class DSL
    def beanshell_sampler(params={}, &block)
      node = RubyJmeter::BeanshellSampler.new(params)
      attach_node(node, &block)
    end
  end

  class BeanshellSampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      params[:name] ||= 'BeanshellSampler'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<BeanShellSampler guiclass="BeanShellSamplerGui" testclass="BeanShellSampler" testname="#{params[:name]}" enabled="true">
  <stringProp name="BeanShellSampler.query"/>
  <stringProp name="BeanShellSampler.filename"/>
  <stringProp name="BeanShellSampler.parameters"/>
  <boolProp name="BeanShellSampler.resetInterpreter">false</boolProp>
</BeanShellSampler>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
