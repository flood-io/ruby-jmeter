module RubyJmeter
  class ExtendedDSL < DSL
    def http_request_defaults(params = {}, &block)
      params[:image_parser] = true if params.keys.include? :download_resources
      params[:concurrentDwn] = true if params.keys.include? :use_concurrent_pool
      params[:concurrentPool] = params[:use_concurrent_pool] if params.keys.include? :use_concurrent_pool

      node = RubyJmeter::HttpRequestDefaults.new(params).tap do |node|
        node.doc.children.first.add_child (
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <stringProp name="HTTPSampler.embedded_url_re">#{params[:urls_must_match]}</stringProp>
          EOS
        ) if params[:urls_must_match]

        node.doc.children.first.add_child (
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <boolProp name="HTTPSampler.md5">true</stringProp>
          EOS
        ) if params[:md5]

        node.doc.children.first.add_child (
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <stringProp name="HTTPSampler.proxyHost">#{params[:proxy_host]}</stringProp>
          EOS
        ) if params[:proxy_host]

        node.doc.children.first.add_child (
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <stringProp name="HTTPSampler.proxyPort">#{params[:proxy_port]}</stringProp>
          EOS
        ) if params[:proxy_port]
      end

      attach_node(node, &block)
    end

    alias defaults http_request_defaults
  end
end
