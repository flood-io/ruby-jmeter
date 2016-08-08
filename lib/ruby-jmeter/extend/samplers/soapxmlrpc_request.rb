module RubyJmeter
  class ExtendedDSL < DSL
    def soapxmlrpc_request(params, &block)
      params[:method] ||= 'POST'

      super
    end
  end
end
