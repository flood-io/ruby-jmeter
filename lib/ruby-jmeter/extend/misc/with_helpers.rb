module RubyJmeter
  class ExtendedDSL < DSL
    def with_user_agent(device)
      http_header_manager name: 'User-Agent', value: RubyJmeter::UserAgent.new(device).string
    end

    def with_browser(device)
      http_header_manager name: 'User-Agent', value: RubyJmeter::UserAgent.new(device).string
      http_header_manager [
        { name: 'Accept-Encoding', value: 'gzip,deflate,sdch' },
        { name: 'Accept', value: 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' }
      ]
    end

    def with_xhr
      http_header_manager name: 'X-Requested-With', value: 'XMLHttpRequest'
    end

    def with_gzip
      http_header_manager name: 'Accept-Encoding', value: 'gzip, deflate'
    end

    def with_json
      http_header_manager name: 'Accept', value: 'text/html, application/xhtml+xml, application/xml;q=0.9, */*;q=0.8, application/json'
    end
  end
end
