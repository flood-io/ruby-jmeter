module RubyJmeter
  class DSL
    def ftp_request_defaults(params={}, &block)
      node = RubyJmeter::FtpRequestDefaults.new(params)
      attach_node(node, &block)
    end
  end

  class FtpRequestDefaults
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'FtpRequestDefaults' : (params[:name] || 'FtpRequestDefaults')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ConfigTestElement guiclass="FtpConfigGui" testclass="ConfigTestElement" testname="#{testname}" enabled="true">
  <stringProp name="FTPSampler.server"/>
  <stringProp name="FTPSampler.port"/>
  <stringProp name="FTPSampler.filename"/>
  <stringProp name="FTPSampler.localfilename"/>
  <stringProp name="FTPSampler.inputdata"/>
  <boolProp name="FTPSampler.binarymode">false</boolProp>
  <boolProp name="FTPSampler.saveresponse">false</boolProp>
  <boolProp name="FTPSampler.upload">false</boolProp>
</ConfigTestElement>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
