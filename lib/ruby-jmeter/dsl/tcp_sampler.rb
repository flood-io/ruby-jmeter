module RubyJmeter
  class DSL
    def tcp_sampler(params={}, &block)
      node = RubyJmeter::TcpSampler.new(params)
      attach_node(node, &block)
    end
  end

  class TcpSampler
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'TcpSampler' : (params[:name] || 'TcpSampler')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<TCPSampler guiclass="TCPSamplerGui" testclass="TCPSampler" testname="#{testname}" enabled="true">
  <stringProp name="TCPSampler.server"/>
  <boolProp name="TCPSampler.reUseConnection">true</boolProp>
  <stringProp name="TCPSampler.port"/>
  <boolProp name="TCPSampler.nodelay">false</boolProp>
  <stringProp name="TCPSampler.timeout"/>
  <stringProp name="TCPSampler.request"/>
  <boolProp name="TCPSampler.closeConnection">false</boolProp>
  <stringProp name="ConfigTestElement.username"/>
  <stringProp name="ConfigTestElement.password"/>
</TCPSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
