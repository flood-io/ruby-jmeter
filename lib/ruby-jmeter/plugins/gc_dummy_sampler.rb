module RubyJmeter

  class GCDummySampler
    attr_accessor :doc
    include Helper
    def initialize(name, params={})
      @doc = Nokogiri::XML(<<-EOF.strip_heredoc)
        <kg.apc.jmeter.samplers.DummySampler guiclass="kg.apc.jmeter.samplers.DummySamplerGui" testclass="kg.apc.jmeter.samplers.DummySampler" testname="jp@gc - Dummy Sampler" enabled="true">
        <boolProp name="WAITING">true</boolProp>
        <boolProp name="SUCCESFULL">true</boolProp>
        <stringProp name="RESPONSE_CODE">200</stringProp>
        <stringProp name="RESPONSE_MESSAGE">OK</stringProp>
        <stringProp name="REQUEST_DATA"></stringProp>
        <stringProp name="RESPONSE_DATA"></stringProp>
        <stringProp name="RESPONSE_TIME">0</stringProp>
        <stringProp name="LATENCY">0</stringProp>
      </kg.apc.jmeter.samplers.DummySampler>
      EOF
      update params
    end
  end  

end
