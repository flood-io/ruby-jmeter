module RubyJmeter
  class DSL
    def http_header_manager(params={}, &block)
      node = RubyJmeter::HttpHeaderManager.new(params)
      attach_node(node, &block)
    end
  end

  class HttpHeaderManager
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'HttpHeaderManager' : (params[:name] || 'HttpHeaderManager')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="#{testname}" enabled="true">
  <collectionProp name="HeaderManager.headers">
    <elementProp name="" elementType="Header">
      <stringProp name="Header.name"/>
      <stringProp name="Header.value"/>
    </elementProp>
  </collectionProp>
</HeaderManager>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
