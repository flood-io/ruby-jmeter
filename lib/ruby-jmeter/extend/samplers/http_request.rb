module RubyJmeter
  class ExtendedDSL < DSL
    def http_request(*args, &block)
      params = args.shift || {}
      params = { url: params }.merge(args.shift || {}) if params.class == String

      params[:method] ||= case __callee__.to_s
      when 'visit'
        'GET'
      when 'submit'
        'POST'
      else
        __callee__.to_s.upcase
      end

      params[:name] ||= params[:url]

      parse_http_request(params)

      if params[:sample]
        transaction name: params[:name], parent: true do
          loops count: params[:sample].to_i do
            params.delete(:sample)
            attach_node(http_request_node(params), &block)
          end
        end
      else
        attach_node(http_request_node(params), &block)
      end
    end

    def http_request_node(params)
      RubyJmeter::HttpRequest.new(params).tap do |node|
        node.doc.children.first.add_child (
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <stringProp name="HTTPSampler.implementation">#{params[:implementation]}</stringProp>
          EOS
        ) if params[:implementation]

        node.doc.children.first.add_child (
          Nokogiri::XML(<<-EOS.strip_heredoc).children
            <stringProp name="TestPlan.comments">#{params[:comments]}</stringProp>
          EOS
        ) if params[:comments]
      end
    end

    alias request http_request
    alias get http_request
    alias visit http_request
    alias post http_request
    alias submit http_request
    alias delete http_request
    alias patch http_request
    alias put http_request
    alias head http_request
  end
end