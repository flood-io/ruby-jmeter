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
      cookie_jar = user_defined_cookies(params[:user_cookies]) if params.include? :user_cookies
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<CookieManager guiclass="CookiePanel" testclass="CookieManager" testname="#{testname}" enabled="true">
  <collectionProp name="CookieManager.cookies">#{cookie_jar}</collectionProp
  <boolProp name="CookieManager.clearEachIteration">false</boolProp>
  <stringProp name="CookieManager.policy">default</stringProp>
  <stringProp name="CookieManager.implementation">org.apache.jmeter.protocol.http.control.HC4CookieHandler</stringProp>
</CookieManager>)
      EOS
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end

    def user_defined_cookies(user_cookies)
      cookie_jar = ""
      if user_cookies.is_a?(Hash)
        user_cookies.each do |name, attrs|
          value = attrs.fetch(:value, "")
          domain = attrs.fetch(:domain, "")
          path = attrs.fetch(:path, "")
          secure = attrs.fetch(:secure, false)
          expires = attrs.fetch(:expires, 0)
          path_specified = !path.empty?
          domain_specified = !domain.empty?
          element = <<-EOS.strip_heredoc
<elementProp name="#{name}" elementType="Cookie" testname="#{name}">
  <stringProp name="Cookie.value">#{value}</stringProp>
  <stringProp name="Cookie.domain">#{domain}</stringProp>
  <stringProp name="Cookie.path">#{path}</stringProp>
  <boolProp name="Cookie.secure">#{secure}</boolProp>
  <longProp name="Cookie.expires">#{expires}</longProp>
  <boolProp name="Cookie.path_specified">#{path_specified}</boolProp>
  <boolProp name="Cookie.domain_specified">#{domain_specified}</boolProp>
</elementProp>
          EOS
          cookie_jar << element
        end
      end
      cookie_jar
    end
  end

end
