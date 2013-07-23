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
      params[:name] ||= 'HttpHeaderManager'
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<HeaderManager guiclass="HeaderPanel" testclass="HeaderManager" testname="#{params[:name]}" enabled="true">
  <collectionProp name="HeaderManager.headers">
    <elementProp name="" elementType="Header">
      <stringProp name="Header.name"/>
      <stringProp name="Header.value"/>
    </elementProp>
  </collectionProp>
</HeaderManager>)
      EOS
      update params
      update_at_xpath params if params[:update_at_xpath]
    end
  end

end
