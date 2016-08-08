module RubyJmeter
  class DSL
    def http_cookie_manager(params={}, &block)
      node = RubyJmeter::HttpCookieManager.new(params)
      attach_node(node, &block)
    end
  end

  class HttpCookieManager
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'HttpCookieManager' : (params[:name] || 'HttpCookieManager')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CookieManager guiclass="CookiePanel" testclass="CookieManager" testname="#{testname}" enabled="true">
  <collectionProp name="CookieManager.cookies"/>
  <boolProp name="CookieManager.clearEachIteration">false</boolProp>
  <stringProp name="CookieManager.policy">default</stringProp>
  <stringProp name="CookieManager.implementation">org.apache.jmeter.protocol.http.control.HC4CookieHandler</stringProp>
</CookieManager>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end

end
