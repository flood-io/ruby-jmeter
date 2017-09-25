# frozen_string_literal: true

module RubyJmeter
  class ExtendedDSL < DSL
    def http_cookie_manager(params = {}, &block)
      params[:clearEachIteration] = true if params.keys.include? :clear_each_iteration

      node = RubyJmeter::HttpCookieManager.new(params)

      params[:user_defined_cookies]&.each { |cookie| add_cookie_to_collection(cookie, node) }

      attach_node(node, &block)
    end

    alias cookies http_cookie_manager

    private

    def add_cookie_to_collection(cookie, node)
      raise 'Cookie name must be provided.' unless cookie[:name]
      raise 'Cookie value must be provided.' unless cookie[:value]
      node.doc.at_xpath('//collectionProp') <<
          Nokogiri::XML(<<-EOS.strip_heredoc).children
              <elementProp name="#{cookie[:name]}" elementType="Cookie" testname="#{cookie[:name]}">
                <stringProp name="Cookie.value">#{cookie[:value]}</stringProp>
                <stringProp name="Cookie.domain">#{cookie[:domain]}</stringProp>
                <stringProp name="Cookie.path">#{cookie[:path]}</stringProp>
                <boolProp name="Cookie.secure">#{cookie[:secure] || false}</boolProp>
                <longProp name="Cookie.expires">0</longProp>
                <boolProp name="Cookie.path_specified">true</boolProp>
                <boolProp name="Cookie.domain_specified">true</boolProp>
              </elementProp>
      EOS
    end
  end
end
