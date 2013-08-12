module RubyJmeter
  class DSL
    def os_process_sampler(params={}, &block)
      node = RubyJmeter::OsProcessSampler.new(params)
      attach_node(node, &block)
    end
  end

  class OsProcessSampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'OsProcessSampler' : (params[:name] || 'OsProcessSampler')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<SystemSampler guiclass="SystemSamplerGui" testclass="SystemSampler" testname="#{testname}" enabled="true">
  <boolProp name="SystemSampler.checkReturnCode">false</boolProp>
  <stringProp name="SystemSampler.expectedReturnCode">0</stringProp>
  <stringProp name="SystemSampler.command"/>
  <elementProp name="SystemSampler.arguments" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <elementProp name="SystemSampler.environment" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="#{testname}" enabled="true">
    <collectionProp name="Arguments.arguments"/>
  </elementProp>
  <stringProp name="SystemSampler.directory"/>
</SystemSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
