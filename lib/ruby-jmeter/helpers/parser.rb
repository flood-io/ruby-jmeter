module RubyJmeter
  module Parser

    def parse_http_request(params)
      if params[:raw_path]
        params[:path] = params[:url]
        parse_url(params)
      else
        parse_url(params)
        params[:fill_in] ||= {}
        params[:params] && params[:params].split('&').each do |param|
          name,value = param.split('=')
          params[:fill_in][name] ||= []
          params[:fill_in][name] << value
        end
      end

      fill_in(params) if params.has_key?(:fill_in)
      raw_body(params) if params.has_key?(:raw_body)
      files(params) if params.has_key?(:files)
    end

    def parse_url(params)
      return if params[:url].empty?
      if params[:url] =~ /https?:\/\/\$/ || params[:url][0] == '$'
        params[:path] = params[:url] # special case for named expressions
      else
        uri = parse_uri(params[:url])
        params[:port]     ||= uri.port unless URI.parse(URI::encode(params[:url])).scheme.nil?
        params[:protocol] ||= uri.scheme unless URI.parse(URI::encode(params[:url])).scheme.nil?
        params[:domain]   ||= uri.host
        params[:path]     ||= uri.path && URI::decode(uri.path)
        params[:params]   ||= uri.query && URI::decode(uri.query)
      end
      params.delete(:url)
    end

    def parse_uri(uri)
      URI.parse(URI::encode(uri)).scheme.nil? ?
        URI.parse(URI::encode("http://#{uri}")) :
        URI.parse(URI::encode(uri))
    end

    def fill_in(params)
      params[:update_at_xpath] ||= []
      params[:update_at_xpath] = params[:fill_in].
        each_with_object(params[:update_at_xpath]) do |(name, values), memo|
           Array(values).each do |value|
            memo << {
              :xpath => '//collectionProp',
              :value => Nokogiri::XML(<<-EOF.strip_heredoc).children
                <elementProp name="#{name}" elementType="HTTPArgument">
                  <boolProp name="HTTPArgument.always_encode">#{params[:always_encode] ? 'true' : false}</boolProp>
                  <stringProp name="Argument.value">#{value}</stringProp>
                  <stringProp name="Argument.metadata">=</stringProp>
                  <boolProp name="HTTPArgument.use_equals">true</boolProp>
                  <stringProp name="Argument.name">#{name}</stringProp>
                </elementProp>
                EOF
            }
          end
        end
      params.delete(:fill_in)
    end

    def raw_body(params)
      params[:update_at_xpath] ||= []
      params[:update_at_xpath] << {
        :xpath => '//HTTPSamplerProxy',
        :value => Nokogiri::XML(<<-EOF.strip_heredoc).children
          <boolProp name="HTTPSampler.postBodyRaw">true</boolProp>
          EOF
      }

      params[:update_at_xpath] << {
        :xpath => '//collectionProp',
        :value => Nokogiri::XML(<<-EOF.strip_heredoc).children
          <elementProp name="" elementType="HTTPArgument">
            <boolProp name="HTTPArgument.always_encode">false</boolProp>
            <stringProp name="Argument.value">#{params[:raw_body].encode(:xml => :text)}</stringProp>
            <stringProp name="Argument.metadata">=</stringProp>
          </elementProp>
          EOF
      }
      params.delete(:raw_body)
    end

    def files(params)
      files = params.delete(:files)
      return if files.empty?
      x = Nokogiri::XML::Builder.new do |b|
        b.elementProp(name: "HTTPsampler.Files", elementType: "HTTPFileArgs") {
          b.collectionProp(name: "HTTPFileArgs.files") {
            files.each do |f|
              b.elementProp(name: f[:path], elementType: "HTTPFileArg") {
                b.stringProp f[:path] || '' , name: "File.path"
                b.stringProp f[:paramname] || '' , name: "File.paramname"
                b.stringProp f[:mimetype] || '' , name: "File.mimetype"
              }
            end
          }
        }
      end
      params[:update_at_xpath] ||= []
      params[:update_at_xpath] << {
        :xpath => '//HTTPSamplerProxy',
        :value => x.doc.root
      }
    end

    def parse_test_type(params)
      case params.keys.first.to_s
      when 'contains'
        2
      when 'not-contains'
        6
      when 'matches'
        1
      when 'not-matches'
        5
      when 'equals'
        8
      when 'not-equals'
        12
      when 'substring'
        16
      when 'not-substring'
        20
      else
        2
      end
    end

  end
end
