module RubyJmeter
  class DSL
    def save_responses_to_a_file(params={}, &block)
      node = RubyJmeter::SaveResponsesToAFile.new(params)
      attach_node(node, &block)
    end
  end

  class SaveResponsesToAFile
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'SaveResponsesToAFile' : (params[:name] || 'SaveResponsesToAFile')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<ResultSaver guiclass="ResultSaverGui" testclass="ResultSaver" testname="#{testname}" enabled="true">
  <stringProp name="FileSaver.filename"/>
  <boolProp name="FileSaver.errorsonly">false</boolProp>
  <boolProp name="FileSaver.skipautonumber">false</boolProp>
  <boolProp name="FileSaver.skipsuffix">false</boolProp>
  <boolProp name="FileSaver.successonly">false</boolProp>
</ResultSaver>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
