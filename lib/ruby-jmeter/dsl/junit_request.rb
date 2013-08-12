module RubyJmeter
  class DSL
    def junit_request(params={}, &block)
      node = RubyJmeter::JunitRequest.new(params)
      attach_node(node, &block)
    end
  end

  class JunitRequest
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'JunitRequest' : (params[:name] || 'JunitRequest')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<JUnitSampler guiclass="JUnitTestSamplerGui" testclass="JUnitSampler" testname="#{testname}" enabled="true">
  <stringProp name="junitSampler.classname">test.RerunTest</stringProp>
  <stringProp name="junitsampler.constructorstring"/>
  <stringProp name="junitsampler.method">testRerun</stringProp>
  <stringProp name="junitsampler.pkg.filter"/>
  <stringProp name="junitsampler.success">Test successful</stringProp>
  <stringProp name="junitsampler.success.code">1000</stringProp>
  <stringProp name="junitsampler.failure">Test failed</stringProp>
  <stringProp name="junitsampler.failure.code">0001</stringProp>
  <stringProp name="junitsampler.error">An unexpected error occured</stringProp>
  <stringProp name="junitsampler.error.code">9999</stringProp>
  <stringProp name="junitsampler.exec.setup">false</stringProp>
  <stringProp name="junitsampler.append.error">false</stringProp>
  <stringProp name="junitsampler.append.exception">false</stringProp>
</JUnitSampler>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
